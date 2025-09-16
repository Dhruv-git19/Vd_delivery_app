import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_confirm_cont.dart';
import 'package:vedasip_delivery_app/feature/login_screen/login_screen.dart';
import 'package:vedasip_delivery_app/feature/otp_screen/otp_screen.dart';
import 'package:vedasip_delivery_app/feature/delivery_details_screen/delivery_details_screen.dart';
import 'package:vedasip_delivery_app/feature/home_screen/home_screen.dart';
import 'package:vedasip_delivery_app/feature/confirm_delivery%20screen/confirm_delivery%20screen.dart';

import 'package:vedasip_delivery_app/feature/verification%20screen/verification_screen.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    initialLocation: '/confirmDelivery',
    routes: [
      GoRoute(
        path: '/otp',
        name: AppRoutes.otpscreen,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoutes.loginscreen,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/home',
        name: AppRoutes.homeScreen,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/deliveryDetails',
        name: AppRoutes.deliveryDetailsScreen,
        builder: (context, state) => const DeliveryDetailsScreen(),
      ),
      GoRoute(
        path: 'confirmDelivery',
        name: AppRoutes.confirmDeliveryScreen,
        builder: (context, state) => const ConfirmDeliveryScreen(),
      ),
    ],
  );
}
