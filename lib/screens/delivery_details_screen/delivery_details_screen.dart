import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/widgets/detail_container.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_icon_backg_cont.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/widgets/image_container.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: 'Delivery Details',
        text: 'Pending Payment',
        code: '#DEL001',
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: [
          //     verificationColor,
          //     const Color.fromARGB(255, 218, 247, 239),
          //   ],
          //   begin: AlignmentDirectional.topCenter,
          //   end: AlignmentDirectional.bottomCenter,
          // ),
          color: verificationColor,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
            child: Column(
              children: [
                DetailContainer(
                  name: 'Emma',
                  customerType: 'Premium Customer',
                  address: '14, Powder Gali',
                ),
                SizedBox(height: 15.h),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AllColors.deliverydetailBoundary),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Items to Deliver',
                            style: TextStyle(
                              color: verifyheadingcolor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 3.h,
                              horizontal: 7.w,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Text(
                              '2',
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      _items('Alkaline Water Bottle', 'Quantity: 1'),
                      SizedBox(height: 10),
                      _items('Alkaline Water Bottle', 'Quantity: 1'),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(255, 204, 204, 204),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Special Instructions',
                          style: TextStyle(
                            color: verifyheadingcolor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Please handle fragile items with care.',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AllColors.deliverydetailshadelight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Call customer upon arrival',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AllColors.deliverydetailshadelight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Collect empty bottles if available.',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AllColors.deliverydetailshadelight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Special Instructions',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AllColors.deliverydetailshadelight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                CommonButton(buttonValue: 'Arrived at Destination'),
                SizedBox(height: 10.h),
                CommonButton(
                  buttonValue: 'Back to Detail',
                  backgroundColor: Colors.white,
                  outlineColor: primaryColor,
                  textStyle: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _items(String name, String quantity) {
  return Row(
    children: [
      ProductImage(),
      SizedBox(width: 10.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AllColors.deliverydetailfontColor,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            quantity,
            style: TextStyle(
              fontSize: 10.sp,
              color: AllColors.deliverydetailshadelight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ],
  );
}
