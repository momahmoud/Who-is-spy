import 'package:salfah/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AnimatedSubmitButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const AnimatedSubmitButton({
    required this.text,
    required this.onTap,
    super.key,
  });

  @override
  State<AnimatedSubmitButton> createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<AnimatedSubmitButton> {
  double _scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[AppColors.color1, AppColors.color3],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.color1.withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.color3.withValues(alpha: 0.2),
                blurRadius: 28,
                offset: const Offset(0, 14),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
