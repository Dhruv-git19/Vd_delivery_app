import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/routing/route_generator.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/feature/login_screen.dart/login_screen.dart';
import 'package:vedasip_delivery_app/feature/login_screen.dart/otp_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Delivery App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/otp',
        onGenerateRoute: RouteGenerator.generateRoute,
        home: const OtpScreen(),
      ),
    );
  }
}
