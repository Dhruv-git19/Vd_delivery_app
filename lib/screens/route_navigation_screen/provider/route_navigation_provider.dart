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
}
