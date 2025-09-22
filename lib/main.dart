import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/routes/route_generator.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/feature/deliveries_list_screen/deliveries_list_screen.dart';
import 'package:vedasip_delivery_app/feature/delivery_details_screen/delivery_details_screen.dart';
import 'package:vedasip_delivery_app/feature/home_screen/xd.dart';
import 'package:vedasip_delivery_app/feature/home_screen/xd2.dart';
import 'package:vedasip_delivery_app/feature/confirm_delivery%20screen/confirm_delivery%20screen.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_container.dart';
import 'package:vedasip_delivery_app/feature/payment_collection_screen/widgets/tab_bar.dart';
import 'package:vedasip_delivery_app/feature/verification%20screen/widgets/common_verify_button.dart';
import 'package:vedasip_delivery_app/feature/home_screen/home_screen.dart';
import 'package:vedasip_delivery_app/feature/live_map_screen/live_map_screen.dart';
import 'package:vedasip_delivery_app/feature/login_screen/login_screen.dart';
import 'package:vedasip_delivery_app/feature/otp_screen/otp_screen.dart';
import 'package:vedasip_delivery_app/feature/my_deliveries_map_screen/my_deliveries_map_screen.dart';
import 'package:vedasip_delivery_app/feature/payment_collection_screen/payment_collection_screen.dart';
import 'package:vedasip_delivery_app/feature/take_photo_screen/take_photo_screen.dart';
import 'package:vedasip_delivery_app/feature/verification%20screen/verification_screen.dart';

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
        theme: ThemeData(),
        // routerConfig: MyAppRouter().router,
        home: MyDeliveriesMapScreen(),
      ),
    );
  }
}
