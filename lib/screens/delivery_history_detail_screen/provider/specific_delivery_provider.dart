import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/screens/delivery_history_detail_screen/model/specific_delivery_model.dart';

class SpecificDeliveryProvider with ChangeNotifier {
  final DioHttp _dioHttp = DioHttp();

  SpecificDeliveryResponse? deliveryData;
  bool isLoading = true;
  String? error;

  Future<void> fetchSpecificDelivery(
    BuildContext context, {
    required int orderId,
    required String orderType,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _dioHttp.getSpecificDeliveryPartnerOrderHistory(
        context,
        orderId: orderId,
        orderType: orderType,
      );

      final dynamic payload =
          (response.data is Map && response.data.containsKey('data'))
          ? response.data['data']
          : response.data;

      if (payload is Map<String, dynamic>) {
        deliveryData = SpecificDeliveryResponse.fromJson(payload);
      } else {
        deliveryData = null;
        error = 'Invalid response format';
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      deliveryData = null;
      isLoading = false;
      notifyListeners();
    }
  }
}
