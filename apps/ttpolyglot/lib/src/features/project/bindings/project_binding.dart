import 'package:get/get.dart';

import '../controllers/project_controller.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    final projectId = Get.parameters['projectId'];
    if (projectId != null) {
      Get.put(ProjectController(), tag: projectId);
    }
  }
}
