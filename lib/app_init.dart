import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/di/di.dart';
import 'core/infrastructure/local_data_base/base_local_data_base.dart';
import 'features/ads/presentation/controller/coins_controller.dart';
import 'features/ads/services/ads_service.dart';
import 'features/monetization/services/monetization_service.dart';
import 'features/settings/services/premium_service.dart';
import 'features/settings/services/purchase_service.dart';
import 'features/notifications/services/notification_service.dart';
import 'features/rating/services/rating_prompt_service.dart';

class AppInit {
  static final AppInit _instance = AppInit._internal();

  factory AppInit() => _instance;

  AppInit._internal();

  Future<void> beforeAppInit() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // .env missing – AdConfig will use test ID fallbacks
    }

    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    await MobileAds.instance.initialize();
    await NotificationService.instance.initNotifications();

    configureDependencies();

    await RatingPromptService.instance.recordColdStartSession();

    await ScreenUtil.ensureScreenSize();

    await di<BaseDatabase>().init();

    await MonetizationService.recordColdOpen();
    await PremiumService(di<BaseDatabase>()).syncPremiumTierWithLegacyPurchases();

    Get.put<PurchaseService>(PurchaseService(), permanent: true);
    await Get.find<PurchaseService>().initialize();

    Get.put<CoinsController>(
      CoinsController(di<BaseDatabase>()),
      permanent: true,
    );

    Get.put<AdsService>(AdsService(di<BaseDatabase>()), permanent: true);
  }
}
