import 'dart:convert';
import 'dart:developer';

import 'package:ttpolyglot/src/core/storage/storage_provider.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_parsers/parsers.dart';

/// 翻译服务实现
class TranslationServiceImpl implements TranslationService {
  final StorageService _storageService;

  TranslationServiceImpl(this._storageService);

  /// 从存储提供者创建翻译服务
  static Future<TranslationServiceImpl> create() async {
    try {
      final storageProvider = StorageProvider();
      await storageProvider.initialize();
      return TranslationServiceImpl(storageProvider.storageService);
    } catch (error, stackTrace) {
      log('创建翻译服务失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntry>> getTranslationEntries(
    String projectId, {
    bool includeSourceLanguage = false,
  }) async {
    try {
      final entriesJson = await _storageService.read('projects.$projectId.translations');
      if (entriesJson == null) return [];

      final entriesData = jsonDecode(entriesJson) as List<dynamic>;
      List<TranslationEntry> result =
          entriesData.map((data) => TranslationEntry.fromJson(data as Map<String, dynamic>)).toList();

      if (!includeSourceLanguage) return result;

      if (result.isEmpty) return [];

      final copyLanguageCode = result.first.targetLanguage.code;
      final copyEntries = result.where((item) => item.targetLanguage.code == copyLanguageCode).toList().map(
            (item) => item.copyWith(
              id: item.id.replaceAll(item.targetLanguage.code, item.sourceLanguage.code),
              targetLanguage: item.sourceLanguage,
              targetText: item.sourceText,
              status: TranslationStatus.completed,
            ),
          );

      return [...copyEntries, ...result];
    } catch (error, stackTrace) {
      log('获取翻译条目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<TranslationEntry>> getTranslationEntriesByLanguage(
    String projectId,
    Language targetLanguage, {
    bool includeSourceLanguage = false,
  }) async {
    try {
      final allEntries = await getTranslationEntries(projectId, includeSourceLanguage: includeSourceLanguage);
      return allEntries.where((entry) => entry.targetLanguage.code == targetLanguage.code).toList();
    } catch (error, stackTrace) {
      log('根据语言获取翻译条目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<TranslationEntry>> getTranslationEntriesByStatus(
    String projectId,
    TranslationStatus status,
  ) async {
    try {
      final allEntries = await getTranslationEntries(projectId);
      return allEntries.where((entry) => entry.status == status).toList();
    } catch (error, stackTrace) {
      log('根据状态获取翻译条目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<TranslationEntry> createTranslationEntry(TranslationEntry entry) async {
    try {
      final allEntries = await getTranslationEntries(entry.projectId);
      allEntries.add(entry);
      await _saveTranslationEntries(entry.projectId, allEntries);
      return entry;
    } catch (error, stackTrace) {
      log('创建翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntry>> batchCreateTranslationEntries(
    List<TranslationEntry> entries,
  ) async {
    try {
      if (entries.isEmpty) return [];

      final projectId = entries.first.projectId;
      final allEntries = await getTranslationEntries(projectId);
      allEntries.addAll(entries);
      await _saveTranslationEntries(projectId, allEntries);
      return entries;
    } catch (error, stackTrace) {
      log('批量创建翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntry>> createTranslationKey(
    CreateTranslationKeyRequest request,
  ) async {
    try {
      final entries = TranslationUtils.generateTranslationEntries(request);
      return await batchCreateTranslationEntries(entries);
    } catch (error, stackTrace) {
      log('创建翻译键失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<TranslationEntry> updateTranslationEntry(TranslationEntry entry) async {
    try {
      final allEntries = await getTranslationEntries(entry.projectId);
      final index = allEntries.indexWhere((e) => e.id == entry.id);

      if (index == -1) {
        throw Exception('翻译条目不存在: ${entry.id}');
      }

      allEntries[index] = entry.copyWith(updatedAt: DateTime.now());
      await _saveTranslationEntries(entry.projectId, allEntries);
      return allEntries[index];
    } catch (error, stackTrace) {
      log('更新翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteTranslationEntry(String entryId) async {
    try {
      // 从条目ID中解析项目ID
      final parts = entryId.split('_');
      if (parts.length < 2) {
        throw Exception('无效的翻译条目ID: $entryId');
      }

      final projectId = parts[0];
      final allEntries = await getTranslationEntries(projectId);
      final filteredEntries = allEntries.where((e) => e.id != entryId).toList();

      if (filteredEntries.length == allEntries.length) {
        throw Exception('翻译条目不存在: $entryId');
      }

      await _saveTranslationEntries(projectId, filteredEntries);
    } catch (error, stackTrace) {
      log('删除翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntry>> batchUpdateTranslationEntries(
    List<TranslationEntry> entries,
  ) async {
    try {
      if (entries.isEmpty) return [];

      final projectId = entries.first.projectId;
      final allEntries = await getTranslationEntries(projectId);

      for (final entry in entries) {
        final index = allEntries.indexWhere((e) => e.id == entry.id);
        if (index != -1) {
          allEntries[index] = entry.copyWith(updatedAt: DateTime.now());
        }
      }

      await _saveTranslationEntries(projectId, allEntries);
      return entries;
    } catch (error, stackTrace) {
      log('批量更新翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntry>> searchTranslationEntries(
    String projectId,
    String query, {
    Language? sourceLanguage,
    Language? targetLanguage,
    TranslationStatus? status,
  }) async {
    try {
      final allEntries = await getTranslationEntries(projectId);

      return allEntries.where((entry) {
        // 搜索条件
        final matchesQuery = query.isEmpty ||
            entry.key.toLowerCase().contains(query.toLowerCase()) ||
            entry.sourceText.toLowerCase().contains(query.toLowerCase()) ||
            entry.targetText.toLowerCase().contains(query.toLowerCase());

        final matchesSourceLanguage = sourceLanguage == null || entry.sourceLanguage.code == sourceLanguage.code;

        final matchesTargetLanguage = targetLanguage == null || entry.targetLanguage.code == targetLanguage.code;

        final matchesStatus = status == null || entry.status == status;

        return matchesQuery && matchesSourceLanguage && matchesTargetLanguage && matchesStatus;
      }).toList();
    } catch (error, stackTrace) {
      log('搜索翻译条目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<Map<String, int>> getTranslationProgress(String projectId) async {
    try {
      final allEntries = await getTranslationEntries(projectId);
      final statusCounts = <String, int>{};

      for (final entry in allEntries) {
        final statusKey = entry.status.name;
        statusCounts[statusKey] = (statusCounts[statusKey] ?? 0) + 1;
      }

      return statusCounts;
    } catch (error, stackTrace) {
      log('获取翻译进度失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 同步项目语言变化
  /// 当项目的目标语言发生变化时，同步更新翻译条目
  Future<void> syncProjectLanguages(
    String projectId,
    Language sourceLanguage,
    List<Language> newTargetLanguages,
  ) async {
    try {
      final allEntries = await getTranslationEntries(projectId);

      // 按翻译键分组现有条目
      final groupedEntries = <String, List<TranslationEntry>>{};
      for (final entry in allEntries) {
        if (!groupedEntries.containsKey(entry.key)) {
          groupedEntries[entry.key] = [];
        }
        groupedEntries[entry.key]!.add(entry);
      }

      final updatedEntries = <TranslationEntry>[];

      // 对每个翻译键处理语言同步
      for (final keyGroup in groupedEntries.entries) {
        final key = keyGroup.key;
        final existingEntries = keyGroup.value;

        // 获取源条目（用于创建新语言条目）
        final sourceEntry = existingEntries.firstWhere(
          (entry) => entry.sourceLanguage.code == sourceLanguage.code,
          orElse: () => existingEntries.first,
        );

        // 获取当前已有的目标语言
        final existingTargetLanguages = existingEntries.map((entry) => entry.targetLanguage).toSet();

        // 确定需要添加的语言
        final languagesToAdd = newTargetLanguages
            .where((lang) => !existingTargetLanguages.any((existing) => existing.code == lang.code))
            .toList();

        // 确定需要删除的语言
        final languagesToRemove = existingTargetLanguages
            .where((lang) => !newTargetLanguages.any((newLang) => newLang.code == lang.code))
            .toList();

        // 保留仍然存在的条目
        final entriesToKeep = existingEntries
            .where((entry) => newTargetLanguages.any((lang) => lang.code == entry.targetLanguage.code))
            .toList();

        // 为新语言创建条目
        for (final language in languagesToAdd) {
          final newEntry = TranslationEntry(
            id: _generateId(),
            projectId: projectId,
            key: key,
            sourceLanguage: sourceLanguage,
            sourceText: sourceEntry.sourceText,
            targetLanguage: language,
            targetText: '',
            status: TranslationStatus.pending,
            context: sourceEntry.context,
            comment: sourceEntry.comment,
            maxLength: sourceEntry.maxLength,
            isPlural: sourceEntry.isPlural,
            pluralForms: sourceEntry.pluralForms,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          updatedEntries.add(newEntry);
        }

        // 添加保留的条目
        updatedEntries.addAll(entriesToKeep);

        log('同步翻译键 "$key": 添加 ${languagesToAdd.length} 个语言, 删除 ${languagesToRemove.length} 个语言');
      }

      // 按目标语言的 sortIndex 排序
      updatedEntries.sort((a, b) {
        final aIndex = a.targetLanguage.sortIndex;
        final bIndex = b.targetLanguage.sortIndex;
        if (aIndex != bIndex) {
          return aIndex.compareTo(bIndex);
        }
        return a.key.compareTo(b.key);
      });

      // 保存更新后的翻译条目
      await _saveTranslationEntries(projectId, updatedEntries);

      log('项目语言同步完成: 共 ${updatedEntries.length} 个翻译条目');
    } catch (error, stackTrace) {
      log('同步项目语言失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 生成唯一ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
  }

  /// 保存翻译条目到存储
  Future<void> _saveTranslationEntries(String projectId, List<TranslationEntry> entries) async {
    final entriesJson = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _storageService.write('projects.$projectId.translations', entriesJson);
  }

  // 以下方法暂时不实现，返回默认值或抛出异常
  @override
  Future<String> exportTranslations(
    String projectId,
    Language language, {
    String format = FileFormats.json,
    TranslationKeyStyle keyStyle = TranslationKeyStyle.nested,
    List<TranslationEntry> entries = const [],
  }) async {
    if (entries.isEmpty) {
      entries = await getTranslationEntriesByLanguage(
        projectId,
        language,
        includeSourceLanguage: true,
      );
    }

    entries.sort((a, b) => a.key.compareTo(b.key));

    final jsonParser = ParserFactory.getParser(FileFormats.json);

    final jsonString = await jsonParser.writeString(
      entries,
      language,
      options: {
        'nestedKeyStyle': keyStyle == TranslationKeyStyle.nested,
      },
    );

    log(jsonString, name: language.code);

    return jsonString;
  }

  @override
  Future<List<TranslationEntry>> importTranslations(
    String projectId,
    String filePath, {
    String format = FileFormats.json,
    TranslationKeyStyle keyStyle = TranslationKeyStyle.nested,
  }) async {
    throw UnimplementedError('importTranslations not implemented');
  }

  @override
  Future<TranslationEntry> autoTranslate(TranslationEntry entry, String translationProvider) async {
    throw UnimplementedError('autoTranslate not implemented');
  }

  @override
  Future<List<TranslationEntry>> batchAutoTranslate(List<TranslationEntry> entries, String translationProvider) async {
    throw UnimplementedError('batchAutoTranslate not implemented');
  }

  @override
  Future<Map<String, dynamic>> validateTranslation(TranslationEntry entry) async {
    throw UnimplementedError('validateTranslation not implemented');
  }
}
