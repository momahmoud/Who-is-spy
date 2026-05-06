import 'package:salfah/core/di/index.dart';
import 'package:salfah/core/infrastructure/local_data_base/base_local_data_base.dart';
import 'package:salfah/features/settings/presentation/controller/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(di<BaseDatabase>()),
    );
  }
}
