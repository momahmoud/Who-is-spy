import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salfah/config/theme/app_colors.dart';

/// Button for custom dialog actions.
class CustomDialogAction extends StatelessWidget {
  const CustomDialogAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 13.h),
            decoration: BoxDecoration(
              gradient: isPrimary
                  ? const LinearGradient(
                      colors: <Color>[AppColors.color1, AppColors.color3],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isPrimary ? null : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
              border: isPrimary
                  ? null
                  : Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
              boxShadow: isPrimary
                  ? <BoxShadow>[
                      BoxShadow(
                        color: AppColors.color1.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.primaryWhite,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
