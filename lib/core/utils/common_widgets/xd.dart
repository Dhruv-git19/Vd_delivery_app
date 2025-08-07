import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class DottedBorderClipExample extends StatelessWidget {
  const DottedBorderClipExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: DottedBorder(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue.shade50,
              ),
              width: 200,
              height: 100,
              alignment: Alignment.center,
              child: Text(
                "Clipped Inside Rounded Dotted Border",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
