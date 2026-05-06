import 'package:shared_preferences/shared_preferences.dart';

abstract final class BoostDoubleCoinsStore {
  static const String _pendingKey = 'mon_boost_double_next_round';

  static Future<bool> hasPendingBoost() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    return p.getBool(_pendingKey) ?? false;
  }

  static Future<void> setPending(bool value) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_pendingKey, value);
  }

  /// Returns true exactly once while a pending boost existed.
  static Future<bool> consumeIfPending() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final bool v = p.getBool(_pendingKey) ?? false;
    if (!v) return false;
    await p.setBool(_pendingKey, false);
    return true;
  }
}
