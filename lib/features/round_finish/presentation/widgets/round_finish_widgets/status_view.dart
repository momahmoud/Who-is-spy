import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/round_finish/presentation/controller/round_finish_controller.dart';
import 'package:salfah/features/round_finish/presentation/widgets/round_finish_widgets/round_finish_action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusView extends StatelessWidget {
  const StatusView({required this.controller, super.key});

  final RoundFinishController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          constraints: BoxConstraints(maxHeight: 0.8.sh),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 28.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                AppColors.primary2,
                Color.lerp(AppColors.primary2, AppColors.color5, 0.4)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: AppColors.color5.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.color5.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.emoji_events_rounded,
                size: 56.w,
                color: AppColors.yellowLightColor250,
              ),
              SizedBox(height: 12.h),
              Text(
                context.localization.results,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: controller.players.entries
                        .map(
                          (MapEntry<String, int> e) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 6.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.18),
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      e.key,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: const BoxDecoration(
                                      color: AppColors.color1,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      '${e.value}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              RoundFinishActionButton(
                text: context.localization.next,
                textColor: Colors.white,
                isPrimary: true,
                gradient: const LinearGradient(
                  colors: <Color>[AppColors.color1, AppColors.color3],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onTap: () async {
                  HapticFeedback.heavyImpact();
                  await controller.onNextFromResults();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
