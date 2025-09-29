import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vedasip_delivery_app/models/filter_model.dart';
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
        await DioHttp().logout(context);
        await _secureStorage.deleteToken();
        await _secureStorage.deleteRole();
        await _secureStorage.deleteDoNotShowOMRTutorial();
        MySnackBar.showSnackBar(
            context, "Session expired. Please login again.");
        context.go(AppRoutes.loginscreen);
      }
      ApiErrorHandler.handleDioError(context, err);
      rethrow;
    } catch (err) {
      ApiErrorHandler.handleUnexpectedError(context, err);
      rethrow;
    }
  }

  Future<Response> getEditUser(BuildContext context, String userId,
      {String? quizId}) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.GetSpecificUser,
      data: {"userId": userId, "editUser": "1", "quiz_id": quizId},
      wrapData: true,
    );
  }
  Future<Response> logout(BuildContext context) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.logout,
      data: {},
      wrapData: true,
    );
  }
  Future<Response> getConfigParamList(
    BuildContext context, {
    required FilterModel filterModel,
  }) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.getConfigParamList,
      data: filterModel.toJson(),
      wrapData: true,
    );
  }
  Future<Response> login(
    BuildContext context, {
    required String userName,
    required String roleUniqueIds,
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
  Future<Response> verifyOTP(
    BuildContext context, {
    required String userName,
    required int otp,
  }) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.verifyOTP,
      data: {
        "userName": userName,
        "otp": otp,
      },
      wrapData: true,
    );
  }

  Future<Response> getQuizListManagement(
    BuildContext context, {
    required FilterModel filterModel,
  }) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.getQuizListManagement,
      data: filterModel.toJson(),
      wrapData: true,
    );
  }
}
