// lib/screens/home_screen/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/theme.dart';
import '../../../storage/flutter_secure_storage.dart';
import '../provider/homeProvider.dart';
import '../widgets/drawerMenuItemWidget.dart';
import '../widgets/home_header_sliver.dart';
import '../widgets/route_preview_section.dart';
import '../widgets/todays_deliveries_sliver.dart';

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

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<HomeProvider>(context, listen: false).fetchData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== Drawer =====
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
                        backgroundImage: const AssetImage(
                          "assets/images/profilePhoto.png",
                        ),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
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

      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: CustomScrollView(
          slivers: [
            HomeHeaderSliver(),
            RoutePreviewSection(),
            TodaysDeliveriesSliver(),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: ColoredBox(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
