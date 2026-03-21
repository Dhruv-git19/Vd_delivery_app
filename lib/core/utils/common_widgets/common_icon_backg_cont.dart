import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonIconBackgCont extends StatelessWidget {
  final Icon icon;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  const CommonIconBackgCont({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[300],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: icon,
        ),
      ),
    );
  }
}
