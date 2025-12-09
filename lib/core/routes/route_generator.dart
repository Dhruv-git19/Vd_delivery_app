import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../screens/confirm_delivery screen/confirm_delivery screen.dart';
import '../../screens/delivery_details_screen/delivery_details_screen.dart';
import '../../screens/delivery_details_screen/provider/delivery_details_provider.dart';
import '../../screens/delivery_history_detail_screen/delivery_history_detail_screen.dart';
import '../../screens/delivery_history_detail_screen/provider/specific_delivery_provider.dart';
import '../../screens/home_screen/view/home_screen.dart';
import '../../screens/login_screen/view/login_screen.dart';
import '../../screens/my_deliveries_screen/my_deliveries.dart';
import '../../screens/my_deliveries_screen/provider/my_deliveries_provider.dart';
import '../../screens/payment_collection_screen/payment_collection_screen.dart';
import '../../screens/route_navigation_screen/provider/route_navigation_provider.dart';
import '../../screens/route_navigation_screen/route_navigation_screen.dart';
import '../../screens/splash_screen/splash_screen.dart';
import '../../screens/verification_screen.dart/verification_screen.dart';
import 'app_routes.dart';

GoRouter buildRouter() {
  return GoRouter(
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
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>? ?? {};
          final id = params['id'] as int?;
          final type = params['type'] as String?;

          return ConfirmDeliveryScreen(orderId: id, type: type);
        },
      ),
      GoRoute(
        path: '/deliveryList',
        name: AppRoutes.deliveryListScreen,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => MyDeliveriesProvider(),
          child: const MyDeliveries(),
        ),
      ),
      GoRoute(
        path: '/deliveryHistoryDetail',
        name: AppRoutes.deliveryHistoryDetailScreen,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>? ?? {};
          final orderId = params['orderId'] as int? ?? 0;
          final orderType = params['orderType'] as String? ?? 'cart';

          return ChangeNotifierProvider(
            create: (_) => SpecificDeliveryProvider(),
            child: DeliveryHistoryDetailScreen(
              orderId: orderId,
              orderType: orderType,
            ),
          );
        },
      ),
      GoRoute(
        path: '/paymentCollection',
        name: AppRoutes.paymentCollectionScreen,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>? ?? {};
          final id = params['id'] as int?;
          final type = params['type'] as String?;

          return PaymentCollectionScreen(orderId: id, type: type);
        },
      ),
      GoRoute(
        path: '/routeNavigation',
        name: AppRoutes.routeNavigationScreen,
        builder: (context, state) => ChangeNotifierProvider(
          create: (_) => RouteNavigationProvider(),
          child: const RouteNavigationScreen(),
        ),
      ),
      GoRoute(
        path: '/verification',
        name: AppRoutes.verificationscreen,
        builder: (context, state) => const VerificationScreen(),
      ),
    ],
  );
}
