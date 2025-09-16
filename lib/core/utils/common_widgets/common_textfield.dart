import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class CommonTextfield extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final String? errorText;
  final double? height;
  final double? width;
  final Color? fillColor;
  final Color? borderColor;
  final Icon? icon;
  final double? radius;

  const CommonTextfield({
    super.key,
    required this.hintText,
    this.labelText,
    this.textEditingController,
    this.keyboardType,
    this.errorText,
    this.height,
    this.width,
    this.fillColor,
    this.borderColor,
    this.icon,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                labelText!,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          TextField(
            controller: textEditingController,
            keyboardType: keyboardType ?? TextInputType.number,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              hint: hintText != null
                  ? Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AllColors.primaryColor,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          hintText!,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 97, 95, 95),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    )
                  : null,
              filled: true,
              fillColor: fillColor ?? textfieldColor,
              hintStyle: TextStyle(
                color: const Color.fromARGB(255, 97, 95, 95),
                fontSize: 14.sp,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 6.r),
                borderSide: BorderSide(
                  color: borderColor ?? primaryColor,
                  width: 1.w,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 6.r),
                borderSide: BorderSide(
                  color: borderColor ?? primaryColor,
                  width: 1.w,
                ),
              ),
              errorText: errorText,
              errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}
