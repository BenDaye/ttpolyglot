// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_upload_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FileUploadModel _$FileUploadModelFromJson(Map<String, dynamic> json) {
  return _FileUploadModel.fromJson(json);
}

/// @nodoc
mixin _$FileUploadModel {
  /// 文件ID
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id => throw _privateConstructorUsedError;

  /// 用户ID
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// 原始文件名
  @JsonKey(name: 'original_filename')
  String get originalFilename => throw _privateConstructorUsedError;

  /// 存储文件名
  @JsonKey(name: 'stored_filename')
  String get storedFilename => throw _privateConstructorUsedError;

  /// 文件路径
  @JsonKey(name: 'file_path')
  String get filePath => throw _privateConstructorUsedError;

  /// 文件大小（字节）
  @JsonKey(name: 'file_size')
  int get fileSize => throw _privateConstructorUsedError;

  /// MIME类型
  @JsonKey(name: 'mime_type')
  String? get mimeType => throw _privateConstructorUsedError;

  /// 文件哈希值
  @JsonKey(name: 'file_hash')
  String? get fileHash => throw _privateConstructorUsedError;

  /// 上传类型
  @JsonKey(name: 'upload_type')
  String? get uploadType => throw _privateConstructorUsedError;

  /// 是否已处理
  @JsonKey(name: 'is_processed')
  bool get isProcessed => throw _privateConstructorUsedError;

  /// 处理状态
  @JsonKey(name: 'processing_status')
  String get processingStatus => throw _privateConstructorUsedError;

  /// 元数据（JSONB格式）
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 过期时间
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this FileUploadModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FileUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FileUploadModelCopyWith<FileUploadModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FileUploadModelCopyWith<$Res> {
  factory $FileUploadModelCopyWith(
          FileUploadModel value, $Res Function(FileUploadModel) then) =
      _$FileUploadModelCopyWithImpl<$Res, FileUploadModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'original_filename') String originalFilename,
      @JsonKey(name: 'stored_filename') String storedFilename,
      @JsonKey(name: 'file_path') String filePath,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'mime_type') String? mimeType,
      @JsonKey(name: 'file_hash') String? fileHash,
      @JsonKey(name: 'upload_type') String? uploadType,
      @JsonKey(name: 'is_processed') bool isProcessed,
      @JsonKey(name: 'processing_status') String processingStatus,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      DateTime? expiresAt});
}

/// @nodoc
class _$FileUploadModelCopyWithImpl<$Res, $Val extends FileUploadModel>
    implements $FileUploadModelCopyWith<$Res> {
  _$FileUploadModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FileUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? originalFilename = null,
    Object? storedFilename = null,
    Object? filePath = null,
    Object? fileSize = null,
    Object? mimeType = freezed,
    Object? fileHash = freezed,
    Object? uploadType = freezed,
    Object? isProcessed = null,
    Object? processingStatus = null,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilename: null == originalFilename
          ? _value.originalFilename
          : originalFilename // ignore: cast_nullable_to_non_nullable
              as String,
      storedFilename: null == storedFilename
          ? _value.storedFilename
          : storedFilename // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      fileHash: freezed == fileHash
          ? _value.fileHash
          : fileHash // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadType: freezed == uploadType
          ? _value.uploadType
          : uploadType // ignore: cast_nullable_to_non_nullable
              as String?,
      isProcessed: null == isProcessed
          ? _value.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      processingStatus: null == processingStatus
          ? _value.processingStatus
          : processingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FileUploadModelImplCopyWith<$Res>
    implements $FileUploadModelCopyWith<$Res> {
  factory _$$FileUploadModelImplCopyWith(_$FileUploadModelImpl value,
          $Res Function(_$FileUploadModelImpl) then) =
      __$$FileUploadModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'original_filename') String originalFilename,
      @JsonKey(name: 'stored_filename') String storedFilename,
      @JsonKey(name: 'file_path') String filePath,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'mime_type') String? mimeType,
      @JsonKey(name: 'file_hash') String? fileHash,
      @JsonKey(name: 'upload_type') String? uploadType,
      @JsonKey(name: 'is_processed') bool isProcessed,
      @JsonKey(name: 'processing_status') String processingStatus,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      DateTime? expiresAt});
}

