import 'dart:convert';
import 'dart:ui';

import 'package:salfah/config/navigation/route_names.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/const/database_constants.dart';
import 'package:salfah/core/di/index.dart';
import 'package:salfah/core/helpers/app_helper_functions.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/core/utilities/app_logger.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:salfah/features/home/data/models/category_model.dart';
import 'package:salfah/features/monetization/services/monetization_analytics_service.dart';
import 'package:salfah/features/monetization/services/monetization_home_coordinator.dart';
import 'package:salfah/features/settings/services/premium_service.dart';
import 'package:salfah/features/home/presentation/dialogs/unlock_dialog.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();

  final AppHelperFunctions _helper = AppHelperFunctions();
  final BaseDatabase _database = di<BaseDatabase>();
  final CoinsController _coinsController = Get.find<CoinsController>();

  List<CategoryModel> categories = <CategoryModel>[];
  Set<String> unlockedCategories = <String>{};
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  /// Category id -> expiry timestamp (milliseconds). Used to show remaining time for rented categories.
  Map<String, int> categoryRentals = <String, int>{};

  bool _monetizationHomeScheduled = false;

  /// Loads rentals from DB and builds unlocked set + expiry map.
  Future<void> _loadUnlockedCategories() async {
    final String? jsonString = _database.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.categoryRentalsKey,
    );

    final int now = DateTime.now().millisecondsSinceEpoch;

    if (jsonString != null) {
      final Map<String, dynamic> decoded =
          json.decode(jsonString) as Map<String, dynamic>;
      categoryRentals = decoded.map((String k, dynamic v) {
        final int expiry = v is int ? v : 0;
        return MapEntry<String, int>(k, expiry);
      });
      unlockedCategories = categoryRentals.entries
          .where((MapEntry<String, int> e) => e.value > now)
          .map((MapEntry<String, int> e) => e.key)
          .toSet();
    } else {
      categoryRentals = <String, int>{};
      unlockedCategories = <String>{};
    }
  }

  /// Call when locale changes to reload categories from the new language.
  Future<void> refreshCategories() => _loadData();

  Future<void> _loadData() async {
    isLoading = true;
    update();

    final Locale locale = Get.locale ?? const Locale(AppStrings.arabicLang);

    await _helper.load(locale);
    await _loadUnlockedCategories();

    categories = _helper.getCategories(
      unlockedCategories: unlockedCategories,
      categoryRentals: categoryRentals,
    );

    isLoading = false;
    update();
    if (!_monetizationHomeScheduled) {
      _monetizationHomeScheduled = true;
      MonetizationHomeCoordinator.scheduleAfterFirstHomeFrame();
    }
  }

  /// Rents category for [EconomyConfig.rentalDurationMs] (premium may waive coins).
  Future<bool> rentCategory(CategoryModel category) async {
    if (category.price <= 0 || !category.isLocked) return false;

    final EconomyConfig config = await EconomyConfig.load();
    final int cost = config.categoryRentCost;

    final PremiumService premium = PremiumService(_database);
    if (await premium.shouldWaiveCategoryRent(config)) {
      await _addRental(category.id, config.rentalDurationMs);
      await _loadData();
      MonetizationAnalyticsService.logCategoryRented(
        viaCoins: false,
        categoryId: category.id,
      );
      return true;
    }

    if (_coinsController.coins >= cost) {
      final bool success = await _coinsController.deductCoins(
        cost,
        reason: 'category_rent',
      );
      if (success) {
        await _addRental(category.id, config.rentalDurationMs);
        await _loadData();
        MonetizationAnalyticsService.logCategoryRented(
          viaCoins: true,
          categoryId: category.id,
        );
        return true;
      }
    }
    return false;
  }

  /// Grants a rental window without spending coins (used by quick-unlock / perks).
  Future<void> grantTimedCategoryRental(
    String categoryId,
    int durationMs,
  ) async {
    await _addRental(categoryId, durationMs);
    await _loadData();
  }

  Future<void> _addRental(String categoryId, int durationMs) async {
    final int expiry = DateTime.now().millisecondsSinceEpoch + durationMs;
    final String? jsonString = _database.get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.categoryRentalsKey,
    );
    final Map<String, int> rentals = jsonString != null
        ? (json.decode(jsonString) as Map<String, dynamic>).map(
            (String k, dynamic v) => MapEntry<String, int>(k, v as int),
          )
        : <String, int>{};
    rentals[categoryId] = expiry;
    await _database.save<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.categoryRentalsKey,
      value: json.encode(rentals),
    );
  }

  void onCategoryPressed(String categoryKey) {
    final CategoryModel category = categories.firstWhere(
      (CategoryModel c) => c.id == categoryKey,
    );
    if (category.isLocked) {
      showRentDialog(category);
    } else {
      AppLogger().info('Category pressed: $categoryKey');
      Get.toNamed<void>(RouteNames.players, arguments: categoryKey);
    }
  }

  void showRentDialog(CategoryModel category) {
    Get.dialog<void>(
      UnlockDialog(
        category: category,
      ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
    );
  }

  void showUnlockDialog(CategoryModel category) {
    showRentDialog(category);
  }
}
