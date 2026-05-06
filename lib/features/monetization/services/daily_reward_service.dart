import 'package:get/get.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DailyRewardClaimResult {
  claimed,
  alreadyClaimedToday,
  failed,
}

/// Local calendar-day streak + daily coin claims (economy-driven amounts).
abstract final class DailyRewardService {
  static const String _lastClaimYmdKey = 'mon_daily_last_claim_ymd';
  static const String _streakKey = 'mon_daily_streak_days';
  static const String _restoreTargetKey = 'mon_daily_restore_target_streak';

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static DateTime _parseYmd(String ymd) {
    final List<String> p = ymd.split('-');
    return DateTime(
      int.parse(p[0]),
      int.parse(p[1]),
      int.parse(p[2]),
    );
  }

  static int _calendarDaysBetween(DateTime a, DateTime b) {
    final DateTime da = DateTime(a.year, a.month, a.day);
    final DateTime db = DateTime(b.year, b.month, b.day);
    return db.difference(da).inDays;
  }

  static Future<String?> lastClaimYmd() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    return p.getString(_lastClaimYmdKey);
  }

  static Future<int> currentStoredStreak() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    return p.getInt(_streakKey) ?? 0;
  }

  static Future<int?> pendingRestoreTarget() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final int? v = p.getInt(_restoreTargetKey);
    if (v == null || v <= 0) return null;
    return v;
  }

  /// Computes next streak after a successful today's claim without mutating state.
  static Future<int> previewNextStreakForTodayClaim() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String? last = p.getString(_lastClaimYmdKey);
    final int stored = p.getInt(_streakKey) ?? 0;
    final DateTime today = DateTime.now();
    final String todayYmd = _ymd(today);

    if (last == todayYmd) return stored;

    if (last == null || last.isEmpty) {
      return 1;
    }

    final int gap = _calendarDaysBetween(_parseYmd(last), today);
    if (gap == 1) {
      return stored + 1;
    }

    return 1;
  }

  static Future<DailyRewardClaimResult> claimToday() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final EconomyConfig econ = await EconomyConfig.load();
    final String todayYmd = _ymd(DateTime.now());

    final String? last = p.getString(_lastClaimYmdKey);
    if (last == todayYmd) {
      return DailyRewardClaimResult.alreadyClaimedToday;
    }

    int streak = p.getInt(_streakKey) ?? 0;

    if (last != null && last.isNotEmpty) {
      final int gap = _calendarDaysBetween(_parseYmd(last), DateTime.now());
      if (gap == 1) {
        streak += 1;
      } else if (gap > 1) {
        await p.setInt(_restoreTargetKey, streak);
        streak = 1;
      } else {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    final int coinsIndex = (streak - 1).clamp(0, 999);
    final int coins = econ.dailyCoinsForStreakDay(coinsIndex);

    await p.setString(_lastClaimYmdKey, todayYmd);
    await p.setInt(_streakKey, streak);

    final CoinsController c = Get.find<CoinsController>();
    await c.addCoins(coins, reason: 'daily_reward');

    return DailyRewardClaimResult.claimed;
  }

  /// After a missed day, watch a rewarded ad to rewind [lastClaim] to yesterday
  /// and restore the pre-break streak so today's claim can continue the chain.
  static Future<bool> restoreStreakAfterRewardedAd() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final int? target = p.getInt(_restoreTargetKey);
    if (target == null || target <= 0) return false;

    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    await p.setString(_lastClaimYmdKey, _ymd(yesterday));
    await p.setInt(_streakKey, target);
    await p.remove(_restoreTargetKey);
    return true;
  }

  static Future<bool> shouldOfferRestore() async {
    final int? t = await pendingRestoreTarget();
    return t != null && t > 0;
  }

  /// If the calendar gap since last claim is >1 day, snapshot [restoreTargetKey]
  /// from the streak counter so restore UI can appear before claiming.
  static Future<void> rebuildRestoreOfferFromCalendar() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String? last = p.getString(_lastClaimYmdKey);
    final String todayYmd = _ymd(DateTime.now());
    if (last == null || last.isEmpty || last == todayYmd) {
      return;
    }
    final int gap = _calendarDaysBetween(_parseYmd(last), DateTime.now());
    if (gap <= 1) {
      return;
    }
    final int streak = p.getInt(_streakKey) ?? 0;
    if (streak <= 0) {
      return;
    }
    final int existing = p.getInt(_restoreTargetKey) ?? 0;
    if (existing <= 0) {
      await p.setInt(_restoreTargetKey, streak);
    }
  }

  static Future<bool> canShowClaimDialogToday() async {
    final String? last = await lastClaimYmd();
    final String todayYmd = _ymd(DateTime.now());
    if (last == todayYmd) return false;
    return true;
  }
}
