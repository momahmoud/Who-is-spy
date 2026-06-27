import 'package:salfah/config/navigation/route_names.dart';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/common_widgets/background_image_widget.dart';
import 'package:salfah/features/home/presentation/widgets/home_widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:salfah/features/ads/presentation/widgets/banner_ad_widget.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const BackgroundImageWidget(),
        // Deep gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.primary.withValues(alpha: 0.94),
                AppColors.primary1.withValues(alpha: 0.97),
              ],
            ),
          ),
        ),

        SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              _HomeTopBar(),
              const Expanded(child: ContentWidget()),
              const BannerAdWidget(),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.color5.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Settings button
          _TopBarIconButton(
            icon: Icons.settings_rounded,
            onTap: () => Get.toNamed<void>(RouteNames.settings),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const RemoveAdsBarButton(),
              SizedBox(width: 8.w),
              const CoinsCounterWidget(),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.primary2.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.color5.withValues(alpha: 0.25)),
          ),
          child: Icon(icon, color: Colors.white, size: 22.sp),
        ),
      ),
    );
  }
}
