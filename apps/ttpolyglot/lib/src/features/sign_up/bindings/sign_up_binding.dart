import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/sign_up/sign_up.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
  }
}
