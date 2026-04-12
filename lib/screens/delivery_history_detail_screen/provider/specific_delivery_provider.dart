import 'package:flutter/foundation.dart';
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
        if (kDebugMode) {
          final items = deliveryData?.orderDetails?.cart?.items ?? const [];
          final withImages = items
              .where((i) => i.productImages.isNotEmpty)
              .length;
          final firstImage =
              items.isNotEmpty && items.first.productImages.isNotEmpty
                  ? items.first.productImages.first.imageUrl
                  : '';
          debugPrint(
            'SpecificDelivery: items=${items.length} withImages=$withImages firstImageUrl=$firstImage',
          );
        }
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
