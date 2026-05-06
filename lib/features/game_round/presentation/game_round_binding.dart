import 'package:salfah/features/game_round/presentation/controllers/game_round_controller.dart';
import 'package:get/get.dart';

class GameRoundBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GameRoundController());
  }
}
