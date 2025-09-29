import 'package:vedasip_delivery_app/helpers/text_style.dart';
import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/theme/color_pallete.dart';

class MySnackBar {
  // Global key for accessing ScaffoldMessenger
  static final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar(BuildContext context, String message) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: whitebold,
          ),
          backgroundColor: AppColor.primaryColor,
        ),
      );
    } catch (e) {
      // Fallback to global key if context is invalid
      showGlobalSnackBar(message);
    }
  }

  static void showGlobalSnackBar(String message) {
    if (rootScaffoldMessengerKey.currentState != null) {
      rootScaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: whitebold,
          ),
          backgroundColor: AppColor.primaryColor,
        ),
      );
    }
  }
}
