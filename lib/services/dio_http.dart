import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vedasip_delivery_app/constants/api_endpoints.dart';
import 'package:vedasip_delivery_app/services/api_error_handler.dart';
import 'package:vedasip_delivery_app/interceptor/dio_interceptor.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';

class DioHttp {
  final Dio _dio;
  final String _baseUrl;
  final MySecureStorage _secureStorage;

  DioHttp()
    : _dio = Dio()..interceptors.add(DioInterceptor()),
      _baseUrl = dotenv.env['BASE_URL']!,
      _secureStorage = MySecureStorage();

  Future<Response> _postRequest({
    required BuildContext context,
    required ApiEndpoint endpoint,
    required dynamic data,
    bool wrapData = true,
    bool expectDataField = true,
    Function(String)? onSuccess,
  }) async {
    final url = '$_baseUrl${endpoint.fullPath}';
    try {
      final response = await _dio.post(
        url,
        data: jsonEncode(wrapData ? {'data': data} : data),
      );

      if (onSuccess != null && response.data['data'] is String) {
        onSuccess(response.data['data']);
      }
      return response;
    } on DioException catch (err) {
      if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
        await _secureStorage.deleteToken();
        MySnackBar.showSnackBar(
          context,
          "Session expired. Please login again.",
        );
        context.go(AppRoutes.loginscreen);
      }
      ApiErrorHandler.handleDioError(context, err);
      rethrow;
    } catch (err) {
      ApiErrorHandler.handleUnexpectedError(context, err);
      rethrow;
    }
  }

  Future<Response> logout(BuildContext context) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.logout,
      data: {},
      wrapData: true,
    );
  }

  Future<Response> login(
    BuildContext context, {
    required String userName,
  }) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.login,
      data: {
        "userName": userName,
        "roleUniqueIds": ["DELIVERY_PARTNER"],
      },
      wrapData: true,
    );
  }

  Future<Response> getSpecificOrdersAssignment(BuildContext context) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.getSpecificOrdersAssignment,
      data: {},
      wrapData: true,
    );
  }

  Future<Response> getSpecificOrderDetails(
    BuildContext context, {
    required int orderId,
    required String type,
    Map<String, dynamic>? warehouseLocation,
  }) async {
    final data = {
      'orderId': orderId,
      'type': type,
      'warehouseLocation':
          warehouseLocation ?? {'lat': 28.6139, 'lng': 77.2090},
    };

    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.getSpecificOrderDetails,
      data: data,
      wrapData: true,
    );
  }

  Future<Response> getSpecificUser(BuildContext context) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.getSpecificUser,
      data: {},
      wrapData: true,
    );
  }

  Future<Response> verifyOTP(
    BuildContext context, {
    required String userName,
    required int otp,
  }) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.verifyOTP,
      data: {"userName": userName, "otp": otp},
      wrapData: true,
    );
  }
}
