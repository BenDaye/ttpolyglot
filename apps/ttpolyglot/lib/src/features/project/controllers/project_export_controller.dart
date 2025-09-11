import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  static Future<String?> exportTranslationsShortcutJson(
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
      log('exportTranslationsShortcutJson', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出JSON翻译文件失败: $error');
      return null;
    }
  }

  static Future<String?> exportTranslationsShortcutCsv(
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
      log('exportTranslationsShortcutCsv', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出CSV翻译文件失败: $error');
      return null;
    }
  }

  static Future<String?> exportTranslationsShortcutExcel(
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
      log('exportTranslationsShortcutExcel', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出Excel翻译文件失败: $error');
      return null;
    }
  }

  static Future<String?> exportTranslationsShortcutArb(
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
      log('exportTranslationsShortcutArb', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '导出ARB翻译文件失败: $error');
      return null;
    }
  }

  static Future<String?> exportTranslationsShortcutPo(
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
      log('exportTranslationsShortcutPo', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
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
  static Future<String?> exportTranslationsCustom(
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
        return null;
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
      log('自定义导出失败', error: error, stackTrace: stackTrace, name: 'ProjectExportController');
      Get.snackbar('错误', '自定义导出失败: $error');
      return null;
    } finally {
      controller._isExporting.value = false;
    }
  }

  /// 根据格式调用相应的导出方法
  static Future<String?> _exportByFormat({
    required Project project,
    required List<TranslationEntry> entries,
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
    String projectId, {
    required Set<String> selectedLanguages,
    required bool exportOnlyTranslated,
    required bool includeStatus,
    required bool includeTimestamps,
    required String format,
    required Function() onUIUpdate,
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

      // 生成导出描述
      final formatName = switch (format.toLowerCase()) {
        'json' => 'JSON',
        'csv' => 'CSV',
        'excel' => 'Excel',
        'arb' => 'ARB',
        'po' => 'PO',
        _ => format.toUpperCase(),
      };

      final languageText = selectedLanguages.length == 1 ? '单语言' : '${selectedLanguages.length} 种语言';
      final translatedText = exportOnlyTranslated ? '（仅已翻译）' : '';

      final description = '$languageText$translatedText - $formatName 格式';

      final filename =
          savePath != null ? savePath.split('/').last : 'translations_${DateTime.now().millisecondsSinceEpoch}.$format';

      // 保存导出历史
      final historyItem = ExportHistoryItem(
        filename: filename,
        description: description,
        timestamp: DateTime.now(),
        success: savePath != null,
        format: format,
        languageCount: selectedLanguages.length,
        filePath: savePath,
      );

      await ExportHistoryCache.saveExportHistory(projectId, historyItem);
      onUIUpdate(); // 触发UI更新

      return savePath;
    } catch (error, stackTrace) {
      log('exportTranslationsWithHistory', error: error, stackTrace: stackTrace, name: 'ProjectExportController');

      // 导出失败时保存失败记录
      final historyItem = ExportHistoryItem(
        filename: '导出失败',
        description: '导出过程中发生错误',
        timestamp: DateTime.now(),
        success: false,
        format: format,
        languageCount: selectedLanguages.length,
      );

      await ExportHistoryCache.saveExportHistory(projectId, historyItem);
      onUIUpdate(); // 触发UI更新

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

/// 导出历史记录缓存管理
class ExportHistoryCache {
  static const String _cacheKey = 'export_history';
  static const int _maxHistoryPerProject = 5;

  static Future<void> saveExportHistory(String projectId, ExportHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';

    // 获取现有历史记录
    final historyList = await getExportHistory(projectId);

    // 添加新记录到开头
    historyList.insert(0, item);

    // 限制每个项目最多5条记录
    if (historyList.length > _maxHistoryPerProject) {
      historyList.removeRange(_maxHistoryPerProject, historyList.length);
    }

    // 保存到缓存
    final jsonList = historyList.map((item) => item.toJson()).toList();
    await prefs.setString(key, jsonEncode(jsonList));
  }

  static Future<List<ExportHistoryItem>> getExportHistory(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';

    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => ExportHistoryItem.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearExportHistory(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';
    await prefs.remove(key);
  }
}
