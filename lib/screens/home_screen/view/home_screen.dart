import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';
import 'package:vedasip_delivery_app/screens/home_screen/provider/homeProvider.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/iconTextWidget.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/drawerMenuItemWidget.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/coloredContainerWidget.dart';
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
      final provider = Provider.of<HomeProvider>(context, listen: false);
      provider.fetchData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.verificationColor,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 12),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(radius: 40),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 4),
                          ],
                        ),
                        child: Icon(Icons.edit, size: 20, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                  Navigator.of(context).pop();
                  context.go(AppRoutes.loginscreen);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () async {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ),
        toolbarHeight: 150,
        title: Consumer<HomeProvider>(
          builder: (context, provider, _) => Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Welcome ',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: provider.user?.fullName ?? '',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [Icon(Icons.notifications, color: Colors.white)],
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
            ),
          ),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Todays Delivery',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: verifyheadingcolor,
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: provider.isLoading
                      ? const HomeScreenShimmer()
                      : provider.orders.isEmpty
                      ? Center(child: Text('No deliveries found'))
                      : ListView.builder(
                          itemCount: provider.orders.length,
                          itemBuilder: (context, index) {
                            final order = provider.orders[index];
                            return Container(
                              height: 200.h,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Order #${order.id}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF6C6C6C),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      coloredContainer(
                                        'High',
                                        const Color(0xFFB31B10),
                                        const Color(0xFFF2DAD8),
                                      ),
                                      const Spacer(),
                                      coloredContainer(
                                        'Pending',
                                        const Color(0xFF0E45A4),
                                        const Color(0xFFD7E9F9),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    order.address?.toString() ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF929292),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    children: [
                                      iconText(
                                        Icons.access_time_outlined,
                                        order.createdOn,
                                      ),
                                      SizedBox(width: 20.w),
                                      iconText(
                                        Icons.location_on_outlined,
                                        order.distanceInfo?.toString() ?? '',
                                      ),
                                      SizedBox(width: 20.w),
                                      iconText(
                                        Icons.currency_rupee,
                                        order.totalAmount,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    children: [
                                      Text(
                                        order.cart != null ? '1 cart' : '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF838383),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
