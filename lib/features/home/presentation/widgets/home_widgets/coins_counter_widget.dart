import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/assets/app_images.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CoinsCounterWidget extends StatelessWidget {
  const CoinsCounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinsController>(
      builder: (CoinsController controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[AppColors.primary2, AppColors.primary1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: AppColors.yellowNormal.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.yellowNormal.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                AppImages.coin,
                width: 25.h,
                height: 25.h,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8.w),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(
                  '${controller.coins}',
                  key: ValueKey<int>(controller.coins),
                  style: TextStyle(
                    color: AppColors.yellowLightColor250,
                    fontWeight: FontWeight.w900,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
            ],
          ),
        );
      },
    );
  }
}
