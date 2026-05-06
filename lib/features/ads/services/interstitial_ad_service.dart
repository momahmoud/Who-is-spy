import 'dart:async';

import 'package:salfah/core/config/ad_config.dart';
import 'package:salfah/core/const/database_constants.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/features/rating/services/rating_prompt_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Shows interstitial ads. Skips if user has purchased "Remove Ads".
class InterstitialAdService {
  InterstitialAdService(this._db);

  final BaseDatabase _db;

  InterstitialAd? _ad;
  bool _isLoaded = false;
  bool _isLoading = false;
  bool _isShowing = false;
  Completer<void>? _loadCompleter;

  bool get isLoaded => _isLoaded;
  bool get isBusy => _isLoading || _isShowing;

  Future<void> load() async {
    if (_isLoaded) return;
    if (_isLoading && _loadCompleter != null) {
      return _loadCompleter!.future;
    }

    _isLoading = true;
    final Completer<void> completer = Completer<void>();
    _loadCompleter = completer;

    await InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _ad = ad;
          _isLoaded = true;
          ad.fullScreenContentCallback =
              FullScreenContentCallback<InterstitialAd>(
                onAdShowedFullScreenContent: (InterstitialAd ad) {
                  unawaited(RatingPromptService.instance.recordAdShown());
                },
                onAdDismissedFullScreenContent: (InterstitialAd ad) {
                  ad.dispose();
                  _ad = null;
                  _isLoaded = false;
                  _isShowing = false;
                  unawaited(load());
                },
                onAdFailedToShowFullScreenContent:
                    (InterstitialAd ad, AdError error) {
                      ad.dispose();
                      _ad = null;
                      _isLoaded = false;
                      _isShowing = false;
                      unawaited(load());
                    },
              );
          _isLoading = false;
          if (!completer.isCompleted) completer.complete();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _ad = null;
          _isLoaded = false;
          _isLoading = false;
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
    return completer.future;
  }

  /// Returns true if a full-screen presentation was started.
  Future<bool> show() async {
    if (_isShowing) return false;
    if (_ad == null) return false;

    _isShowing = true;
    await _ad!.show();
    return true;
  }

  /// Loads and shows one interstitial. Does not throw if load fails.
  /// Skips if user has purchased "Remove Ads".
  Future<void> loadAndShow() async {
    final String? v = _db.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumAdsRemovedKey,
    );
    if (v == 'true') return;
    if (_isShowing) return;
    await load();
    await show();
  }
}
