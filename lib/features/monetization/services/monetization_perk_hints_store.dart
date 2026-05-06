import 'package:shared_preferences/shared_preferences.dart';

/// Per-round hints (consume when match starts GameRoundController).
abstract final class MonetizationPerkHintsStore {
  static const String _catReveal = 'mon_hint_category_used_this_round';
  static const String _removeWrong =
      'mon_hint_remove_wrong_used_this_round';
  static const String _highlight = 'mon_hint_highlight_used_this_round';

  /// Call at the beginning of each new game round navigation.
  static Future<void> clearForNewRound() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.remove(_catReveal);
    await p.remove(_removeWrong);
    await p.remove(_highlight);
  }

  static Future<bool> wasCategoryRevealUsed() async =>
      (await SharedPreferences.getInstance()).getBool(_catReveal) ?? false;

  static Future<bool> wasRemoveWrongUsed() async =>
      (await SharedPreferences.getInstance()).getBool(_removeWrong) ??
      false;

  static Future<bool> wasHighlightUsed() async =>
      (await SharedPreferences.getInstance()).getBool(_highlight) ?? false;

  static Future<void> _set(String key, bool v) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    await p.setBool(key, v);
  }

  static Future<void> markCategoryRevealUsed() => _set(_catReveal, true);

  static Future<void> markRemoveWrongUsed() => _set(_removeWrong, true);

  static Future<void> markHighlightUsed() => _set(_highlight, true);
}
