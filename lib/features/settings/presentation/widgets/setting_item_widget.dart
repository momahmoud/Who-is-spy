import 'package:salfah/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Single setting row with icon, title, subtitle, optional trailing.
class SettingItemWidget extends StatelessWidget {
  const SettingItemWidget({
    required this.icon,
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.showBorder = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(showBorder ? 0 : 18.r),
          bottomRight: Radius.circular(showBorder ? 0 : 18.r),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: showBorder
                ? Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  )
                : null,
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.color1).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppColors.color1,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12.sp,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...<Widget>[
                SizedBox(width: 12.w),
                trailing!,
              ] else if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.sp,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
