// ignore: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:salfah/features/monetization/services/monetization_economy_prefs.dart';

/// Monetization economy: loaded from assets, supports variants A/B/C with deep merge onto base [A].
class EconomyConfig {
  EconomyConfig._({
    required this.variant,
    required this.startingCoins,
    required this.coinsPerRound,
    required this.coinsPerRewardedAd,
    required this.categoryRentCost,
    required this.rentalDurationHours,
    required this.interstitialEnabled,
    required this.interstitialPolicyMinSessions,
    required this.interstitialPolicyMinRounds,
    required this.interstitialPolicyCooldownSeconds,
    required this.vipCoinBonusPercent,
    required this.vipFreeCategoryRentals,
    required this.hintRevealCategoryCost,
    required this.hintRemoveWrongPlayerCost,
    required this.highlightSuspiciousPlayerCost,
    required this.boostDoubleNextRoundCoinCost,
    required this.boostDoubleNextRoundViaRewarded,
    required this.quickTempUnlockCoinCostFlat,
    required this.quickTempUnlockDurationHoursOverride,
    required this.dailyRewardsStreakAmounts,
    required this.day4BonusMultiplierOnPreviousDay,
    required this.firstLaunchRewardedCoins,
    required this.firstLaunchStarterPackCoins,
    required this.starterPackProductId,
    required this.firstLaunchShowStarterPack,
    required this.streakRestoreRewardedOnly,
    required this.viralLobbyMinPlayers,
    required this.viralLobbyBonusCoins,
    required this.multiRoundBonusEveryN,
    required this.multiRoundBonusCoins,
    required this.invitePlaceholderEnabled,
    required this.invitePlaceholderCoins,
  });

  final String variant;

  /// Legacy name: kills all interstitial when false.
  bool get interstitialPerRound => interstitialEnabled;

  final bool interstitialEnabled;
  final int interstitialPolicyMinSessions;
  final int interstitialPolicyMinRounds;
  final int interstitialPolicyCooldownSeconds;

  final int startingCoins;
  final int coinsPerRound;
  final int coinsPerRewardedAd;
  final int categoryRentCost;
  final int rentalDurationHours;

  final int vipCoinBonusPercent;
  final bool vipFreeCategoryRentals;

  final int hintRevealCategoryCost;
  final int hintRemoveWrongPlayerCost;
  final int highlightSuspiciousPlayerCost;

  final int boostDoubleNextRoundCoinCost;
  final bool boostDoubleNextRoundViaRewarded;

  final int quickTempUnlockCoinCostFlat;
  /// If null/0, fall back to [rentalDurationHours].
  final int? quickTempUnlockDurationHoursOverride;

  final List<int> dailyRewardsStreakAmounts;
  final bool day4BonusMultiplierOnPreviousDay;
  final bool streakRestoreRewardedOnly;

  final int firstLaunchRewardedCoins;
  final int firstLaunchStarterPackCoins;
  final String starterPackProductId;
  final bool firstLaunchShowStarterPack;

  final int viralLobbyMinPlayers;
  final int viralLobbyBonusCoins;
  final int multiRoundBonusEveryN;
  final int multiRoundBonusCoins;

  final bool invitePlaceholderEnabled;
  final int invitePlaceholderCoins;

  static EconomyConfig? _instance;
  static String _cachedResolvedVariant = '';

  static const String _path = 'assets/data/economy_config.json';

  /// Clears cache (e.g. after variant switch in QA).
  static void clearCache() {
    _instance = null;
    _cachedResolvedVariant = '';
  }

