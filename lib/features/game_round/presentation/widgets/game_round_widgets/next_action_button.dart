import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextActionButton extends StatelessWidget {
  const NextActionButton({required this.controller, super.key});

  final GameRoundController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40.h,
      left: 24.w,
      right: 24.w,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.heavyImpact();
          controller.showFinishButton
              ? controller.goToRoundResult()
              : controller.onNextPressed();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[AppColors.color1, AppColors.color3],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.25),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.color1.withValues(alpha: 0.55),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.color3.withValues(alpha: 0.25),
                blurRadius: 36,
                offset: const Offset(0, 16),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Text(
            context.localization.next,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
