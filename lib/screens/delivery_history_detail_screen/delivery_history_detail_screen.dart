import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/screens/delivery_history_detail_screen/provider/specific_delivery_provider.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/widgets/s3_network_image.dart';

class DeliveryHistoryDetailScreen extends StatefulWidget {
  final int orderId;
  final String orderType;

  const DeliveryHistoryDetailScreen({
    super.key,
    required this.orderId,
    required this.orderType,
  });

  @override
  State<DeliveryHistoryDetailScreen> createState() =>
      _DeliveryHistoryDetailScreenState();
}

class _DeliveryHistoryDetailScreenState
    extends State<DeliveryHistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpecificDeliveryProvider>(
        context,
        listen: false,
      ).fetchSpecificDelivery(
        context,
        orderId: widget.orderId,
        orderType: widget.orderType,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: verificationColor,
      appBar: CommonAppbar(
        title: 'Delivery Details',
        code: '#${widget.orderType.toUpperCase()}${widget.orderId}',
      ),
      body: Consumer<SpecificDeliveryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.r, color: Colors.red),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading delivery details',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () {
                      provider.fetchSpecificDelivery(
                        context,
                        orderId: widget.orderId,
                        orderType: widget.orderType,
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final data = provider.deliveryData;
          if (data == null) {
            return const Center(child: Text('No data available'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomerCard(data),
                SizedBox(height: 16.h),

                _buildStatusTimeline(data),
                SizedBox(height: 16.h),

                _buildOrderItems(data),
                SizedBox(height: 16.h),

                _buildAddressCard(data),
                SizedBox(height: 16.h),

                if (data.deliveryProof != null) _buildDeliveryProof(data),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomerCard(data) {
    final customer = data.customer;
    if (customer == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Icon(Icons.person, color: primaryColor, size: 28.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.fullName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AllColors.deliverydetailfontColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      customer.mobileNumber,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AllColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  data.orderDetails?.orderStatus ?? 'N/A',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AllColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline(data) {
    final deliveryDetails = data.deliveryDetails;
    if (deliveryDetails == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Timeline',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AllColors.deliverydetailfontColor,
            ),
          ),
          SizedBox(height: 16.h),
          _buildTimelineItem(
            'Assigned',
            _formatDateTime(deliveryDetails.assignedOn),
            true,
          ),
          _buildTimelineItem(
            'Scheduled Delivery',
            _formatDateTime(deliveryDetails.deliveryDate),
            true,
          ),
          _buildTimelineItem(
            'Completed',
            _formatDateTime(deliveryDetails.completedOn),
            true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String title,
    String time,
    bool isCompleted, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: isCompleted ? AllColors.primaryColor : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 12.r)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2.w,
                height: 40.h,
                color: isCompleted ? AllColors.primaryColor : Colors.grey[300],
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AllColors.deliverydetailfontColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                time,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              if (!isLast) SizedBox(height: 12.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(data) {
    final items = data.orderDetails?.cart?.items ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Items',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AllColors.deliverydetailfontColor,
                ),
              ),
              Text(
                '${items.length} items',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...items.map((item) => _buildOrderItemCard(item)).toList(),
          Divider(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AllColors.deliverydetailfontColor,
                ),
              ),
              Text(
                '₹${data.orderDetails?.totalAmount ?? '0'}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AllColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemCard(item) {
    final imageUrl = item.productImages.isNotEmpty
        ? item.productImages.first.imageUrl
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: S3NetworkImage(
              imageUrl: imageUrl,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AllColors.deliverydetailfontColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  item.variantName,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.totalPrice}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AllColors.deliverydetailfontColor,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '₹${item.unitPrice}/unit',
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(data) {
    final address = data.address;
    if (address == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AllColors.primaryColor,
                size: 24.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AllColors.deliverydetailfontColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            address.fullAddress,
            style: TextStyle(
              fontSize: 14.sp,
              color: AllColors.deliverydetailfontColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '${address.city}, ${address.state}, ${address.country} - ${address.postalCode}',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryProof(data) {
    final proof = data.deliveryProof!;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Proof',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AllColors.deliverydetailfontColor,
            ),
          ),
          SizedBox(height: 12.h),
          if (proof.proofUrls.isNotEmpty)
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: proof.proofUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 12.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: S3NetworkImage(
                        imageUrl: proof.proofUrls[index],
                        width: 120.w,
                        height: 120.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          SizedBox(height: 12.h),
          if (proof.distanceMeters != null)
            _buildInfoRow(
              Icons.social_distance,
              'Distance from delivery point',
              '${proof.distanceMeters} meters',
            ),
          if (proof.exchangeBottles != null)
            _buildInfoRow(
              Icons.recycling,
              'Empty bottles collected',
              '${proof.exchangeBottles} bottles',
            ),
          if (proof.submittedOn != null)
            _buildInfoRow(
              Icons.access_time,
              'Submitted on',
              _formatDateTime(proof.submittedOn),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 18.r, color: Colors.grey[600]),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AllColors.deliverydetailfontColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'N/A';
    }
  }
}
