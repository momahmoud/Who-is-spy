import 'package:salfah/config/navigation/route_names.dart';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/assets/app_images.dart';
import 'package:salfah/core/common_widgets/animated_play_button.dart';
import 'package:salfah/core/common_widgets/background_image_widget.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/intro/presentation/dialogs/about_app_alert_dialog.dart';
import 'package:salfah/features/settings/presentation/widgets/how_to_play_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IntroBody extends StatefulWidget {
  const IntroBody({super.key});

  @override
  State<IntroBody> createState() => _IntroBodyState();
}

class _IntroBodyState extends State<IntroBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const BackgroundImageWidget(),
        // Deep indigo gradient overlay
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.primary.withValues(alpha: 0.88),
                AppColors.primary1.withValues(alpha: 0.95),
                AppColors.primary,
              ],
              stops: const <double>[0, 0.45, 1],
            ),
          ),
        ),
        SafeArea(
          child: Stack(
            children: <Widget>[
              // Settings Icon - Top Left
              Positioned(
                top: 16,
                left: 16,
                child: _NavIconButton(
                  icon: Icons.settings_rounded,
                  onTap: () => Get.toNamed<void>(RouteNames.settings),
                ),
              ),

              // About / info — top right
              Positioned(
                top: 16,
                right: 16,
                child: _NavIconButton(
                  icon: Icons.info_outline_rounded,
                  onTap: () => _showAboutDialog(context),
                ),
              ),

              // Main Content - Centered
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildLogoSection(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.08,
                      ),
                      AnimatedPlayButton(
                        onTap: () => Get.offAllNamed<void>(RouteNames.home),
                      ),
                      SizedBox(height: 12.h),
                      TextButton(
                        onPressed: () => _showHowToPlayDialog(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white.withValues(alpha: 0.92),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                        ),
                        child: Text(
                          context.localization.howToPlayTitle,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                Colors.white.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (BuildContext context, Widget? child) {
        return Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Multi-layer glow (orange + mint)
                Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.color1.withValues(
                          alpha: _glowAnimation.value * 0.35,
                        ),
                        blurRadius: 70,
                        spreadRadius: 12,
                      ),
                      BoxShadow(
                        color: AppColors.color2.withValues(
                          alpha: _glowAnimation.value * 0.22,
                        ),
                        blurRadius: 100,
                        spreadRadius: 24,
                      ),
                      BoxShadow(
                        color: AppColors.color5.withValues(
                          alpha: _glowAnimation.value * 0.15,
                        ),
                        blurRadius: 130,
                        spreadRadius: 36,
                      ),
                    ],
                  ),
                ),
                // Logo
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.color1.withValues(alpha: 0.4),
                      width: 3,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage(AppImages.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => const AboutAppAlertDialog(),
      transitionBuilder: (
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
      transitionBuilder: (
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
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: AppColors.primary2.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.color5.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
