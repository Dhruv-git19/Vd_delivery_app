import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/core/constants/info_list.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_dropdownmenu.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_container.dart';

class DeliveriesListScreen extends StatelessWidget {
  const DeliveriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppbar(title: 'My Deliveries'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CommonTextfield(
              hintText: 'Search Deliveries',
              fillColor: Colors.transparent,
              borderColor: Colors.grey.shade300,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CommonDropdown(text: 'Delivery Status'),
                CommonDropdown(text: 'Time Slot'),
              ],
            ),
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
