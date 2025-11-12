import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_dotted_box.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_icon_backg_cont.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AllColors.verifyheadingcolor,
              ),
            ),
            SizedBox(height: 10.h),
            TabBar(
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelColor: AllColors.primaryColor,
              indicator: BoxDecoration(
                color: AllColors.primaryColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(text: 'QR Code'),
                Tab(text: 'Other Method'),
              ],
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 350.h,
              child: TabBarView(children: [PaymentMethod(), PaymentMethod2()]),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.h),
        CommonIconBackgCont(
          icon: Icon(Icons.qr_code, color: AllColors.primaryColor),
          backgroundColor: AllColors.textfieldColor,
        ),
        Text(
          'QR Code',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AllColors.verifyheadingcolor,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'Ask the customer for payment via QR Code',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AllColors.deliverydetailshadelight,
          ),
        ),
        SizedBox(height: 20.h),
        CommonDottedBox(
          child: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Show This QR Code',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.h),
                Icon(Icons.qr_code_2, color: Colors.black, size: 110.r),
                SizedBox(height: 10.h),
                CommonButton(
                  isfullWidth: true,
                  buttonValue: 'Confirm Delivery',
                  onTap: () {
                    context.go(AppRoutes.homeScreen);
                  },
                  padding: EdgeInsets.all(8.r),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PaymentMethod2 extends StatelessWidget {
  const PaymentMethod2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 10.h),
        CommonIconBackgCont(
          icon: Icon(Icons.qr_code, color: AllColors.primaryColor),
          backgroundColor: AllColors.textfieldColor,
        ),
        Text(
          'QR Code',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AllColors.verifyheadingcolor,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'Ask the customer for payment via QR Code',
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AllColors.deliverydetailshadelight,
          ),
        ),
        SizedBox(height: 20.h),
        CommonDottedBox(
          child: Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Text(
                  'Show This QR Code',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10.h),
                Icon(Icons.qr_code_2, color: Colors.black, size: 110.r),
                SizedBox(height: 10.h),
                CommonButton(
                  isfullWidth: true,
                  buttonValue: 'Confirm Delivery',
                  onTap: () {},
                  padding: EdgeInsets.all(8.r),
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
