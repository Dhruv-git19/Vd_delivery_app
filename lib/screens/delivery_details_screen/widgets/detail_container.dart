import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_icon_backg_cont.dart';

class DetailContainer extends StatelessWidget {
  final String name;
  final String customerType;
  final String address;
  final String distance;
  final String duration;
  final String amount;
  const DetailContainer({
    super.key,
    required this.name,
    required this.customerType,
    required this.address,
    required this.distance,
    required this.duration,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(7.r),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AllColors.deliverydetailBoundary),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AllColors.deliverydetailfontColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              CommonIconBackgCont(
                icon: Icon(Icons.call, color: primaryColor),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
              SizedBox(width: 5.w),
              CommonIconBackgCont(
                icon: Icon(Icons.message_outlined, color: primaryColor),
                backgroundColor: const Color(0xFFF3F4F6),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Divider(indent: 20.w, endIndent: 20.w, color: Colors.grey[100]),
          SizedBox(height: 7.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey[600],
                size: 30.r,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AllColors.deliverydetailfontColor,
                      ),
                    ),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6E6E6E),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 7.h),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: _customicon(
                    Icons.telegram_outlined,
                    'Distance',
                    distance,
                  ),
                ),
                Expanded(
                  child: _customicon(Icons.currency_rupee, 'Amount', amount),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _customicon(IconData icon, String descrip1, String descrip2) {
  return Row(
    children: [
      Icon(icon, size: 20.r, color: Color(0xFF6E6E6E)),
      SizedBox(width: 3.w),
      Flexible(
        child: Text(
          descrip1,
          style: TextStyle(
            fontSize: 12.sp,
            color: Color(0xFF6E6E6E),
            fontWeight: FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      SizedBox(width: 7.w),
      Flexible(
        child: Text(
          descrip2,
          style: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFF6E6E6E),
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