/// @nodoc
class __$$FileUploadModelImplCopyWithImpl<$Res>
    extends _$FileUploadModelCopyWithImpl<$Res, _$FileUploadModelImpl>
    implements _$$FileUploadModelImplCopyWith<$Res> {
  __$$FileUploadModelImplCopyWithImpl(
      _$FileUploadModelImpl _value, $Res Function(_$FileUploadModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FileUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? originalFilename = null,
    Object? storedFilename = null,
    Object? filePath = null,
    Object? fileSize = null,
    Object? mimeType = freezed,
    Object? fileHash = freezed,
    Object? uploadType = freezed,
    Object? isProcessed = null,
    Object? processingStatus = null,
    Object? metadata = freezed,
    Object? createdAt = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_$FileUploadModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilename: null == originalFilename
          ? _value.originalFilename
          : originalFilename // ignore: cast_nullable_to_non_nullable
              as String,
      storedFilename: null == storedFilename
          ? _value.storedFilename
          : storedFilename // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      fileHash: freezed == fileHash
          ? _value.fileHash
          : fileHash // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadType: freezed == uploadType
          ? _value.uploadType
          : uploadType // ignore: cast_nullable_to_non_nullable
              as String?,
      isProcessed: null == isProcessed
          ? _value.isProcessed
          : isProcessed // ignore: cast_nullable_to_non_nullable
              as bool,
      processingStatus: null == processingStatus
          ? _value.processingStatus
          : processingStatus // ignore: cast_nullable_to_non_nullable
              as String,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FileUploadModelImpl implements _FileUploadModel {
  const _$FileUploadModelImpl(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'original_filename') required this.originalFilename,
      @JsonKey(name: 'stored_filename') required this.storedFilename,
      @JsonKey(name: 'file_path') required this.filePath,
      @JsonKey(name: 'file_size') required this.fileSize,
      @JsonKey(name: 'mime_type') this.mimeType,
      @JsonKey(name: 'file_hash') this.fileHash,
      @JsonKey(name: 'upload_type') this.uploadType,
      @JsonKey(name: 'is_processed') this.isProcessed = false,
      @JsonKey(name: 'processing_status') this.processingStatus = 'pending',
      @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'expires_at') @NullableTimesConverter() this.expiresAt})
      : _metadata = metadata;

  factory _$FileUploadModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FileUploadModelImplFromJson(json);

  /// 文件ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  final int id;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// 原始文件名
  @override
  @JsonKey(name: 'original_filename')
  final String originalFilename;

  /// 存储文件名
  @override
  @JsonKey(name: 'stored_filename')
  final String storedFilename;

  /// 文件路径
  @override
  @JsonKey(name: 'file_path')
  final String filePath;

  /// 文件大小（字节）
  @override
  @JsonKey(name: 'file_size')
  final int fileSize;

  /// MIME类型
  @override
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  /// 文件哈希值
  @override
  @JsonKey(name: 'file_hash')
  final String? fileHash;

  /// 上传类型
  @override
  @JsonKey(name: 'upload_type')
  final String? uploadType;

  /// 是否已处理
  @override
  @JsonKey(name: 'is_processed')
  final bool isProcessed;

  /// 处理状态
  @override
  @JsonKey(name: 'processing_status')
  final String processingStatus;

  /// 元数据（JSONB格式）
  final Map<String, dynamic>? _metadata;

  /// 元数据（JSONB格式）
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  final DateTime createdAt;

  /// 过期时间
  @override
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'FileUploadModel(id: $id, userId: $userId, originalFilename: $originalFilename, storedFilename: $storedFilename, filePath: $filePath, fileSize: $fileSize, mimeType: $mimeType, fileHash: $fileHash, uploadType: $uploadType, isProcessed: $isProcessed, processingStatus: $processingStatus, metadata: $metadata, createdAt: $createdAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FileUploadModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.originalFilename, originalFilename) ||
                other.originalFilename == originalFilename) &&
            (identical(other.storedFilename, storedFilename) ||
                other.storedFilename == storedFilename) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.fileHash, fileHash) ||
                other.fileHash == fileHash) &&
            (identical(other.uploadType, uploadType) ||
                other.uploadType == uploadType) &&
            (identical(other.isProcessed, isProcessed) ||
                other.isProcessed == isProcessed) &&
            (identical(other.processingStatus, processingStatus) ||
                other.processingStatus == processingStatus) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      originalFilename,
      storedFilename,
      filePath,
      fileSize,
      mimeType,
      fileHash,
      uploadType,
      isProcessed,
      processingStatus,
      const DeepCollectionEquality().hash(_metadata),
      createdAt,
      expiresAt);

  /// Create a copy of FileUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FileUploadModelImplCopyWith<_$FileUploadModelImpl> get copyWith =>
      __$$FileUploadModelImplCopyWithImpl<_$FileUploadModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FileUploadModelImplToJson(
      this,
    );
  }
}

