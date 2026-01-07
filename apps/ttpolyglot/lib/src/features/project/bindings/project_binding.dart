import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/features.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    final projectId = int.tryParse(Get.parameters['projectId'] ?? '0');
    if (projectId != null) {
      Get.put(ProjectController(projectId: projectId), tag: projectId.toString());
      Get.put(ProjectNavigationController(projectId: projectId), tag: projectId.toString());
      Get.put(TranslationController(projectId: projectId), tag: projectId.toString());
      Get.put(ProjectExportController(projectId: projectId), tag: projectId.toString());
    }
  }
}
