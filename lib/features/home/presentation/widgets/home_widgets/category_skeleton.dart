import 'package:salfah/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(milliseconds: 500),
      color: Colors.white,
      colorOpacity: 0.04,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary2.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(
                  width: 52.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
            Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.15),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22.r),
                  bottomRight: Radius.circular(22.r),
                ),
              ),
              child: Center(
                child: Container(
                  width: 70.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
