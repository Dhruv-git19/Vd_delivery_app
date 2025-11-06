import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class CommonDropdownmenu extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CommonDropdownmenu({
    super.key,
    required this.title,
    required this.items,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 6.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.r),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: false,
          value: value,
          hint: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AllColors.deliverydetailshadelight,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 6.w),
            ],
          ),
          icon: Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.r,
              color: const Color(0xFF41C19E),
            ),
          ),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
