import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/sign_in/controllers/sign_in_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController(), fenix: true);
  }
}
