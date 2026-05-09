import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/assets/app_images.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/localization/generated/l10n.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/ads/services/ads_service.dart';
import 'package:salfah/features/monetization/services/daily_reward_service.dart';

class DailyRewardDialog extends StatefulWidget {
  const DailyRewardDialog({super.key, required this.economy});

  final EconomyConfig economy;

  @override
  State<DailyRewardDialog> createState() => _DailyRewardDialogState();
}

class _DailyRewardDialogState extends State<DailyRewardDialog> {
  bool _busy = false;
  String? _message;
  bool _messagePositive = false;
  bool _offerRestore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await DailyRewardService.rebuildRestoreOfferFromCalendar();
      final bool offer = await DailyRewardService.shouldOfferRestore();
      if (mounted) {
        setState(() => _offerRestore = offer);
      }
    });
  }

  Future<void> _claim() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _message = null;
      _messagePositive = false;
    });
    try {
      final DailyRewardClaimResult r = await DailyRewardService.claimToday();
      if (!mounted) return;
      final AppLocalization l = context.localization;
      if (r == DailyRewardClaimResult.claimed) {
        Navigator.of(context).pop();
        return;
      }
      if (r == DailyRewardClaimResult.alreadyClaimedToday) {
        setState(() {
          _message = l.monetizationDailyRewardAlreadyClaimed;
          _messagePositive = false;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore(bool viaAd) async {
    if (_busy || !_offerRestore) return;
    final AppLocalization l = context.localization;
    setState(() {
      _busy = true;
      _message = null;
      _messagePositive = false;
    });
    try {
      if (viaAd) {
        final bool earned = await Get.find<AdsService>().showRewardedAd(
          placement: 'daily_streak_restore',
        );
        if (!mounted) return;
        if (!earned) {
          setState(() {
            _message = l.monetizationAdNotCompleted;
            _messagePositive = false;
          });
          return;
        }
      }
      final bool ok = await DailyRewardService.restoreStreakAfterRewardedAd();
      if (!mounted) return;
      setState(() {
        _offerRestore = false;
        if (ok) {
          _message = l.monetizationDailyRewardStreakRestoredBody;
          _messagePositive = true;
        } else {
          _message = l.monetizationDailyRewardRestoreUnavailable;
          _messagePositive = false;
        }
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalization l = context.localization;
    final bool isRtl = Get.locale?.languageCode == AppStrings.arabicLang;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
        elevation: 0,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxWidth: 400.w),
              padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 22.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColors.primary2.withValues(alpha: 0.96),
                    AppColors.primary1.withValues(alpha: 0.99),
                  ],
                ),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                  width: 1.5,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 36,
                    offset: const Offset(0, 18),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildHeader(l),
                  SizedBox(height: 20.h),
                  FutureBuilder<int>(
                    future: DailyRewardService.previewNextStreakForTodayClaim(),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snap) {
                      final int nextStreak = snap.data ?? 1;
                      final int coinPreview =
                          widget.economy.dailyCoinsForStreakDay(
                        (nextStreak - 1).clamp(0, 999),
                      );
                      final String preview =
                          l.monetizationDailyRewardPreview(
                        nextStreak,
                        coinPreview,
                      );
                      final List<String> lines = preview.split('\n');
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _StreakPreviewLine(
                            text: lines.isNotEmpty ? lines.first : preview,
                          ),
                          if (lines.length > 1) SizedBox(height: 12.h),
                          if (lines.length > 1)
                            _CoinRewardLine(
                              text: lines.sublist(1).join('\n'),
                              coinAmount: coinPreview,
                            ),
                        ],
                      );
                    },
                  ),
                  if (_message != null) ...<Widget>[
                    SizedBox(height: 16.h),
                    _MessageBanner(
                      message: _message!,
                      positive: _messagePositive,
                    ),
                  ],
                  if (_offerRestore) ...<Widget>[
                    SizedBox(height: 18.h),
                    _RestoreAction(
                      busy: _busy,
                      rewardedOnly: widget.economy.streakRestoreRewardedOnly,
                      label: widget.economy.streakRestoreRewardedOnly
                          ? l.monetizationRestoreStreakWithAd
                          : l.monetizationRestoreStreak,
                      onTap: () => _restore(
                        widget.economy.streakRestoreRewardedOnly,
                      ),
                    ),
                  ],
                  SizedBox(height: 22.h),
                  _ClaimButton(
                    busy: _busy,
                    label: l.monetizationClaimReward,
                    onPressed: _claim,
                  ),
                ],
              ),
            ).animate().scale(
                  duration: 380.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.92, 0.92),
                ),
            PositionedDirectional(
              top: 6.h,
              end: 6.w,
              child: IconButton(
                onPressed: _busy ? null : () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  foregroundColor: Colors.white70,
                  padding: EdgeInsets.all(6.w),
                ),
                icon: Icon(Icons.close_rounded, size: 20.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalization l) {
    return Column(
      children: <Widget>[
        Container(
          width: 72.w,
          height: 72.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.yellowNormal.withValues(alpha: 0.35),
                AppColors.color1.withValues(alpha: 0.25),
              ],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.yellowNormal.withValues(alpha: 0.25),
                blurRadius: 18,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            Icons.local_fire_department_rounded,
            color: AppColors.yellowNormal,
            size: 38.sp,
          ),
        ).animate().scale(
              delay: 80.ms,
              duration: 450.ms,
              curve: Curves.elasticOut,
            ),
        SizedBox(height: 14.h),
        Text(
          l.monetizationDailyRewardTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _StreakPreviewLine extends StatelessWidget {
  const _StreakPreviewLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.calendar_month_rounded,
            color: AppColors.color5.withValues(alpha: 0.95),
            size: 22.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.88),
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 320.ms).slideY(begin: 0.06);
  }
}

