// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:salfah/features/home/data/models/category_model.dart';
import 'package:flutter/services.dart';

class AppHelperFunctions {
  // ───────────────── Singleton ─────────────────
  static final AppHelperFunctions _instance = AppHelperFunctions._internal();
  factory AppHelperFunctions() => _instance;
  AppHelperFunctions._internal();

  // ───────────────── State ─────────────────
  final Map<String, Map<String, dynamic>> _data = <String, Map<String, dynamic>>{};
  bool _isLoaded = false;
  Locale? _loadedLocale;

  // ───────────────── Load JSON once ─────────────────
  Future<void> load(Locale locale) async {
    if (_isLoaded && _loadedLocale == locale) return;

    final String lang = locale.languageCode == 'ar' ? 'ar' : 'en';
    final String manifestPath = 'assets/data/$lang/categories_manifest.json';

    final String manifestString = await rootBundle.loadString(manifestPath);
    final List<dynamic> manifest =
        json.decode(manifestString) as List<dynamic>;

    _data.clear();

    for (final dynamic id in manifest) {
      final String categoryId = id as String;
      final String path = 'assets/data/$lang/$categoryId.json';
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> decoded =
          json.decode(jsonString) as Map<String, dynamic>;
      _data[categoryId] = decoded;
    }

    _loadedLocale = locale;
    _isLoaded = true;
  }

  // ───────────────── Categories ─────────────────
  List<CategoryModel> getCategories({
    Set<String>? unlockedCategories,
    int? rentCostForLocked,
    Map<String, int>? categoryRentals,
  }) {
    _ensureLoaded();
    final Set<String> unlocked = unlockedCategories ?? <String>{};
    final int now = DateTime.now().millisecondsSinceEpoch;

    return _data.entries.map((MapEntry<String, Map<String, dynamic>> entry) {
      final String id = entry.key;
      final Map<String, dynamic> categoryData = entry.value;
      final int priceFromData = (categoryData['price'] as int?) ?? 0;
      final bool isLockedFromFile =
          (categoryData['isLocked'] as bool?) ?? (priceFromData > 0);
      final bool isLocked =
          isLockedFromFile && !unlocked.contains(id);
      final int price = (isLocked && rentCostForLocked != null)
          ? rentCostForLocked
          : priceFromData;
      final int? expiry = categoryRentals != null && categoryRentals[id] != null && categoryRentals[id]! > now
          ? categoryRentals[id]
          : null;

      return CategoryModel(
        id: id,
        image: categoryData['image'] as String? ?? 'assets/images/icon.jpg',
        title: categoryData['name'] as String,
        price: price,
        isLocked: isLocked,
        rentalExpiryMillis: expiry,
      );
    }).toList()
      ..sort((CategoryModel a, CategoryModel b) =>
          (a.isLocked == b.isLocked) ? 0 : (a.isLocked ? 1 : -1));
  }

  int getCategoryPrice(String categoryKey) {
    _ensureLoaded();
    final Map<String, dynamic>? categoryData = _data[categoryKey];
    if (categoryData == null) {
      return 0;
    }
    return (categoryData['price'] as int?) ?? 0;
  }

  String getCategoryName(String categoryKey) {
    _ensureLoaded();
    final Map<String, dynamic>? categoryData = _data[categoryKey];
    if (categoryData == null) {
      throw Exception('Category not found: $categoryKey');
    }
    return categoryData['name'] as String;
  }

  // ───────────────── Items ─────────────────
  List<String> getItems(String categoryKey) {
    _ensureLoaded();
    final Map<String, dynamic>? categoryData = _data[categoryKey];
    if (categoryData == null) {
      throw Exception('Category not found: $categoryKey');
    }

    final List<dynamic>? items = categoryData['items'] as List<dynamic>?;
    if (items == null) {
      return <String>[];
    }
    return items.map((dynamic item) => item as String).toList();
  }

  String getRandomItem(String categoryKey) {
    final List<String> items = getItems(categoryKey);
    return items[Random().nextInt(items.length)];
  }

  List<String> getRandomOptions({
    required String categoryKey,
    required String correctItem,
    int count = 8,
  }) {
    final List<String> sourceItems = getItems(categoryKey);
    final Random random = Random();

    final Set<String> result = <String>{correctItem};

    while (result.length < count) {
      result.add(sourceItems[random.nextInt(sourceItems.length)]);
    }

    return result.toList()..shuffle();
  }

  // ───────────────── Safety ─────────────────
  void _ensureLoaded() {
    if (!_isLoaded) {
      throw Exception(
        'AppHelperFunctions.load(locale) must be called before using data',
      );
    }
  }
}
