// lib/screens/home_screen/widgets/todays_deliveries_sliver.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../provider/homeProvider.dart';
import 'home_screen_shimmer.dart';

class TodaysDeliveriesSliver extends StatelessWidget {
  const TodaysDeliveriesSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, provider, __) {
        try {
          if (provider.isLoading) {
            return const SliverToBoxAdapter(child: HomeScreenShimmer());
          }

          final ordersList = provider.orders;
          if (ordersList.isEmpty) {
            return SliverToBoxAdapter(
              child: Container(
                height: 220.h,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 40.sp,
                      color: const Color(0xFFB0B0B0),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "No deliveries found",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF6C6C6C),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index >= ordersList.length) {
                return const SizedBox.shrink();
              }
              final order = ordersList[index];

              final customerName = order.userDetails?.fullName ?? 'Customer';
              final addressText =
                  order.address?.fullAddress ?? 'Unknown address';
              final duration = order.distanceInfo?.duration ?? 'N/A';
              final distance = order.distanceInfo?.distance ?? 'N/A';
              final amountText = order.totalAmount.toString();

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: DeliveryListItem(
                  onTap: () {
                    context.pushNamed(
                      AppRoutes.deliveryDetailsScreen,
                      extra: {'id': order.id, 'type': order.type},
                    );
                  },
                  customerName: customerName,
                  orderId: order.id.toString(),
                  address: addressText,
                  status: order.status,
                  duration: duration,
                  distance: distance,
                  amount: amountText,
                ),
              );
            }, childCount: ordersList.length),
          );
        } catch (e) {
          return SliverToBoxAdapter(
            child: Container(
              height: 200.h,
              color: Colors.white,
              child: Center(
                child: Text(
                  "Error loading orders: $e",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class DeliveryListItem extends StatelessWidget {
  final VoidCallback onTap;
  final String customerName;
  final String orderId;
  final String address;
  final String status;
  final String duration;
  final String distance;
  final String amount;

  const DeliveryListItem({
    super.key,
    required this.onTap,
    required this.customerName,
    required this.orderId,
    required this.address,
    required this.status,
    required this.duration,
    required this.distance,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Order ID: $orderId',
                        style: TextStyle(fontSize: 12.sp, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFE6F0FF),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Color(0xFF4267B2),
                      fontWeight: FontWeight.w600,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "Address: $address",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                InfoChip(icon: Icons.access_time_outlined, label: duration),
                SizedBox(width: 8.w),
                InfoChip(icon: Icons.navigation_outlined, label: distance),
                SizedBox(width: 8.w),
                InfoChip(icon: Icons.currency_rupee, label: amount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: const Color(0xFF9C9C9C)),
          SizedBox(width: 4.w),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6C6C6C)),
          ),
        ],
      ),
    );
  }
}
