import 'dart:async';

import 'package:flutter/material.dart';

import 'app/barrah_alsalfah_mobile_app.dart';
import 'app_init.dart';
import 'core/utilities/app_logger.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      await AppInit().beforeAppInit();

      runApp(const BarrahAlsalfahMobileApp());
    },
    (Object error, StackTrace stack) {
      AppLogger().error('Unhandled platform error: $error\n$stack');
    },
  );
}
