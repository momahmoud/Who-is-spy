import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:salfah/features/game_round/presentation/widgets/game_round_widgets/game_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoteWidget extends StatelessWidget {
  const VoteWidget({required this.controller, super.key});

  final GameRoundController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: GameCard(
          accentColor: AppColors.color5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.how_to_vote_rounded,
                  size: 56.w,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              GameCardText(context.localization.votingTime),
              if (controller.voter.isNotEmpty) ...<Widget>[
                SizedBox(height: 8.h),
                GameCardSubText(
                  '${controller.voter} ${context.localization.selectPersonWhoIsOut}',
                ),
              ],
              SizedBox(height: 22.h),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.players.keys
                        .where((String p) => p != controller.voter)
                        .map(
                          (String p) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  controller.voteForPlayer(p);
                                },
                                borderRadius: BorderRadius.circular(18.r),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 13.h),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(18.r),
                                    border: Border.all(
                                      color: Colors.white
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    p,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
