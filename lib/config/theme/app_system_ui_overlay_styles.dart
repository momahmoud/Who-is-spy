import 'package:flutter/services.dart';

class AppSystemUiOverlayStyles {
  static const SystemUiOverlayStyle lightStatusBarIconsStyle = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static const SystemUiOverlayStyle darkStatusBarIconsStyle = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
