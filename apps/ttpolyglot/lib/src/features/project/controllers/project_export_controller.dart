import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot_core/core.dart';

class ProjectExportController extends GetxController {
  static ProjectExportController instance(String projectId) {
    return Get.isRegistered<ProjectExportController>(tag: projectId)
        ? Get.find<ProjectExportController>(tag: projectId)
        : Get.put(ProjectExportController(), tag: projectId);
  }

  final ProjectServiceImpl _projectService = Get.find<ProjectServiceImpl>();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();
  final ExportServiceImpl _exportService = Get.find<ExportServiceImpl>();

  static Future<void> exportTranslationsShortcutJson(
    String projectId,
  ) async {
    final controller = instance(projectId);

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
    final controller = instance(projectId);

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
    final controller = instance(projectId);

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
    final controller = instance(projectId);

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
    final controller = instance(projectId);

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

  // 自定义导出相关状态
  final RxSet<String> _selectedLanguages = <String>{}.obs;
  final RxBool _exportOnlyTranslated = true.obs;
  final RxBool _includeStatus = false.obs;
  final RxBool _includeTimestamps = false.obs;
  final RxString _selectedFormat = 'json'.obs;
  final RxBool _isExporting = false.obs;

  // Getters
  Set<String> get selectedLanguages => _selectedLanguages.toSet();
  bool get exportOnlyTranslated => _exportOnlyTranslated.value;
  bool get includeStatus => _includeStatus.value;
  bool get includeTimestamps => _includeTimestamps.value;
  String get selectedFormat => _selectedFormat.value;
  bool get isExporting => _isExporting.value;

  // Setters
  void toggleLanguage(String languageCode) {
    if (_selectedLanguages.contains(languageCode)) {
      _selectedLanguages.remove(languageCode);
    } else {
      _selectedLanguages.add(languageCode);
    }
  }

  void setExportOnlyTranslated(bool value) => _exportOnlyTranslated.value = value;
  void setIncludeStatus(bool value) => _includeStatus.value = value;
  void setIncludeTimestamps(bool value) => _includeTimestamps.value = value;
  void setSelectedFormat(String format) => _selectedFormat.value = format;

  /// 初始化自定义导出设置
  void initializeCustomExport(Project project) {
    // 默认选择所有语言
    _selectedLanguages.clear();
    _selectedLanguages.add(project.defaultLanguage.code);
    _selectedLanguages.addAll(project.targetLanguages.map((lang) => lang.code));

    // 重置其他设置
    _exportOnlyTranslated.value = true;
    _includeStatus.value = false;
    _includeTimestamps.value = false;
    _selectedFormat.value = 'json';
  }

  /// 执行自定义导出
  static Future<void> exportTranslationsCustom(
    String projectId, {
    required Set<String> selectedLanguages,
    required bool exportOnlyTranslated,
    required bool includeStatus,
    required bool includeTimestamps,
    required String format,
  }) async {
    final controller = instance(projectId);
    controller._isExporting.value = true;

    try {
      // 获取项目信息
      final project = await controller._projectService.getProject(projectId);
      if (project == null) {
        Get.snackbar('错误', '项目不存在');
        return;
      }

      // 获取翻译条目
      final allEntries = await controller._translationService.getTranslationEntries(
        projectId,
        includeSourceLanguage: true,
      );

      // 过滤选中的语言
      final filteredEntries = allEntries.where((entry) {
        return selectedLanguages.contains(entry.targetLanguage.code);
      }).toList();

      // 过滤未翻译的内容（如果需要）
      final finalEntries = exportOnlyTranslated
          ? filteredEntries.where((entry) => entry.targetText.trim().isNotEmpty).toList()
          : filteredEntries;

      if (finalEntries.isEmpty) {
        Get.snackbar('提示', '没有符合条件的翻译内容');
        return;
      }

      // 根据格式调用相应的导出方法
      final success = await _exportByFormat(
        project: project,
        entries: finalEntries,
        format: format,
        includeStatus: includeStatus,
        includeTimestamps: includeTimestamps,
      );

      if (success) {
        Get.snackbar('成功', '自定义导出完成');
      }
    } catch (error, stackTrace) {
      log('自定义导出失败', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '自定义导出失败: $error');
    } finally {
      controller._isExporting.value = false;
    }
  }

  /// 根据格式调用相应的导出方法
  static Future<bool> _exportByFormat({
    required Project project,
    required List<TranslationEntry> entries,
    required String format,
    required bool includeStatus,
    required bool includeTimestamps,
  }) async {
    final controller = instance(project.id);

    switch (format) {
      case 'json':
        return await controller._exportService.exportTranslationsShortcutJson(
          project: project,
          entries: entries,
        );
      case 'csv':
        return await controller._exportService.exportTranslationsShortcutCsv(
          project: project,
          entries: entries,
        );
      case 'excel':
        return await controller._exportService.exportTranslationsShortcutExcel(
          project: project,
          entries: entries,
        );
      case 'arb':
        return await controller._exportService.exportTranslationsShortcutArb(
          project: project,
          entries: entries,
        );
      case 'po':
        return await controller._exportService.exportTranslationsShortcutPo(
          project: project,
          entries: entries,
        );
      default:
        throw UnsupportedError('不支持的导出格式: $format');
    }
  }
}
