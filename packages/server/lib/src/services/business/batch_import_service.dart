import 'dart:convert';
import 'dart:developer';

import '../base_service.dart';
import '../infrastructure/database_service.dart';

/// 批量导入服务
///
/// 优化批量导入性能，支持大批量数据导入
class BatchImportService extends BaseService {
  final DatabaseService _databaseService;

  static const int BATCH_SIZE = 1000; // 每批处理1000条

  BatchImportService({
    required DatabaseService databaseService,
  })  : _databaseService = databaseService,
        super('BatchImportService');

  /// 批量导入翻译条目（优化版）
  ///
  /// 分批处理，避免内存溢出，支持进度跟踪
  Future<String> batchImportEntries({
    required int projectId,
    required List<Map<String, dynamic>> entries,
    required String userId,
    bool overrideExisting = false,
  }) async {
    return execute(
      () async {
        logInfo('开始批量导入', context: {
          'project_id': projectId,
          'total_entries': entries.length,
          'override': overrideExisting,
        });

        // 1. 创建批量任务记录
        final jobId = await _createBatchJob(
          projectId: projectId,
          jobType: 'import',
          totalItems: entries.length,
          createdBy: userId,
          config: {
            'override_existing': overrideExisting,
          },
        );

        try {
          await _updateJobStatus(jobId, 'processing');

          int successCount = 0;
          int failedCount = 0;
          final errors = <Map<String, dynamic>>[];

          // 2. 分批处理
          for (var i = 0; i < entries.length; i += BATCH_SIZE) {
            final batch = entries.skip(i).take(BATCH_SIZE).toList();

            try {
              // 3. 批量插入（使用 UNNEST 或多值插入）
              final result = await _batchInsertEntries(
                projectId: projectId,
                entries: batch,
                overrideExisting: overrideExisting,
              );

              successCount += result['success'] as int;
              failedCount += result['failed'] as int;

              if (result['errors'] != null) {
                errors.addAll(result['errors'] as List<Map<String, dynamic>>);
              }
            } catch (error, stackTrace) {
              log('[BatchImportService.batchImportEntries]',
                  error: error, stackTrace: stackTrace, name: 'BatchImportService');

              failedCount += batch.length;
              errors.add({
                'batch_start': i,
                'batch_end': i + batch.length,
                'error': error.toString(),
              });
            }

            // 4. 更新任务进度
            await _updateJobProgress(
              jobId,
              processedItems: i + batch.length,
              successItems: successCount,
              failedItems: failedCount,
            );

            logInfo('批次处理完成', context: {
              'batch': '$i-${i + batch.length}',
              'success': successCount,
              'failed': failedCount,
            });
          }

          // 5. 更新任务状态为完成
          await _updateJobStatus(
            jobId,
            'completed',
            result: {
              'success': successCount,
              'failed': failedCount,
              'total': entries.length,
              'errors': errors.take(100).toList(), // 只保留前100个错误
            },
          );

          logInfo('批量导入完成', context: {
            'job_id': jobId,
            'success': successCount,
            'failed': failedCount,
          });

          return jobId;
        } catch (error, stackTrace) {
          log('[BatchImportService.batchImportEntries]',
              error: error, stackTrace: stackTrace, name: 'BatchImportService');

          await _updateJobStatus(
            jobId,
            'failed',
            errorMessage: error.toString(),
          );

          rethrow;
        }
      },
      operationName: 'batchImportEntries',
    );
  }

