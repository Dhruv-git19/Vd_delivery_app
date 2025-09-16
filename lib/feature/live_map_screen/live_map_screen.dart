import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_appbar.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';

class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppbar(title: 'Live Map Screen'),
      backgroundColor: AllColors.verificationColor,
      body: Column(
        children: [
          SizedBox(height: 10),
          CommonTextfield(
            hintText: "Search Location",
            fillColor: Colors.white,
            borderColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
