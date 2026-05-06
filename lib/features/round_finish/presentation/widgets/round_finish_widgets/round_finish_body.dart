import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/common_widgets/background_image_widget.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/round_finish/presentation/controller/round_finish_controller.dart';
import 'package:salfah/features/round_finish/presentation/widgets/round_finish_widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundFinishBody extends StatelessWidget {
  const RoundFinishBody({required this.controller, super.key});

  final RoundFinishController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const BackgroundImageWidget(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.primary.withValues(alpha: 0.90),
                AppColors.primary1.withValues(alpha: 0.96),
              ],
            ),
          ),
        ),

        if (!controller.statShow) GuessView(controller: controller),
        if (controller.statShow && !controller.endOfRoundShow)
          StatusView(controller: controller),
        if (controller.endOfRoundShow)
          EndOfRoundView(controller: controller),

        if (controller.resultShow &&
            !controller.statShow &&
            !controller.endOfRoundShow)
          Positioned(
            bottom: 20.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  controller.showStats();
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 10.h,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.h),
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
                        color: AppColors.color1.withValues(alpha: 0.5),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: AppColors.color3.withValues(alpha: 0.2),
                        blurRadius: 36,
                        offset: const Offset(0, 16),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    context.localization.results,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
