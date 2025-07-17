import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/settings/settings.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}
