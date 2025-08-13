import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_container.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [primaryColor, secondaryColor],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CommonContainer(
                title: "Driver Login",
                width: 354.w,
                height: 425.h,
              ),
            ),
          ),
          Positioned(
            top: 265.h,
            left: 35.w,
            right: 35.w,
            child: CommonTextfield(
              hintText: 'Enter OTP',
              labelText: 'Enter OTP',
            ),
          ),
          Positioned(
            top: 365.h,
            left: 35.w,
            right: 35.w,
            child: CommonButton(
              buttonValue: 'Verify & Login',
              onTap: () {
                Navigator.pushNamed(context, '/verification');
              },
            ),
          ),
          Positioned(
            bottom: 150.h,
            left: 38.w,
            right: 20.w,
            child: Text(
              "By logging in, you agree to our Terms of Service ",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
