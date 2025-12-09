import 'package:flutter/material.dart';
import '../../../services/dio_http.dart';
import '../model/delivery_history_model.dart';

class MyDeliveriesProvider with ChangeNotifier {
  final DioHttp _dioHttp = DioHttp();

  List<Delivery> deliveries = [];
  bool isLoading = true;
  String? error;
  Pagination? pagination;
  Summary? summary;

  Future<void> fetchDeliveryHistory(BuildContext context) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _dioHttp.getDeliveryPartnerOrderHistory(context);

      final dynamic payload =
          (response.data is Map && response.data.containsKey('data'))
          ? response.data['data']
          : response.data;

      if (payload is Map<String, dynamic>) {
        final historyResponse = DeliveryHistoryResponse.fromJson(payload);
        deliveries = historyResponse.deliveries;
        pagination = historyResponse.pagination;
        summary = historyResponse.summary;
      } else {
        deliveries = [];
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      deliveries = [];
      isLoading = false;
      notifyListeners();
    }
  }

  // Filter deliveries by search text
  List<Delivery> filterDeliveries(String searchText) {
    if (searchText.isEmpty) return deliveries;

    final lowerSearch = searchText.toLowerCase();
    return deliveries.where((delivery) {
      return delivery.customerName.toLowerCase().contains(lowerSearch) ||
          delivery.customerMobile.contains(searchText) ||
          delivery.address?.fullAddress.toLowerCase().contains(lowerSearch) ==
              true ||
          delivery.orderId.toString().contains(searchText);
    }).toList();
  }
}
