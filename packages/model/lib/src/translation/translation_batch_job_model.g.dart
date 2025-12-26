// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_batch_job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranslationBatchJobModelImpl _$$TranslationBatchJobModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TranslationBatchJobModelImpl(
      id: json['id'] as String,
      projectId: const FlexibleIntConverter().fromJson(json['project_id']),
      jobType: json['job_type'] as String,
      status: json['status'] as String? ?? 'pending',
      config: json['config'] as Map<String, dynamic>? ?? const {},
      totalItems: json['total_items'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['total_items']),
      processedItems: json['processed_items'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['processed_items']),
      successItems: json['success_items'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['success_items']),
      failedItems: json['failed_items'] == null
          ? 0
          : const FlexibleIntConverter().fromJson(json['failed_items']),
      result: json['result'] as Map<String, dynamic>?,
      errorMessage: json['error_message'] as String?,
      errorDetails: json['error_details'] as Map<String, dynamic>?,
      createdBy: json['created_by'] as String,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      startedAt: const NullableTimesConverter().fromJson(json['started_at']),
      completedAt:
          const NullableTimesConverter().fromJson(json['completed_at']),
      filePath: json['file_path'] as String?,
    );

Map<String, dynamic> _$$TranslationBatchJobModelImplToJson(
        _$TranslationBatchJobModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project_id': const FlexibleIntConverter().toJson(instance.projectId),
      'job_type': instance.jobType,
      'status': instance.status,
      'config': instance.config,
      'total_items': const FlexibleIntConverter().toJson(instance.totalItems),
      'processed_items':
          const FlexibleIntConverter().toJson(instance.processedItems),
      'success_items':
          const FlexibleIntConverter().toJson(instance.successItems),
      'failed_items': const FlexibleIntConverter().toJson(instance.failedItems),
      'result': instance.result,
      'error_message': instance.errorMessage,
      'error_details': instance.errorDetails,
      'created_by': instance.createdBy,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'started_at': const NullableTimesConverter().toJson(instance.startedAt),
      'completed_at':
          const NullableTimesConverter().toJson(instance.completedAt),
      'file_path': instance.filePath,
    };
