import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class CommonDottedBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets? paddding;
  final double? width;
  const CommonDottedBox({
    super.key,
    required this.child,
    this.paddding,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DottedBorder(
        color: Colors.grey.shade400,
        strokeWidth: 1.2,
        dashPattern: [6, 3],
        borderType: BorderType.RRect,
        radius: const Radius.circular(10),
        child: Container(
          padding: paddding,
          width: width,
          color: Colors.white,
          child: child,
        ),
      ),
    );
  }
}
