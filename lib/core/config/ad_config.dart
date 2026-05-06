import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized AdMob ad unit IDs.
/// Dev/Debug: test IDs. Release/Profile: live IDs from .env.
abstract final class AdConfig {
  // Test IDs (used in debug mode)
  static const String _interstitialAndroidTest =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _interstitialIosTest =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _rewardedAndroidTest =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _rewardedIosTest =
      'ca-app-pub-3940256099942544/1712485313';
  static const String _bannerAndroidTest =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _bannerIosTest =
      'ca-app-pub-3940256099942544/2934735716';

  static String get interstitialAdUnitId => kDebugMode
      ? (Platform.isAndroid ? _interstitialAndroidTest : _interstitialIosTest)
      : (Platform.isAndroid
          ? (dotenv.maybeGet('ANDROID_INTERSTITIAL_ID') ?? _interstitialAndroidTest)
          : (dotenv.maybeGet('IOS_INTERSTITIAL_ID') ?? _interstitialIosTest));

  static String get rewardedAdUnitId => kDebugMode
      ? (Platform.isAndroid ? _rewardedAndroidTest : _rewardedIosTest)
      : (Platform.isAndroid
          ? (dotenv.maybeGet('ANDROID_REWARDED_ID') ?? _rewardedAndroidTest)
          : (dotenv.maybeGet('IOS_REWARDED_ID') ?? _rewardedIosTest));

  static String get bannerAdUnitId => kDebugMode
      ? (Platform.isAndroid ? _bannerAndroidTest : _bannerIosTest)
      : (Platform.isAndroid
          ? (dotenv.maybeGet('ANDROID_BANNER_ID') ?? _bannerAndroidTest)
          : (dotenv.maybeGet('IOS_BANNER_ID') ?? _bannerIosTest));
}
