import 'dart:developer';

import '../config/server_config.dart';
import '../models/translation_entry.dart';
import 'database_service.dart';
import 'redis_service.dart';

/// 翻译服务
class TranslationService {
  final DatabaseService _databaseService;
  final RedisService _redisService;
  final ServerConfig _config;

  TranslationService({
    required DatabaseService databaseService,
    required RedisService redisService,
    required ServerConfig config,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        _config = config;

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
    try {
      log('获取翻译条目: project=$projectId, language=$languageCode, page=$page', name: 'TranslationService');

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
        conditions.add('(te.entry_key ILIKE @search OR te.source_text ILIKE @search OR te.target_text ILIKE @search)');
        parameters['search'] = '%$search%';
      }

      // 计算总数
      final countSql = '''
        SELECT COUNT(*) FROM translation_entries te
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
          u_reviewer.username as reviewer_username,
          l.name as language_name,
          l.native_name as language_native_name
        FROM translation_entries te
        LEFT JOIN users u_translator ON te.translator_id = u_translator.id
        LEFT JOIN users u_reviewer ON te.reviewer_id = u_reviewer.id
        LEFT JOIN languages l ON te.language_code = l.code
        WHERE ${conditions.join(' AND ')}
        ORDER BY te.updated_at DESC
        LIMIT @limit OFFSET @offset
      ''';

      final result = await _databaseService.query(sql, parameters);

      final entries = result.map((row) {
        final entryData = row.toColumnMap();
        return TranslationEntry.fromMap(entryData);
      }).toList();

      return {
        'entries': entries,
        'pagination': {
          'page': page,
          'limit': limit,
          'total': total,
          'pages': (total / limit).ceil(),
        },
      };
    } catch (error, stackTrace) {
      log('获取翻译条目失败', error: error, stackTrace: stackTrace, name: 'TranslationService');
      rethrow;
    }
  }

  /// 根据ID获取翻译条目详情
  Future<TranslationEntry?> getTranslationEntryById(String entryId) async {
    try {
      log('获取翻译条目详情: $entryId', name: 'TranslationService');

      const sql = '''
        SELECT
          te.*,
          u_translator.username as translator_username,
          u_reviewer.username as reviewer_username,
          l.name as language_name,
          l.native_name as language_native_name
        FROM translation_entries te
        LEFT JOIN users u_translator ON te.translator_id = u_translator.id
        LEFT JOIN users u_reviewer ON te.reviewer_id = u_reviewer.id
        LEFT JOIN languages l ON te.language_code = l.code
        WHERE te.id = @entry_id
      ''';

      final result = await _databaseService.query(sql, {'entry_id': entryId});

      if (result.isEmpty) {
        return null;
      }

      final entryData = result.first.toColumnMap();
      return TranslationEntry.fromMap(entryData);
    } catch (error, stackTrace) {
      log('获取翻译条目详情失败: $entryId', error: error, stackTrace: stackTrace, name: 'TranslationService');
      rethrow;
    }
  }

