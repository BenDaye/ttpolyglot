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
              'batch': '${i}-${i + batch.length}',
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

    // 构建批量插入SQL
    final values = <String>[];
    final entryKeys = <String>[];

    for (final entry in entries) {
      try {
        final key = entry['key'] as String? ?? entry['entry_key'] as String;
        final sourceLanguageId = entry['source_language_id'] as int;
        final targetLanguageId = entry['target_language_id'] as int;
        final sourceText = _escape(entry['source_text'] as String? ?? '');
        final targetText = _escape(entry['target_text'] as String? ?? '');
        final status = entry['status'] as String? ?? 'pending';

        values.add('''
          ($projectId, '$key', '$key', $sourceLanguageId, $targetLanguageId,
           '$sourceText', '$targetText', '$status')
        ''');

        entryKeys.add(key);
      } catch (error) {
        failed++;
        errors.add({
          'entry': entry,
          'error': error.toString(),
        });
      }
    }

    if (values.isEmpty) {
      return {
        'success': 0,
        'failed': failed,
        'errors': errors,
      };
    }

    try {
      final onConflict = overrideExisting
          ? '''
            ON CONFLICT (project_id, key, target_language_id) 
            DO UPDATE SET
              target_text = EXCLUDED.target_text,
              status = EXCLUDED.status,
              updated_at = CURRENT_TIMESTAMP
          '''
          : 'ON CONFLICT (project_id, key, target_language_id) DO NOTHING';

      final sql = '''
        INSERT INTO {translation_entries} 
        (project_id, key, entry_key, source_language_id, target_language_id, 
         source_text, target_text, status)
        VALUES ${values.join(',')}
        $onConflict
        RETURNING id
      ''';

      final result = await _databaseService.query(sql, {});
      success = result.length;

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

    for (final entry in entries) {
      try {
        final key = entry['key'] as String? ?? entry['entry_key'] as String;
        final sourceLanguageId = entry['source_language_id'] as int;
        final targetLanguageId = entry['target_language_id'] as int;
        final sourceText = entry['source_text'] as String? ?? '';
        final targetText = entry['target_text'] as String? ?? '';
        final status = entry['status'] as String? ?? 'pending';

        final onConflict = overrideExisting
            ? '''
              ON CONFLICT (project_id, key, target_language_id) 
              DO UPDATE SET
                target_text = @target_text,
                status = @status,
                updated_at = CURRENT_TIMESTAMP
            '''
            : 'ON CONFLICT (project_id, key, target_language_id) DO NOTHING';

        final sql = '''
          INSERT INTO {translation_entries} 
          (project_id, key, entry_key, source_language_id, target_language_id, 
           source_text, target_text, status)
          VALUES (@project_id, @key, @key, @source_language_id, @target_language_id,
                  @source_text, @target_text, @status)
          $onConflict
          RETURNING id
        ''';

        await _databaseService.query(sql, {
          'project_id': projectId,
          'key': key,
          'source_language_id': sourceLanguageId,
          'target_language_id': targetLanguageId,
          'source_text': sourceText,
          'target_text': targetText,
          'status': status,
        });

        success++;
      } catch (error) {
        failed++;
        errors.add({
          'entry': entry,
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

  /// 转义SQL字符串
  String _escape(String text) {
    return text.replaceAll("'", "''").replaceAll(r'\', r'\\');
  }
}
