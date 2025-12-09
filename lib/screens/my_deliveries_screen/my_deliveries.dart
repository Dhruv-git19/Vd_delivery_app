import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/utils/common_widgets/common_appbar.dart';
import '../../core/utils/common_widgets/common_delivery_container.dart';
import '../../theme/color_pallete.dart';
import '../home_screen/widgets/home_screen_shimmer.dart';
import 'provider/my_deliveries_provider.dart';

class MyDeliveries extends StatefulWidget {
  const MyDeliveries({super.key});

  @override
  State<MyDeliveries> createState() => _MyDeliveriesState();
}

class _MyDeliveriesState extends State<MyDeliveries> {
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyDeliveriesProvider>(
        context,
        listen: false,
      ).fetchDeliveryHistory(context);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CommonAppbar(title: 'My Deliveries'),
          Expanded(
            child: Consumer<MyDeliveriesProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const HomeScreenShimmer();
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48.r,
                          color: Colors.red.shade400,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error loading deliveries',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ElevatedButton.icon(
                          onPressed: () {
                            provider.fetchDeliveryHistory(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final filteredDeliveries = provider.filterDeliveries(
                  searchText,
                );

                if (filteredDeliveries.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24.r),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 64.r,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          searchText.isEmpty
                              ? 'No deliveries found'
                              : 'No results for "$searchText"',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchDeliveryHistory(context),
                  color: AppColor.primaryColor,
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      vertical: 0.h,
                      horizontal: 12.w,
                    ),
                    itemCount: filteredDeliveries.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final delivery = filteredDeliveries[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            AppRoutes.deliveryHistoryDetailScreen,
                            extra: {
                              'orderId': delivery.orderId,
                              'orderType': delivery.type,
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CommonDeliveryContainer(
                            name: delivery.customerName,
                            location: delivery.address?.fullAddress ?? 'N/A',
                            time: _formatDate(delivery.completedOn),
                            distance: '${delivery.itemCount}',
                            price: delivery.totalAmount,
                            items: '${delivery.itemCount} items',
                            borderColor: Colors.transparent,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} days ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hours ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} mins ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'N/A';
    }
  }
}
