import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_map_card.dart';
import 'package:vedasip_delivery_app/screens/my_deliveries_map_screen/widgets/status_container.dart';

class MyDeliveriesMapScreen extends StatelessWidget {
  const MyDeliveriesMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppbar(title: 'My Deliveries '),
      body: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Alice Smith',
                        style: TextStyle(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      StatusContainer(
                        text: 'Ready To Deliver',
                        contColor: const Color.fromARGB(255, 221, 235, 248),
                        textcolor: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 20.r),
                      SizedBox(width: 10.w),
                      Text(
                        '123 Main St, Springfield, IL 62701',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey, size: 20.r),
                      SizedBox(width: 10.w),
                      Text(
                        '+1 234 567 890',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _bottleCount(),
                  SizedBox(height: 20.h),
                  const CommonMapCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottleCount() {
    return Container(
      padding: EdgeInsets.all(12.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deliver 2 x 20L AquaRoute',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            'Premium Bottles',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
