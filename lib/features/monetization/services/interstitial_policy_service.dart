import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/features/monetization/services/monetization_lifecycle_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Guardrails for non-spammy interstitial frequency.
abstract final class InterstitialPolicyService {
  static const String _lastShownMsKey = 'mon_interstitial_last_shown_ms';
  static const String _roundsLifetimeKey =
      'mon_completed_rounds_lifetime_count';

  static Future<void> recordRoundFinished() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final int n = (p.getInt(_roundsLifetimeKey) ?? 0) + 1;
    await p.setInt(_roundsLifetimeKey, n);
  }

  static Future<int> get lifetimeRoundsFinished async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    return p.getInt(_roundsLifetimeKey) ?? 0;
  }

  static Future<bool> canShow(EconomyConfig config) async {
    if (!config.interstitialEnabled) return false;

    final int launches = await MonetizationLifecyclePrefs.coldStarts();
    final int rounds = await lifetimeRoundsFinished;
    final SharedPreferences p = await SharedPreferences.getInstance();

    if (launches < config.interstitialPolicyMinSessions) return false;

    if (rounds < config.interstitialPolicyMinRounds) return false;

    final int? last = p.getInt(_lastShownMsKey);
    if (last != null) {
      final int delta =
          DateTime.now().millisecondsSinceEpoch - last;
      if (delta <
          config.interstitialPolicyCooldownSeconds * 1000) {
        return false;
      }
    }
    return true;
  }

  static Future<void> markShownNow() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setInt(
      _lastShownMsKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
