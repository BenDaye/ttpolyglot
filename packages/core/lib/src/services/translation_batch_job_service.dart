import 'package:ttpolyglot_model/model.dart';

/// 翻译批量任务服务接口
abstract class TranslationBatchJobService {
  /// 创建批量任务
  Future<TranslationBatchJobModel> createBatchJob(TranslationBatchJobModel job);

  /// 获取批量任务
  Future<TranslationBatchJobModel?> getBatchJob(String jobId);

  /// 获取项目的批量任务列表
  Future<List<TranslationBatchJobModel>> getProjectBatchJobs(
    int projectId, {
    String? jobType,
    String? status,
    int? limit,
    int? offset,
  });

  /// 获取用户的批量任务列表
  Future<List<TranslationBatchJobModel>> getUserBatchJobs(
    String userId, {
    String? status,
    int? limit,
    int? offset,
  });

  /// 更新任务状态
  Future<TranslationBatchJobModel> updateJobStatus(
    String jobId,
    String status, {
    DateTime? startedAt,
    DateTime? completedAt,
  });

  /// 更新任务进度
  Future<TranslationBatchJobModel> updateJobProgress(
    String jobId, {
    int? processedItems,
    int? successItems,
    int? failedItems,
  });

  /// 更新任务结果
  Future<TranslationBatchJobModel> updateJobResult(
    String jobId, {
    Map<String, dynamic>? result,
    String? errorMessage,
    Map<String, dynamic>? errorDetails,
  });

  /// 取消任务
  Future<TranslationBatchJobModel> cancelJob(String jobId);

  /// 删除任务
  Future<void> deleteJob(String jobId);

  /// 清理已完成的任务（保留指定天数）
  Future<int> cleanupCompletedJobs({int keepDays = 30});
}
