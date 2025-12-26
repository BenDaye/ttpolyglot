// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSessionModel _$UserSessionModelFromJson(Map<String, dynamic> json) {
  return _UserSessionModel.fromJson(json);
}

/// @nodoc
mixin _$UserSessionModel {
  /// 会话ID
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id => throw _privateConstructorUsedError;

  /// 用户ID
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// 访问令牌哈希值
  @JsonKey(name: 'token_hash')
  String get tokenHash => throw _privateConstructorUsedError;

  /// 刷新令牌哈希值
  @JsonKey(name: 'refresh_token_hash')
  String? get refreshTokenHash => throw _privateConstructorUsedError;

  /// 设备ID
  @JsonKey(name: 'device_id')
  String? get deviceId => throw _privateConstructorUsedError;

  /// 设备名称
  @JsonKey(name: 'device_name')
  String? get deviceName => throw _privateConstructorUsedError;

  /// 设备类型
  @JsonKey(name: 'device_type')
  String? get deviceType => throw _privateConstructorUsedError;

  /// IP地址
  @JsonKey(name: 'ip_address')
  String? get ipAddress => throw _privateConstructorUsedError;

  /// 用户代理
  @JsonKey(name: 'user_agent')
  String? get userAgent => throw _privateConstructorUsedError;

  /// 位置信息（JSONB格式）
  @JsonKey(name: 'location_info')
  Map<String, dynamic>? get locationInfo => throw _privateConstructorUsedError;

  /// 最后活动时间
  @JsonKey(name: 'last_activity_at')
  @TimesConverter()
  DateTime get lastActivityAt => throw _privateConstructorUsedError;

  /// 过期时间
  @JsonKey(name: 'expires_at')
  @TimesConverter()
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// 是否激活
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UserSessionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSessionModelCopyWith<UserSessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSessionModelCopyWith<$Res> {
  factory $UserSessionModelCopyWith(
          UserSessionModel value, $Res Function(UserSessionModel) then) =
      _$UserSessionModelCopyWithImpl<$Res, UserSessionModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'token_hash') String tokenHash,
      @JsonKey(name: 'refresh_token_hash') String? refreshTokenHash,
      @JsonKey(name: 'device_id') String? deviceId,
      @JsonKey(name: 'device_name') String? deviceName,
      @JsonKey(name: 'device_type') String? deviceType,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      @JsonKey(name: 'location_info') Map<String, dynamic>? locationInfo,
      @JsonKey(name: 'last_activity_at')
      @TimesConverter()
      DateTime lastActivityAt,
      @JsonKey(name: 'expires_at') @TimesConverter() DateTime expiresAt,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt});
}

/// @nodoc
class _$UserSessionModelCopyWithImpl<$Res, $Val extends UserSessionModel>
    implements $UserSessionModelCopyWith<$Res> {
  _$UserSessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tokenHash = null,
    Object? refreshTokenHash = freezed,
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? deviceType = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? locationInfo = freezed,
    Object? lastActivityAt = null,
    Object? expiresAt = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      tokenHash: null == tokenHash
          ? _value.tokenHash
          : tokenHash // ignore: cast_nullable_to_non_nullable
              as String,
      refreshTokenHash: freezed == refreshTokenHash
          ? _value.refreshTokenHash
          : refreshTokenHash // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: freezed == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      locationInfo: freezed == locationInfo
          ? _value.locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      lastActivityAt: null == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSessionModelImplCopyWith<$Res>
    implements $UserSessionModelCopyWith<$Res> {
  factory _$$UserSessionModelImplCopyWith(_$UserSessionModelImpl value,
          $Res Function(_$UserSessionModelImpl) then) =
      __$$UserSessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'token_hash') String tokenHash,
      @JsonKey(name: 'refresh_token_hash') String? refreshTokenHash,
      @JsonKey(name: 'device_id') String? deviceId,
      @JsonKey(name: 'device_name') String? deviceName,
      @JsonKey(name: 'device_type') String? deviceType,
      @JsonKey(name: 'ip_address') String? ipAddress,
      @JsonKey(name: 'user_agent') String? userAgent,
      @JsonKey(name: 'location_info') Map<String, dynamic>? locationInfo,
      @JsonKey(name: 'last_activity_at')
      @TimesConverter()
      DateTime lastActivityAt,
      @JsonKey(name: 'expires_at') @TimesConverter() DateTime expiresAt,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt});
}

