// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audit_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuditLogModel _$AuditLogModelFromJson(Map<String, dynamic> json) {
  return _AuditLogModel.fromJson(json);
}

/// @nodoc
mixin _$AuditLogModel {
  /// 日志ID
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id => throw _privateConstructorUsedError;

  /// 用户ID
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;

  /// 操作类型
  @JsonKey(name: 'action')
  String get action => throw _privateConstructorUsedError;

  /// 资源类型
  @JsonKey(name: 'resource_type')
  String get resourceType => throw _privateConstructorUsedError;

  /// 资源ID
  @JsonKey(name: 'resource_id')
  @FlexibleIntConverter()
  int? get resourceId => throw _privateConstructorUsedError;

  /// 旧值（JSONB格式）
  @JsonKey(name: 'old_values')
  Map<String, dynamic>? get oldValues => throw _privateConstructorUsedError;

  /// 新值（JSONB格式）
  @JsonKey(name: 'new_values')
  Map<String, dynamic>? get newValues => throw _privateConstructorUsedError;

  /// IP地址
  @JsonKey(name: 'ip_address')
  String? get ipAddress => throw _privateConstructorUsedError;

  /// 用户代理
  @JsonKey(name: 'user_agent')
  String? get userAgent => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AuditLogModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuditLogModelCopyWith<AuditLogModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuditLogModelCopyWith<$Res> {
  factory $AuditLogModelCopyWith(
          AuditLogModel value, $Res Function(AuditLogModel) then) =
      _$AuditLogModelCopyWithImpl<$Res, AuditLogModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'action') String action,
      @JsonKey(name: 'resource_type') String resourceType,
      @JsonKey(name: 'resource_id') @FlexibleIntConverter() int? resourceId,
      @JsonKey(name: 'old_values') Map<String, dynamic>? oldValues,
      @JsonKey(name: 'new_values') Map<String, dynamic>? newValues,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt});
}

/// @nodoc
class _$AuditLogModelCopyWithImpl<$Res, $Val extends AuditLogModel>
    implements $AuditLogModelCopyWith<$Res> {
  _$AuditLogModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? action = null,
    Object? resourceType = null,
    Object? resourceId = freezed,
    Object? oldValues = freezed,
    Object? newValues = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
      resourceId: freezed == resourceId
          ? _value.resourceId
          : resourceId // ignore: cast_nullable_to_non_nullable
              as int?,
      oldValues: freezed == oldValues
          ? _value.oldValues
          : oldValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newValues: freezed == newValues
          ? _value.newValues
          : newValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuditLogModelImplCopyWith<$Res>
    implements $AuditLogModelCopyWith<$Res> {
  factory _$$AuditLogModelImplCopyWith(
          _$AuditLogModelImpl value, $Res Function(_$AuditLogModelImpl) then) =
      __$$AuditLogModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'action') String action,
      @JsonKey(name: 'resource_type') String resourceType,
      @JsonKey(name: 'resource_id') @FlexibleIntConverter() int? resourceId,
      @JsonKey(name: 'old_values') Map<String, dynamic>? oldValues,
      @JsonKey(name: 'new_values') Map<String, dynamic>? newValues,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt});
}

