import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DottedContainer extends StatelessWidget {
  const DottedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        options: RectDottedBorderOptions(
          

        ),
        
        child: Container(
          height: 194.h,
          width: 354.w,
          decoration: BoxDecoration(
          ),
        ),
      ),
    );
  }
}
