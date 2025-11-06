import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget iconText(IconData icon, String text) {
  return Row(
    children: [
      Icon(icon, size: 17.sp, color: const Color.fromARGB(255, 102, 102, 102)),
      SizedBox(width: 4.w),
      Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: Color.fromARGB(255, 134, 134, 134),
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
