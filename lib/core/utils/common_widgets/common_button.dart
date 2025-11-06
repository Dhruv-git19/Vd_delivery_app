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
  final Icon? icon;
  final double? height;
  final double? width;
  final double borderRadius;
  final Color? outlineColor;
  final BoxConstraints? boxConstraints;
  final bool isfullWidth;

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
    this.boxConstraints,
    this.isfullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius.r),
        onTap: onTap,
        child: Container(
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: gradient == null ? (backgroundColor ?? primaryColor) : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius.r),
            border: Border.all(color: outlineColor ?? Colors.transparent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, SizedBox(width: 6.w)],
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
    );

    if (isfullWidth) {
      return SizedBox(width: double.infinity, child: buttonChild);
    } else if (width != null) {
      return SizedBox(width: width, child: buttonChild);
    } else {
      return buttonChild;
    }
  }
}
