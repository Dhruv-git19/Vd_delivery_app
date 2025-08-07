import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class VerifyCommonButton extends StatelessWidget {
  final String buttonValue;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const VerifyCommonButton({
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
    return Row(
      children: [
        Material(
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: width ?? double.infinity,
              height: height ?? 30.sp,
              decoration: BoxDecoration(
                border: Border.all(color: verifybuttonBorderColor, width: 1.5),
                color: backgroundColor ?? Colors.white,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Text(
                  buttonValue,
                  style:
                      textStyle ??
                      TextStyle(
                        fontSize: 10.sp,
                        color: const Color.fromARGB(255, 144, 144, 144),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
