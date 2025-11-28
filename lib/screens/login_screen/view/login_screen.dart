import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/screens/login_screen/provider/loginProvider.dart';
import 'package:vedasip_delivery_app/theme/color_pallete.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<LoginProvider>(context, listen: false);
      provider.reset();
      phoneController.clear();
      otpController.clear();
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          return Stack(
            children: [
              Container(
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 24.h,
                    ),
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          maxWidth: 400.w,
                          maxHeight: 520.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          color: const Color.fromARGB(255, 253, 255, 253),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(18.r),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(
                                    context,
                                  ).viewInsets.bottom,
                                ),
                                child: IntrinsicHeight(
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
                                        child: Center(
                                          child: Icon(
                                            Icons.fire_truck_outlined,
                                            size: 28.r,
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
                                      SizedBox(height: 20.h),
                                      CommonTextfield(
                                        hintText: 'Enter Phone Number',
                                        textEditingController: phoneController,
                                        keyboardType: TextInputType.phone,
                                        enabled: !provider.otpSent,
                                        errorText: provider.phoneError,
                                        onChanged: (value) =>
                                            provider.validatePhone(value),
                                      ),
                                      if (provider.otpSent) ...[
                                        SizedBox(height: 20.h),
                                        CommonTextfield(
                                          hintText: 'Enter OTP',
                                          textEditingController: otpController,
                                          keyboardType: TextInputType.number,
                                        ),
                                        if (provider.testOtp != null)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 8.0.h,
                                            ),
                                            child: Text(
                                              'Test OTP: ${provider.testOtp}',
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        SizedBox(height: 10.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () => provider.sendOtp(
                                                context,
                                                phoneController.text,
                                              ),
                                              child: const Text('Resend OTP'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                provider.reset();
                                                otpController.clear();
                                                phoneController.clear();
                                              },
                                              child: const Text(
                                                'Change Number',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      SizedBox(height: 20.h),
                                      provider.isLoading
                                          ? const CircularProgressIndicator()
                                          : CommonButton(
                                              isfullWidth: true,
                                              onTap: provider.otpSent
                                                  ? () async {
                                                      final success =
                                                          await provider
                                                              .verifyOtp(
                                                                context,
                                                                phoneController
                                                                    .text,
                                                                otpController
                                                                    .text,
                                                              );
                                                      if (success) {
                                                        context.go(
                                                          AppRoutes.homeScreen,
                                                        );
                                                      }
                                                    }
                                                  : () => provider.sendOtp(
                                                      context,
                                                      phoneController.text,
                                                    ),
                                              buttonValue: provider.otpSent
                                                  ? 'Verify & Login'
                                                  : 'Send OTP',
                                            ),
                                      SizedBox(height: 50.h),
                                      Text(
                                        'By logging in, you agree to our Terms of Service',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: const Color(0xFF888888),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   left: 0,
              //   right: 0,
              //   bottom: 24.h,
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(horizontal: 18.w),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Text(
              //           "Don't have an account? ",
              //           style: TextStyle(
              //             fontSize: 12.sp,
              //             color: AppColor.constWhite,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //         GestureDetector(
              //           onTap: () {
              //             context.go(AppRoutes.verificationscreen);
              //           },
              //           child: Text(
              //             'Register here',
              //             style: TextStyle(
              //               fontSize: 12.sp,
              //               color: primaryColor,
              //               fontWeight: FontWeight.w600,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
