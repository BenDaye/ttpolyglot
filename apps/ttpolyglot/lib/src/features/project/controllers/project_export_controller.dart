import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

class ProjectExportController extends GetxController {
  final int projectId;
  ProjectExportController({required this.projectId});

  static ProjectExportController instance(int projectId) {
    return Get.isRegistered<ProjectExportController>(tag: projectId.toString())
        ? Get.find<ProjectExportController>(tag: projectId.toString())
        : Get.put(ProjectExportController(projectId: projectId), tag: projectId.toString());
  }

  final ProjectServiceImpl _projectService = Get.find<ProjectServiceImpl>();
  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();
  final ExportServiceImpl _exportService = Get.find<ExportServiceImpl>();

  static Future<String?> exportTranslationsShortcutJson(
    int projectId,
  ) async {
    final controller = instance(projectId);

    try {
      // 获取项目信息
      final project = await controller._projectService.getProject(
        projectId,
      );
      if (project == null) {
        Get.snackbar('错误', '项目不存在');
        return null;
      }

      final entries = await controller._translationService.getTranslationEntries(
        projectId,
        includeSourceLanguage: true,
      );

      final savePath = await controller._exportService.exportTranslationsShortcutJsonWithPath(
        project: project,
        entries: entries,
      );

      if (savePath == null) return null;

      Get.snackbar('成功', 'JSON翻译文件导出成功');
      return savePath;
    } catch (error, stackTrace) {
      LoggerUtils.error('exportTranslationsShortcutJson', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '导出JSON翻译文件失败: $error');
      return null;
    }
  }

  static Future<String?> exportTranslationsShortcutCsv(
    int projectId,
  ) async {
    final controller = instance(projectId);

    try {
      // 获取项目信息
      final project = await controller._projectService.getProject(
        projectId,
      );
      if (project == null) {
        Get.snackbar('错误', '项目不存在');
        return null;
      }

      final entries = await controller._translationService.getTranslationEntries(
        projectId,
        includeSourceLanguage: true,
      );

      final savePath = await controller._exportService.exportTranslationsShortcutCsvWithPath(
        project: project,
        entries: entries,
      );

      if (savePath == null) return null;

      Get.snackbar('成功', 'CSV翻译文件导出成功');
      return savePath;
    } catch (error, stackTrace) {
      LoggerUtils.error('exportTranslationsShortcutCsv', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '导出CSV翻译文件失败: $error');
      return null;
    }
  }

  static Future<String?> exportTranslationsShortcutExcel(
    int projectId,
  ) async {
    final controller = instance(projectId);

    try {
      // 获取项目信息
      final project = await controller._projectService.getProject(
        projectId,
      );
      if (project == null) {
        Get.snackbar('错误', '项目不存在');
        return null;
      }

      final entries = await controller._translationService.getTranslationEntries(
        projectId,
        includeSourceLanguage: true,
      );

      final savePath = await controller._exportService.exportTranslationsShortcutExcelWithPath(
        project: project,
        entries: entries,
      );

      if (savePath == null) return null;

      Get.snackbar('成功', 'Excel翻译文件导出成功');
      return savePath;
    } catch (error, stackTrace) {
      LoggerUtils.error('exportTranslationsShortcutExcel', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '导出Excel翻译文件失败: $error');
      return null;
    }
  }

  static Future<String?> exportTranslationsShortcutArb(
    int projectId,
  ) async {
    final controller = instance(projectId);

    try {
      // 获取项目信息
      final project = await controller._projectService.getProject(
        projectId,
      );
      if (project == null) {
        Get.snackbar('错误', '项目不存在');
        return null;
      }

      final entries = await controller._translationService.getTranslationEntries(
        projectId,
        includeSourceLanguage: true,
      );

      final savePath = await controller._exportService.exportTranslationsShortcutArbWithPath(
        project: project,
        entries: entries,
      );

      if (savePath == null) return null;

      Get.snackbar('成功', 'ARB翻译文件导出成功');
      return savePath;
    } catch (error, stackTrace) {
      LoggerUtils.error('exportTranslationsShortcutArb', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '导出ARB翻译文件失败: $error');
      return null;
    }
  }

