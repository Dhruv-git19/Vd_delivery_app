import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/screens/route_navigation_screen/model/route_orders_model.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';

class RouteNavigationProvider with ChangeNotifier {
  final DioHttp _dioHttp = DioHttp();

  List<RouteOrder> orders = [];
  int currentOrderIndex = 0;
  bool isLoading = true;
  String? error;
  dynamic optimizedRoute;

  RouteOrder? get currentOrder {
    if (orders.isEmpty || currentOrderIndex >= orders.length) return null;
    return orders[currentOrderIndex];
  }

  RouteOrder? get nextOrder {
    // Find next order with valid address
    for (int i = currentOrderIndex; i < orders.length; i++) {
      if (orders[i].hasValidAddress) {
        return orders[i];
      }
    }
    return null;
  }

  bool get hasNextOrder {
    // Check if there's a next order with valid address
    for (int i = currentOrderIndex + 1; i < orders.length; i++) {
      if (orders[i].hasValidAddress) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchTodaysOrders(BuildContext context) async {
    isLoading = true;
    error = null;
    optimizedRoute = null;
    notifyListeners();

    try {
      debugPrint('📍 Fetching today\'s orders...');
      final response = await _dioHttp.getSpecificOrdersAssignment(context);

      // Check if response is valid
      if (response.data == null) {
        debugPrint('❌ No data received from server');
        throw Exception('No data received from server');
      }

      log('✅ Response received: ${response.data['data']['orders']}');

      // Check for API error response
      final dataResponse = response.data['dataResponse'];
      if (dataResponse != null && dataResponse['returnCode'] != 0) {
        final description = dataResponse['description'] ?? 'Unknown error';
        debugPrint('❌ API Error: $description');
        throw Exception(description);
      }

      final dynamic payload =
          (response.data is Map && response.data.containsKey('data'))
          ? response.data['data']
          : response.data;

      debugPrint('📦 Payload type: ${payload.runtimeType}');

      if (payload is Map<String, dynamic>) {
        try {
          debugPrint('🔍 Starting to parse orders...');

          // Parse orders one by one to identify problematic order
          final ordersList = payload['orders'] as List?;
          if (ordersList == null) {
            debugPrint('❌ No orders list in payload');
            orders = [];
          } else {
            final List<RouteOrder> parsedOrders = [];
            for (int i = 0; i < ordersList.length; i++) {
              try {
                debugPrint(
                  '🔍 Parsing order $i (id: ${ordersList[i]['id']})...',
                );
                final order = RouteOrder.fromJson(
                  ordersList[i] as Map<String, dynamic>,
                );
                parsedOrders.add(order);
                debugPrint('✅ Order $i parsed successfully');
              } catch (orderError, stackTrace) {
                debugPrint('❌ Error parsing order $i: $orderError');
                debugPrint('📦 Order data: ${ordersList[i]}');
                debugPrint('Stack: $stackTrace');
                // Continue parsing other orders
              }
            }

            orders = parsedOrders
                .where((order) => order.hasValidAddress)
                .toList();

            debugPrint('📋 Total orders parsed: ${parsedOrders.length}');
            debugPrint('✅ Orders with valid addresses: ${orders.length}');
          }

          optimizedRoute = payload['optimizedRoute'];
          if (optimizedRoute != null) {
            orders = _applyOptimizedRoute(optimizedRoute, orders);
          }

          currentOrderIndex = 0;
          error = null;
        } catch (parseError, stackTrace) {
          debugPrint('❌ Parse error: $parseError');
          debugPrint('Stack trace: $stackTrace');
          error = 'Failed to parse orders: ${parseError.toString()}';
          orders = [];
        }
      } else {
        debugPrint('❌ Invalid payload type');
        error = 'Invalid response format from server';
        orders = [];
      }

      isLoading = false;
      notifyListeners();
      debugPrint('✅ fetchTodaysOrders completed');
    } catch (e, stackTrace) {
      debugPrint('❌ Exception in fetchTodaysOrders: $e');
      debugPrint('Stack trace: $stackTrace');
      error = 'Failed to load orders: ${e.toString()}';
      orders = [];
      isLoading = false;
      notifyListeners();
    }
  }

  void moveToNextOrder() {
    if (hasNextOrder) {
      currentOrderIndex++;
      notifyListeners();
    }
  }

  void moveToPreviousOrder() {
    if (currentOrderIndex > 0) {
      currentOrderIndex--;
      notifyListeners();
    }
  }

  void resetRoute() {
    currentOrderIndex = 0;
    notifyListeners();
  }

  void setOptimizedOrder(List<RouteOrder> optimizedOrders) {
    if (optimizedOrders.isEmpty) return;
    orders = optimizedOrders.where((o) => o.hasValidAddress).toList();
    currentOrderIndex = 0;
    notifyListeners();
  }

  List<RouteOrder> _applyOptimizedRoute(
    dynamic optimized,
    List<RouteOrder> baseOrders,
  ) {
    if (baseOrders.isEmpty || optimized == null) return baseOrders;

    List<int> ids = [];
    List<int> waypointOrder = [];

    if (optimized is List) {
      for (final v in optimized) {
        final parsed = int.tryParse(v?.toString() ?? '');
        if (parsed != null) ids.add(parsed);
      }
    } else if (optimized is Map) {
      final map = optimized.map((k, v) => MapEntry(k.toString(), v));
      final candidates = [
        'optimizedOrderIds',
        'orderIds',
        'order_ids',
        'sequence',
        'orderSequence',
        'order_sequence',
      ];
      for (final key in candidates) {
        final v = map[key];
        if (v is List) {
          for (final item in v) {
            if (item is Map) {
              final m = item.map((k, v) => MapEntry(k.toString(), v));
              final parsed = int.tryParse(m['id']?.toString() ?? '');
              if (parsed != null) ids.add(parsed);
            } else {
              final parsed = int.tryParse(item?.toString() ?? '');
              if (parsed != null) ids.add(parsed);
            }
          }
          if (ids.isNotEmpty) break;
        }
      }

      final wo = map['waypointOrder'] ?? map['waypoint_order'];
      if (wo is List) {
        for (final item in wo) {
          final parsed = int.tryParse(item?.toString() ?? '');
          if (parsed != null) waypointOrder.add(parsed);
        }
      }
    }

    if (ids.isNotEmpty) {
      final byId = {for (final o in baseOrders) o.id: o};
      final ordered = <RouteOrder>[];
      for (final id in ids) {
        final o = byId[id];
        if (o != null) ordered.add(o);
      }
      for (final o in baseOrders) {
        if (!ordered.any((x) => x.id == o.id)) ordered.add(o);
      }
      return ordered;
    }

    if (waypointOrder.isNotEmpty && waypointOrder.length == baseOrders.length) {
      final ordered = <RouteOrder>[];
      for (final idx in waypointOrder) {
        if (idx >= 0 && idx < baseOrders.length) ordered.add(baseOrders[idx]);
      }
      for (final o in baseOrders) {
        if (!ordered.any((x) => x.id == o.id)) ordered.add(o);
      }
      return ordered;
    }

    return baseOrders;
  }
}
