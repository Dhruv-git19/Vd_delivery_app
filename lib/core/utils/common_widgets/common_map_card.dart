import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonMapCard extends StatelessWidget {
  const CommonMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        "assets/images/map_picture.jpg",
        width: double.infinity,
        height: 130.h,
        fit: BoxFit.cover,
      ),
    );
  }
}
