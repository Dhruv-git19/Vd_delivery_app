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
    notifyListeners();
    try {
      final ordersResponse = await _dioHttp.getSpecificOrdersAssignment(
        context,
      );
      final ordersData = ordersResponse.data['data'];
      final userResponse = await _dioHttp.getSpecificUser(context);
      final userData = userResponse.data['data'];
      orders =
          (ordersData['orders'] as List?)
              ?.map((e) => Order.fromJson(e))
              .toList() ??
          [];
      user = UserResponse.fromJson(userData);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }
}
