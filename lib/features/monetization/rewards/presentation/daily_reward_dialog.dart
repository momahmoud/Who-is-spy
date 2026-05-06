import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salfah/core/config/economy_config.dart';
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
    });
    try {
      final DailyRewardClaimResult r = await DailyRewardService.claimToday();
      if (!mounted) return;
      final l = context.localization;
      if (r == DailyRewardClaimResult.claimed) {
        Navigator.of(context).pop();
        return;
      }
      if (r == DailyRewardClaimResult.alreadyClaimedToday) {
        setState(() => _message = l.monetizationDailyRewardAlreadyClaimed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore(bool viaAd) async {
    if (_busy || !_offerRestore) return;
    final l = context.localization;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      if (viaAd) {
        final bool earned = await Get.find<AdsService>().showRewardedAd(
          placement: 'daily_streak_restore',
        );
        if (!mounted) return;
        if (!earned) {
          setState(() => _message = l.monetizationAdNotCompleted);
          return;
        }
      }
      final bool ok = await DailyRewardService.restoreStreakAfterRewardedAd();
      if (!mounted) return;
      setState(() {
        _offerRestore = false;
        _message = ok
            ? l.monetizationDailyRewardStreakRestoredBody
            : l.monetizationDailyRewardRestoreUnavailable;
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.localization;
    return AlertDialog(
      title: Text(l.monetizationDailyRewardTitle),
      content: FutureBuilder<int>(
        future: DailyRewardService.previewNextStreakForTodayClaim(),
        builder: (BuildContext context, AsyncSnapshot<int> snap) {
          final int nextStreak = snap.data ?? 1;
          final int coinPreview = widget.economy.dailyCoinsForStreakDay(
            (nextStreak - 1).clamp(0, 999),
          );
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                l.monetizationDailyRewardPreview(nextStreak, coinPreview),
              ),
              if (_message != null) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  _message!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ],
          );
        },
      ),
      actions: <Widget>[
        if (_offerRestore)
          TextButton(
            onPressed: _busy
                ? null
                : widget.economy.streakRestoreRewardedOnly
                    ? () => _restore(true)
                    : () => _restore(false),
            child: Text(
              widget.economy.streakRestoreRewardedOnly
                  ? l.monetizationRestoreStreakWithAd
                  : l.monetizationRestoreStreak,
            ),
          ),
        FilledButton(
          onPressed: _busy ? null : _claim,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l.monetizationClaimReward),
        ),
      ],
    );
  }
}
