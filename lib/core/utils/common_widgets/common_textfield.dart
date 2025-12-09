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
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Icon? icon;
  final double? radius;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final EdgeInsetsGeometry? contentPadding;

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
    this.prefixIcon,
    this.suffixIcon,
    this.radius,
    this.enabled = true,
    this.onChanged,
    this.contentPadding,
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
              padding: EdgeInsets.only(bottom: 2.h),
              child: Text(
                labelText!,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),
          TextField(
            controller: textEditingController,
            keyboardType: keyboardType ?? TextInputType.number,
            enabled: enabled,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding:
                  contentPadding ??
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hint: hintText != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
            ),
          ),
          if (errorText != null)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                errorText!,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            ),
        ],
      ),
    );
  }
}
