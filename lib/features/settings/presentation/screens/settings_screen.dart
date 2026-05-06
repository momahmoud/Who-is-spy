import 'package:salfah/core/common_widgets/background_image_widget.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/settings/presentation/widgets/settings_body.dart';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const BackgroundImageWidget(),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  AppColors.primary1.withValues(alpha: 0.92),
                  AppColors.primary.withValues(alpha: 0.98),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: <Widget>[
                _buildAppBar(context),
                const Expanded(child: SettingsBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Get.back<void>(),
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary2.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.color5.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              context.localization.settings,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
