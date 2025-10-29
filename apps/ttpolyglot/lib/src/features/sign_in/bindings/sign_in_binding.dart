import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/sign_in/sign_in.dart';

/// 登录页面依赖注入
class SignInBinding extends Bindings {
  @override
  void dependencies() {
    // 注册登录控制器
    Get.lazyPut<SignInController>(
      () => SignInController(),
    );
  }
}
