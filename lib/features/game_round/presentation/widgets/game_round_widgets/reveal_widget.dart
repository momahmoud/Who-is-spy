import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:salfah/features/game_round/presentation/widgets/game_round_widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevealWidget extends StatelessWidget {
  const RevealWidget({required this.controller, super.key});

  final GameRoundController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: GameCard(
          accentColor: AppColors.color3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_search_rounded,
                  size: 60.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 22.h),
              GameCardText(context.localization.theOneOutsideStoryIs),
              SizedBox(height: 18.h),
              Text(
                controller.currentName ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: controller.timerFinish
                      ? AppColors.yellowLightColor250
                      : Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
