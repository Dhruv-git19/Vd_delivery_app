import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/screens/route_navigation_screen/model/route_orders_model.dart';

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
      final response = await _dioHttp.getSpecificOrdersAssignment(context);

      final dynamic payload =
          (response.data is Map && response.data.containsKey('data'))
          ? response.data['data']
          : response.data;

      if (payload is Map<String, dynamic>) {
        final routeResponse = RouteOrdersResponse.fromJson(payload);
        orders = routeResponse.orders
            .where((order) => order.hasValidAddress)
            .toList();
        currentOrderIndex = 0;
      } else {
        orders = [];
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
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
