import 'dart:developer';
import 'dart:io';

import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _singleton = AppLogger._internal();
  late Logger _logger;

  factory AppLogger() {
    return _singleton;
  }

  AppLogger._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }

  void info(String message) {
    if (Platform.isAndroid) {
      _logger.i(message);
    } else {
      log('✅ $message');
    }
  }

  void warning(String message) {
    if (Platform.isAndroid) {
      _logger.w(message);
    } else {
      log('⚠️ $message');
    }
  }

  void error(String message) {
    if (Platform.isAndroid) {
      _logger.e(message);
    } else {
      log(' ❌ $message');
    }
  }
}
