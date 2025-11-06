import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/screens/home_screen/model/user_model.dart';
import 'package:vedasip_delivery_app/screens/home_screen/model/order_model.dart';

class HomeProvider with ChangeNotifier {
  final DioHttp _dioHttp = DioHttp();

  List<Order> orders = [];
  bool isLoading = true;
  UserResponse? user;
  String? loginError;

  Future<void> fetchData(BuildContext context) async {
    isLoading = true;
    orders = [];
    notifyListeners();
    try {
      final ordersResponse = await _dioHttp.getSpecificOrdersAssignment(
        context,
      );

      final dynamic payload =
          (ordersResponse.data is Map &&
              ordersResponse.data.containsKey('data'))
          ? ordersResponse.data['data']
          : ordersResponse.data;

      dynamic maybeOrders = payload is Map && payload.containsKey('orders')
          ? payload['orders']
          : payload;

      List? ordersList;
      if (maybeOrders is List) {
        ordersList = maybeOrders;
      } else if (maybeOrders is Map &&
          maybeOrders.containsKey('orders') &&
          maybeOrders['orders'] is List) {
        ordersList = maybeOrders['orders'] as List?;
      } else {
        ordersList = null;
      }

      orders = (ordersList ?? <dynamic>[])
          .map<Order?>((e) {
            try {
              return Order.fromJson(e);
            } catch (err, st) {
              debugPrint('Order parsing error: $err\n$st\nitem: $e');
              return null;
            }
          })
          .whereType<Order>()
          .toList();

      final userResponse = await _dioHttp.getSpecificUser(context);
      final dynamic userPayload =
          (userResponse.data is Map && userResponse.data.containsKey('data'))
          ? userResponse.data['data']
          : userResponse.data;
      try {
        user = userPayload != null ? UserResponse.fromJson(userPayload) : null;
      } catch (err) {
        user = null;
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      orders = [];
      isLoading = false;
      notifyListeners();
    }
  }
}
