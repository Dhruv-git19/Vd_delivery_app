import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_icon_backg_cont.dart';

class DetailContainer extends StatelessWidget {
  final String name;
  final String customerType;
  final String address;
  const DetailContainer({
    super.key,
    required this.name,
    required this.customerType,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 204, 204, 204)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    customerType,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                ],
              ),
              Spacer(),
              CommonIconBackgCont(icon: Icon(Icons.call, color: primaryColor)),
              SizedBox(width: 5),
              CommonIconBackgCont(
                icon: Icon(Icons.message_outlined, color: primaryColor),
              ),
            ],
          ),
          Divider(indent: 20, endIndent: 20),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey[600],
                size: 30,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _customicon(Icons.timelapse_rounded, 'ETA', '30 Min'),
                _customicon(Icons.telegram, 'Distance', '2.3 Km'),
                _customicon(Icons.currency_rupee, 'Amount', '\$80'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _customicon(IconData icon, String descrip1, String descrip2) {
  return Column(
    children: [
      Icon(icon, size: 32, color: Colors.grey[600]),
      Text(descrip1, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
      SizedBox(height: 5),
      Text(
        descrip2,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
