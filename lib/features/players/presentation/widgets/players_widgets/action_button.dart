import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/common_widgets/animated_play_button.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/players/presentation/controller/players_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({required this.controller, super.key});

  final PlayersController controller;

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
          onTap: controller.showAddDialog,
          child: Container(
            height: 58.h,
            decoration: BoxDecoration(
              color: AppColors.color4.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.color4.withValues(alpha: 0.45),
                width: 1.5,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.color4.withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (!isRTL) ...<Widget>[
                  Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: 26.w,
                  ),
                  SizedBox(width: 12.w),
                ],
                Text(
                  context.localization.addNewPlayer,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                if (isRTL) ...<Widget>[
                  SizedBox(width: 12.w),
                  Icon(
                    Icons.person_add_rounded,
                    color: Colors.white,
                    size: 26.w,
                  ),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: 18.h),
        AnimatedPlayButton(
          onTap: () {
            HapticFeedback.heavyImpact();
            controller.startGame();
          },
        ),
      ],
    );
  }
}
