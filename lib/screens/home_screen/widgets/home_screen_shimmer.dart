import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 200.h,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 8.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 100.w,
                      height: 20.h,
                      color: Colors.grey[300],
                    ),
                    SizedBox(width: 5.w),
                    Container(
                      width: 40.w,
                      height: 20.h,
                      color: Colors.grey[300],
                    ),
                    const Spacer(),
                    Container(
                      width: 60.w,
                      height: 20.h,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  width: double.infinity,
                  height: 18.h,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 16.h,
                      color: Colors.grey[300],
                    ),
                    SizedBox(width: 20.w),
                    Container(
                      width: 60.w,
                      height: 16.h,
                      color: Colors.grey[300],
                    ),
                    SizedBox(width: 20.w),
                    Container(
                      width: 60.w,
                      height: 16.h,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 14.h,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
