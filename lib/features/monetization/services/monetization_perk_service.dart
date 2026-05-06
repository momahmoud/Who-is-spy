import 'package:get/get.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:salfah/features/monetization/services/boost_double_coins_store.dart';
import 'package:salfah/features/monetization/services/monetization_perk_hints_store.dart';

/// Coin sinks / boosts callable from gameplay UI layers.
abstract final class MonetizationPerkService {
  /// Optional UI: reveal category keywords (consumes coins if not used this round).
  static Future<bool> tryBuyRevealCategory(String categoryKey) async {
    final CoinsController coins = Get.find<CoinsController>();
    final EconomyConfig config = await EconomyConfig.load();

    if (await MonetizationPerkHintsStore.wasCategoryRevealUsed()) {
      return false;
    }

    final int cost = config.hintRevealCategoryCost;
    final bool spent = await coins.deductCoins(
      cost,
      reason: MonetizationDeductionHints.revealCategory,
    );

    if (spent) {
      await MonetizationPerkHintsStore.markCategoryRevealUsed();
      return true;
    }
    return false;
  }

  static Future<bool> tryBuyRemoveWrongPlayer() async {
    final CoinsController coins = Get.find<CoinsController>();
    final EconomyConfig config = await EconomyConfig.load();

    if (await MonetizationPerkHintsStore.wasRemoveWrongUsed()) {
      return false;
    }

    final bool spent = await coins.deductCoins(
      config.hintRemoveWrongPlayerCost,
      reason: MonetizationDeductionHints.removeWrongPlayer,
    );
    if (spent) await MonetizationPerkHintsStore.markRemoveWrongUsed();

    return spent;
  }

  static Future<bool> tryBuyHighlightSuspiciousPlayer() async {
    final CoinsController coins = Get.find<CoinsController>();
    final EconomyConfig config = await EconomyConfig.load();

    if (await MonetizationPerkHintsStore.wasHighlightUsed()) {
      return false;
    }

    final bool spent = await coins.deductCoins(
      config.highlightSuspiciousPlayerCost,
      reason: MonetizationDeductionHints.highlightSuspect,
    );
    if (spent) await MonetizationPerkHintsStore.markHighlightUsed();
    return spent;
  }

  static Future<bool> tryBuyDoubleNextRoundCoins() async {
    if (await BoostDoubleCoinsStore.hasPendingBoost()) return false;

    final CoinsController coins = Get.find<CoinsController>();
    final EconomyConfig config = await EconomyConfig.load();

    final bool spent = await coins.deductCoins(
      config.boostDoubleNextRoundCoinCost,
      reason: MonetizationDeductionHints.doubleBoost,
    );
    if (spent) await BoostDoubleCoinsStore.setPending(true);
    return spent;
  }

  static Future<void> grantDoubleCoinsBoostFromRewarded() async =>
      BoostDoubleCoinsStore.setPending(true);

  /// Cheaper/alternate unlock path coins for temp rental (economy-priced).
  static Future<bool> tryQuickTemporaryUnlockSpend(String categoryKey) async {
    final CoinsController coins = Get.find<CoinsController>();
    final EconomyConfig config = await EconomyConfig.load();

    final bool spent = await coins.deductCoins(
      config.quickTempUnlockCoinCostFlat,
      reason: MonetizationDeductionHints.quickUnlock,
    );
    return spent;
  }
}

/// Deduction routing keys consumed by CoinsController hooks.
abstract final class MonetizationDeductionHints {
  static const String revealCategory = 'hint_reveal_category';
  static const String removeWrongPlayer = 'hint_remove_wrong_player';
  static const String highlightSuspect = 'hint_highlight_suspect';
  static const String doubleBoost = 'boost_double_next_round';
  static const String quickUnlock = 'quick_temp_unlock_category';
}
