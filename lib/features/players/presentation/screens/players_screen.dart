import 'package:salfah/features/players/presentation/controller/players_controller.dart';
import 'package:salfah/features/players/presentation/widgets/players_widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayersController>(
      builder: (PlayersController controller) {
        return Scaffold(
          body: PlayersBody(controller: controller),
        );
      },
    );
  }
}
