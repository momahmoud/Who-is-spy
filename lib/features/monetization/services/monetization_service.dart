import 'package:salfah/features/monetization/services/monetization_analytics_service.dart';
import 'package:salfah/features/monetization/services/monetization_bonus_service.dart';
import 'package:salfah/features/monetization/services/monetization_lifecycle_prefs.dart';

/// App-level monetization bootstrap (called from [AppInit]).
abstract final class MonetizationService {
  static Future<void> recordColdOpen() async {
    await MonetizationLifecyclePrefs.incrementColdStartIfNeeded();
    await MonetizationBonusService.resetSessionRoundCounter();
    MonetizationAnalyticsService.logAppOpen();
  }
}
