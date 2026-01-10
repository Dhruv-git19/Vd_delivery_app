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

  @override
  void initState() {
    super.initState();
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

  String _getCustomerName(Map<String, dynamic>? details) {
    return details?['customer']?['fullName'] ?? '---';
  }

  String _getOrderType(Map<String, dynamic>? details) {
    return details?['type']?.toString() ?? '';
  }

  String _getDistance(Map<String, dynamic>? details) {
    return details?['distanceInfo']?['distance']?.toString() ?? 'N/A';
  }

  String _getTotalAmount(Map<String, dynamic>? details) {
    return details?['totalAmount']?.toString() ?? 'N/A';
  }

  String _getDuration(Map<String, dynamic>? details) {
    return details?['distanceInfo']?['duration']?.toString() ?? 'N/A';
  }

  String _getCustomerAddress(Map<String, dynamic>? details) {
    return details?['address']?['fullAddress'] ?? '---';
  }

  int _getCartItemsCount(Map<String, dynamic>? details) {
    final cartDetails = details?['cart']?['cartDetails'] as List?;
    return cartDetails?.length ?? 0;
  }

  List<Widget> _buildCartItems(Map<String, dynamic>? details) {
    final cartDetails = details?['cart']?['cartDetails'] as List?;
    if (cartDetails == null || cartDetails.isEmpty) {
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

    return cartDetails.map<Widget>((item) {
      final productName =
          item['productVariant']?['product']?['productName'] ?? 'Item';
      final qty = item['quantity']?.toString() ?? '0';
      final price = item['price']?.toString() ?? '0';

      final productImages =
          item['productVariant']?['product']?['productImages'] as List?;
      final imageUrl = (productImages != null && productImages.isNotEmpty)
          ? productImages.first['imageUrl']
          : null;

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

    return Scaffold(
      appBar: CommonAppbar(
        title: 'Delivery Details',
        text: 'Pending Payment',
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
    setState(() {
      _isCheckingArrival = true;
    });

    try {
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

      final apiResponse = BaseApiResponse<Map<String, dynamic>>.fromJson(
        resp.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.dataResponse.returnCode == 0) {
        // Success — navigate to confirm delivery screen
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
