import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'translation_batch_job_model.freezed.dart';
part 'translation_batch_job_model.g.dart';

/// 翻译批量任务模型
@freezed
class TranslationBatchJobModel with _$TranslationBatchJobModel {
  const factory TranslationBatchJobModel({
    /// 任务ID（UUID）
    @JsonKey(name: 'id') required String id,

    /// 项目ID
    @JsonKey(name: 'project_id') @FlexibleIntConverter() required int projectId,

    /// 任务类型
    @JsonKey(name: 'job_type') required String jobType,

    /// 任务状态
    @JsonKey(name: 'status') @Default('pending') String status,

    /// 任务配置（JSONB格式）
    @JsonKey(name: 'config') @Default({}) Map<String, dynamic> config,

    /// 总条目数
    @JsonKey(name: 'total_items') @FlexibleIntConverter() @Default(0) int totalItems,

    /// 已处理条目数
    @JsonKey(name: 'processed_items') @FlexibleIntConverter() @Default(0) int processedItems,

    /// 成功条目数
    @JsonKey(name: 'success_items') @FlexibleIntConverter() @Default(0) int successItems,

    /// 失败条目数
    @JsonKey(name: 'failed_items') @FlexibleIntConverter() @Default(0) int failedItems,

    /// 任务结果（JSONB格式）
    @JsonKey(name: 'result') Map<String, dynamic>? result,

    /// 错误信息
    @JsonKey(name: 'error_message') String? errorMessage,

    /// 错误详情（JSONB格式）
    @JsonKey(name: 'error_details') Map<String, dynamic>? errorDetails,

    /// 创建者ID
    @JsonKey(name: 'created_by') required String createdBy,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 开始执行时间
    @JsonKey(name: 'started_at') @NullableTimesConverter() DateTime? startedAt,

    /// 完成时间
    @JsonKey(name: 'completed_at') @NullableTimesConverter() DateTime? completedAt,

    /// 文件路径（用于导入导出）
    @JsonKey(name: 'file_path') String? filePath,
  }) = _TranslationBatchJobModel;

  const TranslationBatchJobModel._();

  factory TranslationBatchJobModel.fromJson(Map<String, dynamic> json) => _$TranslationBatchJobModelFromJson(json);

  /// 获取进度百分比
  double get progress {
    if (totalItems == 0) return 0.0;
    return (processedItems / totalItems) * 100.0;
  }

  /// 是否已完成
  bool get isCompleted => status == 'completed';

  /// 是否失败
  bool get isFailed => status == 'failed';

  /// 是否处理中
  bool get isProcessing => status == 'processing';

  /// 是否已取消
  bool get isCancelled => status == 'cancelled';
}
