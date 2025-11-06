import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/provider/delivery_details_provider.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/widgets/detail_container.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/widgets/s3_network_image.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  final int? orderId;
  final String? type;

  const DeliveryDetailsScreen({super.key, this.orderId, this.type});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
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

  // Helper methods to safely access Map data
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
        Text(
          'No items found',
          style: TextStyle(
            fontSize: 14.sp,
            color: AllColors.deliverydetailshadelight,
          ),
        ),
      ];
    }

    return cartDetails.map<Widget>((item) {
      final productName =
          item['productVariant']?['product']?['productName'] ?? 'Item';
      final qty = item['quantity']?.toString() ?? '0';
      final price = item['price']?.toString() ?? '0';

      // Get product images
      final productImages =
          item['productVariant']?['product']?['productImages'] as List?;
      final imageUrl = (productImages != null && productImages.isNotEmpty)
          ? productImages.first['imageUrl']
          : null;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            // Use S3NetworkImage for loading images with crash icon fallback
            S3NetworkImage(imageUrl: imageUrl, width: 48.w, height: 48.h),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
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
            Text('₹$price', style: TextStyle(fontSize: 13.sp)),
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
      backgroundColor: verificationColor,
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.details == null
          ? Center(
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
            )
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
              child: Column(
                children: [
                  DetailContainer(
                    name: _getCustomerName(provider.details),
                    customerType: _getOrderType(provider.details),
                    address: _getCustomerAddress(provider.details),
                    distance: _getDistance(provider.details),
                    duration: _getDuration(provider.details),
                    amount: _getTotalAmount(provider.details),
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AllColors.deliverydetailBoundary,
                      ),
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
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 3.h,
                                horizontal: 7.w,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                '${_getCartItemsCount(provider.details)}',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ..._buildCartItems(provider.details),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color.fromARGB(255, 204, 204, 204),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Special Instructions',
                            style: TextStyle(
                              color: verifyheadingcolor,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Please handle fragile items with care.',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AllColors.deliverydetailshadelight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Call customer upon arrival',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AllColors.deliverydetailshadelight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Collect empty bottles if available.',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AllColors.deliverydetailshadelight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Special Instructions',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AllColors.deliverydetailshadelight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  CommonButton(buttonValue: 'Arrived at Destination'),
                  SizedBox(height: 10.h),
                  CommonButton(
                    buttonValue: 'Go to map',
                    backgroundColor: Colors.white,
                    outlineColor: primaryColor,
                    textStyle: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
