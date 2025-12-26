// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_batch_job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranslationBatchJobModel _$TranslationBatchJobModelFromJson(
    Map<String, dynamic> json) {
  return _TranslationBatchJobModel.fromJson(json);
}

/// @nodoc
mixin _$TranslationBatchJobModel {
  /// 任务ID（UUID）
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// 项目ID
  @JsonKey(name: 'project_id')
  @FlexibleIntConverter()
  int get projectId => throw _privateConstructorUsedError;

  /// 任务类型
  @JsonKey(name: 'job_type')
  String get jobType => throw _privateConstructorUsedError;

  /// 任务状态
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;

  /// 任务配置（JSONB格式）
  @JsonKey(name: 'config')
  Map<String, dynamic> get config => throw _privateConstructorUsedError;

  /// 总条目数
  @JsonKey(name: 'total_items')
  @FlexibleIntConverter()
  int get totalItems => throw _privateConstructorUsedError;

  /// 已处理条目数
  @JsonKey(name: 'processed_items')
  @FlexibleIntConverter()
  int get processedItems => throw _privateConstructorUsedError;

  /// 成功条目数
  @JsonKey(name: 'success_items')
  @FlexibleIntConverter()
  int get successItems => throw _privateConstructorUsedError;

  /// 失败条目数
  @JsonKey(name: 'failed_items')
  @FlexibleIntConverter()
  int get failedItems => throw _privateConstructorUsedError;

  /// 任务结果（JSONB格式）
  @JsonKey(name: 'result')
  Map<String, dynamic>? get result => throw _privateConstructorUsedError;

  /// 错误信息
  @JsonKey(name: 'error_message')
  String? get errorMessage => throw _privateConstructorUsedError;

  /// 错误详情（JSONB格式）
  @JsonKey(name: 'error_details')
  Map<String, dynamic>? get errorDetails => throw _privateConstructorUsedError;

  /// 创建者ID
  @JsonKey(name: 'created_by')
  String get createdBy => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 开始执行时间
  @JsonKey(name: 'started_at')
  @NullableTimesConverter()
  DateTime? get startedAt => throw _privateConstructorUsedError;

  /// 完成时间
  @JsonKey(name: 'completed_at')
  @NullableTimesConverter()
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// 文件路径（用于导入导出）
  @JsonKey(name: 'file_path')
  String? get filePath => throw _privateConstructorUsedError;

  /// Serializes this TranslationBatchJobModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationBatchJobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationBatchJobModelCopyWith<TranslationBatchJobModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationBatchJobModelCopyWith<$Res> {
  factory $TranslationBatchJobModelCopyWith(TranslationBatchJobModel value,
          $Res Function(TranslationBatchJobModel) then) =
      _$TranslationBatchJobModelCopyWithImpl<$Res, TranslationBatchJobModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'project_id') @FlexibleIntConverter() int projectId,
      @JsonKey(name: 'job_type') String jobType,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'config') Map<String, dynamic> config,
      @JsonKey(name: 'total_items') @FlexibleIntConverter() int totalItems,
      @JsonKey(name: 'processed_items')
      @FlexibleIntConverter()
      int processedItems,
      @JsonKey(name: 'success_items') @FlexibleIntConverter() int successItems,
      @JsonKey(name: 'failed_items') @FlexibleIntConverter() int failedItems,
      @JsonKey(name: 'result') Map<String, dynamic>? result,
      @JsonKey(name: 'error_message') String? errorMessage,
      @JsonKey(name: 'error_details') Map<String, dynamic>? errorDetails,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'started_at')
      @NullableTimesConverter()
      DateTime? startedAt,
      @JsonKey(name: 'completed_at')
      @NullableTimesConverter()
      DateTime? completedAt,
      @JsonKey(name: 'file_path') String? filePath});
}