abstract class _FileUploadModel implements FileUploadModel {
  const factory _FileUploadModel(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required final int id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'original_filename')
      required final String originalFilename,
      @JsonKey(name: 'stored_filename') required final String storedFilename,
      @JsonKey(name: 'file_path') required final String filePath,
      @JsonKey(name: 'file_size') required final int fileSize,
      @JsonKey(name: 'mime_type') final String? mimeType,
      @JsonKey(name: 'file_hash') final String? fileHash,
      @JsonKey(name: 'upload_type') final String? uploadType,
      @JsonKey(name: 'is_processed') final bool isProcessed,
      @JsonKey(name: 'processing_status') final String processingStatus,
      @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      final DateTime? expiresAt}) = _$FileUploadModelImpl;

  factory _FileUploadModel.fromJson(Map<String, dynamic> json) =
      _$FileUploadModelImpl.fromJson;

  /// 文件ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// 原始文件名
  @override
  @JsonKey(name: 'original_filename')
  String get originalFilename;

  /// 存储文件名
  @override
  @JsonKey(name: 'stored_filename')
  String get storedFilename;

  /// 文件路径
  @override
  @JsonKey(name: 'file_path')
  String get filePath;

  /// 文件大小（字节）
  @override
  @JsonKey(name: 'file_size')
  int get fileSize;

  /// MIME类型
  @override
  @JsonKey(name: 'mime_type')
  String? get mimeType;

  /// 文件哈希值
  @override
  @JsonKey(name: 'file_hash')
  String? get fileHash;

  /// 上传类型
  @override
  @JsonKey(name: 'upload_type')
  String? get uploadType;

  /// 是否已处理
  @override
  @JsonKey(name: 'is_processed')
  bool get isProcessed;

  /// 处理状态
  @override
  @JsonKey(name: 'processing_status')
  String get processingStatus;

  /// 元数据（JSONB格式）
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;

  /// 过期时间
  @override
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  DateTime? get expiresAt;

  /// Create a copy of FileUploadModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FileUploadModelImplCopyWith<_$FileUploadModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateFileUploadRequest _$CreateFileUploadRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateFileUploadRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateFileUploadRequest {
  /// 用户ID
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// 原始文件名
  @JsonKey(name: 'original_filename')
  String get originalFilename => throw _privateConstructorUsedError;

  /// 文件大小
  @JsonKey(name: 'file_size')
  int get fileSize => throw _privateConstructorUsedError;

  /// MIME类型
  @JsonKey(name: 'mime_type')
  String? get mimeType => throw _privateConstructorUsedError;

  /// 上传类型
  @JsonKey(name: 'upload_type')
  String? get uploadType => throw _privateConstructorUsedError;

  /// 元数据
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// 过期时间
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this CreateFileUploadRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateFileUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateFileUploadRequestCopyWith<CreateFileUploadRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateFileUploadRequestCopyWith<$Res> {
  factory $CreateFileUploadRequestCopyWith(CreateFileUploadRequest value,
          $Res Function(CreateFileUploadRequest) then) =
      _$CreateFileUploadRequestCopyWithImpl<$Res, CreateFileUploadRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'original_filename') String originalFilename,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'mime_type') String? mimeType,
      @JsonKey(name: 'upload_type') String? uploadType,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      DateTime? expiresAt});
}

/// @nodoc
class _$CreateFileUploadRequestCopyWithImpl<$Res,
        $Val extends CreateFileUploadRequest>
    implements $CreateFileUploadRequestCopyWith<$Res> {
  _$CreateFileUploadRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateFileUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? originalFilename = null,
    Object? fileSize = null,
    Object? mimeType = freezed,
    Object? uploadType = freezed,
    Object? metadata = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilename: null == originalFilename
          ? _value.originalFilename
          : originalFilename // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadType: freezed == uploadType
          ? _value.uploadType
          : uploadType // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateFileUploadRequestImplCopyWith<$Res>
    implements $CreateFileUploadRequestCopyWith<$Res> {
  factory _$$CreateFileUploadRequestImplCopyWith(
          _$CreateFileUploadRequestImpl value,
          $Res Function(_$CreateFileUploadRequestImpl) then) =
      __$$CreateFileUploadRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'original_filename') String originalFilename,
      @JsonKey(name: 'file_size') int fileSize,
      @JsonKey(name: 'mime_type') String? mimeType,
      @JsonKey(name: 'upload_type') String? uploadType,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      DateTime? expiresAt});
}

