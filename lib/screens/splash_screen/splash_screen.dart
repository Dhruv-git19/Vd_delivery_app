import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../storage/flutter_secure_storage.dart';
import '../../theme/color_pallete.dart';

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
        child: Image.asset(
          'assets/images/DeliveryVeedasipLogo.png',
          width: 300.w,
          height: 300.h,
        ),
      ),
    );
  }
}
