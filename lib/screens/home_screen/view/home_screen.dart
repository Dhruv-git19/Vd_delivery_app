import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../storage/flutter_secure_storage.dart';
import '../../../theme/color_pallete.dart';
import '../../../widget/snack_bar.dart';
import '../../my_deliveries_map_screen/widgets/map_image_container.dart';
import '../provider/homeProvider.dart';
import '../widgets/drawerMenuItemWidget.dart';
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
                    ],
                  ),
                ),
                const SizedBox(height: 25),
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
                  icon: Icons.currency_rupee_outlined,
                  text: 'Cash Collections',
                  onTap: () {
                    context.push(AppRoutes.cashCollectionScreen);
                  },
                ),

                DrawerMenuItem(
                  icon: Icons.delete_outline,
                  text: 'Delete Account',
                  onTap: () async {
                    final provider = Provider.of<HomeProvider>(
                      context,
                      listen: false,
                    );

                    final confirmed = await showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          backgroundColor: Colors.white,
                          contentPadding: EdgeInsets.all(24.w),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: AllColors.drawerIconBackColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red.shade600,
                                  size: 28.sp,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'Delete Confirmation',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'Are you sure you want to delete your account? This action cannot be undone and all your data will be removed.',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AllColors.deliverydetailshadelight,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actionsPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          actions: [
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => Navigator.of(ctx).pop(false),
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Container(
                                        height: 44.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: AllColors.primaryColor,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AllColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: InkWell(
                                      onTap: provider.isLoading
                                          ? null
                                          : () async {
                                              // perform deletion while dialog is open
                                              final success = await provider
                                                  .deleteAccount(ctx);
                                              Navigator.of(ctx).pop(success);
                                            },
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Container(
                                        height: 44.h,
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade600,
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: provider.isLoading
                                              ? SizedBox(
                                                  width: 18.w,
                                                  height: 18.w,
                                                  child: CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                          Colors.white,
                                                        ),
                                                    strokeWidth: 2.0,
                                                  ),
                                                )
                                              : Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmed == true) {
                      await MySecureStorage().deleteToken();
                      MySnackBar.showSnackBar(
                        context,
                        'Account deleted successfully',
                      );
                      Navigator.pop(context);
                      context.go(AppRoutes.loginscreen);
                    } else if (confirmed == false) {
                      MySnackBar.showSnackBar(context, 'Deletion cancelled');
                    } else {
                      MySnackBar.showSnackBar(context, 'Deletion failed');
                    }
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
                          child: Column(children: []),
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
                          if (index >= ordersList.length) {
                            return const SizedBox.shrink();
                          }
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
                                      color: Colors.black.withValues(
                                        alpha: 0.04,
                                      ),
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
