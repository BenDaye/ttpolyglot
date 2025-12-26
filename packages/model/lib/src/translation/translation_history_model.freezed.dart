// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TranslationHistoryModel _$TranslationHistoryModelFromJson(
    Map<String, dynamic> json) {
  return _TranslationHistoryModel.fromJson(json);
}

/// @nodoc
mixin _$TranslationHistoryModel {
  /// 历史记录ID（BIGSERIAL）
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id => throw _privateConstructorUsedError;

  /// 翻译条目ID
  @JsonKey(name: 'entry_id')
  @FlexibleIntConverter()
  int get entryId => throw _privateConstructorUsedError;

  /// 翻译条目UUID
  @JsonKey(name: 'entry_uuid')
  String? get entryUuid => throw _privateConstructorUsedError;

  /// 项目ID
  @JsonKey(name: 'project_id')
  @FlexibleIntConverter()
  int get projectId => throw _privateConstructorUsedError;

  /// 旧的目标文本
  @JsonKey(name: 'old_target_text')
  String? get oldTargetText => throw _privateConstructorUsedError;

  /// 新的目标文本
  @JsonKey(name: 'new_target_text')
  String get newTargetText => throw _privateConstructorUsedError;

  /// 旧的状态
  @JsonKey(name: 'old_status')
  String? get oldStatus => throw _privateConstructorUsedError;

  /// 新的状态
  @JsonKey(name: 'new_status')
  String? get newStatus => throw _privateConstructorUsedError;

  /// 操作类型
  @JsonKey(name: 'action')
  String get action => throw _privateConstructorUsedError;

  /// 修改者ID
  @JsonKey(name: 'changed_by')
  String get changedBy => throw _privateConstructorUsedError;

  /// 修改时间
  @JsonKey(name: 'changed_at')
  @TimesConverter()
  DateTime get changedAt => throw _privateConstructorUsedError;

  /// 修改原因
  @JsonKey(name: 'reason')
  String? get reason => throw _privateConstructorUsedError;

  /// 元数据（JSONB格式）
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this TranslationHistoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranslationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranslationHistoryModelCopyWith<TranslationHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranslationHistoryModelCopyWith<$Res> {
  factory $TranslationHistoryModelCopyWith(TranslationHistoryModel value,
          $Res Function(TranslationHistoryModel) then) =
      _$TranslationHistoryModelCopyWithImpl<$Res, TranslationHistoryModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'entry_id') @FlexibleIntConverter() int entryId,
      @JsonKey(name: 'entry_uuid') String? entryUuid,
      @JsonKey(name: 'project_id') @FlexibleIntConverter() int projectId,
      @JsonKey(name: 'old_target_text') String? oldTargetText,
      @JsonKey(name: 'new_target_text') String newTargetText,
      @JsonKey(name: 'old_status') String? oldStatus,
      @JsonKey(name: 'new_status') String? newStatus,
      @JsonKey(name: 'action') String action,
      @JsonKey(name: 'changed_by') String changedBy,
      @JsonKey(name: 'changed_at') @TimesConverter() DateTime changedAt,
      @JsonKey(name: 'reason') String? reason,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata});
}