  /// 批量插入条目
  Future<Map<String, dynamic>> _batchInsertEntries({
    required int projectId,
    required List<Map<String, dynamic>> entries,
    required bool overrideExisting,
  }) async {
    int success = 0;
    int failed = 0;
    final errors = <Map<String, dynamic>>[];

    // 按 entry_key 分组，因为新结构是一个 entry_key 对应多个目标语言
    final entryMap = <String, Map<String, dynamic>>{};
    final targetLanguagesMap = <String, List<Map<String, String>>>{};

    for (final entry in entries) {
      try {
        final entryKey = entry['key'] as String? ?? entry['entry_key'] as String;
        final sourceLanguage =
            entry['source_language'] as String? ?? entry['source_language_id']?.toString() ?? 'en_US';
        final targetLanguage = entry['target_language'] as String? ?? entry['target_language_id']?.toString() ?? '';
        final sourceText = entry['source_text'] as String? ?? '';
        final targetText = entry['target_text'] as String? ?? '';

        if (entryKey.isEmpty) {
          failed++;
          errors.add({
            'entry': entry,
            'error': 'entry_key 不能为空',
          });
          continue;
        }

        // 存储条目基本信息（只存储一次）
        if (!entryMap.containsKey(entryKey)) {
          entryMap[entryKey] = {
            'entry_key': entryKey,
            'source_language': sourceLanguage,
            'source_text': sourceText,
            'context': entry['context'] as String? ?? '',
            'comment': entry['comment'] as String? ?? '',
          };
          targetLanguagesMap[entryKey] = [];
        }

        // 存储目标语言翻译
        if (targetLanguage.isNotEmpty && targetText.isNotEmpty) {
          targetLanguagesMap[entryKey]!.add({
            'language': targetLanguage,
            'text': targetText,
          });
        }
      } catch (error) {
        failed++;
        errors.add({
          'entry': entry,
          'error': error.toString(),
        });
      }
    }

    if (entryMap.isEmpty) {
      return {
        'success': 0,
        'failed': failed,
        'errors': errors,
      };
    }

    try {
      await _databaseService.transaction(() async {
        // 批量插入 translation_entries
        for (final entryKey in entryMap.keys) {
          final entryData = entryMap[entryKey]!;

          final onConflict = overrideExisting
              ? '''
                ON CONFLICT (project_id, entry_key) 
                DO UPDATE SET
                  source_text = EXCLUDED.source_text,
                  source_language = EXCLUDED.source_language,
                  context = EXCLUDED.context,
                  comment = EXCLUDED.comment,
                  updated_at = CURRENT_TIMESTAMP
              '''
              : 'ON CONFLICT (project_id, entry_key) DO NOTHING';

          final entrySql = '''
            INSERT INTO {translation_entries} 
            (project_id, entry_key, source_language, source_text, context, comment)
            VALUES (@project_id, @entry_key, @source_language, @source_text, @context, @comment)
            $onConflict
            RETURNING id
          ''';

          final entryResult = await _databaseService.query(entrySql, {
            'project_id': projectId,
            'entry_key': entryData['entry_key'],
            'source_language': entryData['source_language'],
            'source_text': entryData['source_text'],
            'context': entryData['context'],
            'comment': entryData['comment'],
          });

          if (entryResult.isNotEmpty) {
            final entryId = entryResult.first.toColumnMap()['id'] as int;

            // 更新目标语言翻译到 target_languages JSONB 字段
            final targetLanguages = targetLanguagesMap[entryKey]!;

            // 先获取现有的 target_languages
            final existingResult = await _databaseService.query('''
              SELECT COALESCE(target_languages::text, '[]') as target_languages
              FROM {translation_entries}
              WHERE id = @entry_id
            ''', {'entry_id': entryId});

            final existingTargetsJson = existingResult.first.toColumnMap()['target_languages'] as String? ?? '[]';
            final existingTargets =
                (jsonDecode(existingTargetsJson) as List<dynamic>).map((item) => item as Map<String, dynamic>).toList();

            // 合并新的目标语言
            for (final targetLang in targetLanguages) {
              final existingIndex = existingTargets.indexWhere((item) => item['language'] == targetLang['language']);
              if (existingIndex >= 0) {
                // 更新现有翻译
                existingTargets[existingIndex]['text'] = targetLang['text'];
              } else {
                // 添加新翻译
                existingTargets.add({'language': targetLang['language'], 'text': targetLang['text']});
              }
            }

            // 更新 target_languages JSONB 字段
            final updatedTargetsJson = jsonEncode(existingTargets);
            await _databaseService.query('''
              UPDATE {translation_entries}
              SET target_languages = @target_languages::jsonb, updated_at = CURRENT_TIMESTAMP
              WHERE id = @entry_id
            ''', {
              'entry_id': entryId,
              'target_languages': updatedTargetsJson,
            });

            success++;
          }
        }
      });

      return {
        'success': success,
        'failed': failed,
        'errors': errors.isEmpty ? null : errors,
      };
    } catch (error, stackTrace) {
      log('[BatchImportService._batchInsertEntries]', error: error, stackTrace: stackTrace, name: 'BatchImportService');

      // 如果批量插入失败，尝试逐条插入
      return await _insertEntriesOneByOne(
        projectId: projectId,
        entries: entries,
        overrideExisting: overrideExisting,
      );
    }
  }

