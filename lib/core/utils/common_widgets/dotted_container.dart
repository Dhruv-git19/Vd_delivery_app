import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/verify_common_button.dart';

class DottedContainer extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final String? verifyText;
  final double? widthcont;
  final double? height;
  final Color? iconColor;
  final Color? textColor;
  final VerifyCommonButton? button;

  const DottedContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.verifyText,
    this.widthcont,
    this.height,
    this.iconColor,
    this.textColor,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: DottedBorder(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: 5.h),
                if (icon != null)
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 236, 235, 235),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Icon(
                      icon,
                      size: 28.sp,
                      color: iconColor ?? primaryColor,
                    ),
                  ),
                SizedBox(height: 5.h),
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                  ),
                SizedBox(height: 6.h),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: const Color.fromARGB(255, 129, 127, 127),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (verifyText != null)
                  Text(
                    verifyText!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: textColor ?? Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                SizedBox(height: 5.h),
                if (button != null)
                  Padding(
                    padding: EdgeInsets.only(
                      left: 30.w,
                      right: 30.w,
                      bottom: 10.h,
                      top: 2.h,
                    ),
                    child: button!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
