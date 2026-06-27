import 'dart:async';

import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/assets/app_images.dart';
import 'package:salfah/core/common_widgets/dialogs/custom_dialog_helper.dart';
import 'package:salfah/core/di/index.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/settings/presentation/widgets/remove_ads_confirmation_dialog.dart';
import 'package:salfah/features/settings/services/premium_service.dart';
import 'package:salfah/features/settings/services/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemoveAdsBarButton extends StatefulWidget {
  const RemoveAdsBarButton({super.key});

  @override
  State<RemoveAdsBarButton> createState() => _RemoveAdsBarButtonState();
}

class _RemoveAdsBarButtonState extends State<RemoveAdsBarButton> {
  late final PremiumService _premiumService;
  StreamSubscription<String>? _purchaseSub;
  StreamSubscription<String>? _restoredSub;
  bool _adsRemoved = false;

  @override
  void initState() {
    super.initState();
    _premiumService = PremiumService(di<BaseDatabase>());
    unawaited(_loadStatus());
    if (Get.isRegistered<PurchaseService>()) {
      final PurchaseService purchase = Get.find<PurchaseService>();
      _purchaseSub = purchase.onPurchaseComplete.listen(_onPurchaseUpdate);
      _restoredSub = purchase.onPurchaseRestored.listen(_onPurchaseUpdate);
    }
  }

  Future<void> _onPurchaseUpdate(String productId) async {
    if (productId == PurchaseService.removeAdsProductId) {
      await _loadStatus();
    }
  }

  Future<void> _loadStatus() async {
    final bool removed = await _premiumService.areAdsRemoved();
    if (mounted) {
      setState(() => _adsRemoved = removed);
    }
  }

  @override
  void dispose() {
    _purchaseSub?.cancel();
    _restoredSub?.cancel();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (_adsRemoved) return;

    final PurchaseService purchase = Get.find<PurchaseService>();
    if (!purchase.isAvailable) {
      CustomDialogHelper.showErrorDialog(
        context,
        title: context.localization.error,
        message: context.localization.storeNotAvailable,
        okLabel: context.localization.ok,
      );
      return;
    }

    final String price = purchase.getFormattedPrice(
      PurchaseService.removeAdsProductId,
    );
    final bool confirm = await RemoveAdsConfirmationDialog.show(
      context,
      price: price,
    );
    if (confirm) {
      unawaited(purchase.purchaseProduct(PurchaseService.removeAdsProductId));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_adsRemoved) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              AppImages.noAds,
              width: 36.w,
              height: 36.h,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
