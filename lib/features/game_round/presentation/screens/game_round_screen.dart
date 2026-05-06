import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:salfah/features/game_round/presentation/widgets/game_round_widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameRoundScreen extends StatelessWidget {
  const GameRoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GameRoundController>(
      builder: (GameRoundController controller) {
        return Scaffold(body: GameRoundBody(controller: controller));
      },
    );
  }
}
