import 'dart:developer';

import 'package:get/get.dart';

class ProjectController extends GetxController {
  late final String projectId;

  @override
  void onInit() {
    super.onInit();
    projectId = Get.parameters['projectId'] ?? '';
  }

  @override
  void onReady() {
    super.onReady();
    log('ProjectController onReady: $projectId');
  }
}
