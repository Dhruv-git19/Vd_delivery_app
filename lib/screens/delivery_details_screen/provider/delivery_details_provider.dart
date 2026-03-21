import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';

class DeliveryDetailsProvider with ChangeNotifier {
  final DioHttp _dio = DioHttp();

  bool isLoading = false;
  Map<String, dynamic>? details;
  String? error;

  Future<Map<String, double>?> _tryGetCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return null;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return {'lat': pos.latitude, 'lng': pos.longitude};
    } catch (_) {
      return null;
    }
  }

  Future<void> fetchOrderDetails(
    BuildContext context, {
    required int orderId,
    required String type,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final warehouseLocation =
          await _tryGetCurrentLocation() ?? {'lat': 28.6139, 'lng': 77.2090};
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