/// @nodoc
class __$$UserSessionModelImplCopyWithImpl<$Res>
    extends _$UserSessionModelCopyWithImpl<$Res, _$UserSessionModelImpl>
    implements _$$UserSessionModelImplCopyWith<$Res> {
  __$$UserSessionModelImplCopyWithImpl(_$UserSessionModelImpl _value,
      $Res Function(_$UserSessionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? tokenHash = null,
    Object? refreshTokenHash = freezed,
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? deviceType = freezed,
    Object? ipAddress = freezed,
    Object? userAgent = freezed,
    Object? locationInfo = freezed,
    Object? lastActivityAt = null,
    Object? expiresAt = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserSessionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      tokenHash: null == tokenHash
          ? _value.tokenHash
          : tokenHash // ignore: cast_nullable_to_non_nullable
              as String,
      refreshTokenHash: freezed == refreshTokenHash
          ? _value.refreshTokenHash
          : refreshTokenHash // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceName: freezed == deviceName
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceType: freezed == deviceType
          ? _value.deviceType
          : deviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      ipAddress: freezed == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userAgent: freezed == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String?,
      locationInfo: freezed == locationInfo
          ? _value._locationInfo
          : locationInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      lastActivityAt: null == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSessionModelImpl extends _UserSessionModel {
  const _$UserSessionModelImpl(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'token_hash') required this.tokenHash,
      @JsonKey(name: 'refresh_token_hash') this.refreshTokenHash,
      @JsonKey(name: 'device_id') this.deviceId,
      @JsonKey(name: 'device_name') this.deviceName,
      @JsonKey(name: 'device_type') this.deviceType,
      @JsonKey(name: 'ip_address') this.ipAddress,
      @JsonKey(name: 'user_agent') this.userAgent,
      @JsonKey(name: 'location_info') final Map<String, dynamic>? locationInfo,
      @JsonKey(name: 'last_activity_at')
      @TimesConverter()
      required this.lastActivityAt,
      @JsonKey(name: 'expires_at') @TimesConverter() required this.expiresAt,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() required this.updatedAt})
      : _locationInfo = locationInfo,
        super._();

  factory _$UserSessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSessionModelImplFromJson(json);

  /// 会话ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  final int id;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// 访问令牌哈希值
  @override
  @JsonKey(name: 'token_hash')
  final String tokenHash;

  /// 刷新令牌哈希值
  @override
  @JsonKey(name: 'refresh_token_hash')
  final String? refreshTokenHash;

  /// 设备ID
  @override
  @JsonKey(name: 'device_id')
  final String? deviceId;

  /// 设备名称
  @override
  @JsonKey(name: 'device_name')
  final String? deviceName;

  /// 设备类型
  @override
  @JsonKey(name: 'device_type')
  final String? deviceType;

  /// IP地址
  @override
  @JsonKey(name: 'ip_address')
  final String? ipAddress;

  /// 用户代理
  @override
  @JsonKey(name: 'user_agent')
  final String? userAgent;

  /// 位置信息（JSONB格式）
  final Map<String, dynamic>? _locationInfo;

  /// 位置信息（JSONB格式）
  @override
  @JsonKey(name: 'location_info')
  Map<String, dynamic>? get locationInfo {
    final value = _locationInfo;
    if (value == null) return null;
    if (_locationInfo is EqualUnmodifiableMapView) return _locationInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 最后活动时间
  @override
  @JsonKey(name: 'last_activity_at')
  @TimesConverter()
  final DateTime lastActivityAt;

  /// 过期时间
  @override
  @JsonKey(name: 'expires_at')
  @TimesConverter()
  final DateTime expiresAt;

  /// 是否激活
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  final DateTime createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserSessionModel(id: $id, userId: $userId, tokenHash: $tokenHash, refreshTokenHash: $refreshTokenHash, deviceId: $deviceId, deviceName: $deviceName, deviceType: $deviceType, ipAddress: $ipAddress, userAgent: $userAgent, locationInfo: $locationInfo, lastActivityAt: $lastActivityAt, expiresAt: $expiresAt, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.tokenHash, tokenHash) ||
                other.tokenHash == tokenHash) &&
            (identical(other.refreshTokenHash, refreshTokenHash) ||
                other.refreshTokenHash == refreshTokenHash) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.deviceName, deviceName) ||
                other.deviceName == deviceName) &&
            (identical(other.deviceType, deviceType) ||
                other.deviceType == deviceType) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            const DeepCollectionEquality()
                .equals(other._locationInfo, _locationInfo) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      tokenHash,
      refreshTokenHash,
      deviceId,
      deviceName,
      deviceType,
      ipAddress,
      userAgent,
      const DeepCollectionEquality().hash(_locationInfo),
      lastActivityAt,
      expiresAt,
      isActive,
      createdAt,
      updatedAt);

  /// Create a copy of UserSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSessionModelImplCopyWith<_$UserSessionModelImpl> get copyWith =>
      __$$UserSessionModelImplCopyWithImpl<_$UserSessionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSessionModelImplToJson(
      this,
    );
  }
}

