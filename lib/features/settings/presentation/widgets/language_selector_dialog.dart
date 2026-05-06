import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/settings/prestation/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Dialog for selecting app language.
class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => const LanguageSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LocalizationController locCtrl = Get.find<LocalizationController>();
    final String current = Get.locale?.languageCode ?? AppStrings.arabicLang;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.primary2,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.color1.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.language_rounded,
                      color: AppColors.color1,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      context.localization.language,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                context.localization.languageDescription,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              SizedBox(height: 24.h),
              _LanguageOption(
                label: context.localization.arabic,
                isSelected: current == AppStrings.arabicLang,
                onTap: () {
                  locCtrl.changeLanguage(AppStrings.arabicLang);
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 12.h),
              _LanguageOption(
                label: context.localization.english,
                isSelected: current == AppStrings.englishLang,
                onTap: () {
                  locCtrl.changeLanguage(AppStrings.englishLang);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.color1.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.color1
                  : Colors.white.withValues(alpha: 0.12),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: <Widget>[
              if (isSelected)
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.w),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 24.sp,
                    color: AppColors.color1,
                  ),
                ),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 16.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