/// @nodoc
class _$TranslationBatchJobModelCopyWithImpl<$Res,
        $Val extends TranslationBatchJobModel>
    implements $TranslationBatchJobModelCopyWith<$Res> {
  _$TranslationBatchJobModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationBatchJobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? jobType = null,
    Object? status = null,
    Object? config = null,
    Object? totalItems = null,
    Object? processedItems = null,
    Object? successItems = null,
    Object? failedItems = null,
    Object? result = freezed,
    Object? errorMessage = freezed,
    Object? errorDetails = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? filePath = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      jobType: null == jobType
          ? _value.jobType
          : jobType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      processedItems: null == processedItems
          ? _value.processedItems
          : processedItems // ignore: cast_nullable_to_non_nullable
              as int,
      successItems: null == successItems
          ? _value.successItems
          : successItems // ignore: cast_nullable_to_non_nullable
              as int,
      failedItems: null == failedItems
          ? _value.failedItems
          : failedItems // ignore: cast_nullable_to_non_nullable
              as int,
      result: freezed == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      errorDetails: freezed == errorDetails
          ? _value.errorDetails
          : errorDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslationBatchJobModelImplCopyWith<$Res>
    implements $TranslationBatchJobModelCopyWith<$Res> {
  factory _$$TranslationBatchJobModelImplCopyWith(
          _$TranslationBatchJobModelImpl value,
          $Res Function(_$TranslationBatchJobModelImpl) then) =
      __$$TranslationBatchJobModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'project_id') @FlexibleIntConverter() int projectId,
      @JsonKey(name: 'job_type') String jobType,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'config') Map<String, dynamic> config,
      @JsonKey(name: 'total_items') @FlexibleIntConverter() int totalItems,
      @JsonKey(name: 'processed_items')
      @FlexibleIntConverter()
      int processedItems,
      @JsonKey(name: 'success_items') @FlexibleIntConverter() int successItems,
      @JsonKey(name: 'failed_items') @FlexibleIntConverter() int failedItems,
      @JsonKey(name: 'result') Map<String, dynamic>? result,
      @JsonKey(name: 'error_message') String? errorMessage,
      @JsonKey(name: 'error_details') Map<String, dynamic>? errorDetails,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'started_at')
      @NullableTimesConverter()
      DateTime? startedAt,
      @JsonKey(name: 'completed_at')
      @NullableTimesConverter()
      DateTime? completedAt,
      @JsonKey(name: 'file_path') String? filePath});
}