/// @nodoc
class __$$AuditLogModelImplCopyWithImpl<$Res>
    extends _$AuditLogModelCopyWithImpl<$Res, _$AuditLogModelImpl>
    implements _$$AuditLogModelImplCopyWith<$Res> {
  __$$AuditLogModelImplCopyWithImpl(
      _$AuditLogModelImpl _value, $Res Function(_$AuditLogModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? action = null,
    Object? resourceType = null,
    Object? resourceId = freezed,
    Object? oldValues = freezed,
    Object? newValues = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$AuditLogModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      resourceType: null == resourceType
          ? _value.resourceType
          : resourceType // ignore: cast_nullable_to_non_nullable
              as String,
      resourceId: freezed == resourceId
          ? _value.resourceId
          : resourceId // ignore: cast_nullable_to_non_nullable
              as int?,
      oldValues: freezed == oldValues
          ? _value._oldValues
          : oldValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      newValues: freezed == newValues
          ? _value._newValues
          : newValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuditLogModelImpl implements _AuditLogModel {
  const _$AuditLogModelImpl(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required this.id,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'action') required this.action,
      @JsonKey(name: 'resource_type') required this.resourceType,
      @JsonKey(name: 'resource_id') @FlexibleIntConverter() this.resourceId,
      @JsonKey(name: 'old_values') final Map<String, dynamic>? oldValues,
      @JsonKey(name: 'new_values') final Map<String, dynamic>? newValues,
      @JsonKey(name: 'ip_address') this.ipAddress,
      @JsonKey(name: 'user_agent') this.userAgent,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt})
      : _oldValues = oldValues,
        _newValues = newValues;

  factory _$AuditLogModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuditLogModelImplFromJson(json);

  /// 日志ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  final int id;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  final String? userId;

  /// 操作类型
  @override
  @JsonKey(name: 'action')
  final String action;

  /// 资源类型
  @override
  @JsonKey(name: 'resource_type')
  final String resourceType;

  /// 资源ID
  @override
  @JsonKey(name: 'resource_id')
  @FlexibleIntConverter()
  final int? resourceId;

  /// 旧值（JSONB格式）
  final Map<String, dynamic>? _oldValues;

  /// 旧值（JSONB格式）
  @override
  @JsonKey(name: 'old_values')
  Map<String, dynamic>? get oldValues {
    final value = _oldValues;
    if (value == null) return null;
    if (_oldValues is EqualUnmodifiableMapView) return _oldValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 新值（JSONB格式）
  final Map<String, dynamic>? _newValues;

  /// 新值（JSONB格式）
  @override
  @JsonKey(name: 'new_values')
  Map<String, dynamic>? get newValues {
    final value = _newValues;
    if (value == null) return null;
    if (_newValues is EqualUnmodifiableMapView) return _newValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// IP地址
  @override
  @JsonKey(name: 'ip_address')
  final String? ipAddress;

  /// 用户代理
  @override
  @JsonKey(name: 'user_agent')
  final String? userAgent;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  final DateTime createdAt;

  @override
  String toString() {
    return 'AuditLogModel(id: $id, userId: $userId, action: $action, resourceType: $resourceType, resourceId: $resourceId, oldValues: $oldValues, newValues: $newValues, ipAddress: $ipAddress, userAgent: $userAgent, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuditLogModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.resourceType, resourceType) ||
                other.resourceType == resourceType) &&
            (identical(other.resourceId, resourceId) ||
                other.resourceId == resourceId) &&
            const DeepCollectionEquality()
                .equals(other._oldValues, _oldValues) &&
            const DeepCollectionEquality()
                .equals(other._newValues, _newValues) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      action,
      resourceType,
      resourceId,
      const DeepCollectionEquality().hash(_oldValues),
      const DeepCollectionEquality().hash(_newValues),
      ipAddress,
      userAgent,
      createdAt);

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuditLogModelImplCopyWith<_$AuditLogModelImpl> get copyWith =>
      __$$AuditLogModelImplCopyWithImpl<_$AuditLogModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuditLogModelImplToJson(
      this,
    );
  }
}

abstract class _AuditLogModel implements AuditLogModel {
  const factory _AuditLogModel(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required final int id,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'action') required final String action,
      @JsonKey(name: 'resource_type') required final String resourceType,
      @JsonKey(name: 'resource_id')
      @FlexibleIntConverter()
      final int? resourceId,
      @JsonKey(name: 'old_values') final Map<String, dynamic>? oldValues,
      @JsonKey(name: 'new_values') final Map<String, dynamic>? newValues,
      @JsonKey(name: 'ip_address') final String? ipAddress,
      @JsonKey(name: 'user_agent') final String? userAgent,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt}) = _$AuditLogModelImpl;

  factory _AuditLogModel.fromJson(Map<String, dynamic> json) =
      _$AuditLogModelImpl.fromJson;

  /// 日志ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  String? get userId;

  /// 操作类型
  @override
  @JsonKey(name: 'action')
  String get action;

  /// 资源类型
  @override
  @JsonKey(name: 'resource_type')
  String get resourceType;

  /// 资源ID
  @override
  @JsonKey(name: 'resource_id')
  @FlexibleIntConverter()
  int? get resourceId;

  /// 旧值（JSONB格式）
  @override
  @JsonKey(name: 'old_values')
  Map<String, dynamic>? get oldValues;

  /// 新值（JSONB格式）
  @override
  @JsonKey(name: 'new_values')
  Map<String, dynamic>? get newValues;

  /// IP地址
  @override
  @JsonKey(name: 'ip_address')
  String? get ipAddress;

  /// 用户代理
  @override
  @JsonKey(name: 'user_agent')
  String? get userAgent;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;

  /// Create a copy of AuditLogModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuditLogModelImplCopyWith<_$AuditLogModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
