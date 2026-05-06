import 'package:shared_preferences/shared_preferences.dart';

/// Runtime override for economy A/B variants (analytics / experiments).
abstract final class MonetizationEconomyPrefs {
  static const String _variantOverrideKey = 'mon_economy_variant_override';

  /// Returns `'B'` if user/setter chose B, else null to use JSON default.
  static Future<String?> getVariantOverride() async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    final String? v = p.getString(_variantOverrideKey);
    if (v == null || v.isEmpty) return null;
    return v;
  }

  static Future<void> setVariantOverride(String? variantKey) async {
    final SharedPreferences p = await SharedPreferences.getInstance();
    if (variantKey == null || variantKey.isEmpty) {
      await p.remove(_variantOverrideKey);
    } else {
      await p.setString(_variantOverrideKey, variantKey);
    }
    // Caller should call EconomyConfig.clearCache() so the merged variant reloads.
  }
}
