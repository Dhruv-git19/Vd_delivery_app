import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/routes/route_generator.dart';
import 'screens/delivery_details_screen/provider/delivery_details_provider.dart';
import 'screens/home_screen/provider/homeProvider.dart';
import 'screens/login_screen/provider/loginProvider.dart';
import 'screens/my_deliveries_screen/provider/my_deliveries_provider.dart';

final router = buildRouter();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => DeliveryDetailsProvider()),
          ChangeNotifierProvider(create: (_) => MyDeliveriesProvider()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Delivery App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(scaffoldBackgroundColor: Colors.white),
        ),
      ),
    );
  }
}
