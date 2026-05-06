class DatabaseConstants {
  const DatabaseConstants._();

  ///START REGION OF TABLES OF CACHES DATA ON HIVE LOCAL DATA BASE
  static const String userDataTable = 'USER-DATA-TABLE';
  static const String userRewardsTable = 'USER-REWARDS-TABLE';

  ///END REGION OF TABLES OF CACHES DATA ON HIVE LOCAL DATA BASE

  ///Start REGION OF CACHE KEYS

  ///END REGION OF TABLES OF CACHES DATA ON HIVE LOCAL DATA BASE

  /// Start REGION UNUSED COLLECTIONS
  static const String languageKey = 'LANGUAGE-VALUE';
  static const String userCoinsKey = 'USER-COINS-VALUE';
  static const String unlockedCategoriesKey = 'UNLOCKED-CATEGORIES-KEY';

  /// JSON map: categoryId -> expiry timestamp (milliseconds since epoch).
  static const String categoryRentalsKey = 'CATEGORY-RENTALS-KEY';

  static const String premiumAdsRemovedKey = 'PREMIUM-ADS-REMOVED-KEY';
  /// VIP tier: multiplier + perks (implies ads disabled for monetization UX).
  static const String premiumVipKey = 'PREMIUM-VIP-KEY';
  static const String premiumDonationsListKey = 'PREMIUM-DONATIONS-LIST-KEY';
  static const String premiumDonationAmountsKey =
      'PREMIUM-DONATION-AMOUNTS-KEY';

  /// End REGION UNUSED COLLECTIONS
}
