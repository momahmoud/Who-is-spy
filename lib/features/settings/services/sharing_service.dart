import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Share the app with optional iPad popover positioning.
class SharingService {
  SharingService({
    this.appName = 'برا السالفة',
    this.iosAppId = '6758549313',
    this.androidPackageName = 'com.fluxy.salfah',
  });

  final String appName;
  final String? iosAppId;
  final String androidPackageName;

  String get _storeUrl {
    if (Platform.isIOS && iosAppId != null) {
      return 'https://apps.apple.com/app/id$iosAppId';
    }
    return 'https://play.google.com/store/apps/details?id=$androidPackageName';
  }

  String get _shareText => 'جرب تطبيق $appName!\n$_storeUrl';

  /// Share the app. [sharePositionOrigin] is for iPad popover.
  Future<void> shareApp({
    required BuildContext context,
    Rect? sharePositionOrigin,
  }) async {
    await Share.share(_shareText, sharePositionOrigin: sharePositionOrigin);
  }
}