class _CoinRewardLine extends StatelessWidget {
  const _CoinRewardLine({
    required this.text,
    required this.coinAmount,
  });

  final String text;
  final int coinAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppColors.yellowNormal.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.yellowBorder.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            AppImages.coin,
            width: 28.w,
            height: 28.w,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.yellowLight50,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.yellowNormal.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '+$coinAmount',
              style: TextStyle(
                color: AppColors.yellowNormal,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 60.ms, duration: 340.ms).slideY(begin: 0.06);
  }
}

class _MessageBanner extends StatelessWidget {
  const _MessageBanner({
    required this.message,
    required this.positive,
  });

  final String message;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final Color accent =
        positive ? AppColors.color2 : AppColors.red500Base;
    final Color iconColor = positive ? AppColors.color2 : AppColors.red300;
    final IconData icon =
        positive ? Icons.check_circle_outline_rounded : Icons.info_outline_rounded;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Container(
        key: ValueKey<String>(message),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: accent.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(
              icon,
              size: 18.sp,
              color: iconColor,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestoreAction extends StatelessWidget {
  const _RestoreAction({
    required this.busy,
    required this.rewardedOnly,
    required this.label,
    required this.onTap,
  });

  final bool busy;
  final bool rewardedOnly;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: busy ? null : onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.color1.withValues(alpha: 0.55),
            ),
            color: AppColors.color1.withValues(alpha: 0.08),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (rewardedOnly)
                Icon(
                  Icons.play_circle_outline_rounded,
                  color: AppColors.color1,
                  size: 22.sp,
                ),
              if (rewardedOnly) SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.color1,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
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

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({
    required this.busy,
    required this.label,
    required this.onPressed,
  });

  final bool busy;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: busy ? null : onPressed,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            gradient: busy
                ? LinearGradient(
                    colors: <Color>[
                      AppColors.color1.withValues(alpha: 0.35),
                      AppColors.color1.withValues(alpha: 0.25),
                    ],
                  )
                : const LinearGradient(
                    colors: <Color>[AppColors.color1, Color(0xFFFF8530)],
                  ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: busy
                ? <BoxShadow>[]
                : <BoxShadow>[
                    BoxShadow(
                      color: AppColors.color1.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(
            child: busy
                ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.redeem_rounded,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.08);
  }
}
