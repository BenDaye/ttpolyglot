import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/reset_password/reset_password.dart';

/// 重置密码绑定
class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
    );
  }
}
