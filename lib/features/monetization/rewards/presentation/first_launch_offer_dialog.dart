import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:salfah/features/ads/services/ads_service.dart';
import 'package:salfah/features/settings/services/purchase_service.dart';

class FirstLaunchOfferDialog extends StatefulWidget {
  const FirstLaunchOfferDialog({
    super.key,
    required this.economy,
    required this.onDone,
  });

  final EconomyConfig economy;
  final VoidCallback onDone;

  @override
  State<FirstLaunchOfferDialog> createState() => _FirstLaunchOfferDialogState();
}

class _FirstLaunchOfferDialogState extends State<FirstLaunchOfferDialog> {
  bool _loading = false;

  Future<void> _watchAd() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final bool earned = await Get.find<AdsService>().showRewardedAd(
        placement: 'first_launch_bonus',
      );
      if (!mounted) return;
      if (earned) {
        await Get.find<CoinsController>().addCoins(
          widget.economy.firstLaunchRewardedCoins,
          reason: 'first_launch_rewarded',
        );
      }
      if (mounted && earned) widget.onDone();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _starterPack() async {
    if (_loading || !widget.economy.firstLaunchShowStarterPack) return;
    setState(() => _loading = true);
    try {
      if (Get.isRegistered<PurchaseService>()) {
        await Get.find<PurchaseService>().purchaseProduct(
          widget.economy.starterPackProductId,
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.localization;
    final int coins = widget.economy.firstLaunchRewardedCoins;
    return AlertDialog(
      title: Text(l.monetizationWelcomeTitle),
      content: Text(
        l.monetizationFirstLaunchFreeCoinsBody(coins),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _loading ? null : widget.onDone,
          child: Text(l.monetizationNotNow),
        ),
        if (widget.economy.firstLaunchShowStarterPack)
          TextButton(
            onPressed: _loading ? null : _starterPack,
            child: Text(l.monetizationStarterPack),
          ),
        FilledButton(
          onPressed: _loading ? null : _watchAd,
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l.monetizationWatchAdShort),
        ),
      ],
    );
  }
}
