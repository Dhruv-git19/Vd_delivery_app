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
    return Scaffold(
      backgroundColor: Colors.white,

      drawer: Drawer(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),

                const SizedBox(height: 8),

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
                            size: 18,
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
                  onTap: () {},
                ),
                DrawerMenuItem(
                  icon: Icons.map_outlined,
                  text: 'Live Map',
                  onTap: () {},
                ),
                DrawerMenuItem(
                  icon: Icons.help_outline,
                  text: 'Support',
                  onTap: () {},
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

      body: RefreshIndicator(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    "Welcome ${provider.user?.fullName ?? 'Joe Doe'}",
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

                              IconButton(
                                icon: const Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),

                          SizedBox(height: 10.h),

                          SizedBox(
                            height: 125.h,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: MapImage(),
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
                    return const SliverToBoxAdapter(child: HomeScreenShimmer());
                  }

                  final ordersList = provider.orders;
                  if (ordersList.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200.h,
                        color: Colors.white,
                        child: const Center(child: Text("No deliveries found")),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        borderRadius: BorderRadius.circular(12),
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
                      child: Center(child: Text("Error loading orders: $e")),
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
      ),
    );
  }
}
