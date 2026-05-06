import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/features/players/presentation/controller/players_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayersList extends StatelessWidget {
  const PlayersList({required this.controller, super.key});

  final PlayersController controller;

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      itemCount: controller.players.length,
      itemBuilder: (BuildContext context, int index) {
        final MapEntry<int, String> playerEntry =
            controller.players.entries.elementAt(index);

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 80)),
          tween: Tween<double>(begin: 0, end: 1),
          curve: Curves.easeOutBack,
          builder: (BuildContext context, double value, Widget? child) {
            return Transform.scale(
              scale: value,
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 72.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  AppColors.primary2.withValues(alpha: 0.95),
                  AppColors.primary1.withValues(alpha: 0.9),
                ],
                begin: isRTL ? Alignment.topRight : Alignment.topLeft,
                end: isRTL ? Alignment.bottomLeft : Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.color5.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.color1.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: <Widget>[
                // Player number badge
                Positioned(
                  left: isRTL ? null : 0,
                  right: isRTL ? 0 : null,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 60.w,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[AppColors.color1, AppColors.color3],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: isRTL
                          ? BorderRadius.only(
                              topRight: Radius.circular(18.r),
                              bottomRight: Radius.circular(18.r),
                            )
                          : BorderRadius.only(
                              topLeft: Radius.circular(18.r),
                              bottomLeft: Radius.circular(18.r),
                            ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.color1.withValues(alpha: 0.45),
                          blurRadius: 10,
                          offset: Offset(isRTL ? 2 : -2, 0),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '#${playerEntry.key}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          shadows: const <Shadow>[
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Player name
                Positioned(
                  left: isRTL ? 100.w : 70.w,
                  right: isRTL ? 70.w : 100.w,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      playerEntry.value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        shadows: const <Shadow>[
                          Shadow(
                            color: Colors.black38,
                            offset: Offset(0, 1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                // Action buttons
                Positioned(
                  right: isRTL ? null : 10.w,
                  left: isRTL ? 10.w : null,
                  top: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.ltr,
                    children: <Widget>[
                      _ActionButtonWidget(
                        icon: Icons.edit_rounded,
                        color: AppColors.color4,
                        onPressed: () => controller.showEditDialog(
                          playerEntry.key,
                          playerEntry.value,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      _ActionButtonWidget(
                        icon: Icons.delete_rounded,
                        color: AppColors.color3,
                        onPressed: () =>
                            controller.removePlayer(playerEntry.key),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButtonWidget extends StatelessWidget {
  const _ActionButtonWidget({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 18.w),
        ),
      ),
    );
  }
}
