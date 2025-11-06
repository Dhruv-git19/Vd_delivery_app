import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color? colors;
  final String? text;
  final String? code;

  const CommonAppbar({
    super.key,
    required this.title,
    this.actions,
    this.colors,
    this.text,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 80,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          if (code != null)
            (Text(
              code!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            )),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          context.pop();
        },
      ),
      actions: [
        if (text != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 247, 216, 220),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              text!,
              style: TextStyle(
                fontSize: 10,
                color: Colors.red[900],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.grey.shade300, height: 1.0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
