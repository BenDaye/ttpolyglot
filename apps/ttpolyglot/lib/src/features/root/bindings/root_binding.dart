import 'package:get/get.dart';

import 'package:ttpolyglot/src/features/root/controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RootController(), fenix: true);
  }
}