/// @nodoc
class __$$TranslationBatchJobModelImplCopyWithImpl<$Res>
    extends _$TranslationBatchJobModelCopyWithImpl<$Res,
        _$TranslationBatchJobModelImpl>
    implements _$$TranslationBatchJobModelImplCopyWith<$Res> {
  __$$TranslationBatchJobModelImplCopyWithImpl(
      _$TranslationBatchJobModelImpl _value,
      $Res Function(_$TranslationBatchJobModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranslationBatchJobModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? jobType = null,
    Object? status = null,
    Object? config = null,
    Object? totalItems = null,
    Object? processedItems = null,
    Object? successItems = null,
    Object? failedItems = null,
    Object? result = freezed,
    Object? errorMessage = freezed,
    Object? errorDetails = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? filePath = freezed,
  }) {
    return _then(_$TranslationBatchJobModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      jobType: null == jobType
          ? _value.jobType
          : jobType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      config: null == config
          ? _value._config
          : config // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      processedItems: null == processedItems
          ? _value.processedItems
          : processedItems // ignore: cast_nullable_to_non_nullable
              as int,
      successItems: null == successItems
          ? _value.successItems
          : successItems // ignore: cast_nullable_to_non_nullable
              as int,
      failedItems: null == failedItems
          ? _value.failedItems
          : failedItems // ignore: cast_nullable_to_non_nullable
              as int,
      result: freezed == result
          ? _value._result
          : result // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      errorDetails: freezed == errorDetails
          ? _value._errorDetails
          : errorDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      filePath: freezed == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationBatchJobModelImpl extends _TranslationBatchJobModel {
  const _$TranslationBatchJobModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'project_id')
      @FlexibleIntConverter()
      required this.projectId,
      @JsonKey(name: 'job_type') required this.jobType,
      @JsonKey(name: 'status') this.status = 'pending',
      @JsonKey(name: 'config') final Map<String, dynamic> config = const {},
      @JsonKey(name: 'total_items') @FlexibleIntConverter() this.totalItems = 0,
      @JsonKey(name: 'processed_items')
      @FlexibleIntConverter()
      this.processedItems = 0,
      @JsonKey(name: 'success_items')
      @FlexibleIntConverter()
      this.successItems = 0,
      @JsonKey(name: 'failed_items')
      @FlexibleIntConverter()
      this.failedItems = 0,
      @JsonKey(name: 'result') final Map<String, dynamic>? result,
      @JsonKey(name: 'error_message') this.errorMessage,
      @JsonKey(name: 'error_details') final Map<String, dynamic>? errorDetails,
      @JsonKey(name: 'created_by') required this.createdBy,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'started_at') @NullableTimesConverter() this.startedAt,
      @JsonKey(name: 'completed_at') @NullableTimesConverter() this.completedAt,
      @JsonKey(name: 'file_path') this.filePath})
      : _config = config,
        _result = result,
        _errorDetails = errorDetails,
        super._();

  factory _$TranslationBatchJobModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationBatchJobModelImplFromJson(json);

  /// 任务ID（UUID）
  @override
  @JsonKey(name: 'id')
  final String id;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  @FlexibleIntConverter()
  final int projectId;

  /// 任务类型
  @override
  @JsonKey(name: 'job_type')
  final String jobType;

  /// 任务状态
  @override
  @JsonKey(name: 'status')
  final String status;

  /// 任务配置（JSONB格式）
  final Map<String, dynamic> _config;

  /// 任务配置（JSONB格式）
  @override
  @JsonKey(name: 'config')
  Map<String, dynamic> get config {
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_config);
  }

  /// 总条目数
  @override
  @JsonKey(name: 'total_items')
  @FlexibleIntConverter()
  final int totalItems;

  /// 已处理条目数
  @override
  @JsonKey(name: 'processed_items')
  @FlexibleIntConverter()
  final int processedItems;

  /// 成功条目数
  @override
  @JsonKey(name: 'success_items')
  @FlexibleIntConverter()
  final int successItems;

  /// 失败条目数
  @override
  @JsonKey(name: 'failed_items')
  @FlexibleIntConverter()
  final int failedItems;

  /// 任务结果（JSONB格式）
  final Map<String, dynamic>? _result;

  /// 任务结果（JSONB格式）
  @override
  @JsonKey(name: 'result')
  Map<String, dynamic>? get result {
    final value = _result;
    if (value == null) return null;
    if (_result is EqualUnmodifiableMapView) return _result;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 错误信息
  @override
  @JsonKey(name: 'error_message')
  final String? errorMessage;

  /// 错误详情（JSONB格式）
  final Map<String, dynamic>? _errorDetails;

  /// 错误详情（JSONB格式）
  @override
  @JsonKey(name: 'error_details')
  Map<String, dynamic>? get errorDetails {
    final value = _errorDetails;
    if (value == null) return null;
    if (_errorDetails is EqualUnmodifiableMapView) return _errorDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 创建者ID
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  final DateTime createdAt;

  /// 开始执行时间
  @override
  @JsonKey(name: 'started_at')
  @NullableTimesConverter()
  final DateTime? startedAt;

  /// 完成时间
  @override
  @JsonKey(name: 'completed_at')
  @NullableTimesConverter()
  final DateTime? completedAt;

  /// 文件路径（用于导入导出）
  @override
  @JsonKey(name: 'file_path')
  final String? filePath;

  @override
  String toString() {
    return 'TranslationBatchJobModel(id: $id, projectId: $projectId, jobType: $jobType, status: $status, config: $config, totalItems: $totalItems, processedItems: $processedItems, successItems: $successItems, failedItems: $failedItems, result: $result, errorMessage: $errorMessage, errorDetails: $errorDetails, createdBy: $createdBy, createdAt: $createdAt, startedAt: $startedAt, completedAt: $completedAt, filePath: $filePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationBatchJobModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.jobType, jobType) || other.jobType == jobType) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._config, _config) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.processedItems, processedItems) ||
                other.processedItems == processedItems) &&
            (identical(other.successItems, successItems) ||
                other.successItems == successItems) &&
            (identical(other.failedItems, failedItems) ||
                other.failedItems == failedItems) &&
            const DeepCollectionEquality().equals(other._result, _result) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            const DeepCollectionEquality()
                .equals(other._errorDetails, _errorDetails) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      projectId,
      jobType,
      status,
      const DeepCollectionEquality().hash(_config),
      totalItems,
      processedItems,
      successItems,
      failedItems,
      const DeepCollectionEquality().hash(_result),
      errorMessage,
      const DeepCollectionEquality().hash(_errorDetails),
      createdBy,
      createdAt,
      startedAt,
      completedAt,
      filePath);

  /// Create a copy of TranslationBatchJobModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationBatchJobModelImplCopyWith<_$TranslationBatchJobModelImpl>
      get copyWith => __$$TranslationBatchJobModelImplCopyWithImpl<
          _$TranslationBatchJobModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationBatchJobModelImplToJson(
      this,
    );
  }
}

