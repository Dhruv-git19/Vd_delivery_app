import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_confirm_cont.dart';
import 'package:vedasip_delivery_app/screens/payment_collection_screen/widgets/tab_bar.dart';
import 'package:vedasip_delivery_app/screens/delivery_details_screen/provider/delivery_details_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _provider = DeliveryDetailsProvider();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.orderId != null) {
        _provider.fetchOrderDetails(
          context,
          orderId: widget.orderId!,
          type: widget.type ?? 'cart',
        );
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

          return Scaffold(
            appBar: CommonAppbar(
              title: 'Payment Collection',
              text: 'Collect Payment',
              code: '#DEL${widget.orderId ?? ''}',
            ),
            body: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
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
                        const CustomTab(),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
