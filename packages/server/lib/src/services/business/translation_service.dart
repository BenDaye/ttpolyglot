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

  /// 获取翻译条目
  Future<Map<String, dynamic>> getTranslationEntries({
    required String projectId,
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
        final conditions = <String>['te.project_id = @project_id'];
        final parameters = <String, dynamic>{'project_id': projectId};

        if (languageCode != null && languageCode.isNotEmpty) {
          conditions.add('te.language_code = @language_code');
          parameters['language_code'] = languageCode;
        }

        if (status != null && status.isNotEmpty && status != 'all') {
          conditions.add('te.status = @status');
          parameters['status'] = status;
        }

        if (translatorId != null && translatorId.isNotEmpty) {
          conditions.add('te.translator_id = @translator_id');
          parameters['translator_id'] = translatorId;
        }

        if (reviewerId != null && reviewerId.isNotEmpty) {
          conditions.add('te.reviewer_id = @reviewer_id');
          parameters['reviewer_id'] = reviewerId;
        }

        if (search != null && search.isNotEmpty) {
          conditions
              .add('(te.entry_key ILIKE @search OR te.source_text ILIKE @search OR te.target_text ILIKE @search)');
          parameters['search'] = '%$search%';
        }

        // 计算总数
        final countSql = '''
        SELECT COUNT(*) FROM {translation_entries} te
        WHERE ${conditions.join(' AND ')}
      ''';

        final countResult = await _databaseService.query(countSql, parameters);
        final total = countResult.first[0] as int;

        // 获取分页数据
        final offset = (page - 1) * limit;
        parameters['limit'] = limit;
        parameters['offset'] = offset;

        final sql = '''
        SELECT
          te.*,
          u_translator.username as translator_username,
          u_reviewer.username as reviewer_username
        FROM {translation_entries} te
        LEFT JOIN {users} u_translator ON te.translator_id = u_translator.id
        LEFT JOIN {users} u_reviewer ON te.reviewer_id = u_reviewer.id
        WHERE ${conditions.join(' AND ')}
        ORDER BY te.updated_at DESC
        LIMIT @limit OFFSET @offset
      ''';

        final result = await _databaseService.query(sql, parameters);

        final entries = result.map((row) => row.toColumnMap()).toList();

        return {
          'entries': entries,
          'pagination': {
            'page': page,
            'limit': limit,
            'total': total,
            'pages': (total / limit).ceil(),
          },
        };
      },
      operationName: 'getTranslationEntries',
    );
  }

  /// 根据ID获取翻译条目详情
  Future<TranslationEntryModel?> getTranslationEntryById(String entryId) async {
    return execute<TranslationEntryModel?>(
      () async {
        logInfo('获取翻译条目详情', context: {'entry_id': entryId});

        const sql = '''
        SELECT
          te.*,
          u_translator.username as translator_username,
          u_reviewer.username as reviewer_username
        FROM {translation_entries} te
        LEFT JOIN {users} u_translator ON te.translator_id = u_translator.id
        LEFT JOIN {users} u_reviewer ON te.reviewer_id = u_reviewer.id
        WHERE te.id = @entry_id
      ''';

        final result = await _databaseService.query(sql, {'entry_id': entryId});

        if (result.isEmpty) {
          return null;
        }

        return TranslationEntryModel.fromJson(result.first.toColumnMap());
      },
      operationName: 'getTranslationEntryById',
    );
  }

  /// 创建翻译条目
  Future<TranslationEntryModel> createTranslationEntry({
    required String projectId,
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
        SELECT id FROM translation_entries
        WHERE project_id = @project_id AND entry_key = @entry_key AND language_code = @language_code
      ''', {
          'project_id': projectId,
          'entry_key': entryKey,
          'language_code': languageCode,
        });

        if (existing.isNotEmpty) {
          throwConflict('翻译条目已存在');
        }

        // 创建翻译条目
        final result = await _databaseService.query('''
        INSERT INTO {translation_entries} (
          project_id, entry_key, language_code, source_text, target_text,
          translator_id, context_info, status, version
        ) VALUES (
          @project_id, @entry_key, @language_code, @source_text, @target_text,
          @translator_id, @context_info, 'pending', 1
        ) RETURNING *
      ''', {
          'project_id': projectId,
          'entry_key': entryKey,
          'language_code': languageCode,
          'source_text': sourceText,
          'target_text': targetText,
          'translator_id': translatorId,
          'context_info': contextInfo,
        });

        final entry = TranslationEntryModel.fromJson(result.first.toColumnMap());

        // 更新项目统计信息
        await _updateProjectStats(projectId);

        logInfo('翻译条目创建成功', context: {'entry_id': entry.id});

        return entry;
      },
      operationName: 'createTranslationEntry',
    );
  }

  /// 更新翻译条目
  Future<TranslationEntryModel> updateTranslationEntry({
    required String entryId,
    String? targetText,
    String? status,
    String? translatorId,
    String? reviewerId,
    String? contextInfo,
    double? qualityScore,
    Map<String, dynamic>? issues,
    String? updatedBy,
  }) async {
    return execute<TranslationEntryModel>(
      () async {
        logInfo('更新翻译条目', context: {'entry_id': entryId});

        final existing = await getTranslationEntryById(entryId);
        if (existing == null) {
          throwNotFound('翻译条目不存在');
        }

        // 构建更新字段
        final updates = <String>[];
        final parameters = <String, dynamic>{'entry_id': entryId};

        if (targetText != null) {
          updates.add('target_text = @target_text');
          parameters['target_text'] = targetText;
        }

        if (status != null) {
          updates.add('status = @status');
          parameters['status'] = status;

          // 根据状态设置时间戳
          if (status == 'completed') {
            updates.add('translated_at = CURRENT_TIMESTAMP');
          } else if (status == 'reviewing') {
            updates.add('reviewed_at = CURRENT_TIMESTAMP');
          } else if (status == 'approved') {
            updates.add('approved_at = CURRENT_TIMESTAMP');
          }
        }

        if (translatorId != null) {
          updates.add('translator_id = @translator_id');
          parameters['translator_id'] = translatorId;
          updates.add('assigned_at = CURRENT_TIMESTAMP');
        }

        if (reviewerId != null) {
          updates.add('reviewer_id = @reviewer_id');
          parameters['reviewer_id'] = reviewerId;
        }

        if (contextInfo != null) {
          updates.add('context_info = @context_info');
          parameters['context_info'] = contextInfo;
        }

        if (qualityScore != null) {
          updates.add('quality_score = @quality_score');
          parameters['quality_score'] = qualityScore;
        }

        if (issues != null) {
          updates.add('issues = @issues');
          parameters['issues'] = issues.toString();
          updates.add('has_issues = @has_issues');
          parameters['has_issues'] = issues.isNotEmpty;
        }

        if (updates.isEmpty) {
          throwBusiness('没有可更新的字段');
        }

        // 更新数据库
        final sql = '''
        UPDATE translation_entries
        SET ${updates.join(', ')}, version = version + 1, updated_at = CURRENT_TIMESTAMP
        WHERE id = @entry_id
        RETURNING *
      ''';

        final result = await _databaseService.query(sql, parameters);
        final updatedEntry = TranslationEntryModel.fromJson(result.first.toColumnMap());

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

        // 删除条目
        await _databaseService.query('DELETE FROM {translation_entries} WHERE id = @entry_id', {'entry_id': entryId});

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
    String? status,
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
            final updateData = <String, dynamic>{};

            if (status != null) {
              updateData['status'] = status;
            }

            if (translatorId != null) {
              updateData['translator_id'] = translatorId;
            }

            if (reviewerId != null) {
              updateData['reviewer_id'] = reviewerId;
            }

            if (updateData.isNotEmpty) {
              final updatedEntry = await updateTranslationEntry(
                entryId: entryId,
                updatedBy: updatedBy,
                targetText: updateData['target_text'],
                status: updateData['status'],
                translatorId: updateData['translator_id'],
                reviewerId: updateData['reviewer_id'],
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
  Future<Map<String, dynamic>> getProjectTranslationStats(String projectId) async {
    return execute(
      () async {
        logInfo('获取项目翻译统计', context: {'project_id': projectId});

        const sql = '''
        SELECT
          COUNT(*) as total_entries,
          COUNT(*) FILTER (WHERE status = 'completed') as completed_entries,
          COUNT(*) FILTER (WHERE status = 'reviewing') as reviewing_entries,
          COUNT(*) FILTER (WHERE status = 'approved') as approved_entries,
          COUNT(*) FILTER (WHERE status = 'pending') as pending_entries,
          COALESCE(SUM(character_count), 0) as total_characters,
          COALESCE(SUM(word_count), 0) as total_words,
          COALESCE(AVG(quality_score), 0) as avg_quality_score,
          COUNT(*) FILTER (WHERE has_issues = true) as entries_with_issues
        FROM translation_entries
        WHERE project_id = @project_id
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
      await _databaseService.query('''
        INSERT INTO {translation_history} (
          translation_entry_id, old_target_text, new_target_text,
          old_status, new_status, change_type, changed_by, change_reason
        ) VALUES (
          @entry_id, @old_text, @new_text,
          @old_status, @new_status, @change_type, @changed_by, @change_reason
        )
      ''', {
        'entry_id': entry.id,
        'old_text': null, // 简化版本，实际应该比较差异
        'new_text': entry.targetText,
        'old_status': null,
        'new_status': entry.status,
        'change_type': changeType,
        'changed_by': changedBy,
        'change_reason': changeReason,
      });
    } catch (error, stackTrace) {
      logError('记录翻译历史失败', error: error, stackTrace: stackTrace, context: {'entry_id': entry.id});
      // 不抛出异常，避免影响主要操作
    }
  }

  /// 更新项目统计信息
  Future<void> _updateProjectStats(String projectId) async {
    try {
      await _databaseService.query('''
        UPDATE projects
        SET
          total_keys = (
            SELECT COUNT(DISTINCT entry_key)
            FROM translation_entries
            WHERE project_id = @project_id
          ),
          translated_keys = (
            SELECT COUNT(DISTINCT entry_key)
            FROM translation_entries
            WHERE project_id = @project_id AND status IN ('completed', 'reviewing', 'approved')
          ),
          languages_count = (
            SELECT COUNT(DISTINCT language_code)
            FROM project_languages
            WHERE project_id = @project_id AND is_enabled = true
          ),
          last_activity_at = CURRENT_TIMESTAMP
        WHERE id = @project_id
      ''', {'project_id': projectId});
    } catch (error, stackTrace) {
      logError('更新项目统计失败', error: error, stackTrace: stackTrace, context: {'project_id': projectId});
      // 不抛出异常，避免影响主要操作
    }
  }
}
