import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the App Store or Play Store for rating.
class RatingService {
  RatingService({String? iosAppId, String? androidPackageName})
    : _iosAppId = iosAppId ?? '6758549313',
      _androidPackageName = androidPackageName ?? 'com.fluxy.salfah';

  final String _iosAppId;
  final String _androidPackageName;

  /// Opens the store rating page directly.
  Future<void> openStoreDirectly() async {
    final Uri url = Platform.isIOS
        ? Uri.parse(
            'https://apps.apple.com/app/id$_iosAppId?action=write-review',
          )
        : Uri.parse(
            'https://play.google.com/store/apps/details?id=$_androidPackageName',
          );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else if (kDebugMode) {
      debugPrint('RatingService: Could not launch $url');
    }
  }
}
