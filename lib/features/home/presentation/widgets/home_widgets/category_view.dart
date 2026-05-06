import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({
    required this.category,
    required this.onTap,
    super.key,
  });

  final CategoryModel category;
  final VoidCallback onTap;

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  bool _isPressed = false;

  static const Color _rentalBadgeGreen = Color(0xFF1DB954);

  // Subtle accent tints per-category derived from the palette
  static const List<Color> _accentTints = <Color>[
    AppColors.color1, // Electric Orange
    AppColors.color4, // Bright Blue
    AppColors.color2, // Vivid Mint
    AppColors.color5, // Lavender
    AppColors.color3, // Hot Pink
    AppColors.color1,
    AppColors.color4,
    AppColors.color2,
    AppColors.color5,
    AppColors.color3,
  ];

  Color _accentForCategory(String id) {
    final int index = id.hashCode.abs() % _accentTints.length;
    return _accentTints[index];
  }

  @override
  Widget build(BuildContext context) {
    final bool isLocked = widget.category.isLocked;
    final Color accent = _accentForCategory(widget.category.id);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: 150.ms,
        curve: Curves.easeOutCubic,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(22.r),
            splashColor: accent.withValues(alpha: 0.12),
            highlightColor: Colors.transparent,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    AppColors.primary2,
                    Color.lerp(AppColors.primary2, accent, 0.08)!,
                  ],
                ),
                border: Border.all(
                  color: isLocked
                      ? Colors.white.withValues(alpha: 0.06)
                      : accent.withValues(alpha: 0.28),
                  width: 1.5,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  if (!isLocked && !_isPressed)
                    BoxShadow(
                      color: accent.withValues(alpha: 0.18),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                      spreadRadius: -4,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    // Card layout
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Image area
                        Expanded(
                          child: _CardImageArea(
                            category: widget.category,
                            accent: accent,
                            isLocked: isLocked,
                          ),
                        ),
                        // Title strip
                        _CardTitleStrip(
                          title: widget.category.title,
                          accent: accent,
                          isLocked: isLocked,
                        ),
                      ],
                    ),

                    // Lock overlay
                    if (isLocked) const _LockedOverlay(),

                    // Rental badge
                    if (widget.category.rentalExpiryMillis != null)
                      _RentalBadge(
                        expiryMillis: widget.category.rentalExpiryMillis!,
                        badgeColor: _rentalBadgeGreen,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _CardImageArea extends StatelessWidget {
  const _CardImageArea({
    required this.category,
    required this.accent,
    required this.isLocked,
  });

  final CategoryModel category;
  final Color accent;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final String imagePath = category.image.startsWith('assets/')
        ? category.image
        : 'assets/images/${category.image}';

    Widget image;
    if (imagePath.endsWith('.svg')) {
      image = SvgPicture.asset(
        imagePath,
        fit: BoxFit.contain,
        width: 70.w,
        height: 70.h,
        colorFilter: isLocked
            ? const ColorFilter.matrix(<double>[
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0,      0,      0,      1, 0,
              ])
            : null,
      );
    } else {
      image = Image.asset(
        imagePath,
        fit: BoxFit.contain,
        width: 70.w,
        height: 70.h,
        color: isLocked ? Colors.white.withValues(alpha: 0.35) : null,
        colorBlendMode: isLocked ? BlendMode.modulate : null,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Very subtle accent top glow on unlocked cards
        if (!isLocked)
          Positioned(
            top: -30,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: <Color>[
                    accent.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                  radius: 1.0,
                ),
              ),
            ),
          ),

        // Image with float animation
        Center(
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: isLocked
                ? image
                : image
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(
                      begin: 0,
                      end: -5,
                      duration: 2200.ms,
                      curve: Curves.easeInOut,
                    ),
          ),
        ),
      ],
    );
  }
}

class _CardTitleStrip extends StatelessWidget {
  const _CardTitleStrip({
    required this.title,
    required this.accent,
    required this.isLocked,
  });

  final String title;
  final Color accent;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.18),
        border: Border(
          top: BorderSide(
            color: isLocked
                ? Colors.white.withValues(alpha: 0.06)
                : accent.withValues(alpha: 0.22),
          ),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: isLocked
              ? Colors.white.withValues(alpha: 0.45)
              : Colors.white,
          letterSpacing: 0.1,
          height: 1.2,
        ),
      ),
    );
  }
}

class _LockedOverlay extends StatelessWidget {
  const _LockedOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.52),
          borderRadius: BorderRadius.circular(22.r),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.lock_rounded,
              color: Colors.white.withValues(alpha: 0.6),
              size: 22.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _RentalBadge extends StatelessWidget {
  const _RentalBadge({
    required this.expiryMillis,
    required this.badgeColor,
  });

  final int expiryMillis;
  final Color badgeColor;

  String _badgeText() {
    final int remainingMs = expiryMillis - DateTime.now().millisecondsSinceEpoch;
    if (remainingMs <= 0) return '0m';
    final int hours = remainingMs ~/ (1000 * 60 * 60);
    final int minutes = (remainingMs % (1000 * 60 * 60)) ~/ (1000 * 60);
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 8,
      start: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.45),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.access_time_filled_rounded,
              color: Colors.white,
              size: 11.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              _badgeText(),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ).animate().scale(delay: 400.ms, curve: Curves.bounceOut),
    );
  }
}
