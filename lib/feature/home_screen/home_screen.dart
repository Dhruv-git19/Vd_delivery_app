import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/constants/info_list.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/home_screen_container.dart';
import 'package:vedasip_delivery_app/feature/navigation_bar/navigation_bar_screen.dart';
import 'package:vedasip_delivery_app/feature/navigation_bar/provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMenuOpen = context.watch<NavigationBarProvider>().ismenuOpen;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [verificationColor, Color.fromARGB(255, 218, 247, 239)],
              begin: AlignmentDirectional.topCenter,
              end: AlignmentDirectional.bottomCenter,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [primaryColor, secondaryColor],
                  begin: AlignmentDirectional.topCenter,
                  end: AlignmentDirectional.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      iconSize: 27.sp,
                      onPressed: () {
                        context.read<NavigationBarProvider>().toggleMenu();
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 9.0, left: 4.0),
                      child: Text.rich(
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
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                        iconSize: 27.sp,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Todays Delivery',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: verifyheadingcolor,
                ),
              ),
            ),

            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                itemCount: infoList.length,
                itemBuilder: (context, index) {
                  final info = infoList[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: [
                        HomeScreenContainer(
                          name: '${info['name']}',
                          location: '${info['location']}',
                          time: '${info['time']}',
                          distance: '${info['distance']}',
                          price: '${info['price']}',
                          items: '${info['items']} items',
                          width: double.infinity,
                        ),
                        SizedBox(height: 12.0),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        if (isMenuOpen)
          Positioned.fill(
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.white,
                  height: double.infinity,
                  child: NavigationBarScreen(),
                ),

                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      context.read<NavigationBarProvider>().toggleMenu();
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
