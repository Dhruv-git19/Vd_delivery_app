import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class CommonContainer extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? iconBgColor;
  final TextStyle? textStyle;

  const CommonContainer({
    super.key,
    required this.title,
    this.width,
    this.height,
    this.backgroundColor,
    this.iconColor,
    this.iconBgColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 425.h,
      width: width ?? 354.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color:
            backgroundColor ??
            const Color.fromARGB(
              255,
              253,
              255,
              253,
            ), //change when using it on actual screen , just for showing that it exist.....
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: iconBgColor ?? primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.fire_truck_outlined,
                    size: 28,
                    color: iconColor ?? Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                title,
                style:
                    textStyle ??
                    TextStyle(
                      fontSize: 18.sp,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
