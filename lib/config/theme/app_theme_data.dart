import 'package:salfah/config/theme/app_color_scheme.dart';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/config/theme/app_text_theme_data.dart';
import 'package:salfah/config/theme/app_theme.dart';
import 'package:salfah/core/extensions/color_extension.dart';
import 'package:flutter/material.dart';

extension AppThemeData on AppTheme {
  ThemeData themeData() {
    return ThemeData(
      primaryColorLight: colorScheme.primary,
      fontFamily: AppTextThemeData.fontFamily,
      colorScheme: colorScheme,
      textTheme: textThemeData(),
      scaffoldBackgroundColor: AppColors.primary,
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: colorScheme.secondary,
        selectionColor: colorScheme.secondary,
        cursorColor: colorScheme.primary,
      ),
    );
  }
}

extension AppDarkThemeData on AppTheme {
  ThemeData darkThemeData() {
    return ThemeData(
      primaryColorLight: colorScheme.primary,
      fontFamily: AppTextThemeData.fontFamily,
      colorScheme: colorScheme,
      textTheme: textThemeData(),
      scaffoldBackgroundColor: AppColors.primary,
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: colorScheme.secondary,
        selectionColor: AppColors.primaryWhite.withValueOpacity(0.5),
        cursorColor: colorScheme.primary,
      ),
    );
  }
}
