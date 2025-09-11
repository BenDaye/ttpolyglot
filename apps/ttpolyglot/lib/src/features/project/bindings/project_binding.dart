import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/features.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    final projectId = Get.parameters['projectId'];
    if (projectId != null) {
      Get.put(ProjectController(), tag: projectId);
      Get.put(ProjectNavigationController(), tag: projectId);
      Get.put(TranslationController(projectId: projectId), tag: projectId);
      Get.put(ProjectExportController(), tag: projectId);
    }
  }
}
