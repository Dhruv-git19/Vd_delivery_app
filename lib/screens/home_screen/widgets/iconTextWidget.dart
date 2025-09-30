  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 17, color: const Color.fromARGB(255, 102, 102, 102)),
        SizedBox(width: 4.w),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 134, 134, 134),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }