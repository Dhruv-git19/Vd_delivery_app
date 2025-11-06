import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/screens/home_screen/model/order_model.dart';
import 'package:go_router/go_router.dart';

class OrderListView extends StatelessWidget {
  final List<Order> orders;
  const OrderListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () {
            context.push(
              '/deliveryDetails',
              extra: {'id': order.id, 'type': order.type},
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.userDetails?.fullName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFF222222),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Add status chip if needed
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F0FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.status,
                        style: const TextStyle(
                          color: Color(0xFF6A8EC9),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  order.address?.fullAddress ?? 'unknown address',
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6C6C6C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 18,
                      color: Color(0xFFB0B0B0),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      order.distanceInfo?.duration ?? 'N/A',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6C6C6C)),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.navigation, size: 18, color: Color(0xFFB0B0B0)),
                    SizedBox(width: 4.w),
                    Text(
                      order.distanceInfo?.distance ?? 'N/A',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6C6C6C)),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.currency_rupee,
                      size: 18,
                      color: Color(0xFFB0B0B0),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      order.totalAmount.toString(),
                      style: TextStyle(fontSize: 13, color: Color(0xFF6C6C6C)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
