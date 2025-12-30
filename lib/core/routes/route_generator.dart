import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/screens/cash_collection_screen/cash_collection_screen.dart';
import 'package:vedasip_delivery_app/screens/deliveries_list_screen/deliveries_list_screen.dart';
import 'package:vedasip_delivery_app/screens/login_screen/view/login_screen.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/delivery_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/provider/delivery_details_provider.dart';
import 'package:vedasip_delivery_app/screens/deliveries_list_screen/provider/delivery_history_provider.dart';
import 'package:vedasip_delivery_app/screens/delivery_history_detail_screen/provider/specific_delivery_provider.dart';
import 'package:vedasip_delivery_app/screens/delivery_history_detail_screen/delivery_history_detail_screen.dart';
import 'package:vedasip_delivery_app/screens/home_screen/view/home_screen.dart';
import 'package:vedasip_delivery_app/screens/confirm_delivery%20screen/confirm_delivery%20screen.dart';
import 'package:vedasip_delivery_app/screens/route_navigation_screen/route_navigation_screen.dart';
import 'package:vedasip_delivery_app/screens/route_navigation_screen/provider/route_navigation_provider.dart';
import 'package:vedasip_delivery_app/screens/my_deliveries_map_screen/my_deliveries_map_screen.dart';
import 'package:vedasip_delivery_app/screens/payment_collection_screen/payment_collection_screen.dart';
import 'package:vedasip_delivery_app/screens/splash_screen/splash_screen.dart';
import 'package:vedasip_delivery_app/screens/verification_screen.dart/verification_screen.dart';

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
          create: (_) => DeliveryHistoryProvider(),
          child: const DeliveriesListScreen(),
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
        path: '/deliveryMap',
        name: AppRoutes.myDeliveriesMapScreen,
        builder: (context, state) => const MyDeliveriesMapScreen(),
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
        GoRoute(
        path: '/cashCollections',
        name: 'cashCollectionScreen',
        builder: (context, state) => const CashCollectionScreen(),
      ),
    ],
  );
}
