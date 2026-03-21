import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vedasip_delivery_app/core/routes/app_routes.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_confirm_cont.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/provider/delivery_details_provider.dart';
import 'package:vedasip_delivery_app/screens/home_screen/provider/homeProvider.dart';
import 'package:vedasip_delivery_app/screens/payment_collection_screen/widgets/tab_bar.dart';
import 'package:vedasip_delivery_app/services/dio_http.dart';

class PaymentCollectionScreen extends StatefulWidget {
  final int? orderId;
  final String? type;

  const PaymentCollectionScreen({super.key, this.orderId, this.type});

  @override
  State<PaymentCollectionScreen> createState() =>
      _PaymentCollectionScreenState();
}

class _PaymentCollectionScreenState extends State<PaymentCollectionScreen> {
  late final DeliveryDetailsProvider _provider;
  final DioHttp _dioHttp = DioHttp();
  Map<String, dynamic>? _paymentModeData;
  bool _isPaymentModeLoading = false;
  String? _paymentModeError;

  @override
  void initState() {
    super.initState();
    _provider = DeliveryDetailsProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.orderId != null) {
        _provider.fetchOrderDetails(
          context,
          orderId: widget.orderId!,
          type: widget.type ?? 'cart',
        );
        if (!mounted) return;
        setState(() {
          _isPaymentModeLoading = true;
          _paymentModeError = null;
        });
        try {
          final resp = await _dioHttp.checkOrderPaymentMode(
            context,
            orderId: widget.orderId.toString(),
            type: widget.type ?? 'cart',
          );
          if (!mounted) return;
          if (resp.data is Map && resp.data.containsKey('data')) {
            setState(() {
              _paymentModeData = resp.data['data'];
            });
          } else {
            setState(() {
              _paymentModeError = 'Invalid payment mode response';
            });
          }
        } catch (e) {
          if (!mounted) return;
          setState(() {
            _paymentModeError = e.toString();
          });
        } finally {
          if (!mounted) return;
          setState(() {
            _isPaymentModeLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  String _getCustomerName(Map<String, dynamic>? details) {
    return details?['customer']?['fullName'] ?? '---';
  }

  String _getCustomerAddress(Map<String, dynamic>? details) {
    return details?['address']?['fullAddress'] ?? '---';
  }

  String _getTotalAmount(Map<String, dynamic>? details) {
    return details?['totalAmount']?.toString() ?? '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DeliveryDetailsProvider>.value(
      value: _provider,
      child: Consumer<DeliveryDetailsProvider>(
        builder: (context, provider, _) {
          final details = provider.details;
          final name = _getCustomerName(details);
          final address = _getCustomerAddress(details);
          final amount = _getTotalAmount(details);
          final itemsCount = details?['cart']?['cartDetails']?.length ?? 0;

          // Determine server payment mode (if available)
          final serverRaw =
              _paymentModeData != null &&
                  _paymentModeData!.containsKey('paymentMode')
              ? _paymentModeData!['paymentMode']
              : null;
          final serverMode = normalizePaymentMethod(serverRaw);

          return Scaffold(
            appBar: CommonAppbar(
              title: 'Payment Collection',
              text: 'Collect Payment',
              code: '#DEL${widget.orderId ?? ''}',
            ),
            body: provider.isLoading || _isPaymentModeLoading
                ? const Center(child: CircularProgressIndicator())
                : _paymentModeError != null
                ? Center(child: Text(_paymentModeError!))
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DeliveryConfirmCont(
                          name: name,
                          address: address,
                          rupee: amount,
                          items: '$itemsCount items',
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Payment details',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AllColors.verifyheadingcolor,
                          ),
                        ),
                        Text(
                          'Choose how you collected the payment and update the status.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AllColors.deliverydetailshadelight,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        if (serverMode == 'ONLINE') ...[
                          Center(
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                Text(
                                  'Payment already processed online.',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: CommonButton(
                                    onTap: () async {
                                      try {
                                        final homeProvider =
                                            Provider.of<HomeProvider>(
                                              context,
                                              listen: false,
                                            );
                                        await homeProvider.fetchData(context);
                                      } catch (_) {}
                                      context.go(AppRoutes.homeScreen);
                                    },
                                    buttonValue: 'Go to home',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          CustomTab(
                            paymentModeData: _paymentModeData,
                            orderId: widget.orderId,
                            orderType: widget.type,
                          ),
                        ],
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
