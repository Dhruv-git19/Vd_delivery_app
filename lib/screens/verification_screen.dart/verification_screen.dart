import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'widgets/dotted_container.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Complete Your Profile",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AllColors.verifyheadingcolor,
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                "Upload required document to start delivering",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AllColors.deliverydetailshadelight,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 15.h),

              Text(
                "37% complete",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AllColors.deliverydetailshadelight,
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: 6.h),

              Container(
                height: 6.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.37,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF41C19E),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              DottedUploadBox(
                backgroundColor: Colors.white,
                title: "ID Photo",
                subTitle: "Take a clear photo of your government ID",
                isUploaded: true,
                fileName: "image.png",
                icon: Icon(Icons.check, size: 20.sp, color: Color(0xFF41C19E)),
                ontap: () {},
              ),

              SizedBox(height: 18.h),

              DottedUploadBox(
                backgroundColor: Colors.white,
                title: "Driving License",
                subTitle: "Upload your valid driving license",
                isUploaded: false,
                icon: Icon(
                  Icons.file_copy_outlined,
                  size: 18.sp,
                  color: AllColors.deliverydetailfontColor,
                ),
                ontap: () {},
              ),

              SizedBox(height: 18.h),

              DottedUploadBox(
                backgroundColor: Colors.white,
                title: "Vehicle Registration",
                subTitle: "Upload your vehicle registration document",
                isUploaded: false,
                icon: Icon(
                  Icons.file_copy_outlined,
                  size: 18.sp,
                  color: AllColors.deliverydetailfontColor,
                ),
                ontap: () {},
              ),

              SizedBox(height: 22.h),

              CommonButton(
                isfullWidth: true,
                buttonValue: "Complete Verification",
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h),
              ),

              SizedBox(height: 14.h),

              Align(
                alignment: Alignment.center,
                child: Text(
                  "Your documents will be reviewed within 24 hours",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