  /// 创建翻译条目
  Future<TranslationEntry> createTranslationEntry({
    required String projectId,
    required String entryKey,
    required String languageCode,
    String? sourceText,
    String? targetText,
    String? translatorId,
    String? contextInfo,
  }) async {
    try {
      log('创建翻译条目: $entryKey ($languageCode)', name: 'TranslationService');

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
        throw const BusinessException('TRANSLATION_ENTRY_EXISTS', '翻译条目已存在');
      }

      // 创建翻译条目
      final result = await _databaseService.query('''
        INSERT INTO translation_entries (
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

      final entry = TranslationEntry.fromMap(result.first.toColumnMap());

      // 更新项目统计信息
      await _updateProjectStats(projectId);

      log('翻译条目创建成功: ${entry.id}', name: 'TranslationService');

      return entry;
    } catch (error, stackTrace) {
      log('创建翻译条目失败: $entryKey', error: error, stackTrace: stackTrace, name: 'TranslationService');
      rethrow;
    }
  }

  /// 更新翻译条目
  Future<TranslationEntry> updateTranslationEntry({
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
    try {
      log('更新翻译条目: $entryId', name: 'TranslationService');

      final existing = await getTranslationEntryById(entryId);
      if (existing == null) {
        throw const NotFoundException('翻译条目不存在');
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
        throw const BusinessException('VALIDATION_NO_UPDATES', '没有可更新的字段');
      }

      // 更新数据库
      final sql = '''
        UPDATE translation_entries
        SET ${updates.join(', ')}, version = version + 1, updated_at = CURRENT_TIMESTAMP
        WHERE id = @entry_id
        RETURNING *
      ''';

      final result = await _databaseService.query(sql, parameters);
      final updatedEntry = TranslationEntry.fromMap(result.first.toColumnMap());

      // 记录翻译历史
      await _recordTranslationHistory(updatedEntry, updatedBy);

      // 更新项目统计信息
      await _updateProjectStats(updatedEntry.projectId);

      log('翻译条目更新成功: $entryId', name: 'TranslationService');

      return updatedEntry;
    } catch (error, stackTrace) {
      log('更新翻译条目失败: $entryId', error: error, stackTrace: stackTrace, name: 'TranslationService');
      rethrow;
    }
  }

  /// 删除翻译条目
  Future<void> deleteTranslationEntry(String entryId, {String? deletedBy}) async {
    try {
      log('删除翻译条目: $entryId', name: 'TranslationService');

      // 获取条目信息以便记录历史
      final entry = await getTranslationEntryById(entryId);
      if (entry == null) {
        throw const NotFoundException('翻译条目不存在');
      }

      // 记录删除历史
      await _recordTranslationHistory(entry, deletedBy, changeType: 'delete');

      // 删除条目
      await _databaseService.query('DELETE FROM translation_entries WHERE id = @entry_id', {'entry_id': entryId});

      // 更新项目统计信息
      await _updateProjectStats(entry.projectId);

      log('翻译条目删除成功: $entryId', name: 'TranslationService');
    } catch (error, stackTrace) {
      log('删除翻译条目失败: $entryId', error: error, stackTrace: stackTrace, name: 'TranslationService');
      rethrow;
    }
  }

  /// 批量更新翻译条目
  Future<List<TranslationEntry>> bulkUpdateTranslationEntries({
    required List<String> entryIds,
    String? status,
    String? translatorId,
    String? reviewerId,
    String? updatedBy,
  }) async {
    try {
      log('批量更新翻译条目: ${entryIds.length} 项', name: 'TranslationService');

      final updatedEntries = <TranslationEntry>[];

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

      log('批量更新完成: ${updatedEntries.length} 项', name: 'TranslationService');

      return updatedEntries;
    } catch (error, stackTrace) {
      log('批量更新翻译条目失败', error: error, stackTrace: stackTrace, name: 'TranslationService');
      rethrow;
    }
  }

  /// 获取翻译历史
  Future<List<Map<String, dynamic>>> getTranslationHistory(
    String entryId, {
    int limit = 50,
  }) async {
    try {
      log('获取翻译历史: $entryId', name: 'TranslationService');

      const sql = '''
        SELECT
          th.*,
          u.username as changed_by_username
        FROM translation_history th
        LEFT JOIN users u ON th.changed_by = u.id
        WHERE th.translation_entry_id = @entry_id
        ORDER BY th.created_at DESC
        LIMIT @limit
      ''';

      final result = await _databaseService.query(sql, {
        'entry_id': entryId,
        'limit': limit,
      });

      return result.map((row) => row.toColumnMap()).toList();
    } catch (error, stackTrace) {
      log('获取翻译历史失败: $entryId', error: error, stackTrace: stackTrace, name: 'TranslationService');
      rethrow;
    }
  }

  /// 获取项目翻译统计
  Future<Map<String, dynamic>> getProjectTranslationStats(String projectId) async {
    try {
      log('获取项目翻译统计: $projectId', name: 'TranslationService');

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
    } catch (error, stackTrace) {
      log('获取项目翻译统计失败: $projectId', error: error, stackTrace: stackTrace, name: 'TranslationService');
      rethrow;
    }
  }

  /// 记录翻译历史
  Future<void> _recordTranslationHistory(
    TranslationEntry entry,
    String? changedBy, {
    String changeType = 'update',
    String? changeReason,
  }) async {
    try {
      await _databaseService.query('''
        INSERT INTO translation_history (
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
      log('记录翻译历史失败: ${entry.id}', error: error, stackTrace: stackTrace, name: 'TranslationService');
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
      log('更新项目统计失败: $projectId', error: error, stackTrace: stackTrace, name: 'TranslationService');
      // 不抛出异常，避免影响主要操作
    }
  }
}
