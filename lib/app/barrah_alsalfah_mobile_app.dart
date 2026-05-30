import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../config/navigation/app_router.dart';
import '../config/navigation/route_names.dart';
import '../config/theme/app_theme.dart';
import '../config/theme/app_theme_data.dart';
import '../core/const/const_strings.dart';
import '../core/localization/generated/l10n.dart';
import '../core/localization/localization_helper.dart';
import '../features/monetization/services/monetization_analytics_service.dart';
import '../features/notifications/services/notification_service.dart';
import '../features/settings/prestation/controller/setting_controller.dart';

class BarrahAlsalfahMobileApp extends StatefulWidget {
  const BarrahAlsalfahMobileApp({super.key});

  @override
  State<BarrahAlsalfahMobileApp> createState() =>
      _BarrahAlsalfahMobileAppState();
}

class _BarrahAlsalfahMobileAppState extends State<BarrahAlsalfahMobileApp>
    with WidgetsBindingObserver {
  DateTime? _foregroundStarted;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    _foregroundStarted = DateTime.now();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        NotificationService.instance
            .ensurePermissionsAndScheduleEngagementNotifications(),
      );
    });
  }

  final LocalizationController localizationController = Get.put(
    LocalizationController(),
  );

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        _foregroundStarted = DateTime.now();
        unawaited(NotificationService.instance.handleAppLaunch());
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        final DateTime? start = _foregroundStarted;
        if (start != null) {
          final int secs = DateTime.now().difference(start).inSeconds;
          if (secs > 0) {
            MonetizationAnalyticsService.sessionTick(
              foregroundSecondsApprox: secs,
            );
          }
          _foregroundStarted = null;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, Widget? child) => GetMaterialApp(
        navigatorKey: Get.key,
        debugShowCheckedModeBanner: false,
        title: AppStrings.applicationName,
        theme: AppTheme.light.themeData(),
        darkTheme: AppTheme.dark.darkThemeData(),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppLocalization.delegate,
        ],
        supportedLocales: LocalizationHelper.supportedLocales,
        locale: localizationController.currentLocale,
        fallbackLocale: const Locale(AppStrings.arabicLang),

        getPages: appRouter,
        initialRoute: RouteNames.splash,
      ),
    );
  }
}
