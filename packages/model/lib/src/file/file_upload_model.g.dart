// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FileUploadModelImpl _$$FileUploadModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FileUploadModelImpl(
      id: const FlexibleIntConverter().fromJson(json['id']),
      userId: json['user_id'] as String,
      originalFilename: json['original_filename'] as String,
      storedFilename: json['stored_filename'] as String,
      filePath: json['file_path'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String?,
      fileHash: json['file_hash'] as String?,
      uploadType: json['upload_type'] as String?,
      isProcessed: json['is_processed'] as bool? ?? false,
      processingStatus: json['processing_status'] as String? ?? 'pending',
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      expiresAt: const NullableTimesConverter().fromJson(json['expires_at']),
    );

Map<String, dynamic> _$$FileUploadModelImplToJson(
        _$FileUploadModelImpl instance) =>
    <String, dynamic>{
      'id': const FlexibleIntConverter().toJson(instance.id),
      'user_id': instance.userId,
      'original_filename': instance.originalFilename,
      'stored_filename': instance.storedFilename,
      'file_path': instance.filePath,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'file_hash': instance.fileHash,
      'upload_type': instance.uploadType,
      'is_processed': instance.isProcessed,
      'processing_status': instance.processingStatus,
      'metadata': instance.metadata,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'expires_at': const NullableTimesConverter().toJson(instance.expiresAt),
    };

_$CreateFileUploadRequestImpl _$$CreateFileUploadRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateFileUploadRequestImpl(
      userId: json['user_id'] as String,
      originalFilename: json['original_filename'] as String,
      fileSize: (json['file_size'] as num).toInt(),
      mimeType: json['mime_type'] as String?,
      uploadType: json['upload_type'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      expiresAt: const NullableTimesConverter().fromJson(json['expires_at']),
    );

Map<String, dynamic> _$$CreateFileUploadRequestImplToJson(
        _$CreateFileUploadRequestImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'original_filename': instance.originalFilename,
      'file_size': instance.fileSize,
      'mime_type': instance.mimeType,
      'upload_type': instance.uploadType,
      'metadata': instance.metadata,
      'expires_at': const NullableTimesConverter().toJson(instance.expiresAt),
    };
