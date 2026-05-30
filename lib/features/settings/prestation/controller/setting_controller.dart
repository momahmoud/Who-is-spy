import 'dart:async';

import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/const/database_constants.dart';
import 'package:salfah/core/di/index.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/features/home/presentation/controller/home_controller.dart';
import 'package:salfah/features/notifications/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  Locale _currentLocale = const Locale(AppStrings.arabicLang);

  Locale get currentLocale => _currentLocale;

  static const List<String> _supportedLanguages = <String>['ar', 'en'];

  @override
  void onInit() {
    super.onInit();
    final String? savedLanguageCode = di<BaseDatabase>().get<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.languageKey,
    );
    if (savedLanguageCode != null &&
        _supportedLanguages.contains(savedLanguageCode)) {
      _currentLocale = Locale(savedLanguageCode);
    } else {
      _currentLocale = const Locale(AppStrings.arabicLang);
    }
    Get.updateLocale(_currentLocale);
  }

  void changeLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    Get.updateLocale(_currentLocale);
    di<BaseDatabase>().save<String>(
      tableName: DatabaseConstants.userDataTable,
      key: DatabaseConstants.languageKey,
      value: languageCode,
    );
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().refreshCategories();
    }
    unawaited(NotificationService.instance.handleAppLaunch());
  }
}
