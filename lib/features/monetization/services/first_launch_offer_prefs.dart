import 'package:shared_preferences/shared_preferences.dart';

abstract final class FirstLaunchOfferPrefs {
  static const String _seenKey = 'mon_first_launch_offer_seen_v1';

  static Future<bool> wasShown() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    return p.getBool(_seenKey) ?? false;
  }

  static Future<void> markShown() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(_seenKey, true);
  }
}
