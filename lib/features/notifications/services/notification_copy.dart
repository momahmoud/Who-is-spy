import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/const/database_constants.dart';
import 'package:salfah/core/di/di.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/core/localization/generated/l10n.dart';
import 'package:salfah/features/notifications/services/notification_service.dart';

/// Resolves localized notification titles, bodies, and channel labels.
abstract final class NotificationCopy {
  static Future<AppLocalization> _load() async {
    String languageCode = Get.locale?.languageCode ?? AppStrings.arabicLang;
    if (languageCode != AppStrings.englishLang &&
        languageCode != AppStrings.arabicLang) {
      languageCode = AppStrings.arabicLang;
    }

    if (Get.locale == null) {
      try {
        final String? saved = di<BaseDatabase>().get<String>(
          tableName: DatabaseConstants.userDataTable,
          key: DatabaseConstants.languageKey,
        );
        if (saved == AppStrings.englishLang ||
            saved == AppStrings.arabicLang) {
          languageCode = saved!;
        }
      } catch (_) {
        // DI not ready; keep fallback.
      }
    }

    return AppLocalization.load(Locale(languageCode));
  }

  static Future<String> channelName() async {
    final AppLocalization l = await _load();
    return l.notificationChannelName;
  }

  static Future<String> channelDescription() async {
    final AppLocalization l = await _load();
    return l.notificationChannelDescription;
  }

  static Future<String> titleFor(NotificationType type) async {
    final AppLocalization l = await _load();
    switch (type) {
      case NotificationType.dailyReminder:
        return l.notificationDailyTitle;
      case NotificationType.funSocial:
        return l.notificationFunSocialTitle;
      case NotificationType.comebackEmotional:
        return l.notificationComebackTitle;
      case NotificationType.challengeMessage:
        return l.notificationChallengeTitle;
    }
  }

  static Future<List<String>> bodiesFor(NotificationType type) async {
    final AppLocalization l = await _load();
    switch (type) {
      case NotificationType.dailyReminder:
        return <String>[l.notificationDailyBody1, l.notificationDailyBody2];
      case NotificationType.funSocial:
        return <String>[
          l.notificationFunSocialBody1,
          l.notificationFunSocialBody2,
        ];
      case NotificationType.comebackEmotional:
        return <String>[
          l.notificationComebackBody1,
          l.notificationComebackBody2,
        ];
      case NotificationType.challengeMessage:
        return <String>[
          l.notificationChallengeBody1,
          l.notificationChallengeBody2,
        ];
    }
  }
}
