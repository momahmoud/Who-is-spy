import 'dart:convert';

import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/const/database_constants.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/features/settings/services/purchase_service.dart';

/// Manages premium status (ads removed, donations) via Hive.
class PremiumService {
  PremiumService(this._db);

  final BaseDatabase _db;

  static const Map<String, double> _donationAmounts = <String, double>{
    PurchaseService.donationSmallProductId: 0.99,
    PurchaseService.donationMediumProductId: 4.99,
    PurchaseService.donationLargeProductId: 9.99,
  };

  /// Explicit VIP flag (new purchases). Use [isPremiumSubscriber] for economy perks
  /// so legacy "remove ads" buyers keep +% coin earn.
  Future<bool> isVip() async {
    final String? v = _db.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumVipKey,
    );
    return v == 'true';
  }

  /// Remove-ads or explicit VIP — grants coin multiplier and optional free rentals.
  Future<bool> isPremiumSubscriber() async {
    if (await isVip()) return true;
    return await areAdsRemoved();
  }

  /// Activates full VIP tier (ads off + VIP perks). Idempotent.
  Future<void> activateVip() async {
    await _db.save<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumVipKey,
      value: 'true',
    );
    await setAdsRemoved(true);
  }

  /// Migrates legacy "remove ads only" rows to VIP so economy perks apply uniformly.
  Future<void> syncPremiumTierWithLegacyPurchases() async {
    if (await areAdsRemoved() && !(await isVip())) {
      await activateVip();
    }
  }

  /// Whether category rent should waive coin cost this session.
  Future<bool> shouldWaiveCategoryRent(EconomyConfig economy) async =>
      economy.vipFreeCategoryRentals && await isPremiumSubscriber();

  /// Whether ads have been removed.
  Future<bool> areAdsRemoved() async {
    final String? v = _db.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumAdsRemovedKey,
    );
    return v == 'true';
  }

  /// Set ads removed status.
  Future<void> setAdsRemoved(bool value) async {
    await _db.save<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumAdsRemovedKey,
      value: value.toString(),
    );
  }

  /// Record a donation and its amount.
  Future<void> addDonation(String productId, double amount) async {
    final String? listJson = _db.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumDonationsListKey,
    );
    final List<String> list = listJson != null
        ? List<String>.from(jsonDecode(listJson) as List<dynamic>)
        : <String>[];
    list.add(productId);
    await _db.save<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumDonationsListKey,
      value: jsonEncode(list),
    );

    final String? amountsJson = _db.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumDonationAmountsKey,
    );
    final Map<String, dynamic> map = amountsJson != null
        ? jsonDecode(amountsJson) as Map<String, dynamic>
        : <String, dynamic>{};
    final double current = (map[productId] as num?)?.toDouble() ?? 0;
    map[productId] = current + amount;
    await _db.save<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumDonationAmountsKey,
      value: jsonEncode(map),
    );
  }

  /// Get donation amount for a product (for display).
  static double getDonationAmount(String productId) {
    return _donationAmounts[productId] ?? 0;
  }

  /// Total donations ever made.
  Future<double> getTotalDonations() async {
    final String? json = _db.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumDonationAmountsKey,
    );
    if (json == null) return 0;
    final Map<String, dynamic> map =
        jsonDecode(json) as Map<String, dynamic>? ?? <String, dynamic>{};
    double total = 0;
    for (final dynamic v in map.values) {
      total += (v as num).toDouble();
    }
    return total;
  }

  /// Reset premium features (for debug/testing).
  Future<void> resetPremiumFeatures() async {
    await _db.delete<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumAdsRemovedKey,
    );
    await _db.delete<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumVipKey,
    );
    await _db.delete<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumDonationsListKey,
    );
    await _db.delete<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.premiumDonationAmountsKey,
    );
  }
}
