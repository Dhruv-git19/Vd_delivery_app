import 'package:flutter/material.dart';

class CommonIconBackgCont extends StatelessWidget {
  final Icon icon;
  final Color? backgroundColor;
  const CommonIconBackgCont({
    super.key,
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: icon,
    );
  }
}
