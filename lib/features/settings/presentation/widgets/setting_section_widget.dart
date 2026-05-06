import 'package:salfah/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingSectionWidget extends StatelessWidget {
  const SettingSectionWidget({
    required this.icon,
    required this.title,
    required this.children,
    super.key,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final Color accent = iconColor ?? AppColors.color1;
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColors.primary2.withValues(alpha: 0.9),
        border: Border.all(
          color: accent.withValues(alpha: 0.22),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 12.h),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(9.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        accent.withValues(alpha: 0.3),
                        accent.withValues(alpha: 0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(icon, size: 22.sp, color: accent),
                ),
                SizedBox(width: 12.w),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
