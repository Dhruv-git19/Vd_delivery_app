import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_dotted_box.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_icon_backg_cont.dart';
import 'package:vedasip_delivery_app/screens/home_screen/provider/homeProvider.dart';

class CustomTab extends StatelessWidget {
  const CustomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment method',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AllColors.verifyheadingcolor,
            ),
          ),
          SizedBox(height: 8.h),
          TabBar(
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: AllColors.primaryColor,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
            indicator: BoxDecoration(
              color: AllColors.primaryColor,
              borderRadius: BorderRadius.circular(6.r),
            ),
            tabs: const [
              Tab(text: 'Scan & pay (QR)'),
              Tab(text: 'Cash / other'),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 320.h,
            child: const TabBarView(
              physics: BouncingScrollPhysics(),
              children: [_QrPaymentMethod(), _OtherPaymentMethod()],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPaymentMethod extends StatelessWidget {
  const _QrPaymentMethod();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          CommonIconBackgCont(
            icon: Icon(Icons.qr_code_2, color: AllColors.primaryColor),
            backgroundColor: AllColors.textfieldColor,
          ),
          SizedBox(height: 8.h),
          Text(
            'QR Code payment',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AllColors.verifyheadingcolor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Ask the customer to scan and pay using this QR code.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: AllColors.deliverydetailshadelight,
            ),
          ),

          SizedBox(height: 16.h),
          CommonDottedBox(
            paddding: EdgeInsets.all(12.r),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 4.h),
                Text(
                  'Show this QR to customer',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.qr_code_2_rounded,
                    color: Colors.black,
                    size: 110.r,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Customer will pay the full bill amount via UPI.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AllColors.deliverydetailshadelight,
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  children: [
                    Expanded(
                      child: CommonButton(
                        isfullWidth: true,
                        buttonValue: 'Share QR',
                        backgroundColor: Colors.white,
                        outlineColor: AllColors.primaryColor,
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AllColors.primaryColor,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 4.w,
                        ),
                        onTap: () {
                          // TODO: implement share if needed
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: CommonButton(
                        isfullWidth: true,
                        buttonValue: 'Payment received',
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 4.w,
                        ),
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          // Try to refresh HomeProvider if available, then navigate home
                          try {
                            final homeProvider = Provider.of<HomeProvider>(
                              context,
                              listen: false,
                            );
                            await homeProvider.fetchData(context);
                          } catch (_) {}
                          context.go(AppRoutes.homeScreen);
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherPaymentMethod extends StatelessWidget {
  const _OtherPaymentMethod();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 8.h),

        CommonIconBackgCont(
          icon: Icon(Icons.payments_outlined, color: AllColors.primaryColor),
          backgroundColor: AllColors.textfieldColor,
        ),
        SizedBox(height: 8.h),
        Text(
          'Cash / other method',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AllColors.verifyheadingcolor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Use this when customer paid in cash, UPI, or card directly.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: AllColors.deliverydetailshadelight,
          ),
        ),

        SizedBox(height: 16.h),

        CommonDottedBox(
          paddding: EdgeInsets.all(12.r),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment mode',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _PaymentModeChip(label: 'Cash'),
                  _PaymentModeChip(label: 'UPI'),
                  _PaymentModeChip(label: 'Card'),
                  _PaymentModeChip(label: 'Other'),
                ],
              ),

              SizedBox(height: 14.h),

              Text(
                'Notes (optional)',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 6.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  'E.g. Cash received, last 4 digits of card, UPI ref no., etc.',
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
              ),

              SizedBox(height: 18.h),

              CommonButton(
                isfullWidth: true,
                buttonValue: 'Payment received',
                padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 4.w),
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onTap: () async {
                  try {
                    final homeProvider = Provider.of<HomeProvider>(
                      context,
                      listen: false,
                    );
                    await homeProvider.fetchData(context);
                  } catch (_) {}
                  context.go(AppRoutes.homeScreen);
                },
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentModeChip extends StatelessWidget {
  final String label;

  const _PaymentModeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF4B5563),
        ),
      ),
    );
  }
}
