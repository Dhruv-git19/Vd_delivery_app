import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:dio/dio.dart';

class LoginProvider with ChangeNotifier {
  final DioHttp _dioHttp = DioHttp();

  Future<Response> login(
    BuildContext context, {
    required String userName,
    required String roleUniqueIds,
  }) async {
    return _dioHttp.login(
      context,
      userName: userName,
      roleUniqueIds: roleUniqueIds,
    );
  }

  Future<Response> verifyOTP(
    BuildContext context, {
    required String userName,
    required int otp, // Change type to int
  }) async {
    return _dioHttp.verifyOTP(
      context,
      userName: userName,
      otp: otp, // Convert int to String here
    );
  }
}
