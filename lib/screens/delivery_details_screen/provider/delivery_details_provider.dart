import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';

class DeliveryDetailsProvider with ChangeNotifier {
  final DioHttp _dio = DioHttp();

  bool isLoading = false;
  Map<String, dynamic>? details;
  String? error;

  Future<void> fetchOrderDetails(
    BuildContext context, {
    required int orderId,
    required String type, 
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final warehouseLocation = {'lat': 28.6139, 'lng': 77.2090};
      final resp = await _dio.getSpecificOrderDetails(
        context,
        orderId: orderId,
        type: type,
        warehouseLocation: warehouseLocation,
      );

      final dynamic payload =
          (resp.data is Map && resp.data.containsKey('data'))
          ? resp.data['data']
          : resp.data;

      if (payload is Map<String, dynamic>) {
        details = payload;
      } else {
        details = {'data': payload};
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