/// @nodoc
class _$TranslationHistoryModelCopyWithImpl<$Res,
        $Val extends TranslationHistoryModel>
    implements $TranslationHistoryModelCopyWith<$Res> {
  _$TranslationHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranslationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entryId = null,
    Object? entryUuid = freezed,
    Object? projectId = null,
    Object? oldTargetText = freezed,
    Object? newTargetText = null,
    Object? oldStatus = freezed,
    Object? newStatus = freezed,
    Object? action = null,
    Object? changedBy = null,
    Object? changedAt = null,
    Object? reason = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as int,
      entryUuid: freezed == entryUuid
          ? _value.entryUuid
          : entryUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      oldTargetText: freezed == oldTargetText
          ? _value.oldTargetText
          : oldTargetText // ignore: cast_nullable_to_non_nullable
              as String?,
      newTargetText: null == newTargetText
          ? _value.newTargetText
          : newTargetText // ignore: cast_nullable_to_non_nullable
              as String,
      oldStatus: freezed == oldStatus
          ? _value.oldStatus
          : oldStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: freezed == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      changedBy: null == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranslationHistoryModelImplCopyWith<$Res>
    implements $TranslationHistoryModelCopyWith<$Res> {
  factory _$$TranslationHistoryModelImplCopyWith(
          _$TranslationHistoryModelImpl value,
          $Res Function(_$TranslationHistoryModelImpl) then) =
      __$$TranslationHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'entry_id') @FlexibleIntConverter() int entryId,
      @JsonKey(name: 'entry_uuid') String? entryUuid,
      @JsonKey(name: 'project_id') @FlexibleIntConverter() int projectId,
      @JsonKey(name: 'old_target_text') String? oldTargetText,
      @JsonKey(name: 'new_target_text') String newTargetText,
      @JsonKey(name: 'old_status') String? oldStatus,
      @JsonKey(name: 'new_status') String? newStatus,
      @JsonKey(name: 'action') String action,
      @JsonKey(name: 'changed_by') String changedBy,
      @JsonKey(name: 'changed_at') @TimesConverter() DateTime changedAt,
      @JsonKey(name: 'reason') String? reason,
      @JsonKey(name: 'metadata') Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$TranslationHistoryModelImplCopyWithImpl<$Res>
    extends _$TranslationHistoryModelCopyWithImpl<$Res,
        _$TranslationHistoryModelImpl>
    implements _$$TranslationHistoryModelImplCopyWith<$Res> {
  __$$TranslationHistoryModelImplCopyWithImpl(
      _$TranslationHistoryModelImpl _value,
      $Res Function(_$TranslationHistoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranslationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? entryId = null,
    Object? entryUuid = freezed,
    Object? projectId = null,
    Object? oldTargetText = freezed,
    Object? newTargetText = null,
    Object? oldStatus = freezed,
    Object? newStatus = freezed,
    Object? action = null,
    Object? changedBy = null,
    Object? changedAt = null,
    Object? reason = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$TranslationHistoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as int,
      entryUuid: freezed == entryUuid
          ? _value.entryUuid
          : entryUuid // ignore: cast_nullable_to_non_nullable
              as String?,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      oldTargetText: freezed == oldTargetText
          ? _value.oldTargetText
          : oldTargetText // ignore: cast_nullable_to_non_nullable
              as String?,
      newTargetText: null == newTargetText
          ? _value.newTargetText
          : newTargetText // ignore: cast_nullable_to_non_nullable
              as String,
      oldStatus: freezed == oldStatus
          ? _value.oldStatus
          : oldStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      newStatus: freezed == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      changedBy: null == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String,
      changedAt: null == changedAt
          ? _value.changedAt
          : changedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranslationHistoryModelImpl implements _TranslationHistoryModel {
  const _$TranslationHistoryModelImpl(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required this.id,
      @JsonKey(name: 'entry_id') @FlexibleIntConverter() required this.entryId,
      @JsonKey(name: 'entry_uuid') this.entryUuid,
      @JsonKey(name: 'project_id')
      @FlexibleIntConverter()
      required this.projectId,
      @JsonKey(name: 'old_target_text') this.oldTargetText,
      @JsonKey(name: 'new_target_text') required this.newTargetText,
      @JsonKey(name: 'old_status') this.oldStatus,
      @JsonKey(name: 'new_status') this.newStatus,
      @JsonKey(name: 'action') required this.action,
      @JsonKey(name: 'changed_by') required this.changedBy,
      @JsonKey(name: 'changed_at') @TimesConverter() required this.changedAt,
      @JsonKey(name: 'reason') this.reason,
      @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$TranslationHistoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranslationHistoryModelImplFromJson(json);

  /// 历史记录ID（BIGSERIAL）
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  final int id;

  /// 翻译条目ID
  @override
  @JsonKey(name: 'entry_id')
  @FlexibleIntConverter()
  final int entryId;

  /// 翻译条目UUID
  @override
  @JsonKey(name: 'entry_uuid')
  final String? entryUuid;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  @FlexibleIntConverter()
  final int projectId;

  /// 旧的目标文本
  @override
  @JsonKey(name: 'old_target_text')
  final String? oldTargetText;

  /// 新的目标文本
  @override
  @JsonKey(name: 'new_target_text')
  final String newTargetText;

  /// 旧的状态
  @override
  @JsonKey(name: 'old_status')
  final String? oldStatus;

  /// 新的状态
  @override
  @JsonKey(name: 'new_status')
  final String? newStatus;

  /// 操作类型
  @override
  @JsonKey(name: 'action')
  final String action;

  /// 修改者ID
  @override
  @JsonKey(name: 'changed_by')
  final String changedBy;

  /// 修改时间
  @override
  @JsonKey(name: 'changed_at')
  @TimesConverter()
  final DateTime changedAt;

  /// 修改原因
  @override
  @JsonKey(name: 'reason')
  final String? reason;

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

  @override
  String toString() {
    return 'TranslationHistoryModel(id: $id, entryId: $entryId, entryUuid: $entryUuid, projectId: $projectId, oldTargetText: $oldTargetText, newTargetText: $newTargetText, oldStatus: $oldStatus, newStatus: $newStatus, action: $action, changedBy: $changedBy, changedAt: $changedAt, reason: $reason, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranslationHistoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.entryUuid, entryUuid) ||
                other.entryUuid == entryUuid) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.oldTargetText, oldTargetText) ||
                other.oldTargetText == oldTargetText) &&
            (identical(other.newTargetText, newTargetText) ||
                other.newTargetText == newTargetText) &&
            (identical(other.oldStatus, oldStatus) ||
                other.oldStatus == oldStatus) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy) &&
            (identical(other.changedAt, changedAt) ||
                other.changedAt == changedAt) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      entryId,
      entryUuid,
      projectId,
      oldTargetText,
      newTargetText,
      oldStatus,
      newStatus,
      action,
      changedBy,
      changedAt,
      reason,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of TranslationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranslationHistoryModelImplCopyWith<_$TranslationHistoryModelImpl>
      get copyWith => __$$TranslationHistoryModelImplCopyWithImpl<
          _$TranslationHistoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranslationHistoryModelImplToJson(
      this,
    );
  }
}

abstract class _TranslationHistoryModel implements TranslationHistoryModel {
  const factory _TranslationHistoryModel(
          {@JsonKey(name: 'id') @FlexibleIntConverter() required final int id,
          @JsonKey(name: 'entry_id')
          @FlexibleIntConverter()
          required final int entryId,
          @JsonKey(name: 'entry_uuid') final String? entryUuid,
          @JsonKey(name: 'project_id')
          @FlexibleIntConverter()
          required final int projectId,
          @JsonKey(name: 'old_target_text') final String? oldTargetText,
          @JsonKey(name: 'new_target_text') required final String newTargetText,
          @JsonKey(name: 'old_status') final String? oldStatus,
          @JsonKey(name: 'new_status') final String? newStatus,
          @JsonKey(name: 'action') required final String action,
          @JsonKey(name: 'changed_by') required final String changedBy,
          @JsonKey(name: 'changed_at')
          @TimesConverter()
          required final DateTime changedAt,
          @JsonKey(name: 'reason') final String? reason,
          @JsonKey(name: 'metadata') final Map<String, dynamic>? metadata}) =
      _$TranslationHistoryModelImpl;

  factory _TranslationHistoryModel.fromJson(Map<String, dynamic> json) =
      _$TranslationHistoryModelImpl.fromJson;

  /// 历史记录ID（BIGSERIAL）
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id;

  /// 翻译条目ID
  @override
  @JsonKey(name: 'entry_id')
  @FlexibleIntConverter()
  int get entryId;

  /// 翻译条目UUID
  @override
  @JsonKey(name: 'entry_uuid')
  String? get entryUuid;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  @FlexibleIntConverter()
  int get projectId;

  /// 旧的目标文本
  @override
  @JsonKey(name: 'old_target_text')
  String? get oldTargetText;

  /// 新的目标文本
  @override
  @JsonKey(name: 'new_target_text')
  String get newTargetText;

  /// 旧的状态
  @override
  @JsonKey(name: 'old_status')
  String? get oldStatus;

  /// 新的状态
  @override
  @JsonKey(name: 'new_status')
  String? get newStatus;

  /// 操作类型
  @override
  @JsonKey(name: 'action')
  String get action;

  /// 修改者ID
  @override
  @JsonKey(name: 'changed_by')
  String get changedBy;

  /// 修改时间
  @override
  @JsonKey(name: 'changed_at')
  @TimesConverter()
  DateTime get changedAt;

  /// 修改原因
  @override
  @JsonKey(name: 'reason')
  String? get reason;

  /// 元数据（JSONB格式）
  @override
  @JsonKey(name: 'metadata')
  Map<String, dynamic>? get metadata;

  /// Create a copy of TranslationHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranslationHistoryModelImplCopyWith<_$TranslationHistoryModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
