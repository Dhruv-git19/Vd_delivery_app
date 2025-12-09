import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../theme/color_pallete.dart';
import '../../../widget/snack_bar.dart';
import '../../my_deliveries_map_screen/widgets/map_image_container.dart';
import '../provider/homeProvider.dart';
import '../widgets/home_drawer.dart';
import '../widgets/home_screen_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    Widget buildKycPending() {
      return RefreshIndicator(
        onRefresh: () async {
          try {
            await Provider.of<HomeProvider>(
              context,
              listen: false,
            ).fetchData(context);
            final kyc = Provider.of<HomeProvider>(
              context,
              listen: false,
            ).user?.isKycVerified;
            if (kyc != null && kyc == 1) {
              MySnackBar.showSnackBar(context, 'KYC verified.');
            } else {
              MySnackBar.showSnackBar(
                context,
                'KYC is still pending verification.',
              );
            }
          } catch (e) {
            MySnackBar.showSnackBar(context, 'Failed to refresh KYC status');
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_top, size: 72.r, color: primaryColor),
                    SizedBox(height: 16.h),
                    Text(
                      'Your KYC is pending',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: verifyheadingcolor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'We have received your documents. Please wait while we verify your KYC.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF6C6C6C),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                      ),
                      onPressed: () {
                        context.push(AppRoutes.loginscreen);
                      },
                      child: Text(
                        'Go to Login',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColor.constWhite,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Pull down to refresh verification status',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF6C6C6C),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget buildKycRejected() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.report_problem_rounded,
                size: 72.r,
                color: Colors.redAccent,
              ),
              SizedBox(height: 16.h),
              Text(
                'Your KYC was rejected',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Unfortunately your submitted documents were rejected. Please re-submit the required documents.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF6C6C6C),
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                ),
                onPressed: () {
                  context.push(AppRoutes.loginscreen);
                },
                child: Text(
                  'Go to login',
                  style: TextStyle(fontSize: 16.sp, color: AppColor.constWhite),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      drawer: const HomeDrawer(),

      body: Builder(
        builder: (context) {
          if (homeProvider.isLoading) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.h,
                  pinned: false,
                  floating: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 44.w,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                      ),
                                      height: 18.h,
                                      color: Colors.white24,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),

                              Container(
                                width: double.infinity,
                                height: 125.h,
                                color: Colors.white24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: const HomeScreenShimmer(),
                  ),
                ),

                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(color: Colors.white),
                ),
              ],
            );
          }

          final kycVal = homeProvider.user?.isKycVerified;
          if (kycVal != null) {
            if (kycVal == 0) {
              return buildKycPending();
            } else if (kycVal == 2) {
              return buildKycRejected();
            }
          }

          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<HomeProvider>(
                context,
                listen: false,
              ).fetchData(context);
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.h,
                  pinned: false,
                  floating: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,

                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),

                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Builder(
                                    builder: (context) => InkWell(
                                      onTap: () =>
                                          Scaffold.of(context).openDrawer(),
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Container(
                                        padding: EdgeInsets.all(8.r),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.menu_rounded,
                                          color: Colors.white,
                                          size: 24.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome Back,",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Consumer<HomeProvider>(
                                          builder: (_, provider, _) => Text(
                                            provider.user?.fullName ??
                                                'Partner',
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),

                              SizedBox(
                                height: 125.h,
                                width: double.infinity,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: MapImage(),
                                    ),
                                    Positioned(
                                      top: 12.h,
                                      left: 12.w,
                                      child: GestureDetector(
                                        onTap: () {
                                          context.push(
                                            AppRoutes.routeNavigationScreen,
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.1,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.play_arrow_rounded,
                                                color: primaryColor,
                                                size: 20.r,
                                              ),
                                              SizedBox(width: 6.w),
                                              Text(
                                                'Start Today\'s Route',
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      right: 12.w,
                      top: 10.h,
                    ),
                    color: Colors.white,
                    child: Text(
                      'Today\'s Delivery',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: verifyheadingcolor,
                      ),
                    ),
                  ),
                ),

                Consumer<HomeProvider>(
                  builder: (_, provider, _) {
                    try {
                      if (provider.isLoading) {
                        return const SliverToBoxAdapter(
                          child: Column(children: []),
                        );
                      }

                      final ordersList = provider.orders;
                      if (ordersList.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 200.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inventory_2_outlined,
                                  size: 48.r,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "No deliveries assigned yet",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
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
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  context.push(
                                    '/deliveryDetails',
                                    extra: {'id': order.id, 'type': order.type},
                                  );
                                },
                                borderRadius: BorderRadius.circular(16.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 6.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  order.userDetails?.fullName ??
                                                      'Unknown Customer',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                Text(
                                                  '#${order.type.toUpperCase()}${order.id}',
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.grey.shade500,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  order.status.toLowerCase() ==
                                                      'delivered'
                                                  ? Colors.green.withValues(
                                                      alpha: 0.1,
                                                    )
                                                  : Colors.blue.withValues(
                                                      alpha: 0.1,
                                                    ),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: Text(
                                              order.status,
                                              style: TextStyle(
                                                color:
                                                    order.status
                                                            .toLowerCase() ==
                                                        'delivered'
                                                    ? Colors.green
                                                    : Colors.blue,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 10.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 6.h,
                                        ),
                                        child: Divider(
                                          height: 1,
                                          color: Colors.grey.shade100,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.location_on_outlined,
                                            size: 18.r,
                                            color: Colors.grey.shade600,
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Text(
                                              order.address?.fullAddress ??
                                                  'No address provided',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                color: Colors.grey.shade700,
                                                height: 1.4,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6.h),
                                      Row(
                                        children: [
                                          _buildInfoChip(
                                            Icons.access_time_rounded,
                                            order.distanceInfo?.duration ??
                                                'N/A',
                                          ),
                                          SizedBox(width: 12.w),
                                          _buildInfoChip(
                                            Icons.straighten_rounded,
                                            order.distanceInfo?.distance ??
                                                'N/A',
                                          ),
                                          const Spacer(),
                                          Text(
                                            '₹${order.totalAmount}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                            child: Text("Error loading orders: $e"),
                          ),
                        ),
                      );
                    }
                  },
                ),

                SliverToBoxAdapter(
                  child: Container(height: 20.h, color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: Colors.grey.shade600),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
