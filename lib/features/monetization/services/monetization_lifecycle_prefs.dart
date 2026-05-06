import 'package:shared_preferences/shared_preferences.dart';

abstract final class MonetizationLifecyclePrefs {
  static const String _coldStarts = 'mon_cold_start_count';

  /// One increment per OS process cold start ([AppInit]).
  static Future<int> incrementColdStartIfNeeded() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final int n = (p.getInt(_coldStarts) ?? 0) + 1;
    await p.setInt(_coldStarts, n);
    return n;
  }

  static Future<int> coldStarts() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    return p.getInt(_coldStarts) ?? 0;
  }
}