abstract class _UserSessionModel extends UserSessionModel {
  const factory _UserSessionModel(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required final int id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'token_hash') required final String tokenHash,
      @JsonKey(name: 'refresh_token_hash') final String? refreshTokenHash,
      @JsonKey(name: 'device_id') final String? deviceId,
      @JsonKey(name: 'device_name') final String? deviceName,
      @JsonKey(name: 'device_type') final String? deviceType,
      @JsonKey(name: 'ip_address') final String? ipAddress,
      @JsonKey(name: 'user_agent') final String? userAgent,
      @JsonKey(name: 'location_info') final Map<String, dynamic>? locationInfo,
      @JsonKey(name: 'last_activity_at')
      @TimesConverter()
      required final DateTime lastActivityAt,
      @JsonKey(name: 'expires_at')
      @TimesConverter()
      required final DateTime expiresAt,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      @TimesConverter()
      required final DateTime updatedAt}) = _$UserSessionModelImpl;
  const _UserSessionModel._() : super._();

  factory _UserSessionModel.fromJson(Map<String, dynamic> json) =
      _$UserSessionModelImpl.fromJson;

  /// 会话ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// 访问令牌哈希值
  @override
  @JsonKey(name: 'token_hash')
  String get tokenHash;

  /// 刷新令牌哈希值
  @override
  @JsonKey(name: 'refresh_token_hash')
  String? get refreshTokenHash;

  /// 设备ID
  @override
  @JsonKey(name: 'device_id')
  String? get deviceId;

  /// 设备名称
  @override
  @JsonKey(name: 'device_name')
  String? get deviceName;

  /// 设备类型
  @override
  @JsonKey(name: 'device_type')
  String? get deviceType;

  /// IP地址
  @override
  @JsonKey(name: 'ip_address')
  String? get ipAddress;

  /// 用户代理
  @override
  @JsonKey(name: 'user_agent')
  String? get userAgent;

  /// 位置信息（JSONB格式）
  @override
  @JsonKey(name: 'location_info')
  Map<String, dynamic>? get locationInfo;

  /// 最后活动时间
  @override
  @JsonKey(name: 'last_activity_at')
  @TimesConverter()
  DateTime get lastActivityAt;

  /// 过期时间
  @override
  @JsonKey(name: 'expires_at')
  @TimesConverter()
  DateTime get expiresAt;

  /// 是否激活
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  DateTime get updatedAt;

  /// Create a copy of UserSessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSessionModelImplCopyWith<_$UserSessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
