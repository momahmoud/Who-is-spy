import 'package:salfah/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedCircularProgressIndicator extends StatefulWidget {
  const AnimatedCircularProgressIndicator({super.key});

  @override
  State<AnimatedCircularProgressIndicator> createState() =>
      _AnimatedCircularProgressIndicatorState();
}

class _AnimatedCircularProgressIndicatorState
    extends State<AnimatedCircularProgressIndicator>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _colorAnimation = ColorTween(
      begin: AppColors.color2,
      end: AppColors.color4,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: _colorAnimation,
        ),
      ),
    );
  }
}
