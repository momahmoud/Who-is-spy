import 'dart:async';

import 'package:salfah/core/common_widgets/dialogs/custom_dialog_helper.dart';
import 'package:salfah/core/config/economy_config.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/features/ads/presentation/controller/coins_controller.dart';
import 'package:salfah/features/settings/presentation/widgets/remove_ads_confirmation_dialog.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/settings/services/premium_service.dart';
import 'package:salfah/features/settings/services/purchase_service.dart';
import 'package:salfah/features/settings/services/rating_service.dart';
import 'package:salfah/features/settings/services/sharing_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/theme/app_colors.dart';

class SettingsController extends GetxController {
  SettingsController(this._db);

  final BaseDatabase _db;

  late final PurchaseService _purchaseService;
  late final PremiumService _premiumService;
  late final RatingService _ratingService;
  late final SharingService _sharingService;

  StreamSubscription<String>? _purchaseSubscription;
  StreamSubscription<String>? _purchaseErrorSubscription;
  StreamSubscription<void>? _purchaseStartedSubscription;
  StreamSubscription<bool>? _restoreCompleteSubscription;
  StreamSubscription<String>? _purchaseRestoredSubscription;

  final RxBool adsRemoved = false.obs;
  final RxBool vipUnlocked = false.obs;
  final RxBool isPurchasing = false.obs;
  final RxDouble totalDonations = 0.0.obs;

  PurchaseService get purchaseService => _purchaseService;
  PremiumService get premiumService => _premiumService;
  RatingService get ratingService => _ratingService;
  SharingService get sharingService => _sharingService;

  @override
  void onInit() {
    super.onInit();
    _premiumService = PremiumService(_db);
    _purchaseService = Get.find<PurchaseService>();
    _ratingService = RatingService();
    _sharingService = SharingService();

    _purchaseSubscription = _purchaseService.onPurchaseComplete.listen(
      (String productId) => unawaited(_onPurchaseComplete(productId)),
    );
    _purchaseErrorSubscription = _purchaseService.onPurchaseError.listen(
      _onPurchaseError,
    );
    _purchaseStartedSubscription = _purchaseService.onPurchaseStarted.listen(
      _onPurchaseStarted,
    );
    _restoreCompleteSubscription = _purchaseService.onRestoreComplete.listen(
      _onRestoreComplete,
    );
    _purchaseRestoredSubscription = _purchaseService.onPurchaseRestored.listen(
      (String productId) => unawaited(_onPurchaseRestored(productId)),
    );

    unawaited(_purchaseService.initialize().then((_) => _loadPremiumStatus()));
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    _purchaseErrorSubscription?.cancel();
    _purchaseStartedSubscription?.cancel();
    _restoreCompleteSubscription?.cancel();
    _purchaseRestoredSubscription?.cancel();
    super.onClose();
  }

  Future<void> _loadPremiumStatus() async {
    adsRemoved.value = await _premiumService.areAdsRemoved();
    vipUnlocked.value = await _premiumService.isVip();
    totalDonations.value = await _premiumService.getTotalDonations();
  }

  Future<void> _onPurchaseComplete(String productId) async {
    isPurchasing.value = false;
    if (productId == PurchaseService.removeAdsProductId) {
      await _premiumService.activateVip();
      adsRemoved.value = true;
      vipUnlocked.value = true;
      if (Get.context != null && Get.context!.mounted) {
        CustomDialogHelper.showSuccessDialog(
          Get.context!,
          title: Get.context!.localization.purchaseSuccessTitle,
          message: Get.context!.localization.purchaseSuccessMessage,
          okLabel: Get.context!.localization.ok,
        );
      }
    } else {
      final EconomyConfig econ = await EconomyConfig.load();
      if (productId == econ.starterPackProductId) {
        final CoinsController coins = Get.find<CoinsController>();
        await coins.addCoins(econ.firstLaunchStarterPackCoins, reason: 'iap_starter_pack');
        if (Get.context != null && Get.context!.mounted) {
          CustomDialogHelper.showSuccessDialog(
            Get.context!,
            title: Get.context!.localization.purchaseSuccessTitle,
            message: Get.context!.localization.purchaseSuccessMessage,
            okLabel: Get.context!.localization.ok,
          );
        }
        return;
      }
      final double amount = PremiumService.getDonationAmount(productId);
      if (amount <= 0) {
        return;
      }
      await _premiumService.addDonation(productId, amount);
      totalDonations.value += amount;
      if (Get.context != null && Get.context!.mounted) {
        CustomDialogHelper.showSuccessDialog(
          Get.context!,
          title: Get.context!.localization.donationSuccessTitle,
          message: Get.context!.localization.donationSuccessMessage,
          okLabel: Get.context!.localization.ok,
        );
      }
    }
  }

  Future<void> _onPurchaseRestored(String productId) async {
    if (productId == PurchaseService.removeAdsProductId) {
      await _premiumService.activateVip();
      adsRemoved.value = true;
      vipUnlocked.value = true;
    }
  }

  void _onPurchaseError(String message) {
    isPurchasing.value = false;
    if (message.contains('CANCELLED') || message.contains('cancel')) return;
    if (Get.context != null && Get.context!.mounted) {
      CustomDialogHelper.showErrorDialog(
        Get.context!,
        title: Get.context!.localization.error,
        message: message,
        okLabel: Get.context!.localization.ok,
      );
    }
  }

  void _onPurchaseStarted(void _) {
    isPurchasing.value = true;
  }

  void _onRestoreComplete(bool success) {
    isPurchasing.value = false;
    _loadPremiumStatus();
    if (Get.context != null && Get.context!.mounted) {
      final String msg = success
          ? Get.context!.localization.restoreSuccess
          : Get.context!.localization.restoreFailed;
      Get.snackbar(
        '',
        msg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: success ? AppColors.color2 : AppColors.color3,
        colorText: Colors.white,
      );
    }
  }

  Future<void> purchaseRemoveAds() async {
    if (adsRemoved.value) return;
    if (!_purchaseService.isAvailable) {
      CustomDialogHelper.showErrorDialog(
        Get.context!,
        title: Get.context!.localization.error,
        message: Get.context!.localization.storeNotAvailable,
        okLabel: Get.context!.localization.ok,
      );
      return;
    }
    final String price = _purchaseService.getFormattedPrice(
      PurchaseService.removeAdsProductId,
    );
    final bool confirm = await RemoveAdsConfirmationDialog.show(
      Get.context!,
      price: price,
    );
    if (confirm) {
      unawaited(
        _purchaseService.purchaseProduct(PurchaseService.removeAdsProductId),
      );
    }
  }

  Future<void> restorePurchases() async {
    if (isPurchasing.value) return;
    await _purchaseService.restorePurchases();
  }

  Future<void> donate(String productId) async {
    if (!_purchaseService.isAvailable) {
      CustomDialogHelper.showErrorDialog(
        Get.context!,
        title: Get.context!.localization.error,
        message: Get.context!.localization.storeNotAvailable,
        okLabel: Get.context!.localization.ok,
      );
      return;
    }
    unawaited(_purchaseService.purchaseProduct(productId));
  }
}
