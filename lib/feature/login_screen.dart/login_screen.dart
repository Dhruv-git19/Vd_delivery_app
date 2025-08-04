import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_button.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_container.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/common_textfield.dart';
import 'package:vedasip_delivery_app/core/utils/common_widgets/dotted_container.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommonButton(buttonValue: 'LOGIN'),
        ),
      ),
    );
  }
}
