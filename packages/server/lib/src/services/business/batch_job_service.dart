import 'dart:convert';

import '../base_service.dart';
import '../infrastructure/database_service.dart';

/// 批量任务队列管理服务
///
/// 管理批量导入、导出、翻译等长时间运行的任务
class BatchJobService extends BaseService {
  final DatabaseService _databaseService;

  BatchJobService({
    required DatabaseService databaseService,
  })  : _databaseService = databaseService,
        super('BatchJobService');

  /// 创建批量任务
  Future<String> createBatchJob({
    required int projectId,
    required String jobType,
    required int totalItems,
    required String createdBy,
    Map<String, dynamic>? config,
    String? filePath,
  }) async {
    return execute(
      () async {
        logInfo('创建批量任务', context: {
          'project_id': projectId,
          'job_type': jobType,
          'total_items': totalItems,
        });

        final result = await _databaseService.query('''
          INSERT INTO {translation_batch_jobs} 
          (project_id, job_type, total_items, created_by, config, file_path)
          VALUES (@project_id, @job_type, @total_items, @created_by, @config::jsonb, @file_path)
          RETURNING id, created_at
        ''', {
          'project_id': projectId,
          'job_type': jobType,
          'total_items': totalItems,
          'created_by': createdBy,
          'config': jsonEncode(config ?? {}),
          'file_path': filePath,
        });

        final jobId = result.first.toColumnMap()['id'] as String;

        logInfo('批量任务已创建', context: {'job_id': jobId});
        return jobId;
      },
      operationName: 'createBatchJob',
    );
  }

  /// 获取批量任务列表
  Future<Map<String, dynamic>> getBatchJobs({
    int? projectId,
    String? status,
    String? jobType,
    int page = 1,
    int limit = 20,
  }) async {
    return execute(
      () async {
        logInfo('获取批量任务列表', context: {
          'project_id': projectId,
          'status': status,
          'page': page,
        });

        final conditions = <String>[];
        final parameters = <String, dynamic>{};

        if (projectId != null) {
          conditions.add('tbj.project_id = @project_id');
          parameters['project_id'] = projectId;
        }

        if (status != null && status != 'all') {
          conditions.add('tbj.status = @status');
          parameters['status'] = status;
        }

        if (jobType != null && jobType != 'all') {
          conditions.add('tbj.job_type = @job_type');
          parameters['job_type'] = jobType;
        }

        // 计算总数
        final whereClause = conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : '';

        final countSql = '''
          SELECT COUNT(*) FROM {translation_batch_jobs} tbj
          $whereClause
        ''';

        final countResult = await _databaseService.query(countSql, parameters);
        final totalRaw = countResult.first[0];
        final total = (totalRaw is int) ? totalRaw : int.parse(totalRaw.toString());

        // 获取分页数据
        final offset = (page - 1) * limit;
        parameters['limit'] = limit;
        parameters['offset'] = offset;

        final sql = '''
          SELECT
            tbj.*,
            u.username as created_by_username
          FROM {translation_batch_jobs} tbj
          LEFT JOIN {users} u ON tbj.created_by = u.id
          $whereClause
          ORDER BY tbj.created_at DESC
          LIMIT @limit OFFSET @offset
        ''';

        final result = await _databaseService.query(sql, parameters);
        final jobs = result.map((row) => row.toColumnMap()).toList();

        return {
          'jobs': jobs,
          'pagination': {
            'page': page,
            'limit': limit,
            'total': total,
            'pages': (total / limit).ceil(),
          },
        };
      },
      operationName: 'getBatchJobs',
    );
  }

  /// 根据ID获取批量任务详情
  Future<Map<String, dynamic>?> getBatchJobById(String jobId) async {
    return execute(
      () async {
        logInfo('获取批量任务详情', context: {'job_id': jobId});

        final result = await _databaseService.query('''
          SELECT
            tbj.*,
            u.username as created_by_username
          FROM {translation_batch_jobs} tbj
          LEFT JOIN {users} u ON tbj.created_by = u.id
          WHERE tbj.id = @job_id
        ''', {'job_id': jobId});

        if (result.isEmpty) {
          return null;
        }

        return result.first.toColumnMap();
      },
      operationName: 'getBatchJobById',
    );
  }

  /// 更新任务进度
  Future<void> updateJobProgress(
    String jobId, {
    required int processedItems,
    required int successItems,
    required int failedItems,
  }) async {
    return execute(
      () async {
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
      },
      operationName: 'updateJobProgress',
    );
  }

