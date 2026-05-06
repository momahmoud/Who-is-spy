import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

extension AppColorScheme on AppTheme {
  ColorScheme get colorScheme {
    switch (this) {
      case AppTheme.light:
        return _lightColorScheme;
      case AppTheme.dark:
        return _darkColorScheme;
    }
  }

  ColorScheme get _lightColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.color1,
    onPrimary: AppColors.primaryWhite,
    secondary: AppColors.color2,
    onSecondary: AppColors.primaryWhite,
    tertiary: AppColors.color5,
    onTertiary: AppColors.primaryWhite,
    error: AppColors.color3,
    onError: AppColors.primaryWhite,
    surface: AppColors.primary1,
    onSurface: AppColors.primaryWhite,
    surfaceContainer: AppColors.primary2,
    shadow: AppColors.primaryWhite,
    outline: AppColors.color5,
  );

  ColorScheme get _darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.color1,
    onPrimary: AppColors.primaryWhite,
    secondary: AppColors.color2,
    onSecondary: AppColors.primaryWhite,
    tertiary: AppColors.color5,
    onTertiary: AppColors.primaryWhite,
    error: AppColors.color3,
    onError: AppColors.primaryWhite,
    surface: AppColors.primary1,
    onSurface: AppColors.primaryWhite,
    surfaceContainer: AppColors.primary2,
    shadow: AppColors.primaryWhite,
    outline: AppColors.color5,
  );
}
