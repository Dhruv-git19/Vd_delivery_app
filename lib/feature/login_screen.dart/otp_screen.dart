import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_container.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                height: 360.h,
              ),
            ),
          ),
          Positioned(
            top: 270.h,
            left: 35.w,
            right: 35.w,
            child: CommonTextfield(
              hintText: 'Enter phone number',
              labelText: 'Phone Number',
            ),
          ),
          Positioned(
            top: 370.h,
            left: 35.w,
            right: 35.w,
            child: CommonButton(
              buttonValue: 'OTP',
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ),
        ],
      ),
    );
  }
}
