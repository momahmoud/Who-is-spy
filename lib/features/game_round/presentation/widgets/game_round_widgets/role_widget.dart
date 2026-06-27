import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/helpers/app_helper_functions.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:salfah/features/game_round/presentation/widgets/game_round_widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleWidget extends StatelessWidget {
  const RoleWidget({required this.controller, super.key});
  final GameRoundController controller;

  String _getCategoryName(String categoryKey) {
    try {
      return AppHelperFunctions().getCategoryName(categoryKey);
    } catch (_) {
      return categoryKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = controller.players.keys.elementAt(controller.counter);
    final bool isOutside = name == controller.outsidePlayer;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: GameCard(
          accentColor: isOutside ? AppColors.color3 : AppColors.color2,
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
                  isOutside ? Icons.block_rounded : Icons.check_circle_rounded,
                  size: 60.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 22.h),
              GameCardText(
                isOutside
                    ? context.localization.youAreOutsideStory
                    : context.localization.youAreInsideStory,
              ),
              if (isOutside) ...<Widget>[
                SizedBox(height: 10.h),
                GameCardSubText(
                  '${context.localization.hintTheSaidAbout} ${_getCategoryName(controller.category)}',
                ),
              ],
              if (!isOutside) ...<Widget>[
                SizedBox(height: 12.h),
                Text(
                  controller.item,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                GameCardSubText(context.localization.yourGoal),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
