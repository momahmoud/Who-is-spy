import 'package:salfah/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared card container used by all game round phase widgets.
class GameCard extends StatelessWidget {
  const GameCard({required this.child, this.accentColor, super.key});

  final Widget child;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? AppColors.color1;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 38.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            AppColors.primary2,
            Color.lerp(AppColors.primary2, accent, 0.4)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: accent.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.45),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class GameCardText extends StatelessWidget {
  const GameCardText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        height: 1.3,
      ),
    );
  }
}

class GameCardSubText extends StatelessWidget {
  const GameCardSubText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.88),
        height: 1.4,
      ),
    );
  }
}
