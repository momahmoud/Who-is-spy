import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/const/database_constants.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/features/monetization/services/boost_double_coins_store.dart';
import 'package:salfah/features/monetization/services/monetization_analytics_service.dart';
import 'package:get/get.dart';

class CoinsController extends GetxController {
  CoinsController(this.database);

  final BaseDatabase database;

  int coins = 0;

  @override
  void onInit() {
    super.onInit();
    _initCoins();
  }

  Future<void> _initCoins() async {
    final EconomyConfig config = await EconomyConfig.load();
    final int? saved = database.get<int>(
      tableName: DatabaseConstants.userRewardsTable,
      key: DatabaseConstants.userCoinsKey,
    );
    if (saved == null) {
      coins = config.startingCoins;
      await database.save<int>(
        tableName: DatabaseConstants.userRewardsTable,
        key: DatabaseConstants.userCoinsKey,
        value: coins,
      );
      MonetizationAnalyticsService.logCoinsEarned(
        config.startingCoins,
        reason: 'starting_balance',
      );
    } else {
      coins = saved;
    }
    update();
  }

  Future<int> _earnBasisPoints() async {
    final EconomyConfig econ = await EconomyConfig.load();
    final String? vip = database.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumVipKey,
    );
    final String? adsOff = database.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumAdsRemovedKey,
    );
    final bool premium = vip == 'true' || adsOff == 'true';
    if (!premium) return 100;
    return 100 + econ.vipCoinBonusPercent;
  }

  /// Adds coins after applying VIP earning % and optional one-time double boost.
  Future<void> addCoins(int value, {String reason = 'general'}) async {
    if (value <= 0) return;

    final int basis = await _earnBasisPoints();
    int total = value * basis ~/ 100;

    if (await BoostDoubleCoinsStore.consumeIfPending()) {
      total *= 2;
    }

    coins += total;
    await database.save<int>(
      tableName: DatabaseConstants.userRewardsTable,
      key: DatabaseConstants.userCoinsKey,
      value: coins,
    );
    MonetizationAnalyticsService.logCoinsEarned(total, reason: reason);
    update();
  }

  Future<bool> deductCoins(int value, {String reason = 'general'}) async {
    if (coins >= value) {
      coins -= value;
      await database.save<int>(
        tableName: DatabaseConstants.userRewardsTable,
        key: DatabaseConstants.userCoinsKey,
        value: coins,
      );
      MonetizationAnalyticsService.logCoinsSpent(value, reason: reason);
      update();
      return true;
    }
    return false;
  }
}
