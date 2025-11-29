import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/screens/my_deliveries_map_screen/widgets/map_image_container.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';
import 'package:vedasip_delivery_app/screens/home_screen/provider/homeProvider.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/drawerMenuItemWidget.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/home_screen_shimmer.dart';
import 'package:vedasip_delivery_app/theme/color_pallete.dart';

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
      return Center(
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
                  style: TextStyle(fontSize: 16.sp, color: AppColor.constWhite),
                ),
              ),
            ],
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

      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32.r),
            bottomRight: Radius.circular(32.r),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 8.h),

                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 45.r,
                        backgroundImage: AssetImage(
                          "assets/images/profilePhoto.png",
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Icon(
                            Icons.edit,
                            size: 18.r,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                DrawerMenuItem(
                  icon: Icons.person_outline,
                  text: 'Profile',
                  onTap: () {},
                ),
                DrawerMenuItem(
                  icon: Icons.inventory_2_outlined,
                  text: 'My Delivery',
                  onTap: () {
                    context.push(AppRoutes.deliveryListScreen);
                  },
                ),
                DrawerMenuItem(
                  icon: Icons.map_outlined,
                  text: 'Live Map',
                  onTap: () {
                    context.push(AppRoutes.routeNavigationScreen);
                  },
                ),

                DrawerMenuItem(
                  icon: Icons.logout,
                  text: 'Logout',
                  onTap: () async {
                    await MySecureStorage().deleteToken();
                    Navigator.pop(context);
                    context.go(AppRoutes.loginscreen);
                  },
                ),

                const Spacer(),
              ],
            ),
          ),
        ),
      ),

      body: Builder(
        builder: (context) {
          if (homeProvider.isLoading) {
            // When loading, show a full-screen shimmer built with a SliverAppBar
            // followed by the HomeScreenShimmer so the user sees a skeleton of
            // the real screen (matches the real layout using slivers).
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Builder(
                                    builder: (context) => IconButton(
                                      icon: const Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      onPressed: () =>
                                          Scaffold.of(context).openDrawer(),
                                    ),
                                  ),

                                  Expanded(
                                    child: Consumer<HomeProvider>(
                                      builder: (_, provider, __) => Text(
                                        "Welcome ${provider.user?.fullName ?? ''}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),

                                  // IconButton(
                                  //   icon: Icon(
                                  //     Icons.notifications,
                                  //     color: Colors.white,
                                  //     size: 26.r,
                                  //   ),
                                  //   onPressed: () {
                                  //     context.push(
                                  //       AppRoutes.verificationscreen,
                                  //     );
                                  //   },
                                  // ),
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
                                            horizontal: 16.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              25.r,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.1,
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
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    child: Text(
                      'Todays Delivery',
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
                          child: Column(children: [

                            ],
                          ),
                        );
                      }

                      final ordersList = provider.orders;
                      if (ordersList.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Container(
                            height: 200.h,
                            color: Colors.white,
                            child: const Center(
                              child: Text("No deliveries found"),
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          if (index >= ordersList.length)
                            return const SizedBox.shrink();
                          final order = ordersList[index];
                          return Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: GestureDetector(
                              onTap: () {
                                context.push(
                                  '/deliveryDetails',
                                  extra: {'id': order.id, 'type': order.type},
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 12.h),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            order.userDetails?.fullName ??
                                                'Unknown',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Color(0xFF222222),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 4.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE6F0FF),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            order.status,
                                            style: const TextStyle(
                                              color: Color(0xFF6A8EC9),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      order.address?.fullAddress ??
                                          'unknown address',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6C6C6C),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_outlined,
                                          size: 16,
                                          color: Color(0xFFB0B0B0),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          order.distanceInfo?.duration ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6C6C6C),
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Icon(
                                          Icons.navigation,
                                          size: 16,
                                          color: Color(0xFFB0B0B0),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          order.distanceInfo?.distance ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6C6C6C),
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        Icon(
                                          Icons.currency_rupee,
                                          size: 16,
                                          color: Color(0xFFB0B0B0),
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          order.totalAmount.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6C6C6C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
}
