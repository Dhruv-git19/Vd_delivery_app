import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';

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
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
