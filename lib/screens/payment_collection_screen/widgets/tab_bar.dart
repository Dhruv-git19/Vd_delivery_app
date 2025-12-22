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
import 'package:vedasip_delivery_app/services/dio_http.dart';
import 'package:vedasip_delivery_app/widget/snack_bar.dart';

String normalizePaymentMethod(String? method) {
  if (method == null) return 'CASH';
  final lower = method.toString().toLowerCase().trim();

  const onlineKeys = [
    'online',
    'upi',
    'card',
    'digital',
    'e-payment',
    'epayment',
    'netbanking',
  ];
  for (final k in onlineKeys) {
    if (lower.contains(k)) return 'ONLINE';
  }

  const cashKeys = [
    'cash',
    'cod',
    'pod',
    'pay_on_delivery',
    'cash_on_delivery',
    'pay on delivery',
  ];
  for (final k in cashKeys) {
    if (lower.contains(k)) return 'CASH';
  }

  return 'CASH';
}

class CustomTab extends StatelessWidget {
  final Map<String, dynamic>? paymentModeData;
  final int? orderId;
  final String? orderType;
  const CustomTab({
    super.key,
    this.paymentModeData,
    this.orderId,
    this.orderType,
  });

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
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                _QrPaymentMethod(
                  paymentModeData: paymentModeData,
                  orderId: orderId,
                  orderType: orderType,
                ),
                _OtherPaymentMethod(
                  paymentModeData: paymentModeData,
                  orderId: orderId,
                  orderType: orderType,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPaymentMethod extends StatefulWidget {
  final Map<String, dynamic>? paymentModeData;
  final int? orderId;
  final String? orderType;
  const _QrPaymentMethod({this.paymentModeData, this.orderId, this.orderType});

  @override
  State<_QrPaymentMethod> createState() => _QrPaymentMethodState();
}

class _QrPaymentMethodState extends State<_QrPaymentMethod> {
  bool _isLoading = false;
  String? _error;

  Future<void> _handlePaymentReceived() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final dio = DioHttp();
      final serverRaw =
          widget.paymentModeData != null &&
              widget.paymentModeData!['paymentMode'] != null
          ? widget.paymentModeData!['paymentMode']
          : 'ONLINE';
      final serverMode = normalizePaymentMethod(serverRaw);

      if (serverMode == 'ONLINE') {
        try {
          final homeProvider = Provider.of<HomeProvider>(
            context,
            listen: false,
          );
          await homeProvider.fetchData(context);
        } catch (_) {}
        if (mounted) context.go(AppRoutes.homeScreen);
      } else {
        // Server expects POD/CASH: for QR flow assume online payment via QR, so send ONLINE
        final paymentToSend = 'ONLINE';
        final resp = await dio.completeDeliveryPayment(
          context,
          orderId: widget.orderId?.toString() ?? '',
          paymentMethod: paymentToSend,
        );

        final dataResponse = resp.data['dataResponse'];
        final returnCode = dataResponse != null
            ? dataResponse['returnCode']
            : null;
        final description = dataResponse != null
            ? dataResponse['description']
            : null;
        if (returnCode == 0) {
          try {
            final homeProvider = Provider.of<HomeProvider>(
              context,
              listen: false,
            );
            await homeProvider.fetchData(context);
          } catch (_) {}
          if (mounted) context.go(AppRoutes.homeScreen);
        } else {
          final msg = description ?? 'Payment failed';
          setState(() {
            _error = msg;
          });
          MySnackBar.showSnackBar(context, msg);
        }
      }
      // (handled above inside branches) no duplicate processing here
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                // if (_error != null)
                //   Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 8.0),
                //     child: Text(_error!, style: TextStyle(color: Colors.red)),
                //   ),
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
                        buttonValue: _isLoading
                            ? 'Processing...'
                            : 'Payment received',
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 4.w,
                        ),
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        onTap: _isLoading ? null : _handlePaymentReceived,
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

class _OtherPaymentMethod extends StatefulWidget {
  final Map<String, dynamic>? paymentModeData;
  final int? orderId;
  final String? orderType;
  const _OtherPaymentMethod({
    this.paymentModeData,
    this.orderId,
    this.orderType,
  });

  @override
  State<_OtherPaymentMethod> createState() => _OtherPaymentMethodState();
}

class _OtherPaymentMethodState extends State<_OtherPaymentMethod> {
  bool _isLoading = false;
  String? _error;
  String _selectedMethod = 'Cash';

  Future<void> _handlePaymentReceived() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final dio = DioHttp();
      final serverRaw =
          widget.paymentModeData != null &&
              widget.paymentModeData!['paymentMode'] != null
          ? widget.paymentModeData!['paymentMode']
          : 'ONLINE';
      final serverMode = normalizePaymentMethod(serverRaw);

      // If server already expects ONLINE payments, skip API and treat as success
      if (serverMode == 'ONLINE') {
        try {
          final homeProvider = Provider.of<HomeProvider>(
            context,
            listen: false,
          );
          await homeProvider.fetchData(context);
        } catch (_) {}
        if (mounted) context.go(AppRoutes.homeScreen);
      } else {
        final paymentToSend = normalizePaymentMethod(_selectedMethod);
        final resp = await dio.completeDeliveryPayment(
          context,
          orderId: widget.orderId?.toString() ?? '',
          paymentMethod: paymentToSend,
        );
        final dataResponse = resp.data['dataResponse'];
        final returnCode = dataResponse != null
            ? dataResponse['returnCode']
            : null;
        final description = dataResponse != null
            ? dataResponse['description']
            : null;
        if (returnCode == 0) {
          try {
            final homeProvider = Provider.of<HomeProvider>(
              context,
              listen: false,
            );
            await homeProvider.fetchData(context);
          } catch (_) {}
          if (mounted) context.go(AppRoutes.homeScreen);
        } else {
          final msg = description ?? 'Payment failed';
          setState(() {
            _error = msg;
          });
          MySnackBar.showSnackBar(context, msg);
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                  for (final method in ['Cash', 'UPI', 'Card', 'Other'])
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMethod = method;
                        });
                      },
                      child: _PaymentModeChip(
                        label: method,
                        selected: _selectedMethod == method,
                      ),
                    ),
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

              // if (_error != null)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8.0),
              //     child: Text(_error!, style: TextStyle(color: Colors.red)),
              //   ),
              CommonButton(
                isfullWidth: true,
                buttonValue: _isLoading ? 'Processing...' : 'Payment received',
                padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 4.w),
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                onTap: _isLoading ? null : _handlePaymentReceived,
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
  final bool selected;
  const _PaymentModeChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: selected
            ? AllColors.primaryColor.withOpacity(0.15)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: selected ? AllColors.primaryColor : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: selected ? AllColors.primaryColor : const Color(0xFF4B5563),
        ),
      ),
    );
  }
}
