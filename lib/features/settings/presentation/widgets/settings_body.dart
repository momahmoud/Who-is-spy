import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/intro/presentation/dialogs/about_app_alert_dialog.dart';
import 'package:salfah/features/settings/presentation/controller/settings_controller.dart';
import 'package:salfah/features/settings/presentation/widgets/donation_options_dialog.dart';
import 'package:salfah/features/settings/presentation/widgets/how_to_play_dialog.dart';
import 'package:salfah/features/settings/presentation/widgets/setting_item_widget.dart';
import 'package:salfah/features/settings/presentation/widgets/setting_section_widget.dart';
import 'package:salfah/features/settings/services/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'language_selector_dialog.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final SettingsController ctrl = Get.find<SettingsController>();
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 8.h, bottom: 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAppInfoCard(context),
            _buildGeneralSection(context),
            _buildPremiumSection(context, ctrl),
            _buildSupportSection(context, ctrl),
            _buildContactSection(context, ctrl),
          ],
        ),
      );
    });
  }

  Widget _buildAppInfoCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primary2, AppColors.primary1],
        ),
        border: Border.all(
          color: AppColors.color1.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.color1.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[AppColors.color1, AppColors.color3],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.color1.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.sports_esports_rounded,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.localization.gameTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: AppColors.color2,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
    final String currentLang = Get.locale?.languageCode == 'ar'
        ? 'العربية'
        : 'English';
    return SettingSectionWidget(
      icon: Icons.tune_rounded,
      title: context.localization.general,
      iconColor: AppColors.color2,
      children: <Widget>[
        SettingItemWidget(
          icon: Icons.language_rounded,
          title: context.localization.language,
          subtitle: context.localization.languageDescription,
          iconColor: AppColors.color2,
          trailing: Text(
            currentLang,
            style: TextStyle(
              color: AppColors.color2,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          onTap: () => LanguageSelectorDialog.show(context),
        ),
        SettingItemWidget(
          icon: Icons.info_outline_rounded,
          title: context.localization.aboutTheGame,
          subtitle: context.localization.tapToRead,
          iconColor: AppColors.color1,
          onTap: () => _showAboutDialog(context),
        ),
        SettingItemWidget(
          icon: Icons.menu_book_rounded,
          title: context.localization.howToPlayTitle,
          subtitle: context.localization.tapToRead,
          iconColor: AppColors.color4,
          onTap: () => _showHowToPlayDialog(context),
          showBorder: false,
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => const AboutAppAlertDialog(),
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> anim1,
            Animation<double> anim2,
            Widget child,
          ) {
            return Transform.scale(
              scale: Curves.easeInOutBack.transform(anim1.value),
              child: FadeTransition(opacity: anim1, child: child),
            );
          },
    );
  }

  void _showHowToPlayDialog(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => const HowToPlayDialog(),
      transitionBuilder:
          (
            BuildContext context,
            Animation<double> anim1,
            Animation<double> anim2,
            Widget child,
          ) {
            return Transform.scale(
              scale: Curves.easeInOutBack.transform(anim1.value),
              child: FadeTransition(opacity: anim1, child: child),
            );
          },
    );
  }

  Widget _buildPremiumSection(BuildContext context, SettingsController ctrl) {
    return SettingSectionWidget(
      icon: Icons.star_rounded,
      title: context.localization.premium,
      iconColor: AppColors.color1,
      children: <Widget>[
        SettingItemWidget(
          icon: ctrl.adsRemoved.value
              ? Icons.check_circle_rounded
              : Icons.visibility_off_rounded,
          title: context.localization.removeAds,
          subtitle: ctrl.vipUnlocked.value
              ? '${context.localization.removeAdsDescription}'
                  '${context.localization.monetizationVipBadgeSuffix}'
              : context.localization.removeAdsDescription,
          iconColor: ctrl.adsRemoved.value
              ? AppColors.color2
              : AppColors.color3,
          onTap: ctrl.adsRemoved.value ? null : () => ctrl.purchaseRemoveAds(),
          trailing: ctrl.adsRemoved.value
              ? _buildBadge(
                  context,
                  context.localization.activated,
                  AppColors.color2,
                )
              : _buildPriceBadge(
                  context,
                  ctrl.purchaseService.getFormattedPrice(
                    PurchaseService.removeAdsProductId,
                  ),
                ),
        ),
        SettingItemWidget(
          icon: Icons.restore_rounded,
          title: context.localization.restorePurchases,
          subtitle: context.localization.restorePurchasesDescription,
          iconColor: AppColors.color1,
          onTap: () => ctrl.restorePurchases(),
          showBorder: false,
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context, SettingsController ctrl) {
    return SettingSectionWidget(
      icon: Icons.favorite_rounded,
      title: context.localization.support,
      iconColor: AppColors.color3,
      children: <Widget>[
        SettingItemWidget(
          icon: FontAwesomeIcons.heart,
          title: context.localization.donateToDeveloper,
          subtitle: context.localization.donateDeveloperSubtitle,
          iconColor: AppColors.color3,
          onTap: () {
            Get.dialog<void>(
              DonationOptionsDialog(
                getFormattedPrice: ctrl.purchaseService.getFormattedPrice,
                isPurchasing: false,
                onSelectTier: (String productId) {
                  Get.back<void>();
                  ctrl.donate(productId);
                },
              ),
            );
          },
          trailing: ctrl.totalDonations.value > 0
              ? Text(
                  ctrl.totalDonations.value.toStringAsFixed(1),
                  style: TextStyle(
                    color: AppColors.color2,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
        SettingItemWidget(
          icon: Icons.star_rounded,
          title: context.localization.rateApp,
          iconColor: AppColors.color1,
          onTap: () => ctrl.ratingService.openStoreDirectly(),
        ),
        SettingItemWidget(
          icon: Icons.share_rounded,
          title: context.localization.shareApp,
          iconColor: AppColors.color2,
          onTap: () => ctrl.sharingService.shareApp(context: context),
          showBorder: false,
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context, SettingsController ctrl) {
    return SettingSectionWidget(
      icon: Icons.contact_mail_rounded,
      title: context.localization.contact,
      iconColor: AppColors.color4,
      children: <Widget>[
        SettingItemWidget(
          icon: Icons.email_rounded,
          title: context.localization.email,
          subtitle: 'support@fluxy.com',
          iconColor: AppColors.color4,
          onTap: () => _launchEmail('support@fluxy.com'),
        ),
        SettingItemWidget(
          icon: Icons.language_rounded,
          title: context.localization.website,
          subtitle: 'https://fluxy.com',
          iconColor: AppColors.color2,
          onTap: () => launchUrl(Uri.parse('https://fluxy.com')),
          showBorder: false,
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPriceBadge(BuildContext context, String price) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.color1, AppColors.color3],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.color1.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        price,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
