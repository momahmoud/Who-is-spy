import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:salfah/features/game_round/presentation/widgets/game_round_widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GivePhoneWidget extends StatelessWidget {
  const GivePhoneWidget({required this.controller, super.key});

  final GameRoundController controller;

  @override
  Widget build(BuildContext context) {
    final String name = controller.players.keys.elementAt(controller.counter);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: GameCard(
          accentColor: AppColors.color1,
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
                  Icons.mark_chat_unread_rounded,
                  size: 60.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34.sp,
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
              ),
              SizedBox(height: 14.h),
              GameCardText('${context.localization.givePhoneTo} $name'),
              SizedBox(height: 10.h),
              GameCardSubText(context.localization.tabNextToKnow),
            ],
          ),
        ),
      ),
    );
  }
}
