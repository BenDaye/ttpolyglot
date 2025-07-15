import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_controller.dart';
import 'package:ttpolyglot/src/features/project/services/translation_service_impl.dart';
import 'package:ttpolyglot_core/core.dart';

/// 翻译控制器
class TranslationController extends GetxController {
  final String projectId;
  late final TranslationServiceImpl _translationService;
  ProjectController? _projectController;

  // 响应式变量
  final _translationEntries = <TranslationEntry>[].obs;
  final _filteredEntries = <TranslationEntry>[].obs;
  final _isLoading = false.obs;
  final _error = ''.obs;
  final _searchQuery = ''.obs;
  final _selectedLanguage = Rxn<Language>();
  final _selectedStatus = Rxn<TranslationStatus>();

  // 用于监听项目语言变化
  Project? _lastProject;

  // Getters
  List<TranslationEntry> get translationEntries => _translationEntries;
  List<TranslationEntry> get filteredEntries => _filteredEntries;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  String get searchQuery => _searchQuery.value;
  Language? get selectedLanguage => _selectedLanguage.value;
  TranslationStatus? get selectedStatus => _selectedStatus.value;

  TranslationController({required this.projectId});

  @override
  void onInit() {
    super.onInit();
    _initializeService();
    _setupProjectListener();
  }

