import 'package:flutter/material.dart';
import 'package:vedasip_delivery_app/core/theme/theme.dart';

class CommonDropdown extends StatelessWidget {
  final String text;

  const CommonDropdown({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_drop_down, color: AllColors.primaryColor),
        ],
      ),
    );
  }
}
