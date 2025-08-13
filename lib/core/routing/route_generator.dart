import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/feature/home_screen/home_screen.dart';
import 'package:vedasip_delivery_app/feature/login_screen/login_screen.dart';
import 'package:vedasip_delivery_app/feature/login_screen/otp_screen.dart';
import 'package:vedasip_delivery_app/feature/verification_screen/verification_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/otp':
        return MaterialPageRoute(builder: (_) => const OtpScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/verification':
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