  /// 逐条插入（容错处理）
  Future<Map<String, dynamic>> _insertEntriesOneByOne({
    required int projectId,
    required List<Map<String, dynamic>> entries,
    required bool overrideExisting,
  }) async {
    int success = 0;
    int failed = 0;
    final errors = <Map<String, dynamic>>[];

    // 按 entry_key 分组
    final entryMap = <String, Map<String, dynamic>>{};
    final targetLanguagesMap = <String, List<Map<String, String>>>{};

    for (final entry in entries) {
      try {
        final entryKey = entry['key'] as String? ?? entry['entry_key'] as String;
        final sourceLanguage =
            entry['source_language'] as String? ?? entry['source_language_id']?.toString() ?? 'en_US';
        final targetLanguage = entry['target_language'] as String? ?? entry['target_language_id']?.toString() ?? '';
        final sourceText = entry['source_text'] as String? ?? '';
        final targetText = entry['target_text'] as String? ?? '';

        if (entryKey.isEmpty) {
          failed++;
          errors.add({
            'entry': entry,
            'error': 'entry_key 不能为空',
          });
          continue;
        }

        if (!entryMap.containsKey(entryKey)) {
          entryMap[entryKey] = {
            'entry_key': entryKey,
            'source_language': sourceLanguage,
            'source_text': sourceText,
            'context': entry['context'] as String? ?? '',
            'comment': entry['comment'] as String? ?? '',
          };
          targetLanguagesMap[entryKey] = [];
        }

        if (targetLanguage.isNotEmpty && targetText.isNotEmpty) {
          targetLanguagesMap[entryKey]!.add({
            'language': targetLanguage,
            'text': targetText,
          });
        }
      } catch (error) {
        failed++;
        errors.add({
          'entry': entry,
          'error': error.toString(),
        });
      }
    }

    // 逐条插入
    for (final entryKey in entryMap.keys) {
      try {
        final entryData = entryMap[entryKey]!;

        final onConflict = overrideExisting
            ? '''
              ON CONFLICT (project_id, entry_key) 
              DO UPDATE SET
                source_text = EXCLUDED.source_text,
                source_language = EXCLUDED.source_language,
                context = EXCLUDED.context,
                comment = EXCLUDED.comment,
                updated_at = CURRENT_TIMESTAMP
            '''
            : 'ON CONFLICT (project_id, entry_key) DO NOTHING';

        final entrySql = '''
          INSERT INTO {translation_entries} 
          (project_id, entry_key, source_language, source_text, context, comment)
          VALUES (@project_id, @entry_key, @source_language, @source_text, @context, @comment)
          $onConflict
          RETURNING id
        ''';

        final entryResult = await _databaseService.query(entrySql, {
          'project_id': projectId,
          'entry_key': entryData['entry_key'],
          'source_language': entryData['source_language'],
          'source_text': entryData['source_text'],
          'context': entryData['context'],
          'comment': entryData['comment'],
        });

        if (entryResult.isNotEmpty) {
          final entryId = entryResult.first.toColumnMap()['id'] as int;

          // 更新目标语言翻译到 target_languages JSONB 字段
          final targetLanguages = targetLanguagesMap[entryKey]!;

          // 先获取现有的 target_languages
          final existingResult = await _databaseService.query('''
            SELECT COALESCE(target_languages::text, '[]') as target_languages
            FROM {translation_entries}
            WHERE id = @entry_id
          ''', {'entry_id': entryId});

          final existingTargetsJson = existingResult.first.toColumnMap()['target_languages'] as String? ?? '[]';
          final existingTargets =
              (jsonDecode(existingTargetsJson) as List<dynamic>).map((item) => item as Map<String, dynamic>).toList();

          // 合并新的目标语言
          for (final targetLang in targetLanguages) {
            final existingIndex = existingTargets.indexWhere((item) => item['language'] == targetLang['language']);
            if (existingIndex >= 0) {
              // 更新现有翻译
              existingTargets[existingIndex]['text'] = targetLang['text'];
            } else {
              // 添加新翻译
              existingTargets.add({'language': targetLang['language'], 'text': targetLang['text']});
            }
          }

          // 更新 target_languages JSONB 字段
          final updatedTargetsJson = jsonEncode(existingTargets);
          await _databaseService.query('''
            UPDATE {translation_entries}
            SET target_languages = @target_languages::jsonb, updated_at = CURRENT_TIMESTAMP
            WHERE id = @entry_id
          ''', {
            'entry_id': entryId,
            'target_languages': updatedTargetsJson,
          });

          success++;
        }
      } catch (error) {
        failed++;
        errors.add({
          'entry_key': entryKey,
          'error': error.toString(),
        });
      }
    }

    return {
      'success': success,
      'failed': failed,
      'errors': errors.isEmpty ? null : errors,
    };
  }

