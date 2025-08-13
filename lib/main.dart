import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/routing/route_generator.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/dotted_container.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/home_screen_container.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/verify_common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/xd.dart';
import 'package:vedasip_delivery_app/feature/home_screen/home_screen.dart';
import 'package:vedasip_delivery_app/feature/login_screen/login_screen.dart';
import 'package:vedasip_delivery_app/feature/login_screen/otp_screen.dart';
import 'package:vedasip_delivery_app/feature/navigation_bar/navigation_bar_screen.dart';
import 'package:vedasip_delivery_app/feature/navigation_bar/provider/provider.dart';
import 'package:vedasip_delivery_app/feature/verification_screen/verification_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationBarProvider(),
      child: ScreenUtilInit(
        minTextAdapt: true,
        child: MaterialApp(
          title: 'Delivery App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          initialRoute: '/otp',
          onGenerateRoute: RouteGenerator.generateRoute,
          home: HomeScreen(),
        ),
      ),
    );
  }
}
