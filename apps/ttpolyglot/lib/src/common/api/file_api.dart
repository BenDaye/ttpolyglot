import 'dart:developer';

import 'package:ttpolyglot/src/common/network/http_client.dart';

/// 文件/批量任务 API
class FileApi {
  /// 获取批量任务列表（导入/导出历史）
  Future<Map<String, dynamic>?> getBatchJobs({
    required int projectId,
    String? jobType,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (jobType != null) {
        queryParams['job_type'] = jobType;
      }

      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await HttpClient.get(
        '/projects/$projectId/batch-jobs',
        query: queryParams,
      );

      return response.data as Map<String, dynamic>?;
    } catch (error, stackTrace) {
      log('[getBatchJobs]', error: error, stackTrace: stackTrace, name: 'FileApi');
      return null;
    }
  }

  /// 创建批量任务记录（上报导入/导出结果）
  Future<bool> createBatchJobRecord({
    required int projectId,
    required String jobType,
    required String status,
    required int totalItems,
    int successItems = 0,
    int failedItems = 0,
    Map<String, dynamic>? config,
    Map<String, dynamic>? result,
    String? errorMessage,
    String? filePath,
  }) async {
    try {
      await HttpClient.post(
        '/projects/$projectId/batch-jobs',
        data: {
          'job_type': jobType,
          'status': status,
          'total_items': totalItems,
          'success_items': successItems,
          'failed_items': failedItems,
          if (config != null) 'config': config,
          if (result != null) 'result': result,
          if (errorMessage != null) 'error_message': errorMessage,
          if (filePath != null) 'file_path': filePath,
        },
      );
      return true;
    } catch (error, stackTrace) {
      log('[createBatchJobRecord]', error: error, stackTrace: stackTrace, name: 'FileApi');
      return false;
    }
  }
}
