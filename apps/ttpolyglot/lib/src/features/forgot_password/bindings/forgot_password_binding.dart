import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/forgot_password/forgot_password.dart';

/// 忘记密码绑定
class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}
