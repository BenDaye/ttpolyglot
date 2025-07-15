import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/root/root.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RootController(), fenix: true);
  }
}
