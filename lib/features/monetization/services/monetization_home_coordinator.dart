import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/features/monetization/services/daily_reward_service.dart';
import 'package:salfah/features/monetization/services/first_launch_offer_prefs.dart';
import 'package:salfah/features/monetization/services/monetization_analytics_service.dart';
import 'package:salfah/features/monetization/rewards/presentation/daily_reward_dialog.dart';
import 'package:salfah/features/monetization/rewards/presentation/first_launch_offer_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Post-home entry prompts (first launch, daily reward, lightweight invite hook).
abstract final class MonetizationHomeCoordinator {
  static const String _inviteSessionKey = 'mon_invite_placeholder_session';

  static void scheduleAfterFirstHomeFrame() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final BuildContext? ctx = Get.overlayContext ?? Get.context;
      if (ctx == null || !ctx.mounted) return;
      unawaited(runPromotions(ctx));
    });
  }

  static Future<void> runPromotions(BuildContext ctx) async {
    if (!ctx.mounted) return;

    final EconomyConfig econ = await EconomyConfig.load();
    if (!ctx.mounted) return;

    await _maybeLogInviteOncePerSession(econ);

    if (!await FirstLaunchOfferPrefs.wasShown()) {
      if (!ctx.mounted) return;
      await showDialog<void>(
        context: ctx,
        barrierDismissible: false,
        builder: (_) => FirstLaunchOfferDialog(
          economy: econ,
          onDone: () => Navigator.of(ctx).pop(),
        ),
      );
      await FirstLaunchOfferPrefs.markShown();
    }

    if (!ctx.mounted) return;

    await DailyRewardService.rebuildRestoreOfferFromCalendar();
    final bool canDaily = await DailyRewardService.canShowClaimDialogToday();
    final bool restore = await DailyRewardService.shouldOfferRestore();
    if ((canDaily || restore) && ctx.mounted) {
      await showDialog<void>(
        context: ctx,
        barrierDismissible: true,
        builder: (_) =>
            DailyRewardDialog(economy: econ),
      );
    }
  }

  static Future<void> _maybeLogInviteOncePerSession(
    EconomyConfig econ,
  ) async {
    if (!econ.invitePlaceholderEnabled) return;
    final SharedPreferences p = await SharedPreferences.getInstance();
    if (p.getBool(_inviteSessionKey) ?? false) return;
    await p.setBool(_inviteSessionKey, true);
    MonetizationAnalyticsService.invitePlaceholderShown();
  }

  /// For tests / session simulation.
  static Future<void> clearInviteSessionFlag() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.remove(_inviteSessionKey);
  }
}
