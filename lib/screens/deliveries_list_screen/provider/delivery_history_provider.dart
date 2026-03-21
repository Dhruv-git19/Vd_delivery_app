import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/screens/deliveries_list_screen/model/delivery_history_model.dart';

class DeliveryHistoryProvider with ChangeNotifier {
  final DioHttp _dioHttp = DioHttp();

  List<Delivery> deliveries = [];
  bool isLoading = true;
  String? error;
  Pagination? pagination;
  Summary? summary;
  bool showNormalOrders = true;
  bool showSubscriptionOrders = true;

  String get orderTypeFilter {
    if (showNormalOrders && showSubscriptionOrders) return 'All';
    if (showNormalOrders) return 'Normal Order';
    if (showSubscriptionOrders) return 'Subscription';
    return 'All';
  }

  bool _isSubscription(Delivery delivery) {
    return delivery.type.toLowerCase().contains('sub');
  }

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
    final lowerSearch = searchText.toLowerCase();

    return deliveries.where((delivery) {
      final isSub = _isSubscription(delivery);
      final matchesType = isSub ? showSubscriptionOrders : showNormalOrders;
      if (!matchesType) return false;

      if (searchText.isEmpty) return true;

      return delivery.customerName.toLowerCase().contains(lowerSearch) ||
          delivery.customerMobile.contains(searchText) ||
          delivery.address?.fullAddress.toLowerCase().contains(lowerSearch) ==
              true ||
          delivery.orderId.toString().contains(searchText);
    }).toList();
  }

  void setShowNormalOrders(bool value) {
    showNormalOrders = value;
    notifyListeners();
  }

  void setShowSubscriptionOrders(bool value) {
    showSubscriptionOrders = value;
    notifyListeners();
  }

  void setOrderTypeFilter(String? value) {
    final v = value ?? 'All';
    if (v == 'Normal Order') {
      showNormalOrders = true;
      showSubscriptionOrders = false;
    } else if (v == 'Subscription') {
      showNormalOrders = false;
      showSubscriptionOrders = true;
    } else {
      showNormalOrders = true;
      showSubscriptionOrders = true;
    }
    notifyListeners();
  }
}
