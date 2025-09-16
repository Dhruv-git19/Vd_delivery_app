import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class CommonButton extends StatelessWidget {
  final String buttonValue;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final TextStyle? textStyle;
  final IconData? icon;
  final double? height;
  final double? width;
  final double borderRadius;
  final Color? outlineColor;

  const CommonButton({
    super.key,
    required this.buttonValue,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.gradient,
    this.textStyle,
    this.icon,
    this.height,
    this.width,
    this.borderRadius = 10.0,
    this.outlineColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 48.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius.r),
          onTap: onTap,
          child: Container(
            padding:
                padding ??
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: gradient == null
                  ? (backgroundColor ?? primaryColor)
                  : null,
              gradient: gradient,
              borderRadius: BorderRadius.circular(borderRadius.r),
              border: Border.all(color: outlineColor ?? Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20.sp, color: Colors.white),
                  SizedBox(width: 6.w),
                ],
                Text(
                  buttonValue,
                  style:
                      textStyle ??
                      TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