  static Future<EconomyConfig> load({String? forceVariant}) async {
    final String? prefsVariantOverride =
        await MonetizationEconomyPrefs.getVariantOverride();
    final String overrideKey = forceVariant ?? prefsVariantOverride ?? '';

    final String jsonString = await rootBundle.loadString(_path);
    final Map<String, dynamic> root =
        json.decode(jsonString) as Map<String, dynamic>;

    final String defaultVariant =
        (root['default_variant'] as String?) ?? 'A';
    final Map<String, dynamic>? variantsRaw =
        root['variants'] as Map<String, dynamic>?;

    if (variantsRaw != null &&
        variantsRaw.containsKey(defaultVariant)) {
      final Map<String, dynamic> baseBranch =
          Map<String, dynamic>.from(
            variantsRaw[defaultVariant]! as Map<dynamic, dynamic>,
          ).map((dynamic k, dynamic v) =>
              MapEntry<String, dynamic>(k.toString(), v),);

      String active =
          overrideKey.isNotEmpty ? overrideKey : defaultVariant;
      if (!variantsRaw.containsKey(active)) {
        active = defaultVariant;
      }

      Map<String, dynamic> merged =
          Map<String, dynamic>.from(baseBranch);

      if (active != defaultVariant &&
          variantsRaw.containsKey(active)) {
        final Map<String, dynamic> overlay =
            Map<String, dynamic>.from(
              variantsRaw[active]! as Map<dynamic, dynamic>,
            ).map((dynamic k, dynamic v) =>
                MapEntry<String, dynamic>(k.toString(), v),);
        merged = _deepMerge(merged, overlay);
      }

      final String resolvedKey = active;

      if (_instance != null &&
          _cachedResolvedVariant == resolvedKey &&
          forceVariant == null) {
        return _instance!;
      }

      _instance = EconomyConfig._fromMergedMap(resolvedKey, merged);
      _cachedResolvedVariant = resolvedKey;
      return _instance!;
    }

    /// Legacy flat file fallback
    final Map<String, dynamic> merged =
        Map<String, dynamic>.from(root);
    final String vk =
        overrideKey.isNotEmpty
            ? overrideKey
            : (merged['variant'] as String?) ?? defaultVariant;
    _instance = EconomyConfig._fromMergedMap(vk, merged);
    _cachedResolvedVariant = vk;
    return _instance!;
  }

  factory EconomyConfig._fromMergedMap(
    String variant,
    Map<String, dynamic> m,
  ) {
    final Map<String, dynamic>? policy =
        m['interstitial_policy'] as Map<String, dynamic>?;

    final Map<String, dynamic>? hints =
        m['hints'] as Map<String, dynamic>?;
    final Map<String, dynamic>? boosts =
        m['boosts'] as Map<String, dynamic>?;
    final Map<String, dynamic>? quick =
        m['quick_unlock'] as Map<String, dynamic>?;
    final Map<String, dynamic>? daily =
        m['daily_rewards'] as Map<String, dynamic>?;
    final Map<String, dynamic>? first =
        m['first_launch_offer'] as Map<String, dynamic>?;
    final Map<String, dynamic>? viral =
        m['viral_bonus'] as Map<String, dynamic>?;
    final Map<String, dynamic>? invite =
        m['invite_placeholder'] as Map<String, dynamic>?;

    final dynamic dailyAmountsDynamic = daily?['streak_coin_amounts'];
    final List<int> streakCoins = dailyAmountsDynamic is List
        ? dailyAmountsDynamic
            .map((dynamic e) => (e as num).toInt())
            .toList()
        : <int>[10, 20, 30, 50];

    final num? tempHoursNum =
        quick?['temp_unlock_duration_hours_override'] as num?;
    final int? tempHoursDyn = tempHoursNum?.toInt();
    return EconomyConfig._(
      variant: variant,
      startingCoins: (m['starting_coins'] as num?)?.toInt() ?? 25,
      coinsPerRound: (m['coins_per_round'] as num?)?.toInt() ?? 5,
      coinsPerRewardedAd:
          (m['coins_per_rewarded_ad'] as num?)?.toInt() ?? 50,
      categoryRentCost:
          (m['category_rent_cost'] as num?)?.toInt() ?? 150,
      rentalDurationHours:
          (m['rental_duration_hours'] as num?)?.toInt() ?? 2,
      interstitialEnabled: (m['interstitial_enabled'] as bool?) ??
          (m['interstitial_per_round'] as bool?) ??
          true,
      interstitialPolicyMinSessions:
          (policy?['min_sessions_before_first_interstitial']
                  as num?)
              ?.toInt() ??
          2,
      interstitialPolicyMinRounds:
          (policy?['min_rounds_since_install'] as num?)?.toInt() ??
          2,
      interstitialPolicyCooldownSeconds:
          (policy?['cooldown_seconds_between_interstitials'] as num?)
              ?.toInt() ??
          120,
      vipCoinBonusPercent:
          (m['vip_coin_bonus_percent'] as num?)?.toInt() ?? 50,
      vipFreeCategoryRentals:
          (m['vip_free_category_rentals'] as bool?) ?? false,
      hintRevealCategoryCost:
          (hints?['reveal_category_cost'] as num?)?.toInt() ?? 15,
      hintRemoveWrongPlayerCost:
          (hints?['remove_wrong_player_cost'] as num?)?.toInt() ?? 20,
      highlightSuspiciousPlayerCost:
          (hints?['highlight_suspicious_player_cost'] as num?)
              ?.toInt() ??
          12,
      boostDoubleNextRoundCoinCost:
          (boosts?['double_next_round_coin_cost'] as num?)
              ?.toInt() ??
          25,
      boostDoubleNextRoundViaRewarded:
          (boosts?['double_next_round_also_available_via_rewarded']
                  as bool?) ??
          true,
      quickTempUnlockCoinCostFlat:
          (quick?['temp_category_unlock_coin_cost_flat'] as num?)
              ?.toInt() ??
          30,
      quickTempUnlockDurationHoursOverride: tempHoursDyn,
      dailyRewardsStreakAmounts: streakCoins,
      day4BonusMultiplierOnPreviousDay:
          (daily?['day4_is_bonus_claim_x2_previous'] as bool?) ?? false,
      streakRestoreRewardedOnly:
          (daily?['streak_restore_rewarded_only'] as bool?) ?? true,
      firstLaunchRewardedCoins:
          (first?['free_coins_via_rewarded_amount'] as num?)
              ?.toInt() ??
          100,
      firstLaunchStarterPackCoins:
          (first?['starter_pack_coins_award'] as num?)?.toInt() ?? 250,
      starterPackProductId:
          (first?['starter_pack_product_id'] as String?) ??
          'salfah.starter_pack',
      firstLaunchShowStarterPack:
          (first?['show_starter_pack_button'] as bool?) ?? false,
      viralLobbyMinPlayers:
          (viral?['min_players_for_lobby_bonus'] as num?)?.toInt() ??
          3,
      viralLobbyBonusCoins:
          (viral?['lobby_bonus_coins'] as num?)?.toInt() ?? 3,
      multiRoundBonusEveryN:
          (viral?['multi_round_bonus_every_n_rounds'] as num?)
                  ?.toInt() ??
          4,
      multiRoundBonusCoins:
          (viral?['multi_round_bonus_coins'] as num?)?.toInt() ?? 5,
      invitePlaceholderEnabled:
          (invite?['enabled'] as bool?) ?? false,
      invitePlaceholderCoins:
          (invite?['reward_coins'] as num?)?.toInt() ?? 10,
    );
  }

