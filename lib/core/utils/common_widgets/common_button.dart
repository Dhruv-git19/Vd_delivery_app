import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class CommonButton extends StatelessWidget {
  final String buttonValue;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const CommonButton({
    super.key,
    required this.buttonValue,
    this.onTap,
    this.width,
    this.height,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 44.sp,
          decoration: BoxDecoration(
            color: backgroundColor ?? primaryColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: Text(
              buttonValue,
              style:
                  textStyle ??
                  TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
