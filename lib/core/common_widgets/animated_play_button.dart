import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedPlayButton extends StatelessWidget {
  const AnimatedPlayButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[AppColors.color1, AppColors.color3],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.color1.withValues(alpha: 0.55),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: AppColors.color3.withValues(alpha: 0.25),
              blurRadius: 40,
              offset: const Offset(0, 16),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          context.localization.startPlaying,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
