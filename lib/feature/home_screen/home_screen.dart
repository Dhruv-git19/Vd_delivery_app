import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/constants/info_list.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/images/profile_placeholder.png'), // Replace with your asset
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(Icons.edit, size: 20, color: primaryColor),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _DrawerMenuItem(
                icon: Icons.person_outline,
                text: 'Profile',
                onTap: () {},
              ),
              _DrawerMenuItem(
                icon: Icons.inventory_2_outlined,
                text: 'My Delivery',
                onTap: () {},
              ),
              _DrawerMenuItem(
                icon: Icons.map_outlined,
                text: 'Live Map',
                onTap: () {},
              ),
              _DrawerMenuItem(
                icon: Icons.help_outline,
                text: 'Support',
                onTap: () {},
              ),
              _DrawerMenuItem(
                icon: Icons.logout,
                text: 'Logout',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ),
        toolbarHeight: 150,
        title: Text.rich(
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
              const TextSpan(
                text: 'Jetha Gada',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
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
      body: Padding(
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
              child: ListView.builder(
                itemCount: infoList.length,
                itemBuilder: (context, index) {
                  final info = infoList[index];
                  return Column(
                    children: [
                      CommonDeliveryContainer(
                        name: info['name'] ?? '',
                        location: info['location'] ?? '',
                        time: info['time'] ?? '',
                        distance: info['distance'] ?? '',
                        price: info['price'] ?? '',
                        items: '${info['items'] ?? ''} items',
                      ),
                      SizedBox(height: 12.0),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _DrawerMenuItem({required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEFFCF7),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: primaryColor),
      ),
      title: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      onTap: onTap,
      horizontalTitleGap: 0,
    );
  }
}