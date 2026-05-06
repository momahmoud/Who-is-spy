import 'package:salfah/features/round_finish/presentation/controller/round_finish_controller.dart';
import 'package:get/get.dart';

class RoundFinishBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RoundFinishController());
  }
}
