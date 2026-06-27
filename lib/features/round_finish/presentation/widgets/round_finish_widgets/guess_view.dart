import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/round_finish/presentation/controller/round_finish_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GuessView extends StatelessWidget {
  const GuessView({required this.controller, super.key});

  final RoundFinishController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          constraints: BoxConstraints(maxHeight: 0.75.sh),
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 30.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                AppColors.primary2,
                Color.lerp(AppColors.primary2, AppColors.color1, 0.4)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32.r),
            border: Border.all(
              color: AppColors.color1.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.color1.withValues(alpha: 0.4),
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
              Text(
                context.localization.givePhoneToOutsider,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: controller.items.map((String e) {
                      final bool isDisabled = controller.resultShow;
                      final bool isSelected = controller.selectedItem == e;
                      final bool isCorrect = e == controller.item;

                      Color cardColor;
                      Color textColor;

                      if (isDisabled) {
                        if (isSelected && isCorrect) {
                          cardColor = AppColors.color2;
                          textColor = Colors.white;
                        } else if (isSelected && !isCorrect) {
                          cardColor = AppColors.color3;
                          textColor = Colors.white;
                        } else if (!isSelected && isCorrect) {
                          cardColor = AppColors.color2;
                          textColor = Colors.white;
                        } else {
                          cardColor = Colors.white.withValues(alpha: 0.2);
                          textColor = Colors.white.withValues(alpha: 0.5);
                        }
                      } else {
                        cardColor = Colors.white.withValues(alpha: 0.15);
                        textColor = Colors.white;
                      }

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: isDisabled
                                ? null
                                : () {
                                    HapticFeedback.lightImpact();
                                    controller.selectItem(e);
                                  },
                            borderRadius: BorderRadius.circular(20.r),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                vertical: 12.h,
                                horizontal: 24.w,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                                boxShadow: isDisabled
                                    ? null
                                    : <BoxShadow>[
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.15,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                e,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
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
