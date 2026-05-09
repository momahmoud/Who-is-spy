import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/const/const_strings.dart';
import 'package:salfah/core/extensions/color_extension.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Get.locale?.languageCode == AppStrings.arabicLang;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 340.w,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.82,
            ),
            padding: EdgeInsets.all(22.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  AppColors.primary2,
                  AppColors.primary2.withValueOpacity(0.88),
                ],
              ),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(
                width: 2,
                color: Colors.white.withValueOpacity(0.45),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValueOpacity(0.32),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 38.sp,
                ),
                SizedBox(height: 12.h),
                Text(
                  context.localization.howToPlayTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Divider(color: Colors.white24, height: 28.h),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      context.localization.howToPlayBody,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white.withValueOpacity(0.88),
                        fontSize: 14.5.sp,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.color2,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      context.localization.understood,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
