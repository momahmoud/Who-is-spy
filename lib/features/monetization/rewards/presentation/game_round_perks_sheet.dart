import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/localization/generated/l10n.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/ads/services/ads_service.dart';
import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:salfah/features/monetization/services/monetization_perk_service.dart';

Future<void> showGameRoundPerksSheet(
  BuildContext context,
  GameRoundController game,
) async {
  final EconomyConfig econ = await EconomyConfig.load();
  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (BuildContext sheetCtx) {
      final AppLocalization l = sheetCtx.localization;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                l.monetizationRoundBoostsTitle,
                style: Theme.of(sheetCtx).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.category_outlined),
                title: Text(l.monetizationRevealCategoryHintTitle),
                subtitle: Text(l.monetizationCoinAmountCoins(econ.hintRevealCategoryCost)),
                onTap: () async {
                  final bool ok = await MonetizationPerkService.tryBuyRevealCategory(
                    game.category,
                  );
                  if (!sheetCtx.mounted) return;
                  Navigator.of(sheetCtx).pop();
                  _snack(
                    l,
                    ok,
                    ok
                        ? l.monetizationCategoryHintUnlockedWithCategory(game.category)
                        : l.monetizationUnavailableOrInsufficientCoins,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_off_outlined),
                title: Text(l.monetizationRemoveWrongPlayerHintTitle),
                subtitle:
                    Text(l.monetizationCoinAmountCoins(econ.hintRemoveWrongPlayerCost)),
                onTap: () async {
                  final bool ok =
                      await MonetizationPerkService.tryBuyRemoveWrongPlayer();
                  if (!sheetCtx.mounted) return;
                  Navigator.of(sheetCtx).pop();
                  if (ok) {
                    final List<String> pool = game.players.keys
                        .where((String k) => k != game.outsidePlayer)
                        .toList();
                    final String tip = pool.isEmpty
                        ? l.monetizationHintActiveThisRound
                        : l.monetizationFocusLessOnPlayer(
                            pool[Random().nextInt(pool.length)],
                          );
                    _snack(l, true, tip);
                  } else {
                    _snack(l, false, l.monetizationUnavailableOrInsufficientCoins);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: Text(l.monetizationHighlightSuspiciousTitle),
                subtitle:
                    Text(l.monetizationCoinAmountCoins(econ.highlightSuspiciousPlayerCost)),
                onTap: () async {
                  final bool ok =
                      await MonetizationPerkService.tryBuyHighlightSuspiciousPlayer();
                  if (!sheetCtx.mounted) return;
                  Navigator.of(sheetCtx).pop();
                  if (ok) {
                    final String mark = game.players.keys
                        .elementAt(Random().nextInt(game.players.length));
                    _snack(
                      l,
                      true,
                      l.monetizationSuspiciousPayAttention(mark),
                    );
                  } else {
                    _snack(l, false, l.monetizationUnavailableOrInsufficientCoins);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.bolt_outlined),
                title: Text(l.monetizationDoubleCoinsNextRoundTitle),
                subtitle: Text(
                  econ.boostDoubleNextRoundViaRewarded
                      ? l.monetizationDoubleCoinsSubtitleCoinsOrAd(
                          econ.boostDoubleNextRoundCoinCost,
                        )
                      : l.monetizationDoubleCoinsSubtitleCoinsOnly(
                          econ.boostDoubleNextRoundCoinCost,
                        ),
                ),
                onTap: () async {
                  Navigator.of(sheetCtx).pop();
                  if (context.mounted) {
                    await _pickDoubleBoost(context, econ);
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _pickDoubleBoost(BuildContext context, EconomyConfig econ) async {
  final AppLocalization l = context.localization;
  final bool? useRewardedAd = await showDialog<bool>(
    context: context,
    builder: (BuildContext dCtx) => AlertDialog(
      title: Text(l.monetizationDoubleNextRoundDialogTitle),
      content: Text(l.monetizationDoubleNextRoundDialogBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(dCtx, false),
          child: Text(
            l.monetizationDoubleCoinsSubtitleCoinsOnly(
              econ.boostDoubleNextRoundCoinCost,
            ),
          ),
        ),
        if (econ.boostDoubleNextRoundViaRewarded)
          TextButton(
            onPressed: () => Navigator.pop(dCtx, true),
            child: Text(l.monetizationRewardedAdButton),
          ),
        TextButton(
          onPressed: () => Navigator.pop(dCtx),
          child: Text(l.cancel),
        ),
      ],
    ),
  );
  if (useRewardedAd == null || !context.mounted) return;

  if (useRewardedAd) {
    final bool earned = await Get.find<AdsService>().showRewardedAd(
      placement: 'boost_double_next_round',
    );
    if (earned) {
      await MonetizationPerkService.grantDoubleCoinsBoostFromRewarded();
      _snack(l, true, l.monetizationNextPayoutDoubledOnce);
    } else {
      _snack(l, false, l.monetizationAdNotCompleted);
    }
    return;
  }

  final bool ok = await MonetizationPerkService.tryBuyDoubleNextRoundCoins();
  _snack(
    l,
    ok,
    ok
        ? l.monetizationNextPayoutDoubledOnce
        : l.monetizationUnavailableOrInsufficientCoins,
  );
}

void _snack(AppLocalization l, bool ok, String msg) {
  Get.snackbar(
    ok ? l.ok : l.monetizationNoticeTitle,
    msg,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}
