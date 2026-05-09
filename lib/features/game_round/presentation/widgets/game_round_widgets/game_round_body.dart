import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/common_widgets/background_image_widget.dart';
import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:salfah/features/game_round/presentation/widgets/game_round_widgets/index.dart';
import 'package:flutter/material.dart';

class GameRoundBody extends StatelessWidget {
  final GameRoundController controller;
  const GameRoundBody({required this.controller, super.key});

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
                AppColors.primary.withValues(alpha: 0.90),
                AppColors.primary1.withValues(alpha: 0.96),
              ],
            ),
          ),
        ),

        if (!controller.show &&
            !controller.showQuestion &&
            !controller.vote &&
            !controller.showBraSalfa)
          GivePhoneWidget(controller: controller),

        if (controller.show &&
            !controller.showQuestion &&
            !controller.vote &&
            !controller.showBraSalfa)
          RoleWidget(controller: controller),

        if (controller.showQuestion &&
            !controller.vote &&
            !controller.showBraSalfa)
          QuestionsWidget(controller: controller),

        if (controller.vote && !controller.showBraSalfa)
          VoteWidget(controller: controller),

        if (controller.showBraSalfa) RevealWidget(controller: controller),

        if (!controller.vote &&
            (!controller.showBraSalfa || controller.timerFinish))
          NextActionButton(controller: controller),
      ],
    );
  }
}
