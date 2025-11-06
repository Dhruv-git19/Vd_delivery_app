import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapImage extends StatelessWidget {
  final String? imageUrl;

  const MapImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: SizedBox(
        width: 200.w,
        height: 136.h,
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/map_picture.jpg',
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset('assets/images/map_picture.jpg', fit: BoxFit.cover),
      ),
    );
  }
}
