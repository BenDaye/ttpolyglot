import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'file_upload_model.freezed.dart';
part 'file_upload_model.g.dart';

/// 文件上传模型
@freezed
class FileUploadModel with _$FileUploadModel {
  const factory FileUploadModel({
    /// 文件ID
    @JsonKey(name: 'id') @FlexibleIntConverter() required int id,

    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 原始文件名
    @JsonKey(name: 'original_filename') required String originalFilename,

    /// 存储文件名
    @JsonKey(name: 'stored_filename') required String storedFilename,

    /// 文件路径
    @JsonKey(name: 'file_path') required String filePath,

    /// 文件大小（字节）
    @JsonKey(name: 'file_size') required int fileSize,

    /// MIME类型
    @JsonKey(name: 'mime_type') String? mimeType,

    /// 文件哈希值
    @JsonKey(name: 'file_hash') String? fileHash,

    /// 上传类型
    @JsonKey(name: 'upload_type') String? uploadType,

    /// 是否已处理
    @JsonKey(name: 'is_processed') @Default(false) bool isProcessed,

    /// 处理状态
    @JsonKey(name: 'processing_status') @Default('pending') String processingStatus,

    /// 元数据（JSONB格式）
    @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 过期时间
    @JsonKey(name: 'expires_at') @NullableTimesConverter() DateTime? expiresAt,
  }) = _FileUploadModel;

  factory FileUploadModel.fromJson(Map<String, dynamic> json) => _$FileUploadModelFromJson(json);
}

/// 创建文件上传请求模型
@freezed
class CreateFileUploadRequest with _$CreateFileUploadRequest {
  const factory CreateFileUploadRequest({
    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 原始文件名
    @JsonKey(name: 'original_filename') required String originalFilename,

    /// 文件大小
    @JsonKey(name: 'file_size') required int fileSize,

    /// MIME类型
    @JsonKey(name: 'mime_type') String? mimeType,

    /// 上传类型
    @JsonKey(name: 'upload_type') String? uploadType,

    /// 元数据
    @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,

    /// 过期时间
    @JsonKey(name: 'expires_at') @NullableTimesConverter() DateTime? expiresAt,
  }) = _CreateFileUploadRequest;

  factory CreateFileUploadRequest.fromJson(Map<String, dynamic> json) => _$CreateFileUploadRequestFromJson(json);
}
