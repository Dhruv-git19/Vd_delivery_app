import 'package:flutter/material.dart';

import '../../../core/model/base_api_response.dart';
import '../../../services/dio_http.dart';
import '../../../storage/flutter_secure_storage.dart';
import '../../../widget/snack_bar.dart';

class LoginProvider with ChangeNotifier {
  final DioHttp _dioHttp = DioHttp();

  bool isLoading = false;
  bool otpSent = false;
  String? testOtp;
  String? phoneError;

  Future<void> sendOtp(BuildContext context, String phone) async {
    final phoneRegExp = RegExp(r'^\d{10}$');
    if (!phoneRegExp.hasMatch(phone)) {
      phoneError = 'Please enter a valid 10-digit mobile number.';
      notifyListeners();
      return;
    }
    isLoading = true;
    phoneError = null;
    notifyListeners();
    final response = await _dioHttp.login(context, userName: phone);
    isLoading = false;
    final apiResponse = BaseApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (data) => data as Map<String, dynamic>,
    );
    if (apiResponse.dataResponse.returnCode == 0) {
      otpSent = true;
      testOtp = apiResponse.data?['otp'].toString();
    } else {
      otpSent = false;
      testOtp = null;
      MySnackBar.showSnackBar(
        context,
        apiResponse.dataResponse.description.isNotEmpty
            ? apiResponse.dataResponse.description
            : 'Failed to send OTP',
      );
    }
    notifyListeners();
  }

  void validatePhone(String value) {
    final phoneRegExp = RegExp(r'^\d{10}$');
    if (value.trim().isEmpty) {
      phoneError = null;
    } else if (!phoneRegExp.hasMatch(value.trim())) {
      phoneError = 'Please enter a valid 10-digit mobile number.';
    } else {
      phoneError = null;
    }
    notifyListeners();
  }

  Future<bool> verifyOtp(
    BuildContext context,
    String phone,
    String otpText,
  ) async {
    isLoading = true;
    notifyListeners();
    final response = await _dioHttp.verifyOTP(
      context,
      userName: phone,
      otp: int.parse(otpText),
    );
    isLoading = false;
    final apiResponse = BaseApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (data) => data as Map<String, dynamic>,
    );
    notifyListeners();
    if (apiResponse.dataResponse.returnCode == 0) {
      final token = apiResponse.data?['token'];
      await MySecureStorage().writeToken(token);
      MySnackBar.showSnackBar(context, "Login successful");
      return true;
    } else {
      MySnackBar.showSnackBar(
        context,
        apiResponse.dataResponse.description.isNotEmpty
            ? apiResponse.dataResponse.description
            : 'OTP verification failed',
      );
      return false;
    }
  }

  void reset() {
    isLoading = false;
    otpSent = false;
    testOtp = null;
    phoneError = null;
    notifyListeners();
  }
}
