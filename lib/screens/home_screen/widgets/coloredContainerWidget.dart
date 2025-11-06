import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget coloredContainer(String text, Color textcolor, Color contColor) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
    decoration: BoxDecoration(
      color: contColor,
      borderRadius: BorderRadius.circular(15.0.r),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 10.0.sp,
        color: textcolor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