abstract class _TranslationBatchJobModel extends TranslationBatchJobModel {
  const factory _TranslationBatchJobModel(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'project_id')
      @FlexibleIntConverter()
      required final int projectId,
      @JsonKey(name: 'job_type') required final String jobType,
      @JsonKey(name: 'status') final String status,
      @JsonKey(name: 'config') final Map<String, dynamic> config,
      @JsonKey(name: 'total_items')
      @FlexibleIntConverter()
      final int totalItems,
      @JsonKey(name: 'processed_items')
      @FlexibleIntConverter()
      final int processedItems,
      @JsonKey(name: 'success_items')
      @FlexibleIntConverter()
      final int successItems,
      @JsonKey(name: 'failed_items')
      @FlexibleIntConverter()
      final int failedItems,
      @JsonKey(name: 'result') final Map<String, dynamic>? result,
      @JsonKey(name: 'error_message') final String? errorMessage,
      @JsonKey(name: 'error_details') final Map<String, dynamic>? errorDetails,
      @JsonKey(name: 'created_by') required final String createdBy,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'started_at')
      @NullableTimesConverter()
      final DateTime? startedAt,
      @JsonKey(name: 'completed_at')
      @NullableTimesConverter()
      final DateTime? completedAt,
      @JsonKey(name: 'file_path')
      final String? filePath}) = _$TranslationBatchJobModelImpl;
  const _TranslationBatchJobModel._() : super._();

  factory _TranslationBatchJobModel.fromJson(Map<String, dynamic> json) =
      _$TranslationBatchJobModelImpl.fromJson;

  /// 任务ID（UUID）
  @override
  @JsonKey(name: 'id')
  String get id;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  @FlexibleIntConverter()
  int get projectId;

  /// 任务类型
  @override
  @JsonKey(name: 'job_type')
  String get jobType;

  /// 任务状态
  @override
  @JsonKey(name: 'status')
  String get status;

  /// 任务配置（JSONB格式）
  @override
  @JsonKey(name: 'config')
  Map<String, dynamic> get config;

  /// 总条目数
  @override
  @JsonKey(name: 'total_items')
  @FlexibleIntConverter()
  int get totalItems;

  /// 已处理条目数
  @override
  @JsonKey(name: 'processed_items')
  @FlexibleIntConverter()
  int get processedItems;

  /// 成功条目数
  @override
  @JsonKey(name: 'success_items')
  @FlexibleIntConverter()
  int get successItems;

  /// 失败条目数
  @override
  @JsonKey(name: 'failed_items')
  @FlexibleIntConverter()
  int get failedItems;

  /// 任务结果（JSONB格式）
  @override
  @JsonKey(name: 'result')
  Map<String, dynamic>? get result;

  /// 错误信息
  @override
  @JsonKey(name: 'error_message')
  String? get errorMessage;

  /// 错误详情（JSONB格式）
  @override
  @JsonKey(name: 'error_details')
  Map<String, dynamic>? get errorDetails;

  /// 创建者ID
  @override
  @JsonKey(name: 'created_by')
  String get createdBy;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;

  /// 开始执行时间
  @override
  @JsonKey(name: 'started_at')
  @NullableTimesConverter()
  DateTime? get startedAt;

  /// 完成时间
  @override
  @JsonKey(name: 'completed_at')
  @NullableTimesConverter()
  DateTime? get completedAt;

  /// 文件路径（用于导入导出）
  @override
  @JsonKey(name: 'file_path')
  String? get filePath;

  /// Create a copy of TranslationBatchJobModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationBatchJobModelImplCopyWith<_$TranslationBatchJobModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