  /// 初始化翻译服务
  Future<void> _initializeService() async {
    try {
      _translationService = await TranslationServiceImpl.create();
      await loadTranslationEntries();
    } catch (error, stackTrace) {
      _error.value = '初始化翻译服务失败: $error';
      log('初始化翻译服务失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 设置项目监听器
  void _setupProjectListener() {
    // 延迟获取项目控制器，确保它已经初始化
    Future.delayed(const Duration(milliseconds: 100), () {
      if (Get.isRegistered<ProjectController>(tag: projectId)) {
        _projectController = Get.find<ProjectController>(tag: projectId);

        // 使用 ever 监听项目变化
        ever(_projectController!.projectObs, (Project? project) {
          if (project != null) {
            _handleProjectChange(project);
          }
        });
      }
    });
  }

  /// 处理项目变化
  void _handleProjectChange(Project newProject) async {
    if (_lastProject == null) {
      _lastProject = newProject;
      return;
    }

    // 检查语言配置是否发生变化
    final hasLanguageChanged = _hasLanguageConfigChanged(_lastProject!, newProject);

    if (hasLanguageChanged) {
      log('检测到项目语言配置变化，开始同步翻译条目...');

      try {
        await _translationService.syncProjectLanguages(
          projectId,
          newProject.defaultLanguage,
          newProject.targetLanguages,
        );

        // 同步完成后重新加载翻译条目
        await loadTranslationEntries();

        Get.snackbar('成功', '项目语言同步完成');
      } catch (error, stackTrace) {
        log('同步项目语言失败', error: error, stackTrace: stackTrace);
        Get.snackbar('错误', '项目语言同步失败: $error');
      }
    }

    _lastProject = newProject;
  }

  /// 检查语言配置是否发生变化
  bool _hasLanguageConfigChanged(Project oldProject, Project newProject) {
    // 检查默认语言是否变化
    if (oldProject.defaultLanguage.code != newProject.defaultLanguage.code) {
      return true;
    }

    // 检查目标语言数量是否变化
    if (oldProject.targetLanguages.length != newProject.targetLanguages.length) {
      return true;
    }

    // 检查目标语言内容是否变化
    final oldCodes = oldProject.targetLanguages.map((lang) => lang.code).toSet();
    final newCodes = newProject.targetLanguages.map((lang) => lang.code).toSet();

    if (!oldCodes.containsAll(newCodes) || !newCodes.containsAll(oldCodes)) {
      return true;
    }

    // 检查语言排序是否变化
    for (int i = 0; i < oldProject.targetLanguages.length; i++) {
      if (oldProject.targetLanguages[i].sortIndex != newProject.targetLanguages[i].sortIndex) {
        return true;
      }
    }

    return false;
  }

  /// 加载翻译条目
  Future<void> loadTranslationEntries() async {
    _isLoading.value = true;
    _error.value = '';

    try {
      final entries = await _translationService.getTranslationEntries(projectId);
      _translationEntries.assignAll(entries);
      _applyFilters();
    } catch (error, stackTrace) {
      _error.value = '加载翻译条目失败: $error';
      log('加载翻译条目失败', error: error, stackTrace: stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 刷新翻译条目
  Future<void> refreshTranslationEntries() async {
    await loadTranslationEntries();
  }

  /// 创建翻译键
  Future<void> createTranslationKey({
    required String key,
    required String sourceText,
    required Language sourceLanguage,
    required List<Language> targetLanguages,
    String? context,
    String? comment,
    int? maxLength,
    bool isPlural = false,
    Map<String, String>? pluralForms,
  }) async {
    try {
      final request = CreateTranslationKeyRequest(
        projectId: projectId,
        key: key,
        sourceLanguage: sourceLanguage,
        sourceText: sourceText,
        targetLanguages: targetLanguages,
        context: context,
        comment: comment,
        maxLength: maxLength,
        isPlural: isPlural,
        pluralForms: pluralForms,
        generateForDefaultLanguage: true,
      );

      if (!request.isValid) {
        final errors = request.validate();
        throw Exception('创建翻译键验证失败: ${errors.join(', ')}');
      }

      await _translationService.createTranslationKey(request);
      await loadTranslationEntries();

      Get.snackbar('成功', '翻译键创建成功');
    } catch (error, stackTrace) {
      _error.value = '创建翻译键失败: $error';
      Get.snackbar('错误', _error.value);
      log('创建翻译键失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 更新翻译条目
  Future<void> updateTranslationEntry(TranslationEntry entry) async {
    try {
      await _translationService.updateTranslationEntry(entry);

      // 更新本地列表
      final index = _translationEntries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _translationEntries[index] = entry;
        _applyFilters();
      }

      Get.snackbar('成功', '翻译条目更新成功');
    } catch (error, stackTrace) {
      _error.value = '更新翻译条目失败: $error';
      Get.snackbar('错误', _error.value);
      log('更新翻译条目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 删除翻译条目
  Future<void> deleteTranslationEntry(String entryId) async {
    try {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('删除翻译条目'),
          content: const Text('确定要删除这个翻译条目吗？此操作不可撤销。'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('确定'),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      if (result == true) {
        await _translationService.deleteTranslationEntry(entryId);

        // 从本地列表中移除
        _translationEntries.removeWhere((e) => e.id == entryId);
        _applyFilters();

        Get.snackbar('成功', '翻译条目删除成功');
      }
    } catch (error, stackTrace) {
      _error.value = '删除翻译条目失败: $error';
      Get.snackbar('错误', _error.value);
      log('删除翻译条目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 批量删除翻译条目
  Future<void> batchDeleteTranslationEntries(List<String> entryIds) async {
    try {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('批量删除翻译条目'),
          content: Text('确定要删除选中的 ${entryIds.length} 个翻译条目吗？此操作不可撤销。'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('确定'),
            ),
          ],
        ),
        barrierDismissible: false,
      );

      if (result == true) {
        for (final entryId in entryIds) {
          await _translationService.deleteTranslationEntry(entryId);
        }

        // 从本地列表中移除
        _translationEntries.removeWhere((e) => entryIds.contains(e.id));
        _applyFilters();

        Get.snackbar('成功', '批量删除翻译条目成功');
      }
    } catch (error, stackTrace) {
      _error.value = '批量删除翻译条目失败: $error';
      Get.snackbar('错误', _error.value);
      log('批量删除翻译条目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 搜索翻译条目
  void searchTranslationEntries(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  /// 根据语言筛选
  void filterByLanguage(Language? language) {
    _selectedLanguage.value = language;
    _applyFilters();
  }

  /// 根据状态筛选
  void filterByStatus(TranslationStatus? status) {
    _selectedStatus.value = status;
    _applyFilters();
  }

  /// 清除筛选条件
  void clearFilters() {
    _searchQuery.value = '';
    _selectedLanguage.value = null;
    _selectedStatus.value = null;
    _applyFilters();
  }

  /// 应用筛选条件
  void _applyFilters() {
    var filtered = _translationEntries.toList();

    // 搜索筛选
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered = filtered.where((entry) {
        return entry.key.toLowerCase().contains(query) ||
            entry.sourceText.toLowerCase().contains(query) ||
            entry.targetText.toLowerCase().contains(query);
      }).toList();
    }

    // 语言筛选
    if (_selectedLanguage.value != null) {
      filtered = filtered.where((entry) => entry.targetLanguage.code == _selectedLanguage.value!.code).toList();
    }

    // 状态筛选
    if (_selectedStatus.value != null) {
      filtered = filtered.where((entry) => entry.status == _selectedStatus.value).toList();
    }

    _filteredEntries.assignAll(filtered);
  }

  /// 获取翻译进度统计
  Future<Map<String, int>> getTranslationProgress() async {
    try {
      return await _translationService.getTranslationProgress(projectId);
    } catch (error, stackTrace) {
      log('获取翻译进度失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 获取可用的语言列表
  List<Language> getAvailableLanguages() {
    final languages = <Language>[];
    for (final entry in _translationEntries) {
      if (!languages.any((lang) => lang.code == entry.targetLanguage.code)) {
        languages.add(entry.targetLanguage);
      }
    }

    // 按 sortIndex 排序
    languages.sort((a, b) {
      final aIndex = a.sortIndex;
      final bIndex = b.sortIndex;
      if (aIndex != bIndex) {
        return aIndex.compareTo(bIndex);
      }
      // 如果 sortIndex 相同，则按语言代码排序
      return a.code.compareTo(b.code);
    });

    return languages;
  }

  /// 获取可用的状态列表
  List<TranslationStatus> getAvailableStatuses() {
    return TranslationStatus.values;
  }

  /// 按翻译键分组条目
  Map<String, List<TranslationEntry>> getGroupedEntries() {
    final grouped = <String, List<TranslationEntry>>{};

    for (final entry in _filteredEntries) {
      grouped.putIfAbsent(entry.key, () => []).add(entry);
    }

    // 按键名排序
    final sortedKeys = grouped.keys.toList()..sort();
    final sortedGrouped = <String, List<TranslationEntry>>{};

    for (final key in sortedKeys) {
      // 按语言的 sortIndex 排序每个组内的条目
      final entries = grouped[key]!;
      entries.sort((a, b) {
        final aIndex = a.targetLanguage.sortIndex;
        final bIndex = b.targetLanguage.sortIndex;
        if (aIndex != bIndex) {
          return aIndex.compareTo(bIndex);
        }
        // 如果 sortIndex 相同，则按语言代码排序
        return a.targetLanguage.code.compareTo(b.targetLanguage.code);
      });
      sortedGrouped[key] = entries;
    }

    return sortedGrouped;
  }

  /// 获取翻译条目统计信息
  Map<String, int> getStatistics() {
    final stats = <String, int>{};

    stats['total'] = _translationEntries.length;
    stats['completed'] = _translationEntries.where((e) => e.status == TranslationStatus.completed).length;
    stats['pending'] = _translationEntries.where((e) => e.status == TranslationStatus.pending).length;
    stats['reviewing'] = _translationEntries.where((e) => e.status == TranslationStatus.reviewing).length;
    stats['translating'] = _translationEntries.where((e) => e.status == TranslationStatus.translating).length;

    return stats;
  }
}
