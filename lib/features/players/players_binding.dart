import 'package:salfah/features/players/presentation/controller/players_controller.dart';
import 'package:get/get.dart';

class PlayersBinding extends Bindings {
  PlayersBinding();

  @override
  void dependencies() {

    Get.lazyPut<PlayersController>(PlayersController.new);
  }
}
