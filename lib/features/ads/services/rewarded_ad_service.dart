import 'dart:async';

import 'package:salfah/core/config/ad_config.dart';
import 'package:salfah/features/rating/services/rating_prompt_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Shows rewarded ads (watch ad for coins). Used internally by [AdsService].
class RewardedAdService {
  RewardedAd? _ad;
  bool _isLoading = false;
  bool _isShowing = false;
  Completer<void>? _loadCompleter;

  bool get isBusy => _isLoading || _isShowing;

  Future<void> preload() async {
    if (_ad != null) return;
    if (_isLoading && _loadCompleter != null) {
      return _loadCompleter!.future;
    }

    _isLoading = true;
    final Completer<void> completer = Completer<void>();
    _loadCompleter = completer;

    await RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _ad = ad;
          _isLoading = false;
          if (!completer.isCompleted) completer.complete();
        },
        onAdFailedToLoad: (_) {
          _ad = null;
          _isLoading = false;
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
  }

  Future<bool> showRewardedAd() async {
    if (_isShowing) return false;

    await preload();
    if (_ad == null) return false;

    final Completer<bool> completer = Completer<bool>();
    bool rewardEarned = false;
    final RewardedAd ad = _ad!;
    _ad = null;
    _isShowing = true;

    ad
      ..fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
        onAdShowedFullScreenContent: (RewardedAd ad) {
          unawaited(RatingPromptService.instance.recordAdShown());
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
          _isShowing = false;
          if (!completer.isCompleted) completer.complete(rewardEarned);
          unawaited(preload());
        },
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
          _isShowing = false;
          if (!completer.isCompleted) completer.complete(false);
          unawaited(preload());
        },
      )
      ..show(
        onUserEarnedReward: (_, _) {
          rewardEarned = true;
        },
      );

    return completer.future;
  }
}
