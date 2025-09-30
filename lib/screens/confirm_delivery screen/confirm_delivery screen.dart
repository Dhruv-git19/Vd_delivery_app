import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_icon_backg_cont.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/screens/confirm_delivery%20screen/widgets/common_confirmation_tabbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_confirm_cont.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_dotted_box.dart';

class ConfirmDeliveryScreen extends StatelessWidget {
  const ConfirmDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        title: 'Confirm Delivery',
        text: 'Awaiting Confirmation',
        code: '#DEL001',
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.all(8.0.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              verificationColor,
              const Color.fromARGB(255, 218, 247, 239),
            ],
            begin: AlignmentDirectional.topCenter,
            end: AlignmentDirectional.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0.r),
          child: SingleChildScrollView(
            child: Column(
              children: [
                DeliveryConfirmCont(
                  name: 'Emma',
                  address: '14, powder Gali , Mumbai',
                  rupee: '80.00',
                  items: '2 items',
                ),

                SizedBox(height: 20.h),
                _confirmationContainer(),
                SizedBox(height: 20.h),
                _EmptyBottleContainer(),
                SizedBox(height: 20.h),
                _confirmationContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _confirmationContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Text(
            'Choose Confirmation Method',
            style: TextStyle(
              fontSize: 14.sp,
              color: AllColors.verifyheadingcolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 225, 255, 247),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Text(
                'Photo Proof',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AllColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CommonIconBackgCont(
            icon: Icon(Icons.security, color: AllColors.primaryColor),
            backgroundColor: const Color.fromARGB(255, 230, 255, 248),
          ),
          SizedBox(height: 10.h),
          Text(
            'Photo Proof',
            style: TextStyle(
              fontSize: 14.sp,
              color: AllColors.verifyheadingcolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Take a photo showing the delivered items or customer receipt',
            style: TextStyle(fontSize: 10.sp, color: Colors.grey[800]),
          ),
          SizedBox(height: 10.h),
          CommonDottedBox(
            paddding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 35.sp,
                  color: Colors.grey,
                ),
                SizedBox(height: 10.h),
                Text(
                  'No  photo captured yest',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 5.h),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     CommonButton(buttonValue: 'Take Photo'),
                //     CommonButton(buttonValue: 'Upload File'),
                //   ],
                // ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _EmptyBottleContainer() {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Empty Bottles Collected',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text('2 Items'),
            ],
          ),
          Text(
            'No. Of Empty Bottles',
            style: TextStyle(color: Colors.grey[850], fontSize: 11.sp),
          ),
          SizedBox(height: 10.h),
          CommonTextfield(
            hintText: 'Enter the numbers',
            fillColor: Colors.white,
            borderColor: Colors.grey.shade300,
            radius: 12.r,
          ),
        ],
      ),
    );
  }
}
