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
      drawer: Drawer(child: ListView(children: [])),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu, color: Colors.white),
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
      body: Column(
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
    );
  }
}
