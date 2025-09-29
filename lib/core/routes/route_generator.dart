import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/feature/login_screen/login_screen.dart';
import 'package:vedasip_delivery_app/feature/delivery_details_screen/delivery_details_screen.dart';
import 'package:vedasip_delivery_app/feature/home_screen/home_screen.dart';
import 'package:vedasip_delivery_app/feature/confirm_delivery%20screen/confirm_delivery%20screen.dart';
import 'package:vedasip_delivery_app/feature/splash_screen/splash_screen.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
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
        path: '/confirmDelivery',
        name: AppRoutes.confirmDeliveryScreen,
        builder: (context, state) => const ConfirmDeliveryScreen(),
      ),
    ],
  );
}
