import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/screens/my_deliveries_map_screen/widgets/map_image_container.dart';
import 'package:vedasip_delivery_app/storage/flutter_secure_storage.dart';
import 'package:vedasip_delivery_app/screens/home_screen/provider/homeProvider.dart';
import 'package:vedasip_delivery_app/screens/home_screen/widgets/order_list_view.dart';
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

      body: CustomScrollView(
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
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.w),
                topRight: Radius.circular(22.w),
              ),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    Text(
                      'Todays Delivery',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: verifyheadingcolor,
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: true,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Consumer<HomeProvider>(
                builder: (_, provider, _) {
                  if (provider.isLoading) return const HomeScreenShimmer();
                  if (provider.orders.isEmpty) {
                    return const Center(child: Text("No deliveries found"));
                  }
                  return OrderListView(orders: provider.orders);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
