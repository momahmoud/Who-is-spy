import 'package:flutter/foundation.dart';
import 'package:salfah/core/utilities/app_logger.dart';

/// Lightweight monetization telemetry (plug in Firebase / UA later).
abstract final class MonetizationAnalyticsService {
  static DateTime? _sessionStartUtc;

  static void logAppOpen({Map<String, Object?> extras = const <String, Object?>{}}) {
    _sessionStartUtc ??= DateTime.now().toUtc();
    _log('app_open', <String, Object?>{
      'ts': DateTime.now().toUtc().toIso8601String(),
      ...extras,
    });
  }

  static void sessionTick({required int foregroundSecondsApprox}) {
    _log(
      'session_length',
      <String, Object?>{'approx_foreground_secs': foregroundSecondsApprox},
    );
  }

  static void logRewardedWatched({
    required String placement,
    required bool rewarded,
    Map<String, Object?> extras = const <String, Object?>{},
  }) {
    _log('rewarded_ad_watched', <String, Object?>{
      'placement': placement,
      'reward_granted': rewarded,
      ...extras,
    });
  }

  static void logInterstitialShown({
    Map<String, Object?> extras = const <String, Object?>{},
  }) {
    _log('interstitial_shown', <String, Object?>{...extras});
  }

  static void logCoinsEarned(int amount, {required String reason}) {
    _log(
      'coins_earned',
      <String, Object?>{'amount': amount, 'reason': reason},
    );
  }

  static void logCoinsSpent(int amount, {required String reason}) {
    _log(
      'coins_spent',
      <String, Object?>{'amount': amount, 'reason': reason},
    );
  }

  static void logCategoryRented({required bool viaCoins, String? categoryId}) {
    _log(
      'category_rented',
      <String, Object?>{'via_coins': viaCoins, 'category_id': categoryId},
    );
  }

  static void invitePlaceholderShown() =>
      _log('invite_placeholder', const <String, Object?>{});

  static Duration? get sessionElapsed =>
      _sessionStartUtc != null ? DateTime.now().toUtc().difference(_sessionStartUtc!) : null;

  static void _log(String event, Map<String, Object?> payload) {
    if (kDebugMode) {
      AppLogger().info('📊 monetization|$event $_compact(payload)');
      return;
    }
    AppLogger().info('monetization|$event $_compact(payload)');
  }

  static String _compact(Map<String, Object?> m) {
    return m.entries.map((MapEntry<String, Object?> e) => '${e.key}=${e.value}').join(' ');
  }
}
