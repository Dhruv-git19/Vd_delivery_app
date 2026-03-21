import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:vedasip_delivery_app/screens/home_screen/model/order_model.dart';
import 'package:vedasip_delivery_app/screens/home_screen/model/user_model.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';

class HomeProvider with ChangeNotifier {
  final DioHttp _dioHttp = DioHttp();

  List<Order> orders = [];
  bool isLoading = true;
  UserResponse? user;
  String? loginError;
  bool showNormalOrders = true;
  bool showSubscriptionOrders = true;
  bool _isDistanceRefreshing = false;

  String get orderTypeFilter {
    if (showNormalOrders && showSubscriptionOrders) return 'All';
    if (showNormalOrders) return 'Normal Order';
    if (showSubscriptionOrders) return 'Subscription';
    return 'All';
  }

  bool _isSubscription(Order order) {
    final t = order.type.toLowerCase();
    return (order.subscriptionType?.isNotEmpty ?? false) || t.contains('sub');
  }

  DateTime? _parseCreatedOn(Order order) {
    final raw = order.createdOn.trim();
    if (raw.isEmpty) return null;
    return DateTime.tryParse(raw) ?? DateTime.tryParse(raw.replaceFirst(' ', 'T'));
  }

  List<Order> get visibleOrders {
    final filtered = orders.where((order) {
      final isSub = _isSubscription(order);
      if (isSub) return showSubscriptionOrders;
      return showNormalOrders;
    }).toList();

    filtered.sort((a, b) {
      final ad = _parseCreatedOn(a);
      final bd = _parseCreatedOn(b);
      if (ad == null && bd == null) return b.id.compareTo(a.id);
      if (ad == null) return 1;
      if (bd == null) return -1;
      final c = bd.compareTo(ad);
      if (c != 0) return c;
      return b.id.compareTo(a.id);
    });

    return filtered;
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
      refreshDistanceInfo(context);
    } catch (e) {
      orders = [];
      isLoading = false;
      notifyListeners();
    }
  }

  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().trim();
    return double.tryParse(s);
  }

  Future<void> refreshDistanceInfo(BuildContext context) async {
    if (_isDistanceRefreshing) return;
    if (orders.isEmpty) return;

    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) return;

    _isDistanceRefreshing = true;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final origin = '${position.latitude},${position.longitude}';

      final indexedDestinations = <({int index, String dest})>[];
      for (var i = 0; i < orders.length; i++) {
        final lat = _toDouble(orders[i].address?.latitude);
        final lng = _toDouble(orders[i].address?.longitude);
        if (lat == null || lng == null) continue;
        indexedDestinations.add((index: i, dest: '$lat,$lng'));
      }
      if (indexedDestinations.isEmpty) return;

      final updatedOrders = List<Order>.from(orders);
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://maps.googleapis.com/maps/api',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      const batchSize = 25;
      for (var start = 0; start < indexedDestinations.length; start += batchSize) {
        final batch = indexedDestinations.skip(start).take(batchSize).toList();
        final destinations = batch.map((e) => e.dest).join('|');

        final resp = await dio.get(
          '/distancematrix/json',
          queryParameters: <String, dynamic>{
            'origins': origin,
            'destinations': destinations,
            'mode': 'driving',
            'units': 'metric',
            'key': apiKey,
          },
        );

        final data = resp.data;
        if (data is! Map) continue;
        final rows = data['rows'];
        if (rows is! List || rows.isEmpty) continue;
        final elements = (rows.first is Map) ? (rows.first as Map)['elements'] : null;
        if (elements is! List) continue;

        for (var i = 0; i < batch.length && i < elements.length; i++) {
          final element = elements[i];
          if (element is! Map) continue;
          if ((element['status']?.toString() ?? '') != 'OK') continue;

          final distanceMap = element['distance'];
          final durationMap = element['duration'];
          if (distanceMap is! Map || durationMap is! Map) continue;

          final info = DistanceInfo(
            distance: distanceMap['text']?.toString(),
            duration: durationMap['text']?.toString(),
            distanceValue: distanceMap['value'] is num
                ? (distanceMap['value'] as num).toInt()
                : int.tryParse(distanceMap['value']?.toString() ?? ''),
            durationValue: durationMap['value'] is num
                ? (durationMap['value'] as num).toInt()
                : int.tryParse(durationMap['value']?.toString() ?? ''),
          );

          final orderIndex = batch[i].index;
          if (orderIndex < 0 || orderIndex >= updatedOrders.length) continue;
          updatedOrders[orderIndex] = updatedOrders[orderIndex].copyWith(
            distanceInfo: info,
          );
        }
      }

      orders = updatedOrders;
      notifyListeners();
    } catch (_) {
    } finally {
      _isDistanceRefreshing = false;
    }
  }

  Future<bool> deleteAccount(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final resp = await _dioHttp.deleteMyAccount(context);
      isLoading = false;
      notifyListeners();

      if (resp.data['dataResponse']?['returnCode'] == 0) {
        return true;
      }
      return false;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
