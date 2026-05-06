import 'dart:ui';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/assets/app_images.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/localization/generated/l10n.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:salfah/features/ads/services/ads_service.dart';
import 'package:salfah/features/home/data/models/category_model.dart';
import 'package:salfah/features/home/presentation/controller/home_controller.dart';
import 'package:salfah/features/monetization/services/monetization_analytics_service.dart';
import 'package:salfah/features/monetization/services/monetization_perk_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class UnlockDialog extends StatelessWidget {
  const UnlockDialog({required this.category, super.key});

  final CategoryModel category;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EconomyConfig>(
      future: EconomyConfig.load(),
      builder: (BuildContext context, AsyncSnapshot<EconomyConfig> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final EconomyConfig config = snapshot.data!;
        final int rentCost = config.categoryRentCost;
        final int coinsPerAd = config.coinsPerRewardedAd;

        return GetBuilder<CoinsController>(
          builder: (CoinsController coinsController) {
            final bool canRent = coinsController.coins >= rentCost;
            final bool isRtl = Get.locale?.languageCode == AppStrings.arabicLang;

            return Directionality(
              textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
              child: Stack(
                children: [
                  // Backdrop Blur
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(color: Colors.black.withValues(alpha: 0.3)),
                    ),
                  ),
                  Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                    elevation: 0,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        // Main Dialog Card
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 32.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary2.withValues(alpha: 0.95),
                                AppColors.primary1.withValues(alpha: 0.98),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(32.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1.5,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 40,
                                offset: const Offset(0, 20),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _buildHeader(context, config.rentalDurationHours),
                              SizedBox(height: 28.h),
                              _buildBody(
                                context,
                                economy: config,
                                rentCost: rentCost,
                                balance: coinsController.coins,
                                canRent: canRent,
                                coinsPerAd: coinsPerAd,
                                category: category,
                                onCoinsAdded: () => coinsController.update(),
                              ),
                            ],
                          ),
                        ),
                        // Close Button
                        Positioned(
                          top: 12.h,
                          right: 12.w,
                          child: _buildCloseButton(context),
                        ),
                      ],
                    ),
                  ).animate().scale(
                        duration: 400.ms,
                        curve: Curves.easeOutBack,
                        begin: const Offset(0.8, 0.8),
                      ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return IconButton(
      onPressed: Get.back<void>,
      icon: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.close_rounded, size: 20.sp, color: Colors.white60),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int rentalDurationHours) {
    return Column(
      children: <Widget>[
        // Lock Icon Container
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.color2.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.lock_rounded,
              color: AppColors.color2,
              size: 36.sp,
            ),
          ),
        ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
        SizedBox(height: 20.h),
        Text(
          context.localization.unlockCategoryTitle(category.title),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.access_time_filled_rounded,
                color: Colors.white.withValues(alpha: 0.6),
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                context.localization.monetizationDurationHoursShort(rentalDurationHours),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required EconomyConfig economy,
    required int rentCost,
    required int balance,
    required bool canRent,
    required int coinsPerAd,
    required CategoryModel category,
    required VoidCallback onCoinsAdded,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildRow(
          context: context,
          label: context.localization.cost,
          value: rentCost,
          isHighlight: false,
        ),
        SizedBox(height: 12.h),
        _buildRow(
          context: context,
          label: context.localization.yourBalance,
          value: balance,
          isHighlight: true,
        ),
        SizedBox(height: 32.h),

        // Primary Rent Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canRent
                ? () async {
                    final HomeController controller =
                        Get.find<HomeController>();
                    final bool success = await controller.rentCategory(
                      category,
                    );
                    if (success && context.mounted) {
                      Get
                        ..back<void>()
                        ..snackbar(
                          context.localization.success,
                          context.localization.categoryRented,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.color2,
                          colorText: Colors.white,
                        );
                    } else if (context.mounted) {
                      Get.snackbar(
                        context.localization.error,
                        context.localization.failedToRent,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.red500Base,
                        colorText: Colors.white,
                      );
                    }
                  }
                : null,
            borderRadius: BorderRadius.circular(20.r),
            child: AnimatedContainer(
              duration: 200.ms,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: canRent
                    ? const LinearGradient(
                        colors: [AppColors.color2, Color(0xFF00BFA5)],
                      )
                    : LinearGradient(
                        colors: [
                          AppColors.color2.withValues(alpha: 0.3),
                          AppColors.color2.withValues(alpha: 0.2),
                        ],
                      ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: canRent
                    ? [
                        BoxShadow(
                          color: AppColors.color2.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.check_circle_rounded,
                    color: canRent ? Colors.white : Colors.white24,
                    size: 24.sp,
                  ),
                  SizedBox(width: 10.w),
                  _buildRentButtonLabel(context, canRent, economy.rentalDurationHours),
                ],
              ),
            ),
          ),
        ).animate().slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOutQuart),

        SizedBox(height: 16.h),

        Text(
          context.localization.monetizationQuickUnlockHours(
            economy.quickUnlockDurationHours,
          ),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton(
                onPressed: balance >= economy.quickTempUnlockCoinCostFlat
                    ? () async {
                        final AppLocalization l = context.localization;
                        final bool spent =
                            await MonetizationPerkService.tryQuickTemporaryUnlockSpend(
                          category.id,
                        );
                        if (!spent || !context.mounted) return;
                        final HomeController hc = Get.find<HomeController>();
                        await hc.grantTimedCategoryRental(
                          category.id,
                          economy.quickUnlockDurationMs,
                        );
                        if (!context.mounted) return;
                        MonetizationAnalyticsService.logCategoryRented(
                          viaCoins: true,
                          categoryId: category.id,
                        );
                        Get
                          ..back<void>()
                          ..snackbar(
                            l.success,
                            l.categoryRented,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.color2,
                            colorText: Colors.white,
                          );
                        onCoinsAdded();
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
                ),
                child: Text(
                  context.localization.monetizationCoinAmountCoins(
                    economy.quickTempUnlockCoinCostFlat,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  final AppLocalization l = context.localization;
                  final bool earned = await Get.find<AdsService>().showRewardedAd(
                    placement: 'quick_temp_unlock_category',
                  );
                  if (!earned || !context.mounted) return;
                  final HomeController hc = Get.find<HomeController>();
                  await hc.grantTimedCategoryRental(
                    category.id,
                    economy.quickUnlockDurationMs,
                  );
                  if (!context.mounted) return;
                  MonetizationAnalyticsService.logCategoryRented(
                    viaCoins: false,
                    categoryId: category.id,
                  );
                  Get
                    ..back<void>()
                    ..snackbar(
                      l.success,
                      l.categoryRented,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.color2,
                      colorText: Colors.white,
                    );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
                ),
                child: Text(context.localization.monetizationQuickUnlockWithAd),
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        _UnlockWatchAdCoinsButton(
          coinsPerAd: coinsPerAd,
          onCoinsAdded: onCoinsAdded,
        ).animate().slideY(begin: 0.3, duration: 500.ms, curve: Curves.easeOutQuart),
      ],
    );
  }

  Widget _buildRentButtonLabel(
    BuildContext context,
    bool canRent,
    int rentalHours,
  ) {
    final Color textColor = canRent ? Colors.white : Colors.white54;
    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: textColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        children: <TextSpan>[
          TextSpan(text: context.localization.rentFor),
          TextSpan(
            text:
                ' ${context.localization.monetizationDurationHoursShort(rentalHours)}',
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required String label,
    required int value,
    required bool isHighlight,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isHighlight
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isHighlight
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(
                AppImages.coin,
                width: 22.w,
                height: 22.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 10.w),
              Text(
                '$value',
                style: TextStyle(
                  color: AppColors.yellowNormal,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }
}

class _UnlockWatchAdCoinsButton extends StatefulWidget {
  const _UnlockWatchAdCoinsButton({
    required this.coinsPerAd,
    required this.onCoinsAdded,
  });

  final int coinsPerAd;
  final VoidCallback onCoinsAdded;

  @override
  State<_UnlockWatchAdCoinsButton> createState() =>
      _UnlockWatchAdCoinsButtonState();
}

class _UnlockWatchAdCoinsButtonState extends State<_UnlockWatchAdCoinsButton> {
  bool _loading = false;

  Future<void> _handleTap() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final bool earned = await Get.find<AdsService>().showRewardedAd(
        placement: 'unlock_dialog_bonus_coins',
      );
      if (!mounted) return;
      if (earned) {
        final CoinsController c = Get.find<CoinsController>();
        final EconomyConfig config = await EconomyConfig.load();
        await c.addCoins(
          config.coinsPerRewardedAd,
          reason: 'rewarded_ad_unlock_dialog',
        );
        widget.onCoinsAdded();
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _loading ? null : _handleTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Opacity(
          opacity: _loading ? 0.55 : 1,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_loading)
                  SizedBox(
                    width: 24.sp,
                    height: 24.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  )
                else
                  Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 24.sp,
                  ),
                SizedBox(width: 10.w),
                Text(
                  context.localization.watchAdCoinsButton(widget.coinsPerAd),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: _loading ? 0.55 : 0.7),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
