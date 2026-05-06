import 'package:salfah/core/extensions/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable action button for round finish and end-of-round views.
class RoundFinishActionButton extends StatelessWidget {
  const RoundFinishActionButton({
    required this.text,
    required this.onTap,
    required this.textColor,
    this.color,
    this.gradient,
    this.borderColor,
    this.icon,
    this.isPrimary = false,
    super.key,
  });

  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;
  final Color textColor;
  final Color? borderColor;
  final IconData? icon;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: color,
          gradient: gradient,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color:
                borderColor ??
                Colors.white.withValueOpacity(isPrimary ? 0.3 : 0.0),
            width: 2,
          ),
          boxShadow: isPrimary
              ? <BoxShadow>[
                  BoxShadow(
                    color: (gradient?.colors.first ?? Colors.black)
                        .withValueOpacity(0.6),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withValueOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(icon, color: textColor, size: 24.sp),
              SizedBox(width: 8.w),
            ],
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  shadows: isPrimary
                      ? <Shadow>[
                          Shadow(
                            color: Colors.black.withValueOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
