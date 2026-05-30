import 'dart:io';

import 'package:flutter/services.dart';

/// Opens OS screens needed for reliable scheduled notifications.
abstract final class NotificationSettingsPlatform {
  static const MethodChannel _channel = MethodChannel(
    'com.fluxy.salfah/notification_settings',
  );

  static Future<void> openAppNotificationSettings() async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod<void>('openAppNotificationSettings');
    } else if (Platform.isIOS) {
      await _channel.invokeMethod<void>('openAppSettings');
    }
  }

  static Future<void> openBatteryOptimizationSettings() async {
    if (!Platform.isAndroid) {
      return;
    }
    await _channel.invokeMethod<void>('openBatteryOptimizationSettings');
  }

}
