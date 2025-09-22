import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';

class CommonContainer extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? iconBgColor;
  final TextStyle? textStyle;
  final String hintText;
  final String labelText;
  final String buttonValue;
  final VoidCallback? onTap;

  const CommonContainer({
    super.key,
    required this.title,
    this.width,
    this.height,
    this.backgroundColor,
    this.iconColor,
    this.iconBgColor,
    this.textStyle,
    required this.hintText,
    required this.labelText,
    required this.buttonValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: EdgeInsets.all(18.r),
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
              SizedBox(height: 20),
              CommonTextfield(hintText: hintText, labelText: labelText),
              SizedBox(height: 20),
              CommonButton(buttonValue: buttonValue, onTap: onTap),
              SizedBox(height: 100.h),
              Text(
                'By logging in, you agree to our Terms of Service',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color.fromARGB(255, 136, 136, 136),
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
