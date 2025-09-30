import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';

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
    if (response.data['dataResponse']['returnCode'] == 0) {
      otpSent = true;
      testOtp = response.data['data']['otp'].toString();
    } else {
      otpSent = false;
      testOtp = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.data['dataResponse']['description'] ?? 'Login failed',
          ),
        ),
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
    notifyListeners();
    if (response.data['dataResponse']['returnCode'] == 0) {
      final token = response.data['data']['token'];
      await MySecureStorage().writeToken(token);
      MySnackBar.showSnackBar(context, "Login successful");
      return true;
    } else {
      MySnackBar.showSnackBar(
        context,
        response.data['dataResponse']['description'] ??
            'OTP verification failed',
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
