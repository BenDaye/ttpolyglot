import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout.dart';

class LayoutBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LayoutController(), permanent: true);
  }
}
