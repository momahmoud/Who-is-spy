import 'dart:async';

import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/const/database_constants.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/features/ads/services/interstitial_ad_service.dart';
import 'package:salfah/features/ads/services/rewarded_ad_service.dart';
import 'package:salfah/features/monetization/services/interstitial_policy_service.dart';
import 'package:salfah/features/monetization/services/monetization_analytics_service.dart';
import 'package:get/get.dart';

/// Centralized ads service. Use this everywhere ads are shown.
///
/// - Interstitial ads: round finish, etc. (skipped if user purchased Remove Ads)
/// - Rewarded ads: watch ad for coins (user-initiated)
class AdsService extends GetxController {
  AdsService(this._db);

  final BaseDatabase _db;

  late final InterstitialAdService _interstitial;
  late final RewardedAdService _rewarded;
  bool _isShowingInterstitial = false;
  bool _isShowingRewarded = false;

  @override
  void onInit() {
    super.onInit();
    _interstitial = InterstitialAdService(_db);
    _rewarded = RewardedAdService();
    preloadInterstitial();
    unawaited(_rewarded.preload());
  }

  /// Preloads an interstitial in the background. Call when results page is shown.
  /// Skips if user has purchased "Remove Ads".
  void preloadInterstitial() {
    final String? v = _db.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumAdsRemovedKey,
    );
    if (v == 'true') return;
    unawaited(_interstitial.load());
  }

  /// Shows an interstitial ad. Uses preloaded ad if available.
  /// Skips if user has purchased "Remove Ads" or [EconomyConfig.interstitialEnabled] is false.
  ///
  /// [useInterstitialPolicy] — when `true` (default), also requires session/round count and
  /// cooldown from [InterstitialPolicyService]. Set to `false` for round-finish "Next" so an
  /// ad is attempted every time (like legacy `interstitialPerRound` behavior).
  Future<void> showInterstitial({bool useInterstitialPolicy = true}) async {
    if (_isShowingInterstitial) return;
    final String? v = _db.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumAdsRemovedKey,
    );
    if (v == 'true') return;

    final EconomyConfig econ = await EconomyConfig.load();
    if (!econ.interstitialEnabled) return;

    if (useInterstitialPolicy &&
        !await InterstitialPolicyService.canShow(econ)) {
      return;
    }

    _isShowingInterstitial = true;
    try {
      bool presented = false;
      if (_interstitial.isLoaded) {
        presented = await _interstitial.show();
      } else {
        await _interstitial.load();
        presented = await _interstitial.show();
      }
      if (presented) {
        MonetizationAnalyticsService.logInterstitialShown();
        await InterstitialPolicyService.markShownNow();
      }
    } finally {
      _isShowingInterstitial = false;
    }
  }

  /// Shows a rewarded ad. Returns true if user earned the reward.
  /// Use for "Watch Ad for Coins" and similar flows.
  Future<bool> showRewardedAd({String placement = 'unknown'}) async {
    if (_isShowingRewarded || _rewarded.isBusy) return false;

    _isShowingRewarded = true;
    try {
      final bool earned = await _rewarded.showRewardedAd();
      MonetizationAnalyticsService.logRewardedWatched(
        placement: placement,
        rewarded: earned,
      );
      unawaited(_rewarded.preload());
      return earned;
    } finally {
      _isShowingRewarded = false;
    }
  }
}
