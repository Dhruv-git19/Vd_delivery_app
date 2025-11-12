import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_confirm_cont.dart';
import 'package:vedasip_delivery_app/screens/payment_collection_screen/widgets/tab_bar.dart';
import 'package:provider/provider.dart';
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

          return Scaffold(
            appBar: CommonAppbar(
              title: 'Payment Collection',
              text: 'Collect Payment',
              code: '#DEL${widget.orderId ?? ''}',
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
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            DeliveryConfirmCont(
                              name: name,
                              address: address,
                              rupee: amount,
                              items:
                                  '${details?['cart']?['cartDetails']?.length ?? 0} items',
                            ),
                            SizedBox(height: 20.h),
                            CustomTab(),
                          ],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
