import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/screens/login_screen/view/login_screen.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/delivery_details_screen.dart';
import 'package:vedasip_delivery_app/screens/home_screen/view/home_screen.dart';
import 'package:vedasip_delivery_app/screens/confirm_delivery%20screen/confirm_delivery%20screen.dart';
import 'package:vedasip_delivery_app/screens/splash_screen/splash_screen.dart';

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
