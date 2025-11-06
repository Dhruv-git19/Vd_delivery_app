import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/screens/deliveries_list_screen/deliveries_list_screen.dart';
import 'package:vedasip_delivery_app/screens/login_screen/view/login_screen.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/delivery_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/provider/delivery_details_provider.dart';
import 'package:vedasip_delivery_app/screens/home_screen/view/home_screen.dart';
import 'package:vedasip_delivery_app/screens/confirm_delivery%20screen/confirm_delivery%20screen.dart';
import 'package:vedasip_delivery_app/screens/my_deliveries_map_screen/my_deliveries_map_screen.dart';
import 'package:vedasip_delivery_app/screens/payment_collection_screen/payment_collection_screen.dart';
import 'package:vedasip_delivery_app/screens/splash_screen/splash_screen.dart';
import 'package:vedasip_delivery_app/screens/verification_screen.dart/verification_screen.dart';

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
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>? ?? {};
          final id = params['id'] as int?;
          final type = params['type'] as String?;

          return ChangeNotifierProvider(
            create: (_) => DeliveryDetailsProvider(),
            child: DeliveryDetailsScreen(orderId: id, type: type),
          );
        },
      ),
      GoRoute(
        path: '/confirmDelivery',
        name: AppRoutes.confirmDeliveryScreen,
        builder: (context, state) => const ConfirmDeliveryScreen(),
      ),
      GoRoute(
        path: '/deliveryList',
        name: AppRoutes.deliveryListScreen,
        builder: (context, state) => const DeliveriesListScreen(),
      ),
      GoRoute(
        path: '/paymentCollection',
        name: AppRoutes.paymentCollectionScreen,
        builder: (context, state) => const PaymentCollectionScreen(),
      ),
      GoRoute(
        path: '/deliveryMap',
        name: AppRoutes.myDeliveriesMapScreen,
        builder: (context, state) => const MyDeliveriesMapScreen(),
      ),
      GoRoute(
        path: '/verification',
        name: AppRoutes.verificationscreen,
        builder: (context, state) => const VerificationScreen(),
      ),
    ],
  );
}
