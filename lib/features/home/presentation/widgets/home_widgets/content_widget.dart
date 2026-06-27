import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/core/widgets/try_our_games_sheet.dart';
import 'package:salfah/features/home/data/models/category_model.dart';
import 'package:salfah/features/home/presentation/controller/home_controller.dart';
import 'package:salfah/features/home/presentation/widgets/home_widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        // Screen header
        SliverToBoxAdapter(child: _CategoriesHeader()),

        // Categories grid
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
          sliver: SliverToBoxAdapter(
            child: GetBuilder<HomeController>(
              builder: (HomeController controller) {
                if (controller.isLoading) {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: 6,
                    itemBuilder: (_, _) => const CategorySkeleton(),
                  );
                }

                final List<CategoryModel> unlocked = controller.categories
                    .where((CategoryModel c) => !c.isLocked)
                    .toList();
                final List<CategoryModel> locked = controller.categories
                    .where((CategoryModel c) => c.isLocked)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _CategoryGrid(
                      categories: unlocked,
                      controller: controller,
                      startIndex: 0,
                      includeTryOurGamesTile: true,
                    ),
                    if (locked.isNotEmpty) ...<Widget>[
                      SizedBox(height: 32.h),
                      _SectionDivider(
                        label: context.localization.moreCategories,
                      ),
                      SizedBox(height: 16.h),
                      _CategoryGrid(
                        categories: locked,
                        controller: controller,
                        startIndex: unlocked.length + 1,
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoriesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Accent pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.color1.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.color1.withValues(alpha: 0.35),
              ),
            ),
            child: Text(
              context.localization.chooseStoryTypeSubtitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.color1,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.transparent,
                  AppColors.color5.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.lock_rounded,
                size: 14.sp,
                color: AppColors.color5.withValues(alpha: 0.7),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color5.withValues(alpha: 0.85),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  AppColors.color5.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.controller,
    required this.startIndex,
    this.includeTryOurGamesTile = false,
  });

  final List<CategoryModel> categories;
  final HomeController controller;
  final int startIndex;
  final bool includeTryOurGamesTile;

  @override
  Widget build(BuildContext context) {
    final int promoCount = includeTryOurGamesTile ? 1 : 0;

    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
          childAspectRatio: 0.82,
        ),
        itemCount: categories.length + promoCount,
        itemBuilder: (BuildContext context, int index) {
          if (includeTryOurGamesTile && index == categories.length) {
            return AnimationConfiguration.staggeredGrid(
              position: startIndex + index,
              duration: const Duration(milliseconds: 450),
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.85,
                curve: Curves.easeOutBack,
                child: FadeInAnimation(
                  child: TryOurGamesGridTile(
                    borderRadius: 22.r,
                  ),
                ),
              ),
            );
          }

          final CategoryModel category = categories[index];
          return AnimationConfiguration.staggeredGrid(
            position: startIndex + index,
            duration: const Duration(milliseconds: 450),
            columnCount: 2,
            child: ScaleAnimation(
              scale: 0.85,
              curve: Curves.easeOutBack,
              child: FadeInAnimation(
                child: CategoryView(
                  category: category,
                  onTap: () {
                    if (category.isLocked) {
                      controller.showUnlockDialog(category);
                    } else {
                      controller.onCategoryPressed(category.id);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
