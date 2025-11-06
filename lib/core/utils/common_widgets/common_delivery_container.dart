import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';

class CommonDeliveryContainer extends StatelessWidget {
  final String name;
  final String location;
  final String time;
  final String distance;
  final String price;
  final String items;
  final double? width;
  final double? height;
  final Color? borderColor;

  const CommonDeliveryContainer({
    super.key,
    required this.name,
    required this.location,
    required this.time,
    required this.distance,
    required this.price,
    required this.items,
    this.width,
    this.height,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 145.h,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor ?? Colors.white),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AllColors.deliverydetailshadelight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 5.w),
              _coloredContainer(
                'High',
                const Color.fromARGB(255, 179, 27, 16),
                const Color.fromARGB(255, 242, 218, 216),
              ),
              const Spacer(),
              _coloredContainer(
                'Delivered',
                AllColors.primaryColor,
                const Color(0xFFE8FFF9),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            location,
            style: TextStyle(
              fontSize: 11.sp,
              color: AllColors.deliverydetailshadelight,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              _iconText(Icons.access_time_outlined, time),
              SizedBox(width: 20.w),
              _iconText(Icons.location_on_outlined, distance),
              SizedBox(width: 20.w),
              _iconText(Icons.currency_rupee, price),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                items,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color.fromARGB(255, 131, 131, 131),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: AllColors.primaryColor,
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white,
                  size: 16.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 17.r, color: const Color.fromARGB(255, 102, 102, 102)),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color.fromARGB(255, 134, 134, 134),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _coloredContainer(String text, Color textcolor, Color contColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: contColor,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: textcolor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
