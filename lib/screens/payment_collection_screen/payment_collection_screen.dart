import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/screens/confirm_delivery%20screen/widgets/common_confirmation_tabbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_delivery_confirm_cont.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_dotted_box.dart';

import 'package:vedasip_delivery_app/screens/payment_collection_screen/widgets/tab_bar.dart';

class PaymentCollectionScreen extends StatelessWidget {
  const PaymentCollectionScreen({super.key});

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
                CustomTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