  static Future<String?> exportTranslationsShortcutPo(
    int projectId,
  ) async {
    final controller = instance(projectId);

    try {
      // 获取项目信息
      final project = await controller._projectService.getProject(
        projectId,
      );
      if (project == null) {
        Get.snackbar('错误', '项目不存在');
        return null;
      }

      final entries = await controller._translationService.getTranslationEntries(
        projectId,
        includeSourceLanguage: true,
      );

      final savePath = await controller._exportService.exportTranslationsShortcutPoWithPath(
        project: project,
        entries: entries,
      );

      if (savePath == null) return null;

      Get.snackbar('成功', 'PO翻译文件导出成功');
      return savePath;
    } catch (error, stackTrace) {
      LoggerUtils.error('exportTranslationsShortcutPo', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '导出PO翻译文件失败: $error');
      return null;
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
  void initializeCustomExport(ProjectModel project) {
    // 默认选择所有语言
    _selectedLanguages.clear();
    _selectedLanguages.addAll(project.languages.map((lang) => lang.code.code));

    // 重置其他设置
    _exportOnlyTranslated.value = true;
    _includeStatus.value = false;
    _includeTimestamps.value = false;
    _selectedFormat.value = 'json';
  }

  /// 执行自定义导出
  static Future<String?> exportTranslationsCustom(
    int projectId, {
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
        return null;
      }

      // 获取翻译条目
      final allEntries = await controller._translationService.getTranslationEntries(
        projectId,
        includeSourceLanguage: true,
      );

      // 过滤选中的语言（检查条目的目标语言列表中是否包含选中的语言）
      final filteredEntries = allEntries.where((entry) {
        return entry.targetLanguages.any((t) => selectedLanguages.contains(t.language.code));
      }).toList();

      // 过滤未翻译的内容（如果需要）— 仅检查选中语言的翻译状态
      final finalEntries = exportOnlyTranslated
          ? filteredEntries
              .where(
                (entry) => entry.targetLanguages
                    .any((t) => selectedLanguages.contains(t.language.code) && t.text.trim().isNotEmpty),
              )
              .toList()
          : filteredEntries;

      if (finalEntries.isEmpty) {
        Get.snackbar('提示', '没有符合条件的翻译内容');
        return null;
      }

      // 根据格式调用相应的导出方法
      final savePath = await _exportByFormat(
        project: project,
        entries: finalEntries,
        format: format,
        includeStatus: includeStatus,
        includeTimestamps: includeTimestamps,
      );

      if (savePath != null) {
        Get.snackbar('成功', '自定义导出完成');
        return savePath;
      }

      return null;
    } catch (error, stackTrace) {
      LoggerUtils.error('自定义导出失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '自定义导出失败: $error');
      return null;
    } finally {
      controller._isExporting.value = false;
    }
  }

  /// 根据格式调用相应的导出方法
  static Future<String?> _exportByFormat({
    required ProjectModel project,
    required List<TranslationEntryModel> entries,
    required String format,
    bool includeStatus = false,
    bool includeTimestamps = false,
  }) async {
    final controller = instance(project.id);

    switch (format) {
      case 'json':
        return await controller._exportService.exportTranslationsShortcutJsonWithPath(
          project: project,
          entries: entries,
        );
      case 'csv':
        return await controller._exportService.exportTranslationsShortcutCsvWithPath(
          project: project,
          entries: entries,
        );
      case 'excel':
        return await controller._exportService.exportTranslationsShortcutExcelWithPath(
          project: project,
          entries: entries,
        );
      case 'arb':
        return await controller._exportService.exportTranslationsShortcutArbWithPath(
          project: project,
          entries: entries,
        );
      case 'po':
        return await controller._exportService.exportTranslationsShortcutPoWithPath(
          project: project,
          entries: entries,
        );
      default:
        throw UnsupportedError('不支持的导出格式: $format');
    }
  }

  /// 执行导出并保存历史记录
  static Future<String?> exportTranslationsWithHistory(
    int projectId, {
    required Set<String> selectedLanguages,
    required bool exportOnlyTranslated,
    required bool includeStatus,
    required bool includeTimestamps,
    required String format,
  }) async {
    try {
      final savePath = await exportTranslationsCustom(
        projectId,
        selectedLanguages: selectedLanguages,
        exportOnlyTranslated: exportOnlyTranslated,
        includeStatus: includeStatus,
        includeTimestamps: includeTimestamps,
        format: format,
      );
      return savePath;
    } catch (error, stackTrace) {
      LoggerUtils.error('exportTranslationsWithHistory', error: error, stackTrace: stackTrace);

      return null;
    }
  }
}

/// 导出历史记录数据模型
class ExportHistoryItem {
  final String filename;
  final String description;
  final DateTime timestamp;
  final bool success;
  final String format;
  final int languageCount;
  final String? filePath;

  ExportHistoryItem({
    required this.filename,
    required this.description,
    required this.timestamp,
    required this.success,
    required this.format,
    required this.languageCount,
    this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'filename': filename,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'success': success,
      'format': format,
      'languageCount': languageCount,
      'filePath': filePath,
    };
  }

  factory ExportHistoryItem.fromJson(Map<String, dynamic> json) {
    return ExportHistoryItem(
      filename: json['filename'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      success: json['success'] ?? false,
      format: json['format'] ?? 'json',
      languageCount: json['languageCount'] ?? 0,
      filePath: json['filePath'],
    );
  }
}
