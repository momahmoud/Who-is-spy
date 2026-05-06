import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/round_finish/presentation/controller/round_finish_controller.dart';
import 'package:salfah/features/round_finish/presentation/widgets/round_finish_widgets/round_finish_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EndOfRoundView extends StatelessWidget {
  const EndOfRoundView({required this.controller, super.key});

  final RoundFinishController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          constraints: BoxConstraints(maxHeight: 0.85.sh),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                AppColors.primary2,
                Color.lerp(AppColors.primary2, AppColors.color2, 0.4)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: AppColors.color2.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.color2.withValues(alpha: 0.35),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.emoji_events_rounded,
                size: 64.w,
                color: AppColors.yellowLightColor250,
              ),
              SizedBox(height: 20.h),
              Text(
                context.localization.endOfRoundTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                context.localization.endOfRoundDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 34.h),
              RoundFinishActionButton(
                text: context.localization.endOfRoundContinuePlaying,
                textColor: Colors.white,
                isPrimary: true,
                gradient: const LinearGradient(
                  colors: <Color>[AppColors.color1, AppColors.color3],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  controller.playAgain();
                },
              ),
              SizedBox(height: 14.h),
              RoundFinishActionButton(
                text: context.localization.changePlayers,
                color: Colors.white.withValues(alpha: 0.12),
                borderColor: Colors.white.withValues(alpha: 0.35),
                textColor: Colors.white,
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller.goToChangePlayers();
                },
              ),
              SizedBox(height: 14.h),
              RoundFinishActionButton(
                text: context.localization.endOfRoundHomePage,
                color: Colors.white.withValues(alpha: 0.12),
                borderColor: Colors.white.withValues(alpha: 0.35),
                textColor: Colors.white,
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller.goToHomePageAfterInterstitial();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
