import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/dotted_container.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/verify_common_button.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                verificationColor,
                const Color.fromARGB(255, 218, 247, 239),
              ],
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
            ),
          ),
        ),

        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              Text(
                'Complete Your Profile',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: verifyheadingcolor,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'Please upload the following documents',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color.fromARGB(255, 106, 106, 106),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 25.h),

              DottedContainer(
                title: 'ID Photo',
                subtitle: 'Take a clear photo of your government ID',
                icon: Icons.check_rounded,
                button: VerifyCommonButton(
                  buttonValue: 'Replace',
                  width: 60.w,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 12.h),

              DottedContainer(
                title: 'Driving License',
                subtitle: 'Take a clear photo of your government ID',
                icon: Icons.plagiarism_outlined,
                iconColor: const Color.fromARGB(255, 121, 120, 120),
                button: VerifyCommonButton(
                  buttonValue: 'Take Photo',
                  width: 90.w,
                ),
              ),
              SizedBox(height: 8.h),

              DottedContainer(
                height: 140.h,
                title: 'Vehicle Registration',
                subtitle: 'Upload your vehicle registration document',
                icon: Icons.plagiarism_outlined,
                iconColor: const Color.fromARGB(255, 119, 119, 119),
                button: VerifyCommonButton(
                  buttonValue: 'Take Photo',
                  width: 90.w,
                ),
              ),

              SizedBox(height: 100.h),
            ],
          ),
        ),

        Positioned(
          bottom: 45.h,
          left: 22.w,
          right: 22.w,
          child: CommonButton(
            buttonValue: 'Complete Verification',
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),

        Positioned(
          bottom: 28.h,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Your documents will be reviewed within 24 hours',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: const Color.fromARGB(255, 136, 136, 136),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
