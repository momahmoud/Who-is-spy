import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salfah/config/theme/app_colors.dart';

/// Base custom dialog with icon, title, content, and actions.
class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.actions = const <Widget>[],
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final Widget content;
  final List<Widget> actions;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[AppColors.primary1, AppColors.primary2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            padding: EdgeInsets.all(28.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.color2)
                        .withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40.sp,
                    color: iconColor ?? AppColors.color2,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryWhite,
                  ),
                ),
                SizedBox(height: 14.h),
                content,
                if (actions.isNotEmpty) ...<Widget>[
                  SizedBox(height: 26.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: actions,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
