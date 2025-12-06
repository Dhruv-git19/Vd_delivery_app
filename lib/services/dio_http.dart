import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/constants/api_endpoints.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/interceptor/dio_interceptor.dart';
import 'package:vedasip_delivery_app/services/api_error_handler.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';

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

  Future<Response> deleteMyAccount(BuildContext context) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.deleteMyAccount,
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
      data: {
        "userName": userName,
        "otp": otp,
        "roleUniqueIds": ["DELIVERY_PARTNER"],
      },
      wrapData: true,
    );
  }

  Future<Response> verifyDeliveryLocation(
    BuildContext context, {
    required String orderId,
    required String type,
    required double currentLat,
    required double currentLng,
  }) async {
    final data = {
      "orderId": orderId,
      "type": type,
      "currentLat": currentLat,
      "currentLng": currentLng,
    };

    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.verifyDeliveryLocation,
      data: data,
      wrapData: true,
    );
  }

  Future<Response> getDeliveryPartnerOrderHistory(BuildContext context) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.getDeliveryPartnerOrderHistory,
      data: {"deliveryStatus": "DELIVERED", "page": 1, "pageSize": 20},
      wrapData: true,
    );
  }

  Future<Response> getAllAreas(
    BuildContext context, {
    int page = 1,
    int pageSize = 100,
  }) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.getAllAreas,
      data: {"page": page, "pageSize": pageSize},
      wrapData: true,
    );
  }

  Future<Response> submitSubscriptionBottleCount(
    BuildContext context, {
    required List<String> uploadedFileUrls,
    required int subscriptionId,
    required int takenBottleCount,
  }) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.submitSubscriptionBottleCount,
      data: {
        "uploadedFileUrls": uploadedFileUrls,
        "subscriptionId": subscriptionId,
        "takenBottleCount": takenBottleCount,
      },
      wrapData: true,
    );
  }

  Future<Response> getSpecificDeliveryPartnerOrderHistory(
    BuildContext context, {
    required String orderType,
    required int orderId,
  }) async {
    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.getSpecificDeliveryPartnerOrderHistory,
      data: {"orderType": orderType, "orderId": orderId},
      wrapData: true,
    );
  }

  Future<Response> uploadProofImages(
    BuildContext context, {
    required List<String> filePaths,
  }) async {
    final url = '$_baseUrl${ApiEndpoint.uploadProofImages.fullPath}';
    try {
      FormData formData = FormData();

      for (String filePath in filePaths) {
        formData.files.add(
          MapEntry('files', await MultipartFile.fromFile(filePath)),
        );
      }

      final response = await _dio.post(url, data: formData);
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

  Future<Response> uploadKYCDocument(
    BuildContext context, {
    required String documentType,
    required String filePath,
  }) async {
    final url = '$_baseUrl${ApiEndpoint.uploadKYCDocument.fullPath}';
    try {
      FormData formData = FormData();

      // include document type as a field
      formData.fields.add(MapEntry('documentType', documentType));

      // attach the single file under key 'file'
      formData.files.add(
        MapEntry('file', await MultipartFile.fromFile(filePath)),
      );

      final response = await _dio.post(url, data: formData);
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

  Future<Response> registerDeliveryPartner(
    BuildContext context, {
    required String fullName,
    required String emailId,
    required String mobileNumber,
    required String password,
    required String idPhotoUrl,
    required String drivingLicenseUrl,
    required String vehicleRegistrationUrl,
    required List<int> areaIds,
  }) async {
    final data = {
      "fullName": fullName,
      "emailId": emailId,
      "mobileNumber": mobileNumber,
      "password": password,
      "vehicleRegistrationUrl": vehicleRegistrationUrl,
      "drivingLicenseUrl": drivingLicenseUrl,
      "idPhotoUrl": idPhotoUrl,
      "areadIds": areaIds,
    };

    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.registerDeliveryPartner,
      data: data,
      wrapData: true,
    );
  }

  Future<Response> submitOrderProof(
    BuildContext context, {
    required String orderId,
    required String type,
    required double currentLat,
    required double currentLng,
    required List<String> uploadedFileUrls,
    String? exchangeBottleCount,
  }) async {
    final data = {
      "orderId": orderId,
      "type": type,
      "currentLat": currentLat,
      "currentLng": currentLng,
      "uploadedFileUrls": uploadedFileUrls,
    };

    if (exchangeBottleCount != null && exchangeBottleCount.isNotEmpty) {
      data["exchangeBottleCount"] = exchangeBottleCount;
    }

    return _postRequest(
      context: context,
      endpoint: ApiEndpoint.submitOrderProof,
      data: data,
      wrapData: true,
    );
  }
}