/// @nodoc
class __$$CreateFileUploadRequestImplCopyWithImpl<$Res>
    extends _$CreateFileUploadRequestCopyWithImpl<$Res,
        _$CreateFileUploadRequestImpl>
    implements _$$CreateFileUploadRequestImplCopyWith<$Res> {
  __$$CreateFileUploadRequestImplCopyWithImpl(
      _$CreateFileUploadRequestImpl _value,
      $Res Function(_$CreateFileUploadRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateFileUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? originalFilename = null,
    Object? fileSize = null,
    Object? mimeType = freezed,
    Object? uploadType = freezed,
    Object? metadata = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$CreateFileUploadRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilename: null == originalFilename
          ? _value.originalFilename
          : originalFilename // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: null == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadType: freezed == uploadType
          ? _value.uploadType
          : uploadType // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateFileUploadRequestImpl implements _CreateFileUploadRequest {
  const _$CreateFileUploadRequestImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'original_filename') required this.originalFilename,
      @JsonKey(name: 'file_size') required this.fileSize,
      @JsonKey(name: 'mime_type') this.mimeType,
      @JsonKey(name: 'upload_type') this.uploadType,
      @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata,
      @JsonKey(name: 'expires_at') @NullableTimesConverter() this.expiresAt})
      : _metadata = metadata;

  factory _$CreateFileUploadRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateFileUploadRequestImplFromJson(json);

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// 原始文件名
  @override
  @JsonKey(name: 'original_filename')
  final String originalFilename;

  /// 文件大小
  @override
  @JsonKey(name: 'file_size')
  final int fileSize;

  /// MIME类型
  @override
  @JsonKey(name: 'mime_type')
  final String? mimeType;

  /// 上传类型
  @override
  @JsonKey(name: 'upload_type')
  final String? uploadType;

  /// 元数据
  final Map<String, dynamic>? _metadata;

  /// 元数据
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 过期时间
  @override
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'CreateFileUploadRequest(userId: $userId, originalFilename: $originalFilename, fileSize: $fileSize, mimeType: $mimeType, uploadType: $uploadType, metadata: $metadata, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateFileUploadRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.originalFilename, originalFilename) ||
                other.originalFilename == originalFilename) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.uploadType, uploadType) ||
                other.uploadType == uploadType) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      originalFilename,
      fileSize,
      mimeType,
      uploadType,
      const DeepCollectionEquality().hash(_metadata),
      expiresAt);

  /// Create a copy of CreateFileUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateFileUploadRequestImplCopyWith<_$CreateFileUploadRequestImpl>
      get copyWith => __$$CreateFileUploadRequestImplCopyWithImpl<
          _$CreateFileUploadRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateFileUploadRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateFileUploadRequest implements CreateFileUploadRequest {
  const factory _CreateFileUploadRequest(
      {@JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'original_filename')
      required final String originalFilename,
      @JsonKey(name: 'file_size') required final int fileSize,
      @JsonKey(name: 'mime_type') final String? mimeType,
      @JsonKey(name: 'upload_type') final String? uploadType,
      @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      final DateTime? expiresAt}) = _$CreateFileUploadRequestImpl;

  factory _CreateFileUploadRequest.fromJson(Map<String, dynamic> json) =
      _$CreateFileUploadRequestImpl.fromJson;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// 原始文件名
  @override
  @JsonKey(name: 'original_filename')
  String get originalFilename;

  /// 文件大小
  @override
  @JsonKey(name: 'file_size')
  int get fileSize;

  /// MIME类型
  @override
  @JsonKey(name: 'mime_type')
  String? get mimeType;

  /// 上传类型
  @override
  @JsonKey(name: 'upload_type')
  String? get uploadType;

  /// 元数据
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata;

  /// 过期时间
  @override
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  DateTime? get expiresAt;

  /// Create a copy of CreateFileUploadRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateFileUploadRequestImplCopyWith<_$CreateFileUploadRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