  /// 创建批量任务
  Future<String> _createBatchJob({
    required int projectId,
    required String jobType,
    required int totalItems,
    required String createdBy,
    Map<String, dynamic>? config,
  }) async {
    final result = await _databaseService.query('''
      INSERT INTO {translation_batch_jobs} 
      (project_id, job_type, total_items, created_by, config)
      VALUES (@project_id, @job_type, @total_items, @created_by, @config::jsonb)
      RETURNING id
    ''', {
      'project_id': projectId,
      'job_type': jobType,
      'total_items': totalItems,
      'created_by': createdBy,
      'config': jsonEncode(config ?? {}),
    });

    return result.first.toColumnMap()['id'] as String;
  }

  /// 更新任务状态
  Future<void> _updateJobStatus(
    String jobId,
    String status, {
    Map<String, dynamic>? result,
    String? errorMessage,
  }) async {
    final updates = <String>['status = @status'];
    final params = <String, dynamic>{
      'job_id': jobId,
      'status': status,
    };

    if (status == 'processing') {
      updates.add('started_at = CURRENT_TIMESTAMP');
    }

    if (status == 'completed' || status == 'failed') {
      updates.add('completed_at = CURRENT_TIMESTAMP');
    }

    if (result != null) {
      updates.add('result = @result::jsonb');
      params['result'] = jsonEncode(result);
    }

    if (errorMessage != null) {
      updates.add('error_message = @error_message');
      params['error_message'] = errorMessage;
    }

    await _databaseService.query('''
      UPDATE {translation_batch_jobs}
      SET ${updates.join(', ')}
      WHERE id = @job_id
    ''', params);
  }

  /// 更新任务进度
  Future<void> _updateJobProgress(
    String jobId, {
    required int processedItems,
    required int successItems,
    required int failedItems,
  }) async {
    await _databaseService.query('''
      UPDATE {translation_batch_jobs}
      SET 
        processed_items = @processed_items,
        success_items = @success_items,
        failed_items = @failed_items
      WHERE id = @job_id
    ''', {
      'job_id': jobId,
      'processed_items': processedItems,
      'success_items': successItems,
      'failed_items': failedItems,
    });
  }
}
