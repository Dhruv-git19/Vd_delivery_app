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

  const CommonTextfield({
    super.key,
    required this.hintText,
    required this.labelText,
    this.textEditingController,
    this.keyboardType,
    this.errorText,
    this.height,
    this.width,
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
              filled: true,
              fillColor: textfieldColor,
              hintStyle: TextStyle(
                color: const Color.fromARGB(255, 97, 95, 95),
                fontSize: 14.sp,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: primaryColor, width: 1.w),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: primaryColor, width: 1.w),
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
