import 'package:ttpolyglot_model/model.dart';

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
  Future<TranslationEntryModel> _buildTranslationEntryModel(Map<String, dynamic> entryData) async {
    final entryId = entryData['id'] as int;

    // 查询目标语言翻译
    final targetLanguagesResult = await _databaseService.query('''
      SELECT language, text
      FROM {translation_entry_targets}
      WHERE entry_id = @entry_id
      ORDER BY language
    ''', {'entry_id': entryId});

    final targetLanguages = targetLanguagesResult.map((row) {
      final data = row.toColumnMap();
      return TranslationTargetLanguageModel(
        language: const LanguageEnumConverter().fromJson(data['language'] as String),
        text: data['text'] as String? ?? '',
      );
    }).toList();

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

            // 插入翻译条目
            final entryResult = await _databaseService.query('''
              INSERT INTO {translation_entries} (
                project_id, entry_key, source_language, source_text,
                translated_by, context
              ) VALUES (
                @project_id, @entry_key, @source_language, @source_text,
                @translator_id, @context_info
              )
              RETURNING id, COALESCE(uuid::text, id::text) as uuid, project_id, 
                        COALESCE(entry_key, '') as entry_key, 
                        COALESCE(source_language, 'en_US') as source_language, 
                        COALESCE(source_text, '') as source_text,
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
            });

            final entryData = entryResult.first.toColumnMap();
            final entryId = entryData['id'] as int;

            // 插入目标语言翻译
            if (targetText.isNotEmpty) {
              await _databaseService.query('''
                INSERT INTO {translation_entry_targets} (entry_id, language, text)
                VALUES (@entry_id, @language, @text)
                ON CONFLICT (entry_id, language) 
                DO UPDATE SET text = @text, updated_at = CURRENT_TIMESTAMP
              ''', {
                'entry_id': entryId,
                'language': languageCode,
                'text': targetText,
              });
            }

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
              'EXISTS (SELECT 1 FROM {translation_entry_targets} tet WHERE tet.entry_id = te.id AND tet.language = @language_code)');
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

        // 组装完整的翻译条目数据
        final entries = <TranslationEntryModel>[];
        for (final row in result) {
          final data = row.toColumnMap();
          final entry = await _buildTranslationEntryModel(data);
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
              'EXISTS (SELECT 1 FROM {translation_entry_targets} tet WHERE tet.entry_id = te.id AND tet.language = @language_code)');
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

        // 组装完整的翻译条目数据
        final entriesList = <TranslationEntryModel>[];
        for (final row in entries) {
          final data = row.toColumnMap();
          final entry = await _buildTranslationEntryModel(data);
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
        return await _buildTranslationEntryModel(resultData);
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

        // 创建翻译条目
        final result = await _databaseService.query('''
        INSERT INTO {translation_entries} (
          project_id, entry_key, source_language, source_text,
          translated_by, context
        ) VALUES (
          @project_id, @entry_key, @source_language, @source_text,
          @translator_id, @context_info
        ) RETURNING id, COALESCE(uuid::text, id::text) as uuid, project_id, 
                    COALESCE(entry_key, '') as entry_key, 
                    COALESCE(source_language, 'en_US') as source_language, 
                    COALESCE(source_text, '') as source_text,
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
        });

        final resultData = result.first.toColumnMap();
        final entryId = resultData['id'] as int;

        // 插入目标语言翻译
        if (targetText != null && targetText.isNotEmpty) {
          await _databaseService.query('''
            INSERT INTO {translation_entry_targets} (entry_id, language, text)
            VALUES (@entry_id, @language, @text)
          ''', {
            'entry_id': entryId,
            'language': languageCode,
            'text': targetText,
          });
        }

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
    String? targetText,
    String? targetLanguage,
    String? translatorId,
    String? reviewerId,
    String? contextInfo,
    String? sourceText,
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

        // 构建更新字段
        final updates = <String>[];
        final parameters = <String, dynamic>{'entry_id': entryId};

        if (sourceText != null) {
          updates.add('source_text = @source_text');
          parameters['source_text'] = sourceText;
        }

        if (translatorId != null) {
          updates.add('translated_by = @translator_id');
          parameters['translator_id'] = translatorId;
        }

        if (reviewerId != null) {
          updates.add('reviewed_by = @reviewer_id');
          parameters['reviewer_id'] = reviewerId;
        }

        if (contextInfo != null) {
          updates.add('context = @context_info');
          parameters['context_info'] = contextInfo;
        }

        if (sortIndex != null) {
          updates.add('sort_index = @sort_index');
          parameters['sort_index'] = sortIndex;
        }

        // 更新翻译条目基本信息
        if (updates.isNotEmpty) {
          final sql = '''
          UPDATE {translation_entries}
          SET ${updates.join(', ')}, updated_at = CURRENT_TIMESTAMP
          WHERE ${isNumericId ? 'id = @entry_id' : 'uuid::text = @entry_id'}
          RETURNING id, COALESCE(uuid::text, id::text) as uuid, project_id, 
                    COALESCE(entry_key, '') as entry_key, 
                    COALESCE(source_language, 'en_US') as source_language, 
                    COALESCE(source_text, '') as source_text,
                    translated_by, reviewed_by, 
                    COALESCE(context, '') as context, 
                    COALESCE(comment, '') as comment,
                    COALESCE(sort_index, 0) as sort_index,
                    deleted_at, created_at, updated_at
        ''';

          await _databaseService.query(sql, parameters);
        }

        // 更新目标语言翻译
        if (targetText != null && targetLanguage != null) {
          // 先获取 entry_id
          final entryResult = await _databaseService.query('''
            SELECT id FROM {translation_entries}
            WHERE ${isNumericId ? 'id = @entry_id' : 'uuid::text = @entry_id'}
          ''', {'entry_id': entryId});

          if (entryResult.isNotEmpty) {
            final entryIdValue = entryResult.first[0] as int;
            await _databaseService.query('''
              INSERT INTO {translation_entry_targets} (entry_id, language, text)
              VALUES (@entry_id, @language, @text)
              ON CONFLICT (entry_id, language) 
              DO UPDATE SET text = @text, updated_at = CURRENT_TIMESTAMP
            ''', {
              'entry_id': entryIdValue,
              'language': targetLanguage,
              'text': targetText,
            });
          }
        }

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
  Future<void> deleteTranslationEntry(String entryId, {String? deletedBy}) async {
    return execute(
      () async {
        logInfo('删除翻译条目', context: {'entry_id': entryId});

        // 获取条目信息以便记录历史
        final entry = await getTranslationEntryById(entryId);
        if (entry == null) {
          throwNotFound('翻译条目不存在');
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
          COUNT(DISTINCT CASE WHEN tet.text IS NOT NULL AND tet.text != '' THEN te.id END) as completed_entries,
          COUNT(DISTINCT CASE WHEN tet.text IS NULL OR tet.text = '' THEN te.id END) as pending_entries,
          COALESCE(SUM(LENGTH(te.source_text)), 0) as total_source_characters,
          COALESCE(SUM(LENGTH(tet.text)), 0) as total_target_characters
        FROM {translation_entries} te
        LEFT JOIN {translation_entry_targets} tet ON tet.entry_id = te.id
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
            INNER JOIN {translation_entry_targets} tet ON tet.entry_id = te.id
            WHERE te.project_id = @project_id 
              AND te.deleted_at IS NULL
              AND tet.text IS NOT NULL 
              AND tet.text != ''
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
}
