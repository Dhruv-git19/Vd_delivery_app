import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';

class CommonDottedBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets? paddding;
  final double? width;

  const CommonDottedBox({
    super.key,
    required this.child,
    this.paddding,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        color: Colors.grey.shade400,
        strokeWidth: 1.2.w,
        dashPattern: [6.w, 3.w],
        borderType: BorderType.RRect,
        radius: Radius.circular(10.r),
        child: Container(
          padding: paddding,
          width: width ?? double.infinity,
          color: Colors.white,
          child: child,
        ),
      ),
    );
  }
}
