import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';
import 'package:vedasip_delivery_app/theme/color_pallete.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkTokenAndRedirect();
  }

  Future<void> _checkTokenAndRedirect() async {
    final token = await MySecureStorage().readToken();
    log('token $token');
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    if (token != null && token.isNotEmpty) {
      context.go(AppRoutes.homeScreen);
    } else {
      context.go(AppRoutes.loginscreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fire_truck_outlined, size: 28.r, color: Colors.white),
            SizedBox(height: 8.h),
            Text(
              "Vedasip Delivery",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
