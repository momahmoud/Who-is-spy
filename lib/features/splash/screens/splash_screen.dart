import 'dart:async';
import 'package:salfah/config/navigation/route_names.dart';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _revealRadiusAnimation;

  late Animation<double> _textOpacity;
  late Animation<double> _textLetterSpacing;
  late Animation<double> _textScale;

  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.4, curve: Curves.easeIn),
      ),
    );

    _textLetterSpacing = Tween<double>(begin: 2, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _textScale = Tween<double>(begin: 1.2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.elasticOut),
      ),
    );

    _revealRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.8, curve: Curves.easeInOutQuart),
      ),
    );

    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.6, 0.9, curve: Curves.easeOutQuint),
          ),
        );
    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.9, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3500), () {
      Get.offAllNamed<void>(RouteNames.intro);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double maxRadius = size.width * 2.0;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return ClipPath(
            clipper: CircleRevealClipper(
              revealPercent: _revealRadiusAnimation.value,
              maxRadius: maxRadius,
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColors.primary,
                    AppColors.primary1,
                    AppColors.primary2,
                  ],
                  stops: <double>[0.0, 0.5, 1.0],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Opacity(
                    opacity: _textOpacity.value,
                    child: Transform.scale(
                      scale: _textScale.value,
                      child: Text(
                        context.localization.gameTitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayLarge?.copyWith(
                          letterSpacing: _textLetterSpacing.value,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _subtitleSlide,
                    child: FadeTransition(
                      opacity: _subtitleOpacity,
                      child: Text(
                        "Who's the Spy?",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium?.copyWith(
                          letterSpacing: _textLetterSpacing.value,
                          color: AppColors.color2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Keep your existing CircleRevealClipper here...
class CircleRevealClipper extends CustomClipper<Path> {
  final double revealPercent;
  final double maxRadius;

  CircleRevealClipper({required this.revealPercent, required this.maxRadius});

  @override
  Path getClip(Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    return Path()..addOval(
      Rect.fromCircle(center: center, radius: maxRadius * revealPercent),
    );
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) =>
      oldClipper.revealPercent != revealPercent;
}
