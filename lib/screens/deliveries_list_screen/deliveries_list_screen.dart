import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/constants/info_list.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_dropdownmenu.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_container.dart';

class DeliveriesListScreen extends StatefulWidget {
  const DeliveriesListScreen({super.key});

  @override
  State<DeliveriesListScreen> createState() => _DeliveriesListScreenState();
}

class _DeliveriesListScreenState extends State<DeliveriesListScreen> {
  String? selectedDoc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppbar(title: 'My Deliveries'),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Column(
          children: [
            CommonTextfield(
              hintText: 'Search Deliveries',
              fillColor: Colors.transparent,
              borderColor: Colors.grey.shade300,
            ),

            SizedBox(height: 12.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommonDropdownmenu(
                  title: "Delivery Status",
                  items: ["Delivered", "Pending", "Cancelled"],
                  value: selectedDoc,
                  onChanged: (val) {
                    setState(() {
                      selectedDoc = val;
                    });
                  },
                ),
                SizedBox(width: 20.w),

                CommonDropdownmenu(
                  title: "Time Slot",
                  items: ["Today", "This Week", "This Month"],
                  value: selectedDoc,
                  onChanged: (val) {
                    setState(() {
                      selectedDoc = val;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 15.h),

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
                        borderColor: Colors.grey.shade300,
                      ),
                      SizedBox(height: 8.h),
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
