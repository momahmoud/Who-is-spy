import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:salfah/core/config/economy_config.dart';

/// Handles in-app purchases (remove ads + donations).
/// Distinguishes between NEW purchases and RESTORED purchases.
class PurchaseService {
  PurchaseService() {
    _purchaseSubscription = InAppPurchase.instance.purchaseStream.listen(
      _onPurchaseUpdate,
      onError: _onPurchaseError,
    );
  }

  static const String removeAdsProductId = 'com.salfah.removeads';
  static const String donationSmallProductId = 'salfah.donation_1';
  static const String donationMediumProductId = 'salfah.donation_5';
  static const String donationLargeProductId = 'salfah.donation_10';

  static const Set<String> _baseProductIds = <String>{
    removeAdsProductId,
    donationSmallProductId,
    donationMediumProductId,
    donationLargeProductId,
  };

  final InAppPurchase _iap = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;
  final StreamController<String> _onPurchaseCompleteController =
      StreamController<String>.broadcast();
  final StreamController<String> _onPurchaseRestoredController =
      StreamController<String>.broadcast();
  final StreamController<String> _onPurchaseErrorController =
      StreamController<String>.broadcast();
  final StreamController<void> _onPurchaseStartedController =
      StreamController<void>.broadcast();
  final StreamController<bool> _onRestoreCompleteController =
      StreamController<bool>.broadcast();

  List<ProductDetails> _products = <ProductDetails>[];
  bool _initialized = false;
  bool _isRestoring = false;

  /// Stream emitted when a NEW purchase succeeds (user just bought).
  Stream<String> get onPurchaseComplete => _onPurchaseCompleteController.stream;

  /// Stream emitted when a purchase is RESTORED (from previous device).
  Stream<String> get onPurchaseRestored => _onPurchaseRestoredController.stream;

  /// Stream emitted on purchase error.
  Stream<String> get onPurchaseError => _onPurchaseErrorController.stream;

  /// Stream emitted when purchase process begins.
  Stream<void> get onPurchaseStarted => _onPurchaseStartedController.stream;

  /// Stream emitted when restore completes (true = success).
  Stream<bool> get onRestoreComplete => _onRestoreCompleteController.stream;

  /// Whether the store is available.
  bool _available = false;
  bool get isAvailable => _available;

  /// Whether restore is in progress.
  bool get isRestoring => _isRestoring;

  /// Initialize and fetch product details.
  Future<void> initialize() async {
    if (_initialized) return;
    _available = await _iap.isAvailable();
    if (!_available) return;
    final EconomyConfig econ = await EconomyConfig.load();
    final Set<String> ids = <String>{
      ..._baseProductIds,
      econ.starterPackProductId,
    };
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    if (response.notFoundIDs.isNotEmpty && kDebugMode) {
      debugPrint(
        'PurchaseService: products not found: ${response.notFoundIDs}',
      );
    }
    _products = response.productDetails;
    _initialized = true;
  }

  /// Purchase a product by id.
  Future<void> purchaseProduct(String productId) async {
    if (!_available || !_initialized) {
      _onPurchaseErrorController.add('Store not available');
      return;
    }
    final ProductDetails? product = _getProduct(productId);
    if (product == null) {
      _onPurchaseErrorController.add('Product not found');
      return;
    }
    _onPurchaseStartedController.add(null);
    final PurchaseParam param = PurchaseParam(productDetails: product);
    final bool isConsumable = productId != removeAdsProductId;
    bool success = false;
    if (isConsumable) {
      success = await _iap.buyConsumable(purchaseParam: param);
    } else {
      success = await _iap.buyNonConsumable(purchaseParam: param);
    }
    if (!success) {
      _onPurchaseErrorController.add('Could not start purchase');
    }
  }

  /// Restore previous purchases.
  Future<bool> restorePurchases() async {
    if (!_available) {
      _onRestoreCompleteController.add(false);
      return false;
    }
    _isRestoring = true;
    _onPurchaseStartedController.add(null);
    try {
      await _iap.restorePurchases();
      _onRestoreCompleteController.add(true);
      return true;
    } catch (e) {
      _onPurchaseErrorController.add(e.toString());
      _onRestoreCompleteController.add(false);
      return false;
    } finally {
      _isRestoring = false;
    }
  }

  /// Returns formatted price for product, or '...' if loading.
  String getFormattedPrice(String productId) {
    final ProductDetails? product = _getProduct(productId);
    return product?.price ?? '...';
  }

  ProductDetails? _getProduct(String productId) {
    try {
      return _products.firstWhere((ProductDetails p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        continue;
      }
      if (purchase.status == PurchaseStatus.error) {
        final String message = purchase.error?.message ?? 'Unknown error';
        if (purchase.error?.code != 'PURCHASE_CANCELLED') {
          _onPurchaseErrorController.add(message);
        }
        _onRestoreCompleteController.add(false);
        continue;
      }
      if (purchase.status == PurchaseStatus.canceled) {
        continue;
      }
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        final bool isRestored = purchase.status == PurchaseStatus.restored;
        if (isRestored) {
          _onPurchaseRestoredController.add(purchase.productID);
        } else {
          _onPurchaseCompleteController.add(purchase.productID);
        }
        _iap.completePurchase(purchase);
      }
    }
  }

  void _onPurchaseError(dynamic error) {
    _isRestoring = false;
    _onPurchaseErrorController.add(error?.toString() ?? 'Unknown error');
    _onRestoreCompleteController.add(false);
  }

  /// Call when disposing the service.
  void dispose() {
    _purchaseSubscription?.cancel();
    _onPurchaseCompleteController.close();
    _onPurchaseRestoredController.close();
    _onPurchaseErrorController.close();
    _onPurchaseStartedController.close();
    _onRestoreCompleteController.close();
  }
}