  static Map<String, dynamic> _deepMerge(
    Map<String, dynamic> base,
    Map<String, dynamic> overlay,
  ) {
    final Map<String, dynamic> out =
        Map<String, dynamic>.from(base);
    for (final MapEntry<String, dynamic> e in overlay.entries) {
      final dynamic existingVal = out[e.key];
      final dynamic overlayVal = e.value;
      if (existingVal != null &&
          existingVal is Map &&
          overlayVal is Map) {
        final Map<dynamic, dynamic> baseMap =
            Map<dynamic, dynamic>.from(existingVal);
        final Map<dynamic, dynamic> overlayMap =
            Map<dynamic, dynamic>.from(overlayVal);
        out[e.key] = _deepMerge(
          Map<String, dynamic>.from(
            baseMap.map(
              (dynamic k, dynamic v) =>
                  MapEntry<String, dynamic>(k.toString(), v),
            ),
          ),
          Map<String, dynamic>.from(
            overlayMap.map(
              (dynamic k, dynamic v) =>
                  MapEntry<String, dynamic>(k.toString(), v),
            ),
          ),
        );
      } else {
        out[e.key] = e.value;
      }
    }
    return out;
  }

  int get rentalDurationMs => rentalDurationHours * 60 * 60 * 1000;

  /// Quick-unlock temporary duration (hours).
  int get quickUnlockDurationHours =>
      quickTempUnlockDurationHoursOverride != null &&
              quickTempUnlockDurationHoursOverride! > 0
          ? quickTempUnlockDurationHoursOverride!
          : rentalDurationHours;

  int get quickUnlockDurationMs => quickUnlockDurationHours * 60 * 60 * 1000;

  /// Day index 0..length-1
  int dailyCoinsForStreakDay(int zeroBasedDay) {
    if (dailyRewardsStreakAmounts.isEmpty) return 10;
    if (zeroBasedDay <= 3) {
      return dailyRewardsStreakAmounts[zeroBasedDay.clamp(
        0,
        dailyRewardsStreakAmounts.length - 1,
      )];
    }
    /// Day 5+: repeat last streak entry or multiplier on day 3
    if (day4BonusMultiplierOnPreviousDay &&
        zeroBasedDay == 4 &&
        dailyRewardsStreakAmounts.length >= 3) {
      return dailyRewardsStreakAmounts[2] * 2;
    }
    return dailyRewardsStreakAmounts.last;
  }
}
