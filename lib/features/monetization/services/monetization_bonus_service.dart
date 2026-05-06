import 'package:get/get.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:salfah/features/monetization/services/monetization_lifecycle_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Session-scoped viral retention bonuses driven by economy_config.
abstract final class MonetizationBonusService {
  static const String _lobbyBonusAtLaunchIndexKey =
      'mon_viral_lobby_awarded_launch_index';

  /// Rounds finished this cold start (incremented on round-complete screen enter).
  static const String _roundsThisColdStartKey = 'mon_rounds_this_launch';

  /// Call once per cold launch after [MonetizationLifecyclePrefs.incrementColdStartIfNeeded].
  static Future<void> resetSessionRoundCounter() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setInt(_roundsThisColdStartKey, 0);
  }

  static Future<void> maybeAwardLobbyPlayerCountBonus({
    required int seatedPlayerCount,
  }) async {
    final EconomyConfig config = await EconomyConfig.load();

    final int launchIndex =
        await MonetizationLifecyclePrefs.coldStarts(); // >=1 after increment

    final SharedPreferences p = await SharedPreferences.getInstance();
    final int lastAwardLaunch =
        p.getInt(_lobbyBonusAtLaunchIndexKey) ?? -1;

    if (lastAwardLaunch == launchIndex) return;

    if (seatedPlayerCount < config.viralLobbyMinPlayers) return;

    await p.setInt(_lobbyBonusAtLaunchIndexKey, launchIndex);

    final CoinsController c = Get.find<CoinsController>();
    await c.addCoins(config.viralLobbyBonusCoins, reason: 'viral_lobby_players');
  }

  /// Call after each completed round (same moment interstitial policy counts a round).
  static Future<void> onRoundFinishedForSessionBonus() async {
    final EconomyConfig config = await EconomyConfig.load();
    final int n = config.multiRoundBonusEveryN;
    if (n <= 0) return;

    final SharedPreferences p = await SharedPreferences.getInstance();
    final int next = (p.getInt(_roundsThisColdStartKey) ?? 0) + 1;
    await p.setInt(_roundsThisColdStartKey, next);

    if (next % n != 0) return;

    final CoinsController c = Get.find<CoinsController>();
    await c.addCoins(config.multiRoundBonusCoins, reason: 'viral_multi_round');
  }
}
