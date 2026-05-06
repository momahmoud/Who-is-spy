import 'package:salfah/config/theme/app_theme.dart';
import 'package:salfah/core/const/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

extension AppTextThemeData on AppTheme {
  static const String fontFamilyEn = 'ElMessiri';
  static const String fontFamilyAr = 'ElMessiri';

  static String get fontFamily {
    final String? languageCode = Get.locale?.languageCode;
    if (languageCode == 'ar') {
      return fontFamilyAr;
    } else if (languageCode == 'en') {
      return fontFamilyEn;
    }
    return fontFamilyAr;
  }

  TextTheme get textTheme => textThemeData();

  TextTheme textThemeData() {
    final String currentFont = fontFamily;
    const Color white = Color(0xFFFFFFFF);

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 28.sp,
        fontWeight: AppDimensions.bold,
        fontFamily: currentFont,
        color: white,
      ),
      displayMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: AppDimensions.bold,
        fontFamily: currentFont,
        color: white,
      ),
      displaySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: AppDimensions.regular,
        fontFamily: currentFont,
        color: white,
      ),
      headlineLarge: TextStyle(
        fontSize: 28.sp,
        fontWeight: AppDimensions.bold,
        fontFamily: currentFont,
        color: white,
      ),
      headlineMedium: TextStyle(
        fontSize: 16.sp,
        fontWeight: AppDimensions.regular,
        fontFamily: currentFont,
        color: white,
      ),
      headlineSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: AppDimensions.regular,
        fontFamily: currentFont,
        color: white,
      ),
      titleLarge: TextStyle(
        fontSize: 22.sp,
        fontWeight: AppDimensions.heavyBold,
        fontFamily: currentFont,
        color: white,
      ),
      titleMedium: TextStyle(
        fontSize: 18.sp,
        fontWeight: AppDimensions.semiBold,
        fontFamily: currentFont,
        color: white,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        fontWeight: AppDimensions.semiBold,
        fontFamily: currentFont,
        color: white,
      ),
      labelLarge: TextStyle(
        fontSize: 16.sp,
        fontWeight: AppDimensions.semiBold,
        fontFamily: currentFont,
        color: white,
      ),
      labelMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: AppDimensions.medium,
        fontFamily: currentFont,
        color: white,
      ),
      labelSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: AppDimensions.medium,
        fontFamily: currentFont,
        color: white,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        fontFamily: currentFont,
        fontWeight: AppDimensions.bold,
        color: white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: AppDimensions.medium,
        fontFamily: currentFont,
        color: white,
      ),
      bodySmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: AppDimensions.regular,
        fontFamily: currentFont,
        color: white,
      ),
    );
  }
}
