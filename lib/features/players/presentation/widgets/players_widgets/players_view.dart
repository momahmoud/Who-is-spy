import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/players/presentation/controller/players_controller.dart';
import 'package:salfah/features/players/presentation/widgets/players_widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlayersView extends StatelessWidget {
  const PlayersView({required this.controller, super.key});

  final PlayersController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _PlayersTopBar(),
          _PlayersHeader(context),
          Expanded(child: PlayersList(controller: controller)),
        ],
      ),
    );
  }
}

class _PlayersTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: Get.back,
              borderRadius: BorderRadius.circular(14.r),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary2.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.color5.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayersHeader extends StatelessWidget {
  const _PlayersHeader(this.context);

  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            context.localization.youCanAddMorePlayers,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
