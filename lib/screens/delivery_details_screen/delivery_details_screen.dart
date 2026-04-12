import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/model/base_api_response.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/theme.dart';
import '../../core/utils/common_widgets/common_appbar.dart';
import '../../core/utils/common_widgets/common_button.dart';
import '../../services/dio_http.dart';
import '../../widget/snack_bar.dart';
import 'provider/delivery_details_provider.dart';
import 'widgets/detail_container.dart';
import 'widgets/s3_network_image.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final int? orderId;
  final String? type;

  const DeliveryDetailsScreen({super.key, this.orderId, this.type});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  bool _isLaunchingMap = false;
  bool _isCheckingArrival = false;
  StreamSubscription<Position>? _positionSubscription;
  Position? _currentPosition;

  String? _formatStatusChipText(String? raw) {
    final s = raw?.toString().trim();
    if (s == null || s.isEmpty || s.toLowerCase() == 'null') return null;
    final normalized = s.replaceAll('_', ' ').trim();
    if (normalized.isEmpty) return null;
    return normalized
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .map(
          (p) => p.length == 1
              ? p.toUpperCase()
              : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String? _getStatusText(Map<String, dynamic>? details) {
    final candidates = <dynamic>[
      details?['paymentStatus'],
      details?['payment_status'],
      details?['status'],
      details?['orderStatus'],
      details?['order_status'],
      details?['deliveryStatus'],
      details?['delivery_status'],
      details?['cart'] is Map ? (details?['cart'] as Map)['status'] : null,
    ];
    for (final c in candidates) {
      final formatted = _formatStatusChipText(c?.toString());
      if (formatted != null) return formatted;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.orderId != null) {
        Provider.of<DeliveryDetailsProvider>(
          context,
          listen: false,
        ).fetchOrderDetails(
          context,
          orderId: widget.orderId!,
          type: widget.type ?? 'cart',
        );
      }
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _startLocationTracking() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final initial = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (mounted) {
        setState(() {
          _currentPosition = initial;
        });
      }

      await _positionSubscription?.cancel();
      _positionSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
            ),
          ).listen((pos) {
            if (!mounted) return;
            setState(() {
              _currentPosition = pos;
            });
          }, onError: (_) {});
    } catch (_) {}
  }

  String _getCustomerName(Map<String, dynamic>? details) {
    return details?['customer']?['fullName'] ?? '---';
  }

  String _getOrderType(Map<String, dynamic>? details) {
    return details?['type']?.toString() ?? '';
  }

  int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  double? _tryParseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  String _formatDistanceFromMeters(int meters) {
    if (meters >= 1000) {
      final km = meters / 1000;
      return '${km.toStringAsFixed(km >= 10 ? 0 : 1)} km';
    }
    return '$meters m';
  }

  String _formatDurationFromSeconds(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final minutes = (seconds / 60).round();
    if (minutes < 60) return '${minutes} min';
    final hours = minutes ~/ 60;
    final remMin = minutes % 60;
    if (remMin == 0) return '${hours}h';
    return '${hours}h ${remMin}m';
  }

  String _getDistance(Map<String, dynamic>? details) {
    final destLat =
        _tryParseDouble(details?['address']?['latitude']) ??
        _tryParseDouble(details?['address']?['lat']);
    final destLng =
        _tryParseDouble(details?['address']?['longitude']) ??
        _tryParseDouble(details?['address']?['lng']);
    if (_currentPosition != null && destLat != null && destLng != null) {
      final meters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        destLat,
        destLng,
      ).round();
      if (meters >= 0) return _formatDistanceFromMeters(meters);
    }

    final raw = details?['distanceInfo']?['distance'];
    final str = raw?.toString().trim();
    if (str != null && str.isNotEmpty && str != 'null') return str;

    final meters =
        _tryParseInt(details?['distanceInfo']?['distanceValue']) ??
        _tryParseInt(details?['distanceInfo']?['distance_value']) ??
        _tryParseInt(details?['distanceValue']) ??
        _tryParseInt(details?['distance_value']);
    if (meters != null && meters >= 0) return _formatDistanceFromMeters(meters);

    return 'N/A';
  }

  String _getTotalAmount(Map<String, dynamic>? details) {
    return details?['totalAmount']?.toString() ?? 'N/A';
  }

  String _getDuration(Map<String, dynamic>? details) {
    final raw = details?['distanceInfo']?['duration'];
    final str = raw?.toString().trim();
    if (str != null && str.isNotEmpty && str != 'null') return str;

    final seconds =
        _tryParseInt(details?['distanceInfo']?['durationValue']) ??
        _tryParseInt(details?['distanceInfo']?['duration_value']) ??
        _tryParseInt(details?['durationValue']) ??
        _tryParseInt(details?['duration_value']);
    if (seconds != null && seconds > 0) {
      return _formatDurationFromSeconds(seconds);
    }

    return 'N/A';
  }

  String _getCustomerAddress(Map<String, dynamic>? details) {
    return details?['address']?['fullAddress'] ?? '---';
  }

  String? _getCustomerMobile(Map<String, dynamic>? details) {
    final customer = details?['customer'];
    final userDetails = details?['userDetails'];
    final candidates = <dynamic>[
      customer is Map ? customer['customerMobile'] : null,
      customer is Map ? customer['mobile'] : null,
      customer is Map ? customer['mobileNo'] : null,
      customer is Map ? customer['mobileNumber'] : null,
      customer is Map ? customer['phone'] : null,
      customer is Map ? customer['phoneNo'] : null,
      userDetails is Map ? userDetails['mobileNumber'] : null,
      userDetails is Map ? userDetails['mobile_number'] : null,
      details?['customerMobile'],
      details?['mobile'],
      details?['mobileNo'],
      details?['mobileNumber'],
      details?['phone'],
      details?['phoneNo'],
    ];

    for (final c in candidates) {
      final s = c?.toString().trim();
      if (s != null && s.isNotEmpty && s != 'null') {
        final normalized = _normalizePhoneNumber(s);
        if (normalized != null && normalized.isNotEmpty) return normalized;
      }
    }
    return null;
  }

  String? _normalizePhoneNumber(String input) {
    var s = input.trim();
    if (s.isEmpty) return null;
    s = s.replaceAll(RegExp(r'[^\d+]'), '');
    if (s.isEmpty) return null;
    if (s.contains('+')) {
      final hasLeadingPlus = s.startsWith('+');
      s = s.replaceAll('+', '');
      if (hasLeadingPlus) s = '+$s';
    }
    return s;
  }

  void _launchDialer(String? phone) async {
    final p = phone?.trim();
    if (p == null || p.isEmpty) {
      if (mounted) {
        MySnackBar.showSnackBar(
          context,
          'Customer mobile number not available',
        );
      }
      return;
    }
    final uri = Uri(scheme: 'tel', path: p);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      MySnackBar.showSnackBar(context, 'Unable to open phone app');
    }
  }

  void _launchSms(String? phone) async {
    final p = phone?.trim();
    if (p == null || p.isEmpty) {
      if (mounted) {
        MySnackBar.showSnackBar(
          context,
          'Customer mobile number not available',
        );
      }
      return;
    }
    final uri = Uri(scheme: 'sms', path: p);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      MySnackBar.showSnackBar(context, 'Unable to open messaging app');
    }
  }

  List<dynamic> _extractItemsList(Map<String, dynamic>? details) {
    if (details == null) return const [];

    dynamic readPath(List<String> keys) {
      dynamic current = details;
      for (final k in keys) {
        if (current is Map && current.containsKey(k)) {
          current = current[k];
        } else {
          return null;
        }
      }
      return current;
    }

    final candidates = <dynamic>[
      readPath(['cart', 'cartDetails']),
      readPath(['cartDetails']),
      readPath(['orderDetails', 'cart', 'cartDetails']),
      readPath(['orderDetails', 'cartDetails']),
      readPath(['subscription', 'cart', 'cartDetails']),
      readPath(['subscription', 'cartDetails']),
      readPath(['subscription', 'subscriptionDetails']),
      readPath(['subscription', 'items']),
      readPath(['subscriptionItems']),
      readPath(['items']),
      readPath(['orderItems']),
      readPath(['products']),
      readPath(['productDetails']),
    ];

    for (final c in candidates) {
      if (c is List) return c;
    }
    return const [];
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return value.map((k, v) => MapEntry(k.toString(), v));
    return const {};
  }

  String _pickFirstNonEmptyString(Map<String, dynamic> map, List<String> keys) {
    for (final k in keys) {
      final v = map[k];
      if (v == null) continue;
      final s = v.toString().trim();
      if (s.isNotEmpty && s.toLowerCase() != 'null') return s;
    }
    return '';
  }

  String? _extractImageUrlFromItem(Map<String, dynamic> item) {
    String? firstFromList(dynamic value) {
      if (value is List && value.isNotEmpty) {
        final firstRaw = value.first;
        if (firstRaw is String) {
          final s = firstRaw.trim();
          return s.isNotEmpty ? s : null;
        }
        final first = _asMap(firstRaw);
        final u = _pickFirstNonEmptyString(first, [
          'imageUrl',
          'image_url',
          'imageURL',
          'url',
          'image',
          'path',
          'key',
          'location',
          'src',
        ]);
        return u.isNotEmpty ? u : null;
      }
      return null;
    }

    final pv = _asMap(
      item['productVariant'] ?? item['product_variant'] ?? item['variant'],
    );
    final p = _asMap(
      pv['product'] ??
          pv['productDetails'] ??
          item['product'] ??
          item['productDetails'] ??
          item['product_details'],
    );

    final fromProductImages = firstFromList(p['productImages']);
    if (fromProductImages != null) return fromProductImages;

    final fromVariantImages = firstFromList(pv['productImages']);
    if (fromVariantImages != null) return fromVariantImages;

    final directProduct = _pickFirstNonEmptyString(p, [
      'imageUrl',
      'image_url',
      'imageURL',
      'image',
      'thumbnail',
      'thumbnailUrl',
      'thumbnail_url',
      'photo',
      'photoUrl',
      'photo_url',
    ]);
    if (directProduct.isNotEmpty) return directProduct;

    final directItem = _pickFirstNonEmptyString(item, [
      'imageUrl',
      'image_url',
      'imageURL',
      'image',
      'thumbnail',
      'thumbnailUrl',
      'thumbnail_url',
      'photo',
      'photoUrl',
      'photo_url',
      'productImage',
      'product_image',
    ]);
    if (directItem.isNotEmpty) return directItem;

    final fromItemImages = firstFromList(item['productImages']);
    if (fromItemImages != null) return fromItemImages;

    final fromImages = firstFromList(item['images']);
    if (fromImages != null) return fromImages;

    return null;
  }

  int _pickFirstInt(Map<String, dynamic> map, List<String> keys) {
    for (final k in keys) {
      final v = map[k];
      if (v == null) continue;
      if (v is int) return v;
      if (v is num) return v.toInt();
      final parsed = int.tryParse(v.toString());
      if (parsed != null) return parsed;
    }
    return 0;
  }

  int _getCartItemsCount(Map<String, dynamic>? details) {
    return _extractItemsList(details).length;
  }

  List<Widget> _buildCartItems(Map<String, dynamic>? details) {
    final items = _extractItemsList(details);
    if (items.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Text(
            'No items found',
            style: TextStyle(
              fontSize: 14.sp,
              color: AllColors.deliverydetailshadelight,
            ),
          ),
        ),
      ];
    }

    return items.map<Widget>((raw) {
      final item = _asMap(raw);
      final pv = _asMap(
        item['productVariant'] ?? item['product_variant'] ?? item['variant'],
      );
      final p = _asMap(
        pv['product'] ??
            pv['productDetails'] ??
            item['product'] ??
            item['productDetails'] ??
            item['product_details'],
      );

      final productName =
          _pickFirstNonEmptyString(p, ['productName', 'name', 'title']) //
              .isNotEmpty
          ? _pickFirstNonEmptyString(p, ['productName', 'name', 'title'])
          : _pickFirstNonEmptyString(item, [
              'productName',
              'product_name',
              'name',
              'itemName',
              'title',
            ]).isNotEmpty
          ? _pickFirstNonEmptyString(item, [
              'productName',
              'product_name',
              'name',
              'itemName',
              'title',
            ])
          : 'Item';

      final qtyInt = _pickFirstInt(item, ['quantity', 'qty', 'count']);
      final qty = qtyInt == 0 ? '1' : qtyInt.toString();

      final priceText = _pickFirstNonEmptyString(item, [
        'price',
        'unitPrice',
        'totalPrice',
        'amount',
        'totalAmount',
      ]);
      final price = priceText.isNotEmpty ? priceText : '0';

      final imageUrl = _extractImageUrlFromItem(item);

      return Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            S3NetworkImage(imageUrl: imageUrl, width: 48.w, height: 48.h),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Quantity: $qty',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AllColors.deliverydetailshadelight,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '₹$price',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DeliveryDetailsProvider>(context);
    final statusText = _getStatusText(provider.details) ?? 'Pending Payment';

    return Scaffold(
      appBar: CommonAppbar(
        title: 'Delivery Details',
        text: statusText,
        code: '#DEL${widget.orderId ?? ''}',
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: _buildBottomActions(context),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.details == null
          ? _buildEmptyState()
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                children: [
                  Column(
                    children: [
                      DetailContainer(
                        name: _getCustomerName(provider.details),
                        customerType: _getOrderType(provider.details),
                        address: _getCustomerAddress(provider.details),
                        distance: _getDistance(provider.details),
                        duration: _getDuration(provider.details),
                        amount: _getTotalAmount(provider.details),
                        onCall: () {
                          _launchDialer(_getCustomerMobile(provider.details));
                        },
                        onMessage: () {
                          _launchSms(_getCustomerMobile(provider.details));
                        },
                      ),
                      SizedBox(height: 12.h),
                      _buildItemsCard(provider.details),
                      SizedBox(height: 12.h),
                      _buildInstructionsCard(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No order details found',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            Text(
              'Order ID: ${widget.orderId ?? 'N/A'}',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsCard(Map<String, dynamic>? details) {
    final itemCount = _getCartItemsCount(details);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AllColors.deliverydetailBoundary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Items to Deliver',
                style: TextStyle(
                  color: verifyheadingcolor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '$itemCount',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          const Divider(height: 1),

          SizedBox(height: 8.h),
          ..._buildCartItems(details),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AllColors.deliverydetailBoundary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Instructions',
            style: TextStyle(
              color: verifyheadingcolor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          _instructionLine('Please handle fragile items with care.'),
          _instructionLine('Call customer upon arrival.'),
          _instructionLine('Collect empty bottles if available.'),
        ],
      ),
    );
  }

  Widget _instructionLine(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 11.sp,
              color: AllColors.deliverydetailshadelight,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                color: AllColors.deliverydetailshadelight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            buttonValue: 'At Destination',
            isfullWidth: true,
            isLoading: _isCheckingArrival,
            onTap: _isCheckingArrival
                ? null
                : () => _checkArrivalAndNavigate(context),
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: CommonButton(
            buttonValue: 'Open in Maps',
            onTap: _isLaunchingMap ? null : () => _openMaps(context),
            isLoading: _isLaunchingMap,
            backgroundColor: Colors.white,
            outlineColor: primaryColor,
            isfullWidth: true,
            textStyle: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openMaps(BuildContext context) async {
    setState(() {
      _isLaunchingMap = true;
    });

    try {
      final provider = Provider.of<DeliveryDetailsProvider>(
        context,
        listen: false,
      );
      final details = provider.details;

      final destLat = details?['address']?['latitude'];
      final destLng = details?['address']?['longitude'];

      if (destLat == null || destLng == null) {
        MySnackBar.showSnackBar(
          context,
          'Destination coordinates not available',
        );
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        final uri = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng&travelmode=driving',
        );
        await _launchUriFallback(context, uri);
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final originLat = position.latitude;
      final originLng = position.longitude;

      final uri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$originLat,$originLng&destination=$destLat,$destLng&travelmode=driving',
      );

      await _launchUriFallback(context, uri);
    } catch (e) {
      try {
        final provider = Provider.of<DeliveryDetailsProvider>(
          context,
          listen: false,
        );
        final details = provider.details;
        final destLat = details?['address']?['latitude'];
        final destLng = details?['address']?['longitude'];
        if (destLat != null && destLng != null) {
          final uri = Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng&travelmode=driving',
          );
          await _launchUriFallback(context, uri);
        } else {
          MySnackBar.showSnackBar(context, 'Unable to open maps');
        }
      } catch (_) {
        MySnackBar.showSnackBar(context, 'Unable to open maps');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLaunchingMap = false;
        });
      }
    }
  }

  Future<void> _launchUriFallback(BuildContext context, Uri uri) async {
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
          MySnackBar.showSnackBar(context, 'Could not open maps');
        }
      }
    } catch (_) {
      MySnackBar.showSnackBar(context, 'Could not open maps');
    }
  }

  Future<void> _checkArrivalAndNavigate(BuildContext context) async {
    if (mounted) {
      setState(() {
        _isCheckingArrival = true;
      });
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        MySnackBar.showSnackBar(
          context,
          'Location is turned off. Please enable location services to confirm arrival.',
        );
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        MySnackBar.showSnackBar(
          context,
          'Location permission denied. Please enable location to confirm arrival.',
        );
        return;
      }

      if (!mounted) return;
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final originLat = position.latitude;
      final originLng = position.longitude;

      // Call backend to verify arrival
      if (widget.orderId == null) {
        MySnackBar.showSnackBar(context, 'Order id not available');
        return;
      }

      final dio = DioHttp();
      final resp = await dio.verifyDeliveryLocation(
        context,
        orderId: widget.orderId!.toString(),
        type: widget.type ?? 'cart',
        currentLat: originLat,
        currentLng: originLng,
      );

      if (!mounted) return;
      final apiResponse = BaseApiResponse<Map<String, dynamic>>.fromJson(
        resp.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.dataResponse.returnCode == 0) {
        // Success — navigate to confirm delivery screen
        if (!mounted) return;
        context.push(
          AppRoutes.confirmDeliveryScreen,
          extra: {'id': widget.orderId, 'type': widget.type},
        );
      } else {
        MySnackBar.showSnackBar(
          context,
          apiResponse.dataResponse.description.isNotEmpty
              ? apiResponse.dataResponse.description
              : 'Unable to verify arrival',
        );
      }
    } catch (e) {
      MySnackBar.showSnackBar(context, 'Error checking location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingArrival = false;
        });
      }
    }
  }
}
