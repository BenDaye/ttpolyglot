import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/service.dart';

class ProjectExportController extends GetxController {
  static ProjectExportController get instance {
    return Get.isRegistered<ProjectExportController>()
        ? Get.find<ProjectExportController>()
        : Get.put(ProjectExportController());
  }

  final ProjectServiceImpl _projectService = Get.find<ProjectServiceImpl>();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();
  final ExportServiceImpl _exportService = Get.find<ExportServiceImpl>();

  static Future<void> exportTranslationsShortcutJson(
    String projectId,
  ) async {
    final controller = instance;

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

      final success = await controller._exportService.exportTranslationsShortcutJson(
        project: project,
        entries: entries,
      );

      if (!success) return;

      Get.snackbar('成功', 'JSON翻译文件导出成功');
    } catch (error, stackTrace) {
      log('exportTranslationsShortcutJson', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出JSON翻译文件失败: $error');
    }
  }

  static Future<void> exportTranslationsShortcutCsv(
    String projectId,
  ) async {
    final controller = instance;

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

      final success = await controller._exportService.exportTranslationsShortcutCsv(
        project: project,
        entries: entries,
      );

      if (!success) return;

      Get.snackbar('成功', 'CSV翻译文件导出成功');
    } catch (error, stackTrace) {
      log('exportTranslationsShortcutCsv', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出CSV翻译文件失败: $error');
    }
  }

  static Future<void> exportTranslationsShortcutExcel(
    String projectId,
  ) async {
    final controller = instance;

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

      final success = await controller._exportService.exportTranslationsShortcutExcel(
        project: project,
        entries: entries,
      );

      if (!success) return;

      Get.snackbar('成功', 'Excel翻译文件导出成功');
    } catch (error, stackTrace) {
      log('exportTranslationsShortcutExcel', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出Excel翻译文件失败: $error');
    }
  }

  static Future<void> exportTranslationsShortcutArb(
    String projectId,
  ) async {
    final controller = instance;

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

      final success = await controller._exportService.exportTranslationsShortcutArb(
        project: project,
        entries: entries,
      );

      if (!success) return;

      Get.snackbar('成功', 'ARB翻译文件导出成功');
    } catch (error, stackTrace) {
      log('exportTranslationsShortcutArb', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出ARB翻译文件失败: $error');
    }
  }

  static Future<void> exportTranslationsShortcutPo(
    String projectId,
  ) async {
    final controller = instance;

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

      final success = await controller._exportService.exportTranslationsShortcutPo(
        project: project,
        entries: entries,
      );

      if (!success) return;

      Get.snackbar('成功', 'PO翻译文件导出成功');
    } catch (error, stackTrace) {
      log('exportTranslationsShortcutPo', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出PO翻译文件失败: $error');
    }
  }
}
