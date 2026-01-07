import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/common/utils/translation_utils.dart';
import 'package:ttpolyglot/src/core/services/export_options.dart';
import 'package:ttpolyglot/src/core/services/translation_service.dart';
import 'package:ttpolyglot/src/core/services/translation_sync_service.dart';
import 'package:ttpolyglot/src/core/storage/storage_provider.dart';
import 'package:ttpolyglot/src/core/storage/storage_service.dart';
import 'package:ttpolyglot_parsers/parsers.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 翻译服务实现
class TranslationServiceImpl extends GetxService implements TranslationService {
  final StorageService _storageService;
  final TranslationApi _translationApi = TranslationApi();

  TranslationServiceImpl(this._storageService);

  /// 从存储提供者创建翻译服务
  static Future<TranslationServiceImpl> create() async {
    try {
      final storageProvider = StorageProvider();
      await storageProvider.initialize();
      return TranslationServiceImpl(storageProvider.storageService);
    } catch (error, stackTrace) {
      LoggerUtils.error('创建翻译服务失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntryModel>> getTranslationEntries(
    int projectId, {
    bool includeSourceLanguage = false,
  }) async {
    try {
      // 优先从服务器获取
      if (AppConfig.useServerForTranslations) {
        try {
          final res = await _translationApi.getTranslations(projectId: projectId, page: 1, limit: 1000);
          if (res != null && res.items != null) {
            final items = res.items!;
            if (items.isNotEmpty) {
              if (!includeSourceLanguage) return items;
              final copyLanguageCode = items.first.targetLanguage.code;
              final copyEntries = items
                  .where((item) => item.targetLanguage.code == copyLanguageCode)
                  .map(
                    (item) => item.copyWith(
                      uuid: item.uuid.replaceAll(item.targetLanguage.code, item.sourceLanguage.code),
                      targetLanguage: item.sourceLanguage,
                      targetText: item.sourceText,
                      status: TranslationStatusEnum.completed,
                    ),
                  )
                  .toList();
              return [...copyEntries, ...items];
            }
          }
        } catch (error, stackTrace) {
          log(
            '[getTranslationEntries_api_fallback]',
            error: error,
            stackTrace: stackTrace,
            name: 'TranslationServiceImpl',
          );
        }
      }

      final entriesJson = await _storageService.read('projects.$projectId.translations');
      if (entriesJson == null) return [];

      final entriesData = jsonDecode(entriesJson) as List<dynamic>;

      // 处理旧数据，确保必需字段不为空
      final cleanedData = entriesData.map((data) {
        if (data is Map<String, dynamic>) {
          // 确保 uuid 不为空，如果为空则使用 id 或生成一个
          if (data['uuid'] == null || (data['uuid'] as String).isEmpty) {
            data['uuid'] = data['id']?.toString() ?? 'temp-${DateTime.now().millisecondsSinceEpoch}';
          }
          // 确保 context 和 comment 不为空
          data['context'] = data['context'] ?? '';
          data['comment'] = data['comment'] ?? '';
        }
        return data;
      }).toList();

      List<TranslationEntryModel> result =
          cleanedData.map((data) => TranslationEntryModel.fromJson(data as Map<String, dynamic>)).toList();

      if (!includeSourceLanguage) return result;

      if (result.isEmpty) return [];

      final copyLanguageCode = result.first.targetLanguage.code;
      final copyEntries = result.where((item) => item.targetLanguage.code == copyLanguageCode).toList().map(
            (item) => item.copyWith(
              uuid: item.uuid.replaceAll(item.targetLanguage.code, item.sourceLanguage.code),
              targetLanguage: item.sourceLanguage,
              targetText: item.sourceText,
              status: TranslationStatusEnum.completed,
            ),
          );

      return [...copyEntries, ...result];
    } catch (error, stackTrace) {
      LoggerUtils.error('获取翻译条目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<TranslationEntryModel>> getTranslationEntriesByLanguage(
    int projectId,
    LanguageEnum targetLanguage, {
    bool includeSourceLanguage = false,
  }) async {
    try {
      final allEntries = await getTranslationEntries(projectId, includeSourceLanguage: includeSourceLanguage);
      return allEntries.where((entry) => entry.targetLanguage.code == targetLanguage.code).toList();
    } catch (error, stackTrace) {
      LoggerUtils.error('根据语言获取翻译条目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<List<TranslationEntryModel>> getTranslationEntriesByStatus(
    int projectId,
    TranslationStatusEnum status,
  ) async {
    try {
      final allEntries = await getTranslationEntries(projectId);
      return allEntries.where((entry) => entry.status == status).toList();
    } catch (error, stackTrace) {
      LoggerUtils.error('根据状态获取翻译条目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<TranslationEntryModel> createTranslationEntryModel(TranslationEntryModel entry) async {
    try {
      // API 优先
      if (AppConfig.useServerForTranslations) {
        try {
          final created = await _translationApi.createTranslation(
            projectId: entry.projectId,
            data: entry.toJson(),
          );
          if (created != null) {
            return created;
          }
        } catch (error, stackTrace) {
          log(
            '[createTranslationEntryModel_api_fallback]',
            error: error,
            stackTrace: stackTrace,
            name: 'TranslationServiceImpl',
          );
        }
      }

      // 本地回退
      final allEntries = await getTranslationEntries(entry.projectId);
      final updated = List<TranslationEntryModel>.from(allEntries)..add(entry);
      await _saveTranslationEntries(entry.projectId, updated);
      // 入队待同步
      try {
        await TranslationSyncService.instance.init();
        await TranslationSyncService.instance.enqueue(
          projectId: entry.projectId,
          opType: 'create',
          payload: entry,
        );
      } catch (_) {}
      return entry.copyWith(updatedAt: DateTime.now());
    } catch (error, stackTrace) {
      LoggerUtils.error('创建翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntryModel>> batchCreateTranslationEntries(
    List<TranslationEntryModel> entries,
  ) async {
    try {
      if (entries.isEmpty) return [];

      final projectId = entries.first.projectId;
      final allEntries = await getTranslationEntries(projectId);
      allEntries.addAll(entries);
      await _saveTranslationEntries(projectId, allEntries);
      return entries;
    } catch (error, stackTrace) {
      LoggerUtils.error('批量创建翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntryModel>> createTranslationKey(
    CreateTranslationKeyRequest request,
  ) async {
    try {
      final generated = TranslationUtils.generateTranslationEntries(
        projectId: request.projectId,
        entryKey: request.entryKey,
        sourceText: request.sourceText,
        sourceLanguage: request.sourceLanguage,
        targetLanguages: request.targetLanguages,
        context: request.context,
        maxLength: request.maxLength,
        isPlural: request.isPlural,
        pluralForms: request.pluralForms,
      );
      final created = await _translationApi.batchCreateTranslations(projectId: request.projectId, items: generated);
      if (created == null) {
        throw Exception('创建翻译键失败：API 返回为空');
      }
      return created;
    } catch (error, stackTrace) {
      log(
        '[createTranslationKey]',
        error: error,
        stackTrace: stackTrace,
        name: 'TranslationServiceImpl',
      );
      LoggerUtils.error('创建翻译键失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<TranslationEntryModel> updateTranslationEntryModel(TranslationEntryModel entry) async {
    try {
      // API 优先
      if (AppConfig.useServerForTranslations) {
        try {
          final updated = await _translationApi.updateTranslation(
            projectId: entry.projectId,
            entryId: entry.uuid,
            data: {
              'target_text': entry.targetText,
              'status': entry.status.name,
              if (entry.context.isNotEmpty) 'context_info': entry.context,
            },
          );
          if (updated != null) {
            return updated;
          }
        } catch (error, stackTrace) {
          log(
            '[updateTranslationEntryModel_api_fallback]',
            error: error,
            stackTrace: stackTrace,
            name: 'TranslationServiceImpl',
          );
        }
      }

      // 本地回退
      final allEntries = await getTranslationEntries(entry.projectId);
      final index = allEntries.indexWhere((e) => e.uuid == entry.uuid);
      if (index == -1) {
        throw Exception('翻译条目不存在: ${entry.uuid}');
      }
      final updatedLocal = entry.copyWith(updatedAt: DateTime.now());
      allEntries[index] = updatedLocal;
      await _saveTranslationEntries(entry.projectId, allEntries);
      // 入队待同步
      try {
        await TranslationSyncService.instance.init();
        await TranslationSyncService.instance.enqueue(
          projectId: entry.projectId,
          opType: 'update',
          payload: entry,
        );
      } catch (_) {}
      return updatedLocal;
    } catch (error, stackTrace) {
      LoggerUtils.error('更新翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteTranslationEntryModel(String entryId) async {
    try {
      // 先通过遍历所有项目来查找包含该条目的项目
      String? targetProjectId;

      // 这里需要一个更好的方法来获取项目ID，暂时通过遍历查找
      // 在实际使用中，条目ID应该包含项目信息或者通过其他方式传递项目ID
      final storageKeys = await _storageService.listKeys('projects.');
      for (final key in storageKeys) {
        if (key.startsWith('projects.') && key.endsWith('.translations')) {
          final projectIdStr = key.substring('projects.'.length, key.length - '.translations'.length);
          final projectId = int.tryParse(projectIdStr);
          if (projectId != null) {
            final allEntries = await getTranslationEntries(projectId);

            if (allEntries.any((e) => e.uuid == entryId)) {
              targetProjectId = projectIdStr;
              break;
            }
          }
        }
      }

      if (targetProjectId == null) {
        throw Exception('翻译条目不存在: $entryId');
      }

      final projectIdInt = int.parse(targetProjectId);
      final allEntries = await getTranslationEntries(projectIdInt);
      final filteredEntries = allEntries.where((e) => e.uuid != entryId).toList();

      if (filteredEntries.length == allEntries.length) {
        throw Exception('翻译条目不存在: $entryId');
      }

      await _saveTranslationEntries(projectIdInt, filteredEntries);
      LoggerUtils.info('成功删除翻译条目: $entryId 从项目: $targetProjectId');
    } catch (error, stackTrace) {
      LoggerUtils.error('删除翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除翻译条目（指定项目ID的版本，更高效）
  @override
  Future<void> deleteTranslationEntryModelFromProject(int projectId, String entryId) async {
    try {
      // API 优先
      if (AppConfig.useServerForTranslations) {
        try {
          final ok = await _translationApi.deleteTranslation(projectId: projectId, entryId: entryId);
          if (ok) {
            return;
          }
        } catch (error, stackTrace) {
          log(
            '[deleteTranslationEntryModelFromProject_api_fallback]',
            error: error,
            stackTrace: stackTrace,
            name: 'TranslationServiceImpl',
          );
        }
      }

      // 本地回退
      final allEntries = await getTranslationEntries(projectId);
      final filteredEntries = allEntries.where((e) => e.uuid != entryId).toList();
      if (filteredEntries.length == allEntries.length) {
        throw Exception('翻译条目不存在: $entryId');
      }
      await _saveTranslationEntries(projectId, filteredEntries);
      LoggerUtils.info('成功删除翻译条目: $entryId 从项目: $projectId');
      // 入队待同步
      try {
        await TranslationSyncService.instance.init();
        await TranslationSyncService.instance.enqueue(
          projectId: projectId,
          opType: 'delete',
          payload: TranslationEntryModel(
            projectId: projectId,
            uuid: entryId,
            entryKey: '',
            sourceText: '',
            targetText: '',
            targetLanguage: LanguageEnum.enUS,
            status: TranslationStatusEnum.pending,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      } catch (_) {}
    } catch (error, stackTrace) {
      LoggerUtils.error('删除翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntryModel>> batchUpdateTranslationEntries(
    List<TranslationEntryModel> entries,
  ) async {
    try {
      if (entries.isEmpty) return [];

      final projectId = entries.first.projectId;
      final allEntries = await getTranslationEntries(projectId);

      for (final entry in entries) {
        final index = allEntries.indexWhere((e) => e.uuid == entry.uuid);
        if (index != -1) {
          allEntries[index] = entry.copyWith(updatedAt: DateTime.now());
        }
      }

      await _saveTranslationEntries(projectId, allEntries);
      return entries;
    } catch (error, stackTrace) {
      LoggerUtils.error('批量更新翻译条目失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<TranslationEntryModel>> searchTranslationEntries(
    int projectId, {
    String? query,
    LanguageEnum? language,
    TranslationStatusEnum? status,
  }) async {
    try {
      // API 优先
      if (AppConfig.useServerForTranslations && query != null && query.isNotEmpty) {
        try {
          final models = await _translationApi.searchTranslations(
            projectId: projectId,
            query: query,
            status: status?.name,
            languageCode: language?.code,
          );
          if (models != null) {
            return models;
          }
        } catch (error, stackTrace) {
          log(
            '[searchTranslationEntries_api_fallback]',
            error: error,
            stackTrace: stackTrace,
            name: 'TranslationServiceImpl',
          );
        }
      }

      final allEntries = await getTranslationEntries(projectId);

      return allEntries.where((entry) {
        // 搜索条件
        final matchesQuery = query == null ||
            query.isEmpty ||
            entry.entryKey.toLowerCase().contains(query.toLowerCase()) ||
            entry.sourceText.toLowerCase().contains(query.toLowerCase()) ||
            entry.targetText.toLowerCase().contains(query.toLowerCase());

        final matchesLanguage = language == null ||
            entry.sourceLanguage.code == language.code ||
            entry.targetLanguage.code == language.code;

        final matchesStatus = status == null || entry.status == status;

        return matchesQuery && matchesLanguage && matchesStatus;
      }).toList();
    } catch (error, stackTrace) {
      LoggerUtils.error('搜索翻译条目失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  @override
  Future<Map<String, int>> getTranslationProgress(int projectId) async {
    try {
      final allEntries = await getTranslationEntries(projectId);
      final statusCounts = <String, int>{};

      for (final entry in allEntries) {
        final statusKey = entry.status.name;
        statusCounts[statusKey] = (statusCounts[statusKey] ?? 0) + 1;
      }

      return statusCounts;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取翻译进度失败', error: error, stackTrace: stackTrace);
      return {};
    }
  }

  /// 同步项目语言变化
  /// 当项目的目标语言发生变化时，同步更新翻译条目
  Future<void> syncProjectLanguages(
    int projectId,
    LanguageEnum sourceLanguage,
    List<LanguageEnum> newTargetLanguages,
  ) async {
    try {
      final allEntries = await getTranslationEntries(projectId);

      // 按翻译键分组现有条目
      final groupedEntries = <String, List<TranslationEntryModel>>{};
      for (final entry in allEntries) {
        if (!groupedEntries.containsKey(entry.entryKey)) {
          groupedEntries[entry.entryKey] = [];
        }
        groupedEntries[entry.entryKey]!.add(entry);
      }

      final updatedEntries = <TranslationEntryModel>[];

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
          final newEntry = TranslationEntryModel(
            uuid: _generateId(),
            projectId: projectId,
            entryKey: key,
            sourceLanguage: sourceLanguage,
            sourceText: sourceEntry.sourceText,
            targetLanguage: language,
            targetText: '',
            status: TranslationStatusEnum.pending,
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

        LoggerUtils.info('同步翻译键 "$key": 添加 ${languagesToAdd.length} 个语言, 删除 ${languagesToRemove.length} 个语言');
      }

      // 按目标语言的 sortIndex 排序
      updatedEntries.sort((a, b) {
        final aIndex = a.targetLanguage.sortIndex;
        final bIndex = b.targetLanguage.sortIndex;
        if (aIndex != bIndex) {
          return aIndex.compareTo(bIndex);
        }
        return a.entryKey.compareTo(b.entryKey);
      });

      // 保存更新后的翻译条目
      await _saveTranslationEntries(projectId, updatedEntries);

      LoggerUtils.info('项目语言同步完成: 共 ${updatedEntries.length} 个翻译条目');
    } catch (error, stackTrace) {
      LoggerUtils.error('同步项目语言失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 生成唯一ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        (DateTime.now().microsecond % 1000).toString().padLeft(3, '0');
  }

  /// 保存翻译条目到存储
  Future<void> _saveTranslationEntries(int projectId, List<TranslationEntryModel> entries) async {
    final entriesJson = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _storageService.write('projects.$projectId.translations', entriesJson);
  }

  // 以下方法暂时不实现，返回默认值或抛出异常
  @override
  Future<String> exportTranslations(
    int projectId,
    LanguageEnum language, {
    String format = FileFormats.json,
    TranslationKeyStyle keyStyle = TranslationKeyStyle.nested,
    List<TranslationEntryModel> entries = const [],
  }) async {
    if (entries.isEmpty) {
      entries = await getTranslationEntriesByLanguage(
        projectId,
        language,
        includeSourceLanguage: true,
      );
    }

    entries.sort((a, b) => a.entryKey.compareTo(b.entryKey));

    final jsonParser = ParserFactory.getParser(FileFormats.json);

    final jsonString = await jsonParser.writeString(
      entries,
      language,
      options: {
        'nestedKeyStyle': keyStyle == TranslationKeyStyle.nested,
      },
    );

    LoggerUtils.info('导出翻译: ${language.code}');

    return jsonString;
  }

  @override
  Future<List<TranslationEntryModel>> importTranslations(
    int projectId,
    String filePath, {
    String format = FileFormats.json,
    TranslationKeyStyle keyStyle = TranslationKeyStyle.nested,
  }) async {
    try {
      LoggerUtils.info('开始导入翻译文件: $filePath, 格式: $format');

      // 获取解析器
      final parser = ParserFactory.getParser(format);

      // 解析文件
      final parseResult = await parser.parseFile(filePath);

      if (parseResult.entries.isEmpty) {
        LoggerUtils.info('文件解析结果为空: $filePath');
        return [];
      }

      LoggerUtils.info('解析到 ${parseResult.entries.length} 个翻译条目');

      // 获取现有翻译条目进行冲突检测
      final existingEntries = await getTranslationEntries(projectId);
      final existingKeys = existingEntries.map((e) => e.entryKey).toSet();

      final importedEntries = <TranslationEntryModel>[];
      final conflictEntries = <TranslationEntryModel>[];
      final newEntries = <TranslationEntryModel>[];

      // 分类处理解析出的条目
      for (final parsedEntry in parseResult.entries) {
        // 更新条目的 projectId
        final entry = parsedEntry.copyWith(
          projectId: projectId,
          uuid: _generateId(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (existingKeys.contains(entry.entryKey)) {
          // 发现冲突的条目
          conflictEntries.add(entry);
          LoggerUtils.info('发现冲突翻译键: ${entry.entryKey}');
        } else {
          // 新的条目
          newEntries.add(entry);
        }
      }

      // 批量创建新条目
      if (newEntries.isNotEmpty) {
        final createdEntries = await batchCreateTranslationEntries(newEntries);
        importedEntries.addAll(createdEntries);
        LoggerUtils.info('成功创建 ${createdEntries.length} 个新翻译条目');
      }

      // 处理冲突条目（暂时跳过，后续实现冲突解决机制）
      if (conflictEntries.isNotEmpty) {
        LoggerUtils.info('跳过 ${conflictEntries.length} 个冲突翻译条目（功能待实现）');
        // TODO: 实现冲突解决机制
      }

      // 输出警告信息
      if (parseResult.warnings.isNotEmpty) {
        for (final warning in parseResult.warnings) {
          LoggerUtils.info('解析警告: $warning');
        }
      }

      LoggerUtils.info('导入完成，共导入 ${importedEntries.length} 个翻译条目');
      return importedEntries;
    } catch (error, stackTrace) {
      LoggerUtils.error('导入翻译文件失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<TranslationEntryModel> autoTranslate(TranslationEntryModel entry, String translationProvider) async {
    throw UnimplementedError('autoTranslate not implemented');
  }

  @override
  Future<List<TranslationEntryModel>> batchAutoTranslate(
    List<TranslationEntryModel> entries,
    String translationProvider,
  ) async {
    throw UnimplementedError('batchAutoTranslate not implemented');
  }

  @override
  Future<Map<String, dynamic>> validateTranslation(TranslationEntryModel entry) async {
    throw UnimplementedError('validateTranslation not implemented');
  }
}
