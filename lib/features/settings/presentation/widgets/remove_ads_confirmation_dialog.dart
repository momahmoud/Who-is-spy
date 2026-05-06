import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Remove Ads purchase confirmation dialog with locale-aware direction.
class RemoveAdsConfirmationDialog extends StatelessWidget {
  const RemoveAdsConfirmationDialog({
    required this.price,
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });

  final String price;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  static Future<bool> show(
    BuildContext context, {
    required String price,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => RemoveAdsConfirmationDialog(
        price: price,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Get.locale?.languageCode == AppStrings.arabicLang;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Container(
          padding: EdgeInsets.all(28.w),
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
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.color3.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.visibility_off_rounded,
                  color: AppColors.color3,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                context.localization.removeAds,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                context.localization.removeAdsDescription,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15.sp,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.color2.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.color2.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    price,
                    style: TextStyle(
                      color: AppColors.color2,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _DialogButton(
                      label: context.localization.cancel,
                      isPrimary: false,
                      onTap: onCancel,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DialogButton(
                      label: context.localization.confirm,
                      isPrimary: true,
                      onTap: onConfirm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.color2
                : Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14.r),
            border: isPrimary
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.white70,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
