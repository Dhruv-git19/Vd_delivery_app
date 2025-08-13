import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';

class HomeScreenContainer extends StatelessWidget {
  final String name;
  final String location;
  final String time;
  final String distance;
  final String price;
  final String items;
  final double? width;
  final double? height;

  const HomeScreenContainer({
    super.key,
    required this.name,
    required this.location,
    required this.time,
    required this.distance,
    required this.price,
    required this.items,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 200.h,
      width: width ?? 200.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 108, 108, 108),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5.w),
              _coloredContainer(
                'High',
                const Color.fromARGB(255, 179, 27, 16),
                const Color.fromARGB(255, 242, 218, 216),
              ),
              Spacer(),
              _coloredContainer(
                'Pending',
                const Color.fromARGB(255, 14, 69, 164),
                const Color.fromARGB(255, 215, 233, 249),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            location,
            style: const TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 146, 146, 146),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _iconText(Icons.access_time_outlined, time),
              SizedBox(width: 20.w),
              _iconText(Icons.location_on_outlined, distance),
              SizedBox(width: 20.w),
              _iconText(Icons.currency_rupee, price),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                items,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 131, 131, 131),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              CommonButton(
                icon: Icons.camera_alt_outlined,
                buttonValue: 'Take Photo',
                padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: Colors.white,
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
        Icon(icon, size: 17, color: const Color.fromARGB(255, 102, 102, 102)),
        SizedBox(width: 4.w),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 134, 134, 134),
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
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.0,
          color: textcolor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
