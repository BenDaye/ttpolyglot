import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/services/service.dart';
import 'package:ttpolyglot/src/features/features.dart';
import 'package:ttpolyglot_core/core.dart';

/// 翻译控制器
class TranslationController extends GetxController {
  final String projectId;
  TranslationController({required this.projectId});

  final TranslationServiceImpl _translationService = Get.find<TranslationServiceImpl>();

  // 响应式变量
  final _translationEntries = <TranslationEntry>[].obs;
  final _filteredEntries = <TranslationEntry>[].obs;
  final _isLoading = false.obs;
  final _searchQuery = ''.obs;
  final _selectedLanguage = Rxn<Language>();
  final _selectedStatus = Rxn<TranslationStatus>();
  final _listType = TranslationsListType.byKey.obs;

  // Getters
  List<TranslationEntry> get translationEntries => _translationEntries;
  List<TranslationEntry> get filteredEntries => _filteredEntries;
  bool get isLoading => _isLoading.value;
  String get searchQuery => _searchQuery.value;
  Language? get selectedLanguage => _selectedLanguage.value;
  TranslationStatus? get selectedStatus => _selectedStatus.value;
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
      log('初始化翻译服务失败', error: error, stackTrace: stackTrace, name: 'TranslationController');
    }
  }

  /// 当项目语言配置发生变化时，由外部调用此方法刷新数据
  Future<void> onProjectLanguageChanged() async {
    log('项目语言配置已变化，刷新翻译条目...');

    try {
      await loadTranslationEntries();
      log('翻译条目刷新完成');
    } catch (error, stackTrace) {
      log('刷新翻译条目失败', error: error, stackTrace: stackTrace, name: 'TranslationController');
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
      log('加载翻译条目失败', error: error, stackTrace: stackTrace, name: 'TranslationController');
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
      Get.snackbar('错误', '创建翻译键失败: $error');
      log('创建翻译键失败', error: error, stackTrace: stackTrace, name: 'TranslationController');
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
      Get.snackbar('错误', '更新翻译条目失败: $error');
      log('更新翻译条目失败', error: error, stackTrace: stackTrace, name: 'TranslationController');
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
      Get.snackbar('错误', '删除翻译条目失败: $error');
      log('删除翻译条目失败', error: error, stackTrace: stackTrace, name: 'TranslationController');
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
      Get.snackbar('错误', '批量删除翻译条目失败: $error');
      log('批量删除翻译条目失败', error: error, stackTrace: stackTrace, name: 'TranslationController');
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
      log('获取翻译进度失败', error: error, stackTrace: stackTrace, name: 'TranslationController');
      return {};
    }
  }

  /// 获取可用的语言列表
  List<Language> get availableLanguages {
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
  List<TranslationStatus> get availableStatuses {
    return TranslationStatus.values;
  }

  /// 按翻译键分组条目
  Map<String, List<TranslationEntry>> get groupedEntries {
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

  /// 按语言分组条目（包含来源语言）
  Map<Language, List<TranslationEntry>> get groupedEntriesByLanguage {
    final grouped = <Language, List<TranslationEntry>>{};

    for (final entry in _filteredEntries) {
      // 只按目标语言分组，避免重复
      grouped.putIfAbsent(entry.targetLanguage, () => []).add(entry);
    }

    if (grouped.isNotEmpty) {
      final sourceLanguage = grouped.entries.first.value.first.sourceLanguage;
      final List<TranslationEntry> copy = grouped.entries.first.value
          .map(
            (item) => item.copyWith(
              id: item.id.replaceAll(item.targetLanguage.code, item.sourceLanguage.code),
              targetLanguage: item.sourceLanguage,
              targetText: item.sourceText,
              status: TranslationStatus.completed,
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

    final sortedGrouped = <Language, List<TranslationEntry>>{};

    for (final language in sortedLanguages) {
      // 按翻译键名排序每个语言组内的条目
      final entries = grouped[language]!;
      entries.sort((a, b) => a.key.compareTo(b.key));
      sortedGrouped[language] = entries;
    }

    return sortedGrouped;
  }

  /// 获取翻译条目统计信息
  Map<String, int> get statistics {
    final stats = <String, int>{};

    stats['total'] = _translationEntries.length;
    stats['completed'] = _translationEntries.where((e) => e.status == TranslationStatus.completed).length;
    stats['pending'] = _translationEntries.where((e) => e.status == TranslationStatus.pending).length;
    stats['reviewing'] = _translationEntries.where((e) => e.status == TranslationStatus.reviewing).length;
    stats['translating'] = _translationEntries.where((e) => e.status == TranslationStatus.translating).length;

    return stats;
  }

  /// 获取状态颜色
  static Color getStatusColor(TranslationStatus status) {
    switch (status) {
      case TranslationStatus.pending:
        return Colors.orange;
      case TranslationStatus.translating:
        return Colors.blue;
      case TranslationStatus.completed:
        return Colors.green;
      case TranslationStatus.reviewing:
        return Colors.purple;
      case TranslationStatus.rejected:
        return Colors.red;
      case TranslationStatus.needsRevision:
        return Colors.amber;
      case TranslationStatus.outdated:
        return Colors.grey;
    }
  }
}
