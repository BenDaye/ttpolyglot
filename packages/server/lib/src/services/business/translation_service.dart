import 'dart:convert';

import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_translators/translators.dart';

import '../base_service.dart';
import '../infrastructure/database_service.dart';

/// 翻译服务
class TranslationService extends BaseService {
  final DatabaseService _databaseService;

  TranslationService({
    required DatabaseService databaseService,
  })  : _databaseService = databaseService,
        super('TranslationService');

  /// 从数据库行数据组装 TranslationEntryModel（包括目标语言）
  /// 构建翻译条目模型
  ///
  /// [projectLanguageCodes] 项目所有语言代码列表，传入时补全缺失语言（text 为空）
  Future<TranslationEntryModel> _buildTranslationEntryModel(
    Map<String, dynamic> entryData, {
    List<String>? projectLanguageCodes,
  }) async {
    // 从 target_languages JSONB 字段读取数据
    final targetLanguagesJson = entryData['target_languages'];
    List<TranslationTargetLanguageModel> targetLanguages = [];

    if (targetLanguagesJson != null) {
      if (targetLanguagesJson is String) {
        final decoded = jsonDecode(targetLanguagesJson) as List<dynamic>?;
        if (decoded != null) {
          targetLanguages =
              decoded.map((item) => TranslationTargetLanguageModel.fromJson(item as Map<String, dynamic>)).toList();
        }
      } else if (targetLanguagesJson is List) {
        targetLanguages = targetLanguagesJson
            .map((item) => TranslationTargetLanguageModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    // 将源语言插入 target_languages 首位
    final sourceLanguage = entryData['source_language']?.toString() ?? 'en_US';
    final sourceText = entryData['source_text']?.toString() ?? '';
    if (!targetLanguages.any((t) => t.language.code == sourceLanguage)) {
      targetLanguages.insert(
        0,
        TranslationTargetLanguageModel(
          language: LanguageEnumConverter().fromJson(sourceLanguage),
          text: sourceText,
        ),
      );
    }

    // 补全项目中缺失的语言（text 为空）
    if (projectLanguageCodes != null) {
      for (final code in projectLanguageCodes) {
        if (!targetLanguages.any((t) => t.language.code == code)) {
          targetLanguages.add(
            TranslationTargetLanguageModel(
              language: LanguageEnumConverter().fromJson(code),
              text: '',
            ),
          );
        }
      }
    }

    // 组装完整数据
    final fullData = Map<String, dynamic>.from(entryData);
    fullData['target_languages'] = targetLanguages.map((t) => t.toJson()).toList();

    return TranslationEntryModel.fromJson(fullData);
  }

  /// 批量创建翻译条目
  Future<List<TranslationEntryModel>> batchCreateTranslations({
    required int projectId,
    required List<Map<String, dynamic>> items,
  }) async {
    return execute<List<TranslationEntryModel>>(
      () async {
        logInfo('批量创建翻译条目', context: {'project_id': projectId, 'count': items.length});

        final created = <TranslationEntryModel>[];

        await _databaseService.transaction(() async {
          for (final raw in items) {
            final data = Map<String, dynamic>.from(raw);
            final entryKey = (data['entry_key'] ?? data['key'])?.toString();
            final languageCode = (data['language_code'] ?? data['target_language'] ?? data['lang'])?.toString();
            final sourceText = data['source_text']?.toString() ?? '';
            final targetText = data['target_text']?.toString() ?? '';
            final sourceLanguage = (data['source_language']?.toString() ?? 'en_US');
            final translatorId = data['translator_id']?.toString();
            final contextInfo = data['context_info']?.toString() ?? data['context']?.toString() ?? '';

            if (entryKey == null || entryKey.trim().isEmpty) {
              throwBusiness('entry_key 不能为空');
            }
            if (languageCode == null || languageCode.trim().isEmpty) {
              throwBusiness('language_code 不能为空');
            }

            // 幂等检查：若已存在则跳过并取现有记录
            final existing = await _databaseService.query('''
              SELECT te.id, COALESCE(te.uuid::text, te.id::text) as uuid, te.project_id,
                     COALESCE(te.entry_key, '') as entry_key, 
                     COALESCE(te.source_language, 'en_US') as source_language,
                     COALESCE(te.source_text, '') as source_text,
                     COALESCE(te.target_languages::text, '[]') as target_languages,
                     te.translated_by, te.reviewed_by, 
                     COALESCE(te.context, '') as context,
                     COALESCE(te.comment, '') as comment,
                     COALESCE(te.sort_index, 0) as sort_index,
                     te.deleted_at, te.created_at, te.updated_at,
                     u_translator.username as translator_username,
                     u_reviewer.username as reviewer_username
              FROM {translation_entries} te
              LEFT JOIN {users} u_translator ON te.translated_by = u_translator.id
              LEFT JOIN {users} u_reviewer ON te.reviewed_by = u_reviewer.id
              WHERE te.project_id = @project_id AND te.entry_key = @entry_key AND te.deleted_at IS NULL
            ''', {
              'project_id': projectId,
              'entry_key': entryKey,
            });

            if (existing.isNotEmpty) {
              final existingData = existing.first.toColumnMap();
              final entry = await _buildTranslationEntryModel(existingData);
              created.add(entry);
              continue;
            }

            // 构建 target_languages JSONB 数据
            final targetLanguagesJson = targetText.isNotEmpty
                ? jsonEncode([
                    {'language': languageCode, 'text': targetText}
                  ])
                : '[]';

            // 插入翻译条目
            final entryResult = await _databaseService.query('''
              INSERT INTO {translation_entries} (
                project_id, entry_key, source_language, source_text,
                translated_by, context, target_languages
              ) VALUES (
                @project_id, @entry_key, @source_language, @source_text,
                @translator_id, @context_info, @target_languages::jsonb
              )
              RETURNING id, COALESCE(uuid::text, id::text) as uuid, project_id, 
                        COALESCE(entry_key, '') as entry_key, 
                        COALESCE(source_language, 'en_US') as source_language, 
                        COALESCE(source_text, '') as source_text,
                        COALESCE(target_languages::text, '[]') as target_languages,
                        translated_by, reviewed_by, 
                        COALESCE(context, '') as context, 
                        COALESCE(comment, '') as comment,
                        COALESCE(sort_index, 0) as sort_index,
                        deleted_at, created_at, updated_at
            ''', {
              'project_id': projectId,
              'entry_key': entryKey,
              'source_language': sourceLanguage,
              'source_text': sourceText,
              'translator_id': translatorId,
              'context_info': contextInfo,
              'target_languages': targetLanguagesJson,
            });

            final entryData = entryResult.first.toColumnMap();

            // 组装完整数据
            final entry = await _buildTranslationEntryModel(entryData);
            created.add(entry);
          }
        });

        await _updateProjectStats(projectId);
        logInfo('批量创建翻译成功', context: {'count': created.length});
        return created;
      },
      operationName: 'batchCreateTranslations',
    );
  }

  /// 获取翻译条目（传统分页，保留向后兼容）
  Future<PagerModel<TranslationEntryModel>> getTranslationEntries({
    required int projectId,
    String? languageCode,
    String? status,
    String? translatorId,
    String? reviewerId,
    int page = 1,
    int limit = 50,
    String? search,
  }) async {
    return execute(
      () async {
        logInfo('获取翻译条目', context: {
          'project_id': projectId,
          'language_code': languageCode,
          'page': page,
        });

        // 构建查询条件
        final conditions = <String>['te.project_id = @project_id', 'te.deleted_at IS NULL'];
        final parameters = <String, dynamic>{'project_id': projectId};

        if (languageCode != null && languageCode.isNotEmpty) {
          conditions.add(
              'EXISTS (SELECT 1 FROM jsonb_array_elements(COALESCE(te.target_languages, \'[]\'::jsonb)) AS elem WHERE elem->>\'language\' = @language_code)');
          parameters['language_code'] = languageCode;
        }

        if (translatorId != null && translatorId.isNotEmpty) {
          conditions.add('te.translated_by = @translator_id');
          parameters['translator_id'] = translatorId;
        }

        if (reviewerId != null && reviewerId.isNotEmpty) {
          conditions.add('te.reviewed_by = @reviewer_id');
          parameters['reviewer_id'] = reviewerId;
        }

        if (search != null && search.isNotEmpty) {
          conditions.add('(te.entry_key ILIKE @search OR te.source_text ILIKE @search)');
          parameters['search'] = '%$search%';
        }

        // 计算总数
        final countSql = '''
        SELECT COUNT(*) FROM {translation_entries} te
        WHERE ${conditions.join(' AND ')}
      ''';

        final countResult = await _databaseService.query(countSql, parameters);
        // COUNT(*) 返回的可能是 int 或 bigint，需要安全转换
        final totalRaw = countResult.first[0];
        final total = (totalRaw is int) ? totalRaw : int.parse(totalRaw.toString());

        // 获取分页数据
        final offset = (page - 1) * limit;
        parameters['limit'] = limit;
        parameters['offset'] = offset;

        final sql = '''
        SELECT
          te.id,
          COALESCE(te.uuid::text, te.id::text) as uuid,
          te.project_id,
          COALESCE(te.entry_key, '') as entry_key,
          COALESCE(te.source_language, 'en_US') as source_language,
          COALESCE(te.source_text, '') as source_text,
          COALESCE(te.target_languages::text, '[]') as target_languages,
          te.translated_by,
          te.reviewed_by,
          COALESCE(te.context, '') as context,
          COALESCE(te.comment, '') as comment,
          COALESCE(te.sort_index, 0) as sort_index,
          te.deleted_at,
          te.created_at,
          te.updated_at,
          u_translator.username as translator_username,
          u_reviewer.username as reviewer_username
        FROM {translation_entries} te
        LEFT JOIN {users} u_translator ON te.translated_by = u_translator.id
        LEFT JOIN {users} u_reviewer ON te.reviewed_by = u_reviewer.id
        WHERE ${conditions.join(' AND ')}
        ORDER BY te.sort_index ASC, te.updated_at DESC, te.id DESC
        LIMIT @limit OFFSET @offset
      ''';

        final result = await _databaseService.query(sql, parameters);

        // 查询项目所有语言代码，用于补全缺失语言
        final langResult = await _databaseService.query('''
          SELECT l.code FROM {project_languages} pl
          JOIN {languages} l ON pl.language_id = l.id
          WHERE pl.project_id = @project_id
        ''', {'project_id': projectId});
        final projectLanguageCodes = langResult.map((r) => r[0].toString()).toList();

        // 组装完整的翻译条目数据
        final entries = <TranslationEntryModel>[];
        for (final row in result) {
          final data = row.toColumnMap();
          final entry = await _buildTranslationEntryModel(data, projectLanguageCodes: projectLanguageCodes);
          entries.add(entry);
        }

        return PagerModel<TranslationEntryModel>(
          page: page,
          pageSize: limit,
          totalSize: total,
          totalPage: (total / limit).ceil(),
          items: entries,
        );
      },
      operationName: 'getTranslationEntries',
    );
  }

  /// 获取翻译条目（游标分页，性能优化版）
  ///
  /// 使用游标分页替代传统OFFSET分页，在大数据量下性能更好
  /// cursor 格式："{id}_{updated_at_iso8601}"
  Future<Map<String, dynamic>> getTranslationEntriesCursor({
    required int projectId,
    String? cursor,
    int limit = 50,
    String? languageCode,
    String? search,
  }) async {
    return execute(
      () async {
        logInfo('获取翻译条目（游标分页）', context: {
          'project_id': projectId,
          'cursor': cursor,
          'limit': limit,
        });

        // 构建查询条件
        final conditions = <String>['te.project_id = @project_id', 'te.deleted_at IS NULL'];
        final parameters = <String, dynamic>{
          'project_id': projectId,
          'limit': limit + 1, // 多查询1条用于判断是否有下一页
        };

        // 解析游标
        int? lastId;
        DateTime? lastUpdatedAt;
        if (cursor != null && cursor.isNotEmpty) {
          final parts = cursor.split('_');
          if (parts.length >= 2) {
            lastId = int.tryParse(parts[0]);
            lastUpdatedAt = DateTime.tryParse(parts.sublist(1).join('_'));

            if (lastId != null && lastUpdatedAt != null) {
              // 使用复合条件进行游标分页
              conditions.add('(te.updated_at, te.id) < (@last_updated_at, @last_id)');
              parameters['last_updated_at'] = lastUpdatedAt;
              parameters['last_id'] = lastId;
            }
          }
        }

        // 其他过滤条件
        if (languageCode != null && languageCode.isNotEmpty) {
          conditions.add(
              'EXISTS (SELECT 1 FROM jsonb_array_elements(COALESCE(te.target_languages, \'[]\'::jsonb)) AS elem WHERE elem->>\'language\' = @language_code)');
          parameters['language_code'] = languageCode;
        }

        // 全文搜索（使用优化的索引）
        if (search != null && search.isNotEmpty) {
          conditions.add('''to_tsvector('simple', coalesce(te.source_text, ''))
               @@ plainto_tsquery('simple', @search)''');
          parameters['search'] = search;
        }

        final sql = '''
        SELECT
          te.id,
          COALESCE(te.uuid::text, te.id::text) as uuid,
          te.project_id,
          COALESCE(te.entry_key, '') as entry_key,
          COALESCE(te.source_language, 'en_US') as source_language,
          COALESCE(te.source_text, '') as source_text,
          COALESCE(te.target_languages::text, '[]') as target_languages,
          te.translated_by,
          te.reviewed_by,
          COALESCE(te.context, '') as context,
          COALESCE(te.comment, '') as comment,
          COALESCE(te.sort_index, 0) as sort_index,
          te.deleted_at,
          te.created_at,
          te.updated_at,
          u_translator.username as translator_username,
          u_reviewer.username as reviewer_username
        FROM {translation_entries} te
        LEFT JOIN {users} u_translator ON te.translated_by = u_translator.id
        LEFT JOIN {users} u_reviewer ON te.reviewed_by = u_reviewer.id
        WHERE ${conditions.join(' AND ')}
        ORDER BY te.sort_index ASC, te.updated_at DESC, te.id DESC
        LIMIT @limit
      ''';

        final result = await _databaseService.query(sql, parameters);

        // 判断是否有下一页
        final hasNextPage = result.length > limit;
        final entries = hasNextPage ? result.take(limit).toList() : result;

        // 查询项目所有语言代码，用于补全缺失语言
        final langResult = await _databaseService.query('''
          SELECT l.code FROM {project_languages} pl
          JOIN {languages} l ON pl.language_id = l.id
          WHERE pl.project_id = @project_id
        ''', {'project_id': projectId});
        final projectLanguageCodes = langResult.map((r) => r[0].toString()).toList();

        // 组装完整的翻译条目数据
        final entriesList = <TranslationEntryModel>[];
        for (final row in entries) {
          final data = row.toColumnMap();
          final entry = await _buildTranslationEntryModel(data, projectLanguageCodes: projectLanguageCodes);
          entriesList.add(entry);
        }

        // 生成下一页的游标
        String? nextCursor;
        if (hasNextPage && entries.isNotEmpty) {
          final lastEntry = entries.last.toColumnMap();
          final id = lastEntry['id'];
          final updatedAt = lastEntry['updated_at'] as DateTime;
          nextCursor = '${id}_${updatedAt.toIso8601String()}';
        }

        return {
          'entries': entriesList.map((e) => e.toJson()).toList(),
          'cursor': {
            'nextCursor': nextCursor,
            'hasNextPage': hasNextPage,
            'limit': limit,
          },
        };
      },
      operationName: 'getTranslationEntriesCursor',
    );
  }

  /// 根据ID获取翻译条目详情
  Future<TranslationEntryModel?> getTranslationEntryById(String entryId) async {
    return execute<TranslationEntryModel?>(
      () async {
        logInfo('获取翻译条目详情', context: {'entry_id': entryId});

        // 判断 entryId 是数字 ID 还是 UUID
        final isNumericId = int.tryParse(entryId) != null;

        final sql = '''
        SELECT
          te.id,
          COALESCE(te.uuid::text, te.id::text) as uuid,
          te.project_id,
          COALESCE(te.entry_key, '') as entry_key,
          COALESCE(te.source_language, 'en_US') as source_language,
          COALESCE(te.source_text, '') as source_text,
          COALESCE(te.target_languages::text, '[]') as target_languages,
          te.translated_by,
          te.reviewed_by,
          COALESCE(te.context, '') as context,
          COALESCE(te.comment, '') as comment,
          COALESCE(te.sort_index, 0) as sort_index,
          te.deleted_at,
          te.created_at,
          te.updated_at,
          u_translator.username as translator_username,
          u_reviewer.username as reviewer_username
        FROM {translation_entries} te
        LEFT JOIN {users} u_translator ON te.translated_by = u_translator.id
        LEFT JOIN {users} u_reviewer ON te.reviewed_by = u_reviewer.id
        WHERE ${isNumericId ? 'te.id = @entry_id' : 'te.uuid::text = @entry_id'} AND te.deleted_at IS NULL
      ''';

        final result = await _databaseService.query(sql, {'entry_id': entryId});

        if (result.isEmpty) {
          return null;
        }

        final resultData = result.first.toColumnMap();
        final projectId = resultData['project_id'];

        // 查询项目所有语言代码，用于补全缺失语言
        final langResult = await _databaseService.query('''
          SELECT l.code FROM {project_languages} pl
          JOIN {languages} l ON pl.language_id = l.id
          WHERE pl.project_id = @project_id
        ''', {'project_id': projectId});
        final projectLanguageCodes = langResult.map((r) => r[0].toString()).toList();

        return await _buildTranslationEntryModel(resultData, projectLanguageCodes: projectLanguageCodes);
      },
      operationName: 'getTranslationEntryById',
    );
  }

  /// 创建翻译条目
  Future<TranslationEntryModel> createTranslationEntry({
    required int projectId,
    required String entryKey,
    required String languageCode,
    String? sourceText,
    String? targetText,
    String? translatorId,
    String? contextInfo,
  }) async {
    return execute<TranslationEntryModel>(
      () async {
        logInfo('创建翻译条目', context: {
          'entry_key': entryKey,
          'language_code': languageCode,
        });

        // 检查是否已存在相同的条目
        final existing = await _databaseService.query('''
        SELECT id FROM {translation_entries}
        WHERE project_id = @project_id AND entry_key = @entry_key AND deleted_at IS NULL
      ''', {
          'project_id': projectId,
          'entry_key': entryKey,
        });

        if (existing.isNotEmpty) {
          throwConflict('翻译条目已存在');
        }

        // 构建 target_languages JSONB 数据
        final targetLanguagesJson = (targetText != null && targetText.isNotEmpty)
            ? jsonEncode([
                {'language': languageCode, 'text': targetText}
              ])
            : '[]';

        // 创建翻译条目
        final result = await _databaseService.query('''
        INSERT INTO {translation_entries} (
          project_id, entry_key, source_language, source_text,
          translated_by, context, target_languages
        ) VALUES (
          @project_id, @entry_key, @source_language, @source_text,
          @translator_id, @context_info, @target_languages::jsonb
        ) RETURNING id, COALESCE(uuid::text, id::text) as uuid, project_id, 
                    COALESCE(entry_key, '') as entry_key, 
                    COALESCE(source_language, 'en_US') as source_language, 
                    COALESCE(source_text, '') as source_text,
                    COALESCE(target_languages::text, '[]') as target_languages,
                    translated_by, reviewed_by, 
                    COALESCE(context, '') as context, 
                    COALESCE(comment, '') as comment,
                    COALESCE(sort_index, 0) as sort_index,
                    deleted_at, created_at, updated_at
      ''', {
          'project_id': projectId,
          'entry_key': entryKey,
          'source_language': 'en_US',
          'source_text': sourceText ?? '',
          'translator_id': translatorId,
          'context_info': contextInfo ?? '',
          'target_languages': targetLanguagesJson,
        });

        final resultData = result.first.toColumnMap();

        final entry = await _buildTranslationEntryModel(resultData);

        // 更新项目统计信息
        await _updateProjectStats(projectId);

        logInfo('翻译条目创建成功', context: {'entry_id': entry.uuid});

        return entry;
      },
      operationName: 'createTranslationEntry',
    );
  }

  /// 更新翻译条目
  Future<TranslationEntryModel> updateTranslationEntry({
    required String entryId,
    List<TranslationTargetLanguageModel>? targetLanguages,
    String? sourceText,
    String? contextInfo,
    String? comment,
    String? translatorId,
    String? reviewerId,
    int? sortIndex,
    String? updatedBy,
  }) async {
    return execute<TranslationEntryModel>(
      () async {
        logInfo('更新翻译条目', context: {'entry_id': entryId});

        final existing = await getTranslationEntryById(entryId);
        if (existing == null) {
          throwNotFound('翻译条目不存在');
        }

        // 判断 entryId 是数字 ID 还是 UUID
        final isNumericId = int.tryParse(entryId) != null;
        final whereClause = isNumericId ? 'id = @entry_id' : 'uuid::text = @entry_id';

        // 构建更新字段
        final updates = <String>[];
        final parameters = <String, dynamic>{'entry_id': entryId};

        if (sourceText != null) {
          updates.add('source_text = @source_text');
          parameters['source_text'] = sourceText;
        }

        if (contextInfo != null) {
          updates.add('context = @context_info');
          parameters['context_info'] = contextInfo;
        }

        if (comment != null) {
          updates.add('comment = @comment');
          parameters['comment'] = comment;
        }

        if (translatorId != null) {
          updates.add('translated_by = @translator_id');
          parameters['translator_id'] = translatorId;
        }

        if (reviewerId != null) {
          updates.add('reviewed_by = @reviewer_id');
          parameters['reviewer_id'] = reviewerId;
        }

        if (sortIndex != null) {
          updates.add('sort_index = @sort_index');
          parameters['sort_index'] = sortIndex;
        }

        // 更新目标语言翻译（合并模式：传入的语言更新/新增，未传入的语言保留）
        // 注意：排除源语言，源语言不存入数据库的 target_languages
        if (targetLanguages != null) {
          final sourceLanguageCode = existing.sourceLanguage.code;

          // 从数据库原始数据获取（不含源语言）
          final existingTargets = existing.targetLanguages
              .where((t) => t.language.code != sourceLanguageCode)
              .map((t) => {'language': t.language.code, 'text': t.text})
              .toList();

          for (final incoming in targetLanguages) {
            final code = incoming.language.code;
            // 跳过源语言
            if (code == sourceLanguageCode) continue;
            final idx = existingTargets.indexWhere((t) => t['language'] == code);
            if (idx >= 0) {
              existingTargets[idx] = {'language': code, 'text': incoming.text};
            } else {
              existingTargets.add({'language': code, 'text': incoming.text});
            }
          }

          updates.add('target_languages = @target_languages::jsonb');
          parameters['target_languages'] = jsonEncode(existingTargets);
        }

        if (updates.isEmpty) {
          return existing;
        }

        await _databaseService.query('''
          UPDATE {translation_entries}
          SET ${updates.join(', ')}, updated_at = CURRENT_TIMESTAMP
          WHERE $whereClause
        ''', parameters);

        // 获取更新后的完整数据
        final updatedEntry = await getTranslationEntryById(entryId);
        if (updatedEntry == null) {
          throwNotFound('翻译条目不存在');
        }

        // 记录翻译历史
        await _recordTranslationHistory(updatedEntry, updatedBy);

        // 更新项目统计信息
        await _updateProjectStats(updatedEntry.projectId);

        logInfo('翻译条目更新成功', context: {'entry_id': entryId});

        return updatedEntry;
      },
      operationName: 'updateTranslationEntry',
    );
  }

  /// 删除翻译条目
  ///
  /// 注意：此操作是幂等的，如果条目不存在，视为删除成功
  Future<void> deleteTranslationEntry(String entryId, {String? deletedBy}) async {
    return execute(
      () async {
        logInfo('删除翻译条目', context: {'entry_id': entryId});

        // 获取条目信息以便记录历史
        final entry = await getTranslationEntryById(entryId);
        if (entry == null) {
          // 幂等性：如果条目不存在，视为删除成功，记录日志但不抛出异常
          logInfo('翻译条目不存在，视为删除成功', context: {'entry_id': entryId});
          return;
        }

        // 记录删除历史
        await _recordTranslationHistory(entry, deletedBy, changeType: 'delete');

        // 删除条目（支持通过 ID 或 UUID 删除）
        final isNumericId = int.tryParse(entryId) != null;
        final deleteSql = isNumericId
            ? 'DELETE FROM {translation_entries} WHERE id = @entry_id'
            : 'DELETE FROM {translation_entries} WHERE uuid::text = @entry_id';
        await _databaseService.query(deleteSql, {'entry_id': entryId});

        // 更新项目统计信息
        await _updateProjectStats(entry.projectId);

        logInfo('翻译条目删除成功', context: {'entry_id': entryId});
      },
      operationName: 'deleteTranslationEntry',
    );
  }

  /// 批量更新翻译条目
  Future<List<TranslationEntryModel>> bulkUpdateTranslationEntries({
    required List<String> entryIds,
    String? translatorId,
    String? reviewerId,
    String? updatedBy,
  }) async {
    return execute<List<TranslationEntryModel>>(
      () async {
        logInfo('批量更新翻译条目', context: {'count': entryIds.length});

        final updatedEntries = <TranslationEntryModel>[];

        await _databaseService.transaction(() async {
          for (final entryId in entryIds) {
            final entry = await getTranslationEntryById(entryId);
            if (entry == null) continue;

            // 构建更新数据
            final hasUpdates = translatorId != null || reviewerId != null;

            if (hasUpdates) {
              final updatedEntry = await updateTranslationEntry(
                entryId: entryId,
                updatedBy: updatedBy,
                translatorId: translatorId,
                reviewerId: reviewerId,
              );
              updatedEntries.add(updatedEntry);
            }
          }
        });

        logInfo('批量更新完成', context: {'count': updatedEntries.length});

        return updatedEntries;
      },
      operationName: 'bulkUpdateTranslationEntries',
    );
  }

  /// 获取翻译历史
  Future<List<Map<String, dynamic>>> getTranslationHistory(
    String entryId, {
    int limit = 50,
  }) async {
    return execute(
      () async {
        logInfo('获取翻译历史', context: {'entry_id': entryId});

        const sql = '''
        SELECT
          th.*,
          u.username as changed_by_username
        FROM {translation_history} th
        LEFT JOIN {users} u ON th.changed_by = u.id
        WHERE th.translation_entry_id = @entry_id
        ORDER BY th.created_at DESC
        LIMIT @limit
      ''';

        final result = await _databaseService.query(sql, {
          'entry_id': entryId,
          'limit': limit,
        });

        return result.map((row) => row.toColumnMap()).toList();
      },
      operationName: 'getTranslationHistory',
    );
  }

  /// 获取项目翻译统计
  Future<Map<String, dynamic>> getProjectTranslationStats(int projectId) async {
    return execute(
      () async {
        logInfo('获取项目翻译统计', context: {'project_id': projectId});

        final sql = '''
        SELECT
          COUNT(DISTINCT te.id) as total_entries,
          COUNT(DISTINCT CASE 
            WHEN EXISTS (
              SELECT 1 
              FROM jsonb_array_elements(COALESCE(te.target_languages, '[]'::jsonb)) AS elem 
              WHERE elem->>'text' IS NOT NULL AND elem->>'text' != ''
            ) THEN te.id 
          END) as completed_entries,
          COUNT(DISTINCT CASE 
            WHEN NOT EXISTS (
              SELECT 1 
              FROM jsonb_array_elements(COALESCE(te.target_languages, '[]'::jsonb)) AS elem 
              WHERE elem->>'text' IS NOT NULL AND elem->>'text' != ''
            ) THEN te.id 
          END) as pending_entries,
          COALESCE(SUM(LENGTH(te.source_text)), 0) as total_source_characters,
          COALESCE(SUM(
            (SELECT SUM(LENGTH(COALESCE(elem->>'text', '')))
             FROM jsonb_array_elements(COALESCE(te.target_languages, '[]'::jsonb)) AS elem)
          ), 0) as total_target_characters
        FROM {translation_entries} te
        WHERE te.project_id = @project_id AND te.deleted_at IS NULL
      ''';

        final result = await _databaseService.query(sql, {'project_id': projectId});
        return result.first.toColumnMap();
      },
      operationName: 'getProjectTranslationStats',
    );
  }

  /// 记录翻译历史
  Future<void> _recordTranslationHistory(
    TranslationEntryModel entry,
    String? changedBy, {
    String changeType = 'update',
    String? changeReason,
  }) async {
    try {
      // 通过 UUID 查询获取数字 ID
      final entryResult = await _databaseService.query(
        'SELECT id FROM {translation_entries} WHERE uuid::text = @uuid',
        {'uuid': entry.uuid},
      );

      if (entryResult.isEmpty) {
        logError('无法找到翻译条目ID', context: {'uuid': entry.uuid});
        return;
      }

      final entryData = entryResult.first.toColumnMap();
      final entryIdValue = entryData['id'];
      final entryId = entryIdValue is int ? entryIdValue : int.tryParse(entryIdValue.toString());

      if (entryId == null) {
        logError('无法解析翻译条目ID', context: {'uuid': entry.uuid, 'id': entryIdValue});
        return;
      }

      // changed_by 是必填字段，如果为空则跳过记录
      if (changedBy == null || changedBy.isEmpty) {
        logError('changed_by 不能为空，跳过记录翻译历史', context: {'uuid': entry.uuid});
        return;
      }

      // 获取目标语言翻译文本（简化版本，取第一个）
      final targetText = entry.targetLanguages.isNotEmpty ? entry.targetLanguages.first.text : '';

      await _databaseService.query('''
        INSERT INTO {translation_history} (
          entry_id, entry_uuid, project_id, old_target_text, new_target_text,
          old_status, new_status, action, changed_by, reason
        ) VALUES (
          @entry_id, @entry_uuid, @project_id, @old_text, @new_text,
          @old_status, @new_status, @action, @changed_by, @reason
        )
      ''', {
        'entry_id': entryId,
        'entry_uuid': entry.uuid,
        'project_id': entry.projectId,
        'old_text': null, // 简化版本，实际应该比较差异
        'new_text': targetText,
        'old_status': null,
        'new_status': null, // 状态现在在 target_languages 中计算
        'action': changeType,
        'changed_by': changedBy,
        'reason': changeReason,
      });
    } catch (error, stackTrace) {
      logError('记录翻译历史失败', error: error, stackTrace: stackTrace, context: {'entry_id': entry.uuid});
      // 不抛出异常，避免影响主要操作
    }
  }

  /// 更新项目统计信息
  Future<void> _updateProjectStats(int projectId) async {
    try {
      await _databaseService.query('''
        UPDATE {projects}
        SET
          total_keys = (
            SELECT COUNT(DISTINCT entry_key)
            FROM {translation_entries}
            WHERE project_id = @project_id AND deleted_at IS NULL
          ),
          translated_keys = (
            SELECT COUNT(DISTINCT te.entry_key)
            FROM {translation_entries} te
            WHERE te.project_id = @project_id 
              AND te.deleted_at IS NULL
              AND EXISTS (
                SELECT 1 
                FROM jsonb_array_elements(COALESCE(te.target_languages, '[]'::jsonb)) AS elem 
                WHERE elem->>'text' IS NOT NULL AND elem->>'text' != ''
              )
          ),
          last_activity_at = CURRENT_TIMESTAMP
        WHERE id = @project_id
      ''', {
        'project_id': projectId,
      });
    } catch (error, stackTrace) {
      logError('更新项目统计失败', error: error, stackTrace: stackTrace, context: {'project_id': projectId});
      // 不抛出异常，避免影响主要操作
    }
  }

  /// 翻译单个条目并入库
  Future<TranslationEntryModel> translateEntry({
    required String entryId,
    required List<String> targetLanguages,
    required TranslationProviderConfigModel provider,
    bool force = false,
    String? updatedBy,
  }) async {
    return execute<TranslationEntryModel>(
      () async {
        logInfo('开始翻译条目', context: {'entry_id': entryId, 'targets': targetLanguages});

        final entry = await getTranslationEntryById(entryId);
        if (entry == null) {
          throwNotFound('翻译条目不存在');
        }
        if (entry.sourceText.isEmpty) {
          throwBusiness('源文本为空，无法翻译');
        }

        final updatedEntry = await _translateAndSave(
          entryId: entryId,
          sourceText: entry.sourceText,
          sourceLanguage: entry.sourceLanguage,
          targetLanguages: targetLanguages,
          provider: provider,
          force: force,
        );

        await _recordTranslationHistory(updatedEntry, updatedBy);
        await _updateProjectStats(updatedEntry.projectId);

        logInfo('翻译条目完成', context: {'entry_id': entryId});
        return updatedEntry;
      },
      operationName: 'translateEntry',
    );
  }

  /// 批量翻译整个项目的所有条目并入库
  Future<void> batchTranslateEntries({
    required int projectId,
    required List<String> targetLanguages,
    required TranslationProviderConfigModel provider,
    bool force = false,
    String? updatedBy,
  }) async {
    return execute<void>(
      () async {
        // 获取项目下所有翻译条目
        final allEntries = await getTranslationEntries(projectId: projectId, limit: 10000);
        final entries = allEntries.items ?? [];

        logInfo('开始批量翻译', context: {'project_id': projectId, 'count': entries.length, 'targets': targetLanguages});

        var successCount = 0;

        for (final entry in entries) {
          if (entry.sourceText.isEmpty) continue;

          try {
            final updatedEntry = await _translateAndSave(
              entryId: entry.uuid,
              sourceText: entry.sourceText,
              sourceLanguage: entry.sourceLanguage,
              targetLanguages: targetLanguages,
              provider: provider,
              force: force,
            );
            successCount++;
            await _recordTranslationHistory(updatedEntry, updatedBy);
          } catch (error, stackTrace) {
            logError('翻译条目失败', error: error, stackTrace: stackTrace, context: {'entry_id': entry.uuid});
          }
        }

        await _updateProjectStats(projectId);

        logInfo('批量翻译完成', context: {'total': entries.length, 'success': successCount});
      },
      operationName: 'batchTranslateEntries',
    );
  }

  /// 调用翻译 API 并将结果写入数据库
  ///
  /// 默认只翻译目标语言中还没有值的语言，已有翻译的语言会跳过。
  /// 当 [force] 为 true 时，强制覆盖已有翻译。
  Future<TranslationEntryModel> _translateAndSave({
    required String entryId,
    required String sourceText,
    required LanguageEnum sourceLanguage,
    required List<String> targetLanguages,
    required TranslationProviderConfigModel provider,
    bool force = false,
  }) async {
    // 先读取现有 target_languages
    final isNumericId = int.tryParse(entryId) != null;
    final entryResult = await _databaseService.query('''
      SELECT id, COALESCE(target_languages::text, '[]') as target_languages
      FROM {translation_entries}
      WHERE ${isNumericId ? 'id = @entry_id' : 'uuid::text = @entry_id'}
    ''', {'entry_id': entryId});

    if (entryResult.isEmpty) {
      throwNotFound('翻译条目不存在');
    }

    final entryData = entryResult.first.toColumnMap();
    final existingTargetsJson = entryData['target_languages'] as String? ?? '[]';
    final existingTargets =
        (jsonDecode(existingTargetsJson) as List<dynamic>).map((item) => item as Map<String, dynamic>).toList();

    // 过滤掉已有翻译值的语言，只保留没有值的（force 模式下全部翻译）
    final List<String> needTranslateLanguages;
    if (force) {
      needTranslateLanguages = targetLanguages;
    } else {
      needTranslateLanguages = targetLanguages.where((langCode) {
        final existing = existingTargets.firstWhere(
          (t) => t['language'] == langCode,
          orElse: () => <String, dynamic>{},
        );
        final text = existing['text']?.toString() ?? '';
        return text.isEmpty;
      }).toList();
    }

    // 所有目标语言都已有翻译，直接返回现有条目
    if (needTranslateLanguages.isEmpty) {
      logInfo('所有目标语言已有翻译，跳过', context: {'entry_id': entryId});
      final existingEntry = await getTranslationEntryById(entryId);
      if (existingEntry == null) {
        throwNotFound('翻译条目不存在');
      }
      return existingEntry;
    }

    // 只翻译缺失的语言
    final targetEnums = needTranslateLanguages.map((code) => LanguageEnum.fromValue(code)).toList();

    final result = await TranslationApiService.translateBatchTexts(
      sourceText: sourceText,
      sourceLanguage: sourceLanguage,
      targetLanguages: targetEnums,
      config: provider,
    );

    // 合并翻译结果到 target_languages
    for (final item in result.items) {
      if (!item.success) continue;

      final langCode = item.targetLanguage.code;
      final existingIndex = existingTargets.indexWhere((t) => t['language'] == langCode);

      if (existingIndex >= 0) {
        existingTargets[existingIndex]['text'] = item.translatedText;
      } else {
        existingTargets.add({'language': langCode, 'text': item.translatedText});
      }
    }

    // 更新数据库
    await _databaseService.query('''
      UPDATE {translation_entries}
      SET target_languages = @target_languages::jsonb, updated_at = CURRENT_TIMESTAMP
      WHERE ${isNumericId ? 'id = @entry_id' : 'uuid::text = @entry_id'}
    ''', {
      'entry_id': entryId,
      'target_languages': jsonEncode(existingTargets),
    });

    final updatedEntry = await getTranslationEntryById(entryId);
    if (updatedEntry == null) {
      throwNotFound('更新后条目不存在');
    }

    return updatedEntry;
  }
}
