import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_dropdownmenu.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_container.dart';
import 'package:vedasip_delivery_app/screens/deliveries_list_screen/provider/delivery_history_provider.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/home_screen_shimmer.dart';

class DeliveriesListScreen extends StatefulWidget {
  const DeliveriesListScreen({super.key});

  @override
  State<DeliveriesListScreen> createState() => _DeliveriesListScreenState();
}

class _DeliveriesListScreenState extends State<DeliveriesListScreen> {
  String searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DeliveryHistoryProvider>(
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
      appBar: CommonAppbar(title: 'My Deliveries'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Column(
          children: [
            CommonTextfield(
              hintText: 'Search Deliveries',
              fillColor: Colors.transparent,
              borderColor: Colors.grey.shade300,
              textEditingController: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),

            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Consumer<DeliveryHistoryProvider>(
                builder: (_, provider, __) {
                  return CommonDropdownmenu(
                    title: 'Filter',
                    items: const ['All', 'Normal Order', 'Subscription'],
                    value: provider.orderTypeFilter,
                    onChanged: provider.setOrderTypeFilter,
                  );
                },
              ),
            ),
            SizedBox(height: 12.h),

            Expanded(
              child: Consumer<DeliveryHistoryProvider>(
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
                            Icons.error_outline,
                            size: 48.r,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Error loading deliveries',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ElevatedButton(
                            onPressed: () {
                              provider.fetchDeliveryHistory(context);
                            },
                            child: const Text('Retry'),
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
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64.r,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            searchText.isEmpty
                                ? 'No deliveries found'
                                : 'No results for "$searchText"',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => provider.fetchDeliveryHistory(context),
                    child: ListView.builder(
                      itemCount: filteredDeliveries.length,
                      itemBuilder: (context, index) {
                        final delivery = filteredDeliveries[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push(
                                  AppRoutes.deliveryHistoryDetailScreen,
                                  extra: {
                                    'orderId': delivery.orderId,
                                    'orderType': delivery.type,
                                  },
                                );
                              },
                              child: CommonDeliveryContainer(
                                name: delivery.customerName,
                                location:
                                    delivery.address?.fullAddress ?? 'N/A',
                                time: _formatDate(delivery.completedOn),
                                distance: '${delivery.itemCount}',
                                price: delivery.totalAmount,
                                items: '${delivery.itemCount} items',
                                borderColor: Colors.grey.shade300,
                              ),
                            ),
                            SizedBox(height: 8.h),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
