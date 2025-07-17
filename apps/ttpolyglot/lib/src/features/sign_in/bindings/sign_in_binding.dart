import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/sign_in/sign_in.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController(), fenix: true);
  }
}
