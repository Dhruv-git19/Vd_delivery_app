import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/routes/route_generator.dart';
import 'package:vedasip_delivery_app/feature/login_screen/loginProvider.dart';



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
        ],
        child: MaterialApp.router(
          title: 'Delivery App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          routerConfig: MyAppRouter().router,
        ),
      ),
    );
  }
}
