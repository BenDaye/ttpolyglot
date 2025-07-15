import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/sign_up/controllers/sign_up_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
