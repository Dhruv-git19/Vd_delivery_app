import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/feature/navigation_bar/provider/provider.dart';

class NavigationBarScreen extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  const NavigationBarScreen({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            ClipOval(
              child: Image.asset(
                'assets/profile.webp',
                width: 80.w,
                height: 80.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30.h),
            _tile(Icons.person, 'Profile'),
            _tile(Icons.production_quantity_limits, 'My Delivery'),
            _tile(Icons.push_pin_outlined, 'Live Map'),
            _tile(Icons.question_mark_outlined, 'Support'),
            _tile(Icons.logout, 'Logout'),
          ],
        ),
      ),
    );
  }
}

Widget _tile(IconData icon, String text) {
  return Material(
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListTile(
        tileColor: Colors.white,
        leading: Container(
          width: 45.w,
          height: 45.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: const Color.fromARGB(255, 229, 246, 249),
          ),
          child: Icon(icon, size: 27.w, color: primaryColor),
        ),

        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color.fromARGB(255, 128, 128, 128),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}
