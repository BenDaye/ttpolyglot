import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/profile/controllers/profile_controller.dart';

/// 个人信息绑定
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