  /// 更新任务状态
  Future<void> updateJobStatus(
    String jobId,
    String status, {
    Map<String, dynamic>? result,
    String? errorMessage,
    Map<String, dynamic>? errorDetails,
  }) async {
    return execute(
      () async {
        logInfo('更新任务状态', context: {
          'job_id': jobId,
          'status': status,
        });

        final updates = <String>['status = @status'];
        final params = <String, dynamic>{
          'job_id': jobId,
          'status': status,
        };

        if (status == 'processing') {
          updates.add('started_at = CURRENT_TIMESTAMP');
        }

        if (status == 'completed' || status == 'failed' || status == 'cancelled') {
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

        if (errorDetails != null) {
          updates.add('error_details = @error_details::jsonb');
          params['error_details'] = jsonEncode(errorDetails);
        }

        await _databaseService.query('''
          UPDATE {translation_batch_jobs}
          SET ${updates.join(', ')}
          WHERE id = @job_id
        ''', params);
      },
      operationName: 'updateJobStatus',
    );
  }

  /// 取消批量任务
  Future<void> cancelBatchJob(String jobId, String userId) async {
    return execute(
      () async {
        logInfo('取消批量任务', context: {
          'job_id': jobId,
          'user_id': userId,
        });

        await updateJobStatus(
          jobId,
          'cancelled',
          errorMessage: 'Cancelled by user',
        );

        logInfo('批量任务已取消', context: {'job_id': jobId});
      },
      operationName: 'cancelBatchJob',
    );
  }

  /// 重试失败的任务
  Future<void> retryFailedJob(String jobId) async {
    return execute(
      () async {
        logInfo('重试失败任务', context: {'job_id': jobId});

        await _databaseService.query('''
          UPDATE {translation_batch_jobs}
          SET 
            status = 'pending',
            error_message = NULL,
            error_details = NULL,
            started_at = NULL,
            completed_at = NULL,
            processed_items = 0,
            success_items = 0,
            failed_items = 0
          WHERE id = @job_id AND status = 'failed'
        ''', {'job_id': jobId});

        logInfo('任务已重置为待处理', context: {'job_id': jobId});
      },
      operationName: 'retryFailedJob',
    );
  }

  /// 删除批量任务
  Future<void> deleteBatchJob(String jobId) async {
    return execute(
      () async {
        logInfo('删除批量任务', context: {'job_id': jobId});

        await _databaseService.query('''
          DELETE FROM {translation_batch_jobs}
          WHERE id = @job_id
        ''', {'job_id': jobId});

        logInfo('批量任务已删除', context: {'job_id': jobId});
      },
      operationName: 'deleteBatchJob',
    );
  }

  /// 获取项目的任务统计
  Future<Map<String, dynamic>> getProjectJobStats(int projectId) async {
    return execute(
      () async {
        logInfo('获取项目任务统计', context: {'project_id': projectId});

        final result = await _databaseService.query('''
          SELECT
            COUNT(*) as total_jobs,
            COUNT(*) FILTER (WHERE status = 'pending') as pending_jobs,
            COUNT(*) FILTER (WHERE status = 'processing') as processing_jobs,
            COUNT(*) FILTER (WHERE status = 'completed') as completed_jobs,
            COUNT(*) FILTER (WHERE status = 'failed') as failed_jobs,
            COUNT(*) FILTER (WHERE status = 'cancelled') as cancelled_jobs,
            COALESCE(SUM(success_items), 0) as total_success_items,
            COALESCE(SUM(failed_items), 0) as total_failed_items
          FROM {translation_batch_jobs}
          WHERE project_id = @project_id
        ''', {'project_id': projectId});

        return result.first.toColumnMap();
      },
      operationName: 'getProjectJobStats',
    );
  }

  /// 清理旧的已完成任务
  Future<int> cleanupOldJobs({
    int daysOld = 30,
    List<String> statusesToClean = const ['completed', 'cancelled'],
  }) async {
    return execute(
      () async {
        logInfo('清理旧任务', context: {
          'days_old': daysOld,
          'statuses': statusesToClean,
        });

        final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
        final statusList = statusesToClean.map((s) => "'$s'").join(',');

        final result = await _databaseService.query('''
          DELETE FROM {translation_batch_jobs}
          WHERE 
            completed_at < @cutoff_date
            AND status IN ($statusList)
          RETURNING id
        ''', {'cutoff_date': cutoffDate});

        final deletedCount = result.length;

        logInfo('清理完成', context: {'deleted_count': deletedCount});
        return deletedCount;
      },
      operationName: 'cleanupOldJobs',
    );
  }

  /// 获取正在处理的任务列表
  Future<List<Map<String, dynamic>>> getProcessingJobs() async {
    return execute(
      () async {
        logInfo('获取正在处理的任务');

        final result = await _databaseService.query('''
          SELECT
            tbj.*,
            u.username as created_by_username
          FROM {translation_batch_jobs} tbj
          LEFT JOIN {users} u ON tbj.created_by = u.id
          WHERE tbj.status = 'processing'
          ORDER BY tbj.started_at DESC
        ''', {});

        return result.map((row) => row.toColumnMap()).toList();
      },
      operationName: 'getProcessingJobs',
    );
  }

  /// 检查并标记超时的任务
  Future<int> markTimeoutJobs({int timeoutMinutes = 60}) async {
    return execute(
      () async {
        logInfo('检查超时任务', context: {'timeout_minutes': timeoutMinutes});

        final cutoffTime = DateTime.now().subtract(Duration(minutes: timeoutMinutes));

        final result = await _databaseService.query('''
          UPDATE {translation_batch_jobs}
          SET 
            status = 'failed',
            error_message = 'Task timeout after $timeoutMinutes minutes',
            completed_at = CURRENT_TIMESTAMP
          WHERE 
            status = 'processing'
            AND started_at < @cutoff_time
          RETURNING id
        ''', {'cutoff_time': cutoffTime});

        final markedCount = result.length;

        if (markedCount > 0) {
          logInfo('已标记超时任务', context: {'count': markedCount});
        }

        return markedCount;
      },
      operationName: 'markTimeoutJobs',
    );
  }
}
