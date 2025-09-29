import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_container.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/feature/login_screen/loginProvider.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool otpSent = false;
  String? testOtp;
  bool isLoading = false;


  Future<void> handleSendOtp() async {
    if (phoneController.text.length == 10) {
      setState(() => isLoading = true);
      final provider = Provider.of<LoginProvider>(context, listen: false);
      final response = await provider.login(
        context,
        userName: phoneController.text,
        roleUniqueIds: "DELIVERY_PARTNER",
      );
      setState(() => isLoading = false);
      if (response.data['dataResponse']['returnCode'] == 0) {
        setState(() {
          otpSent = true;
          testOtp = response.data['data']['otp'].toString();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response.data['dataResponse']['description'] ?? 'Login failed',
            ),
          ),
        );
      }
    }
  }

  Future<void> handleVerifyOtp() async {
    setState(() => isLoading = true);
    final provider = Provider.of<LoginProvider>(context, listen: false);
    final response = await provider.verifyOTP(
      context,
      userName: phoneController.text,
      otp: int.parse(otpController.text),
    );
    setState(() => isLoading = false);
    if (response.data['dataResponse']['returnCode'] == 0) {
      final token = response.data['data']['token'];
      await MySecureStorage().writeToken(token);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login successful!')));
      context.go(AppRoutes.homeScreen);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.data['dataResponse']['description'] ??
                'OTP verification failed',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 120.h),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: const Color.fromARGB(255, 253, 255, 253),
                ),
                child: Padding(
                  padding: EdgeInsets.all(18.r),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.fire_truck_outlined,
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Driver Login',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      CommonTextfield(
                        hintText: 'Enter Phone Number',
                        textEditingController: phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: !otpSent,
                      ),
                      if (otpSent) ...[
                        SizedBox(height: 20),
                        CommonTextfield(
                          hintText: 'Enter OTP',
                          textEditingController: otpController,
                          keyboardType: TextInputType.number,
                        ),
                        if (testOtp != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Test OTP: $testOtp',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                      SizedBox(height: 20),
                      isLoading
                          ? const CircularProgressIndicator()
                          : CommonButton(
                              onTap: otpSent ? handleVerifyOtp : handleSendOtp,
                              buttonValue: otpSent
                                  ? 'Verify & Login'
                                  : 'Send OTP',
                            ),
                      SizedBox(height: 50),
                      Text(
                        'By logging in, you agree to our Terms of Service',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color.fromARGB(255, 136, 136, 136),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
