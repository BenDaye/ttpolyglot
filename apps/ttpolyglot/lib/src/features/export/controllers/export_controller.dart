import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/project_service_impl.dart';
import 'package:ttpolyglot/src/core/services/translation_service_impl.dart';
import 'package:ttpolyglot/src/features/export/export.dart';

class ExportController extends GetxController {
  static ExportController get to {
    return Get.isRegistered<ExportController>() ? Get.find<ExportController>() : Get.put(ExportController());
  }

  final ProjectServiceImpl _projectService = Get.find<ProjectServiceImpl>();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();

  static Future<void> exportTranslationsShortcutJson(
    String projectId,
  ) async {
    final controller = to;

    try {
      // 获取项目信息
      final project = await controller._projectService.getProject(
        projectId,
      );
      if (project == null) {
        Get.snackbar('错误', '项目不存在');
        return;
      }

      final entries = await controller._translationService.getTranslationEntries(
        projectId,
        includeSourceLanguage: true,
      );

      final success = await ExportServiceImpl().exportTranslationsShortcutJson(
        project: project,
        entries: entries,
      );

      if (!success) return;

      Get.snackbar('成功', '翻译文件导出成功');
    } catch (error, stackTrace) {
      log('exportTranslationsShortcutJson', error: error, stackTrace: stackTrace, name: 'ExportController');
      Get.snackbar('错误', '导出翻译文件失败: $error');
    }
  }
}
