import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
// (no extra icon background widget required here)

class DottedUploadBox extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? fileName; // nullable
  final bool isUploaded;
  final VoidCallback onTakePhoto;
  final VoidCallback onUploadFile;
  final Widget icon;
  final EdgeInsets? padding;
  final double borderRadius;
  final Color borderColor;
  final Color? iconbackgroundColor;
  final Color? backgroundColor;
  final Widget? preview;
  final VoidCallback? onRemove;

  const DottedUploadBox({
    super.key,
    required this.subTitle,
    this.isUploaded = false,
    this.fileName,
    required this.title,
    required this.icon,
    this.padding,
    this.borderRadius = 14,
    this.borderColor = const Color(0xFF41C19E),
    this.iconbackgroundColor,
    required this.onTakePhoto,
    required this.onUploadFile,
    this.preview,
    this.onRemove,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(borderRadius.r),
        dashPattern: const [5, 3],
        strokeWidth: 1,
        color: borderColor,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        width: double.infinity,
        padding: padding ?? EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: iconbackgroundColor ?? Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: icon,
            ),

            SizedBox(height: 12.h),

            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: borderColor,
              ),
            ),

            SizedBox(height: 5.h),

            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: AllColors.deliverydetailfontColor,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: 12.h),
            // If a preview widget is provided, show it with a top-right remove button
            if (preview != null) ...[
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: SizedBox(
                      width: double.infinity,
                      height: 120.h,
                      child: preview,
                    ),
                  ),
                  Positioned(
                    right: 6.w,
                    top: 6.h,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(6.r),
                        child: Icon(
                          Icons.close,
                          size: 16.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
            ],

            // Always show action buttons at the bottom (Take Photo / Upload File)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonButton(
                  isfullWidth: false,
                  buttonValue: "Take Photo",
                  backgroundColor: Colors.transparent,
                  outlineColor: Colors.grey.shade300,
                  textStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                  icon: Icon(
                    Icons.camera_alt,
                    size: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  onTap: onTakePhoto,
                  padding: EdgeInsets.symmetric(
                    vertical: 7.h,
                    horizontal: 16.w,
                  ),
                  borderRadius: 8.r,
                ),
                SizedBox(width: 10.w),
                CommonButton(
                  buttonValue: "Upload File",
                  outlineColor: Colors.grey.shade300,
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                  icon: Icon(
                    Icons.upload_file,
                    size: 18.sp,
                    color: Colors.grey.shade600,
                  ),
                  onTap: onUploadFile,
                  padding: EdgeInsets.symmetric(
                    vertical: 7.h,
                    horizontal: 16.w,
                  ),
                  borderRadius: 8.r,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
