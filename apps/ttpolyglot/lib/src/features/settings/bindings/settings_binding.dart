import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/settings/controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}
