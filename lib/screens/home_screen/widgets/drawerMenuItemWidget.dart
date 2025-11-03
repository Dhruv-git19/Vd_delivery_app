import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const DrawerMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AllColors.drawerIconBackColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: primaryColor, size: 22.r),
            ),
            SizedBox(width: 14.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,

                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
