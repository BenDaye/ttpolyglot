import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot/src/core/services/translation_sync_service.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 翻译控制器
///
/// 负责管理翻译条目的创建、更新和查询。
/// 所有翻译操作都使用项目的主语言作为源语言，确保数据一致性。
class TranslationController extends GetxController {
  final int projectId;
  TranslationController({required this.projectId});

  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();

  // 响应式变量
  final _translationEntries = <TranslationEntryModel>[].obs;
  final _filteredEntries = <TranslationEntryModel>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedLanguage = Rxn<LanguageEnum>();
  final _selectedStatus = Rxn<TranslationStatusEnum>();
  final _listType = TranslationsListType.byKey.obs;

  // Getters
  List<TranslationEntryModel> get translationEntries => _translationEntries;
  List<TranslationEntryModel> get filteredEntries => _filteredEntries;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  LanguageEnum? get selectedLanguage => _selectedLanguage.value;
  TranslationStatusEnum? get selectedStatus => _selectedStatus.value;
  TranslationsListType get listType => _listType.value;

  @override
  void onInit() {
    super.onInit();
    _initializeService();
  }

  /// 初始化翻译服务
  Future<void> _initializeService() async {
    try {
      await loadTranslationEntries();
    } catch (error, stackTrace) {
      LoggerUtils.error('初始化翻译服务失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 当项目语言配置发生变化时，由外部调用此方法刷新数据
  Future<void> onProjectLanguageChanged() async {
    LoggerUtils.info('项目语言配置已变化，刷新翻译条目...');

    try {
      await loadTranslationEntries();
      LoggerUtils.info('翻译条目刷新完成');
    } catch (error, stackTrace) {
      LoggerUtils.error('刷新翻译条目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 加载翻译条目
  Future<void> loadTranslationEntries() async {
    _isLoading.value = true;

    try {
      final entries = await _translationService.getTranslationEntries(projectId);
      _translationEntries.assignAll(entries);
      _applyFilters();
    } catch (error, stackTrace) {
      LoggerUtils.error('加载翻译条目失败', error: error, stackTrace: stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 刷新翻译条目
  Future<void> refreshTranslationEntries() async {
    await loadTranslationEntries();
  }

  /// 创建翻译键
  ///
  /// 使用项目的主语言作为源语言创建翻译条目。
  /// 这种设计确保了所有翻译都基于相同的源语言，提高了数据一致性。
  Future<void> createTranslationKey({
    required String key,
    required String sourceText,
    required List<LanguageEnum> targetLanguages,
    String? context,
    String? comment,
    int? maxLength,
    bool isPlural = false,
    Map<String, String>? pluralForms,
  }) async {
    try {
      // 获取项目信息以确保使用正确的主语言
      final project = await ProjectsController.getProject(projectId);
      if (project == null) {
        throw Exception('项目不存在: $projectId');
      }

      // 使用项目的主语言作为源语言
      final request = CreateTranslationKeyRequest(
        projectId: projectId,
        entryKey: key,
        sourceLanguage: project.primaryLanguage.code,
        sourceText: sourceText,
        targetLanguages: targetLanguages,
        context: context,
        maxLength: maxLength,
        isPlural: isPlural,
        pluralForms: pluralForms != null ? jsonEncode(pluralForms) : null,
      );

      // 验证目标语言不包含主语言
      if (targetLanguages.any((lang) => lang == project.primaryLanguage.code)) {
        throw Exception('目标语言不能包含项目的主语言');
      }

      await _translationService.createTranslationKey(request);
      await loadTranslationEntries();

      Get.snackbar('成功', '翻译键创建成功');
    } catch (error, stackTrace) {
      Get.snackbar('错误', '创建翻译键失败: $error');
      LoggerUtils.error('创建翻译键失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 更新翻译条目
  Future<void> updateTranslationEntryModel(TranslationEntryModel entry, {bool isShowSnackbar = true}) async {
    try {
      await _translationService.updateTranslationEntryModel(entry);

      // 更新本地列表
      final index = _translationEntries.indexWhere((e) => e.uuid == entry.uuid);
      if (index != -1) {
        _translationEntries[index] = entry;
        _applyFilters();
      }

      if (isShowSnackbar) {
        Get.snackbar('成功', '翻译条目更新成功');
      }
    } catch (error, stackTrace) {
      if (isShowSnackbar) {
        Get.snackbar('错误', '更新翻译条目失败: $error');
      }
      LoggerUtils.error('更新翻译条目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 批量更新翻译条目
  Future<void> updateTranslationEntries(List<TranslationEntryModel> entries, {bool isShowSnackbar = true}) async {
    if (entries.isEmpty) return;

    try {
      // 批量更新到服务
      for (final entry in entries) {
        await _translationService.updateTranslationEntryModel(entry);
      }

      // 更新本地列表
      for (final entry in entries) {
        final index = _translationEntries.indexWhere((e) => e.uuid == entry.uuid);
        if (index != -1) {
          _translationEntries[index] = entry;
        }
      }

      // 重新应用筛选
      _applyFilters();

      if (isShowSnackbar) {
        Get.snackbar('成功', '批量更新翻译条目成功');
      }
    } catch (error, stackTrace) {
      Get.snackbar('错误', '批量更新翻译条目失败: $error');
      LoggerUtils.error('批量更新翻译条目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 删除翻译条目
  Future<void> deleteTranslationEntryModel(String entryId) async {
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
        // 先从本地查找条目确认存在
        final entryToDelete = _translationEntries.firstWhereOrNull((e) => e.uuid == entryId);
        if (entryToDelete == null) {
          throw Exception('翻译条目不存在');
        }

        // 使用更高效的删除方法
        await _translationService.deleteTranslationEntryModelFromProject(projectId, entryId);

        // 从本地列表中移除
        _translationEntries.removeWhere((e) => e.uuid == entryId);
        _applyFilters();

        Get.snackbar('成功', '翻译条目删除成功');
      }
    } catch (error, stackTrace) {
      Get.snackbar('错误', '删除翻译条目失败: $error');
      LoggerUtils.error('删除翻译条目失败', error: error, stackTrace: stackTrace);
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
          await _translationService.deleteTranslationEntryModelFromProject(projectId, entryId);
        }

        // 从本地列表中移除
        _translationEntries.removeWhere((e) => entryIds.contains(e.uuid));
        _applyFilters();

        Get.snackbar('成功', '批量删除翻译条目成功');
      }
    } catch (error, stackTrace) {
      Get.snackbar('错误', '批量删除翻译条目失败: $error');
      LoggerUtils.error('批量删除翻译条目失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 搜索翻译条目
  void searchTranslationEntries(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  /// 根据语言筛选
  void filterByLanguage(LanguageEnum? language) {
    _selectedLanguage.value = language;
    _applyFilters();
  }

  /// 根据状态筛选
  void filterByStatus(TranslationStatusEnum? status) {
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
        return entry.entryKey.toLowerCase().contains(query) ||
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

  /// 切换列表类型
  void switchListType(TranslationsListType type) {
    _listType.value = type;
    _applyFilters();
  }

  /// 获取翻译进度统计
  Future<Map<String, int>> getTranslationProgress() async {
    try {
      return await _translationService.getTranslationProgress(projectId);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取翻译进度失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 获取可用的语言列表
  List<LanguageEnum> get availableLanguages {
    final languages = <LanguageEnum>[];
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
  List<TranslationStatusEnum> get availableStatuses {
    return TranslationStatusEnum.values;
  }

  /// 手动触发同步待入库的变更（网络恢复后调用）
  Future<void> syncPendingOperations() async {
    try {
      await TranslationSyncService.instance.init();
      await TranslationSyncService.instance.drain(projectId);
      Get.snackbar('同步完成', '所有待入库的变更已同步到服务器');
    } catch (error, stackTrace) {
      Get.snackbar('同步失败', '请稍后重试: $error');
      LoggerUtils.error('同步待入库变更失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 按翻译键分组条目
  Map<String, List<TranslationEntryModel>> get groupedEntries {
    final grouped = <String, List<TranslationEntryModel>>{};

    for (final entry in _filteredEntries) {
      grouped.putIfAbsent(entry.entryKey, () => []).add(entry);
    }

    // 按键名排序
    final sortedKeys = grouped.keys.toList()..sort();
    final sortedGrouped = <String, List<TranslationEntryModel>>{};

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

  /// 按语言分组条目（包含来源语言）
  Map<LanguageEnum, List<TranslationEntryModel>> get groupedEntriesByLanguage {
    final grouped = <LanguageEnum, List<TranslationEntryModel>>{};

    for (final entry in _filteredEntries) {
      // 只按目标语言分组，避免重复
      grouped.putIfAbsent(entry.targetLanguage, () => []).add(entry);
    }

    if (grouped.isNotEmpty) {
      final sourceLanguage = grouped.entries.first.value.first.sourceLanguage;
      final List<TranslationEntryModel> copy = grouped.entries.first.value
          .map(
            (item) => item.copyWith(
              uuid: item.uuid.replaceAll(item.targetLanguage.code, item.sourceLanguage.code),
              targetLanguage: item.sourceLanguage,
              targetText: item.sourceText,
              status: TranslationStatusEnum.completed,
            ),
          )
          .toList();
      grouped.putIfAbsent(sourceLanguage, () => []).addAll(copy);
    }

    // 按语言的 sortIndex 排序
    final sortedLanguages = grouped.keys.toList()
      ..sort(
        (a, b) {
          final aIndex = a.sortIndex;
          final bIndex = b.sortIndex;
          if (aIndex != bIndex) {
            return aIndex.compareTo(bIndex);
          }
          // 如果 sortIndex 相同，则按语言代码排序
          return a.code.compareTo(b.code);
        },
      );

    final sortedGrouped = <LanguageEnum, List<TranslationEntryModel>>{};

    for (final language in sortedLanguages) {
      // 按翻译键名排序每个语言组内的条目
      final entries = grouped[language]!;
      entries.sort((a, b) => a.entryKey.compareTo(b.entryKey));
      sortedGrouped[language] = entries;
    }

    return sortedGrouped;
  }

  /// 获取翻译条目统计信息
  Map<String, int> get statistics {
    final stats = <String, int>{};

    stats['total'] = _translationEntries.length;
    stats['completed'] = _translationEntries.where((e) => e.status == TranslationStatusEnum.completed).length;
    stats['pending'] = _translationEntries.where((e) => e.status == TranslationStatusEnum.pending).length;
    stats['reviewing'] = _translationEntries.where((e) => e.status == TranslationStatusEnum.reviewing).length;
    stats['translating'] = _translationEntries.where((e) => e.status == TranslationStatusEnum.translating).length;

    return stats;
  }

  /// 获取项目默认语言
  Future<LanguageEnum?> getProjectDefaultLanguage() async {
    try {
      final project = await ProjectsController.getProject(projectId);
      return project?.primaryLanguage.code;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取项目默认语言失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 获取状态颜色
  static Color getStatusColor(TranslationStatusEnum status) {
    switch (status) {
      case TranslationStatusEnum.pending:
        return Colors.orange;
      case TranslationStatusEnum.translating:
        return Colors.yellow;
      case TranslationStatusEnum.completed:
        return Colors.green;
      case TranslationStatusEnum.reviewing:
        return Colors.purple;
      case TranslationStatusEnum.approved:
        return Colors.blue;
    }
  }
}
