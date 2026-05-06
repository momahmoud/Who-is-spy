import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/common_widgets/background_image_widget.dart';
import 'package:salfah/core/extensions/widgets_extensions.dart';
import 'package:salfah/features/players/presentation/controller/players_controller.dart';
import 'package:salfah/features/players/presentation/widgets/players_widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayersBody extends StatelessWidget {
  const PlayersBody({required this.controller, super.key});

  final PlayersController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        const BackgroundImageWidget(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                AppColors.primary.withValues(alpha: 0.88),
                AppColors.primary1.withValues(alpha: 0.94),
              ],
            ),
          ),
        ),
        PlayersView(controller: controller),
        Align(
          alignment: Alignment.bottomCenter,
          child: ActionButton(controller: controller),
        ).paddingBottom(30.h).paddingHorizontal(20.w),
      ],
    );
  }
}
