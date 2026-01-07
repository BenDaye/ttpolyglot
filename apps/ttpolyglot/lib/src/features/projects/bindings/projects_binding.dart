import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/features.dart';

class ProjectsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectsController(), fenix: true);
  }
}
