import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class TakePhotoScreen extends StatelessWidget {
  const TakePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(child: Text('Take Photo Screen')),
      ),
    );
  }
}
