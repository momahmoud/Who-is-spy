import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/settings/services/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:salfah/config/theme/app_colors.dart';

/// Dialog showing three donation tiers.
class DonationOptionsDialog extends StatelessWidget {
  const DonationOptionsDialog({
    required this.onSelectTier,
    required this.getFormattedPrice,
    required this.isPurchasing,
    super.key,
  });

  final void Function(String productId) onSelectTier;
  final String Function(String productId) getFormattedPrice;
  final bool isPurchasing;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Get.locale?.languageCode == AppStrings.arabicLang;
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: AppColors.primary2,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                context.localization.donateToDeveloper,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                context.localization.donateDeveloperSubtitle,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              _DonationCard(
                productId: PurchaseService.donationSmallProductId,
                title: context.localization.donationSmall,
                color: AppColors.color4,
                price: getFormattedPrice(
                  PurchaseService.donationSmallProductId,
                ),
                onTap: isPurchasing
                    ? null
                    : () =>
                          onSelectTier(PurchaseService.donationSmallProductId),
              ),
              SizedBox(height: 12.h),
              _DonationCard(
                productId: PurchaseService.donationMediumProductId,
                title: context.localization.donationMedium,
                color: AppColors.color2,
                price: getFormattedPrice(
                  PurchaseService.donationMediumProductId,
                ),
                onTap: isPurchasing
                    ? null
                    : () =>
                          onSelectTier(PurchaseService.donationMediumProductId),
              ),
              SizedBox(height: 12.h),
              _DonationCard(
                productId: PurchaseService.donationLargeProductId,
                title: context.localization.donationLarge,
                color: AppColors.color1,
                price: getFormattedPrice(
                  PurchaseService.donationLargeProductId,
                ),
                onTap: isPurchasing
                    ? null
                    : () =>
                          onSelectTier(PurchaseService.donationLargeProductId),
              ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () => Get.back<void>(),
                child: Text(
                  context.localization.cancel,
                  style: TextStyle(color: Colors.white70, fontSize: 15.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonationCard extends StatelessWidget {
  const _DonationCard({
    required this.productId,
    required this.title,
    required this.color,
    required this.price,
    required this.onTap,
  });

  final String productId;
  final String title;
  final Color color;
  final String price;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.favorite_rounded, color: color, size: 28.sp),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  price,
                  style: TextStyle(
                    color: color,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
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
