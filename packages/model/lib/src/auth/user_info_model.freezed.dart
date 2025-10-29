// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) {
  return _UserInfoModel.fromJson(json);
}

/// @nodoc
mixin _$UserInfoModel {
  /// 用户名
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;

  /// 邮箱
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;

  /// 加密邮箱
  @JsonKey(name: 'email_encrypted')
  String? get emailEncrypted => throw _privateConstructorUsedError;

  /// 显示名称
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;

  /// 头像URL
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// 手机号
  @JsonKey(name: 'phone')
  String? get phone => throw _privateConstructorUsedError;

  /// 是否为活跃用户
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;

  /// 是否为邮箱已验证
  @JsonKey(name: 'is_email_verified')
  bool? get isEmailVerified => throw _privateConstructorUsedError;

  /// 邮箱验证时间
  @JsonKey(name: 'email_verified_at')
  @NullableTimesConverter()
  DateTime? get emailVerifiedAt => throw _privateConstructorUsedError;

  /// 最后登录时间
  @JsonKey(name: 'last_login_at')
  @NullableTimesConverter()
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;

  /// 最后登录IP
  @JsonKey(name: 'last_login_ip')
  String? get lastLoginIp => throw _privateConstructorUsedError;

  /// 最后登录位置
  @JsonKey(name: 'last_login_location')
  LocationModel? get lastLoginLocation => throw _privateConstructorUsedError;

  /// 登录尝试次数
  @JsonKey(name: 'login_attempts')
  int? get loginAttempts => throw _privateConstructorUsedError;

  /// 锁定时间
  @JsonKey(name: 'locked_until')
  @NullableTimesConverter()
  DateTime? get lockedUntil => throw _privateConstructorUsedError;

  /// 密码修改时间
  @JsonKey(name: 'password_changed_at')
  @NullableTimesConverter()
  DateTime? get passwordChangedAt => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @NullableTimesConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  @JsonKey(name: 'updated_at')
  @NullableTimesConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// 角色
  @JsonKey(name: 'roles')
  List<RoleModel> get roles => throw _privateConstructorUsedError;

  /// Serializes this UserInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserInfoModelCopyWith<UserInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoModelCopyWith<$Res> {
  factory $UserInfoModelCopyWith(
          UserInfoModel value, $Res Function(UserInfoModel) then) =
      _$UserInfoModelCopyWithImpl<$Res, UserInfoModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'email_encrypted') String? emailEncrypted,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'phone') String? phone,
      @JsonKey(name: 'is_active') bool? isActive,
      @JsonKey(name: 'is_email_verified') bool? isEmailVerified,
      @JsonKey(name: 'email_verified_at')
      @NullableTimesConverter()
      DateTime? emailVerifiedAt,
      @JsonKey(name: 'last_login_at')
      @NullableTimesConverter()
      DateTime? lastLoginAt,
      @JsonKey(name: 'last_login_ip') String? lastLoginIp,
      @JsonKey(name: 'last_login_location') LocationModel? lastLoginLocation,
      @JsonKey(name: 'login_attempts') int? loginAttempts,
      @JsonKey(name: 'locked_until')
      @NullableTimesConverter()
      DateTime? lockedUntil,
      @JsonKey(name: 'password_changed_at')
      @NullableTimesConverter()
      DateTime? passwordChangedAt,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      DateTime? updatedAt,
      @JsonKey(name: 'roles') List<RoleModel> roles});

  $LocationModelCopyWith<$Res>? get lastLoginLocation;
}

/// @nodoc
class _$UserInfoModelCopyWithImpl<$Res, $Val extends UserInfoModel>
    implements $UserInfoModelCopyWith<$Res> {
  _$UserInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? emailEncrypted = freezed,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? phone = freezed,
    Object? isActive = freezed,
    Object? isEmailVerified = freezed,
    Object? emailVerifiedAt = freezed,
    Object? lastLoginAt = freezed,
    Object? lastLoginIp = freezed,
    Object? lastLoginLocation = freezed,
    Object? loginAttempts = freezed,
    Object? lockedUntil = freezed,
    Object? passwordChangedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? roles = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailEncrypted: freezed == emailEncrypted
          ? _value.emailEncrypted
          : emailEncrypted // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isEmailVerified: freezed == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      emailVerifiedAt: freezed == emailVerifiedAt
          ? _value.emailVerifiedAt
          : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginIp: freezed == lastLoginIp
          ? _value.lastLoginIp
          : lastLoginIp // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLoginLocation: freezed == lastLoginLocation
          ? _value.lastLoginLocation
          : lastLoginLocation // ignore: cast_nullable_to_non_nullable
              as LocationModel?,
      loginAttempts: freezed == loginAttempts
          ? _value.loginAttempts
          : loginAttempts // ignore: cast_nullable_to_non_nullable
              as int?,
      lockedUntil: freezed == lockedUntil
          ? _value.lockedUntil
          : lockedUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passwordChangedAt: freezed == passwordChangedAt
          ? _value.passwordChangedAt
          : passwordChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      roles: null == roles
          ? _value.roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<RoleModel>,
    ) as $Val);
  }

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationModelCopyWith<$Res>? get lastLoginLocation {
    if (_value.lastLoginLocation == null) {
      return null;
    }

    return $LocationModelCopyWith<$Res>(_value.lastLoginLocation!, (value) {
      return _then(_value.copyWith(lastLoginLocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserInfoModelImplCopyWith<$Res>
    implements $UserInfoModelCopyWith<$Res> {
  factory _$$UserInfoModelImplCopyWith(
          _$UserInfoModelImpl value, $Res Function(_$UserInfoModelImpl) then) =
      __$$UserInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'email_encrypted') String? emailEncrypted,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'phone') String? phone,
      @JsonKey(name: 'is_active') bool? isActive,
      @JsonKey(name: 'is_email_verified') bool? isEmailVerified,
      @JsonKey(name: 'email_verified_at')
      @NullableTimesConverter()
      DateTime? emailVerifiedAt,
      @JsonKey(name: 'last_login_at')
      @NullableTimesConverter()
      DateTime? lastLoginAt,
      @JsonKey(name: 'last_login_ip') String? lastLoginIp,
      @JsonKey(name: 'last_login_location') LocationModel? lastLoginLocation,
      @JsonKey(name: 'login_attempts') int? loginAttempts,
      @JsonKey(name: 'locked_until')
      @NullableTimesConverter()
      DateTime? lockedUntil,
      @JsonKey(name: 'password_changed_at')
      @NullableTimesConverter()
      DateTime? passwordChangedAt,
      @JsonKey(name: 'created_at')
      @NullableTimesConverter()
      DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @NullableTimesConverter()
      DateTime? updatedAt,
      @JsonKey(name: 'roles') List<RoleModel> roles});

  @override
  $LocationModelCopyWith<$Res>? get lastLoginLocation;
}

/// @nodoc
class __$$UserInfoModelImplCopyWithImpl<$Res>
    extends _$UserInfoModelCopyWithImpl<$Res, _$UserInfoModelImpl>
    implements _$$UserInfoModelImplCopyWith<$Res> {
  __$$UserInfoModelImplCopyWithImpl(
      _$UserInfoModelImpl _value, $Res Function(_$UserInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? emailEncrypted = freezed,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? phone = freezed,
    Object? isActive = freezed,
    Object? isEmailVerified = freezed,
    Object? emailVerifiedAt = freezed,
    Object? lastLoginAt = freezed,
    Object? lastLoginIp = freezed,
    Object? lastLoginLocation = freezed,
    Object? loginAttempts = freezed,
    Object? lockedUntil = freezed,
    Object? passwordChangedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? roles = null,
  }) {
    return _then(_$UserInfoModelImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailEncrypted: freezed == emailEncrypted
          ? _value.emailEncrypted
          : emailEncrypted // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isEmailVerified: freezed == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool?,
      emailVerifiedAt: freezed == emailVerifiedAt
          ? _value.emailVerifiedAt
          : emailVerifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginAt: freezed == lastLoginAt
          ? _value.lastLoginAt
          : lastLoginAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastLoginIp: freezed == lastLoginIp
          ? _value.lastLoginIp
          : lastLoginIp // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLoginLocation: freezed == lastLoginLocation
          ? _value.lastLoginLocation
          : lastLoginLocation // ignore: cast_nullable_to_non_nullable
              as LocationModel?,
      loginAttempts: freezed == loginAttempts
          ? _value.loginAttempts
          : loginAttempts // ignore: cast_nullable_to_non_nullable
              as int?,
      lockedUntil: freezed == lockedUntil
          ? _value.lockedUntil
          : lockedUntil // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passwordChangedAt: freezed == passwordChangedAt
          ? _value.passwordChangedAt
          : passwordChangedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      roles: null == roles
          ? _value._roles
          : roles // ignore: cast_nullable_to_non_nullable
              as List<RoleModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoModelImpl implements _UserInfoModel {
  const _$UserInfoModelImpl(
      {@JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'email_encrypted') this.emailEncrypted,
      @JsonKey(name: 'display_name') this.displayName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'phone') this.phone,
      @JsonKey(name: 'is_active') this.isActive,
      @JsonKey(name: 'is_email_verified') this.isEmailVerified,
      @JsonKey(name: 'email_verified_at')
      @NullableTimesConverter()
      this.emailVerifiedAt,
      @JsonKey(name: 'last_login_at')
      @NullableTimesConverter()
      this.lastLoginAt,
      @JsonKey(name: 'last_login_ip') this.lastLoginIp,
      @JsonKey(name: 'last_login_location') this.lastLoginLocation,
      @JsonKey(name: 'login_attempts') this.loginAttempts,
      @JsonKey(name: 'locked_until') @NullableTimesConverter() this.lockedUntil,
      @JsonKey(name: 'password_changed_at')
      @NullableTimesConverter()
      this.passwordChangedAt,
      @JsonKey(name: 'created_at') @NullableTimesConverter() this.createdAt,
      @JsonKey(name: 'updated_at') @NullableTimesConverter() this.updatedAt,
      @JsonKey(name: 'roles') required final List<RoleModel> roles})
      : _roles = roles;

  factory _$UserInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoModelImplFromJson(json);

  /// 用户名
  @override
  @JsonKey(name: 'username')
  final String username;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  final String email;

  /// 加密邮箱
  @override
  @JsonKey(name: 'email_encrypted')
  final String? emailEncrypted;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;

  /// 头像URL
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  /// 手机号
  @override
  @JsonKey(name: 'phone')
  final String? phone;

  /// 是否为活跃用户
  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;

  /// 是否为邮箱已验证
  @override
  @JsonKey(name: 'is_email_verified')
  final bool? isEmailVerified;

  /// 邮箱验证时间
  @override
  @JsonKey(name: 'email_verified_at')
  @NullableTimesConverter()
  final DateTime? emailVerifiedAt;

  /// 最后登录时间
  @override
  @JsonKey(name: 'last_login_at')
  @NullableTimesConverter()
  final DateTime? lastLoginAt;

  /// 最后登录IP
  @override
  @JsonKey(name: 'last_login_ip')
  final String? lastLoginIp;

  /// 最后登录位置
  @override
  @JsonKey(name: 'last_login_location')
  final LocationModel? lastLoginLocation;

  /// 登录尝试次数
  @override
  @JsonKey(name: 'login_attempts')
  final int? loginAttempts;

  /// 锁定时间
  @override
  @JsonKey(name: 'locked_until')
  @NullableTimesConverter()
  final DateTime? lockedUntil;

  /// 密码修改时间
  @override
  @JsonKey(name: 'password_changed_at')
  @NullableTimesConverter()
  final DateTime? passwordChangedAt;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @NullableTimesConverter()
  final DateTime? createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  @NullableTimesConverter()
  final DateTime? updatedAt;

  /// 角色
  final List<RoleModel> _roles;

  /// 角色
  @override
  @JsonKey(name: 'roles')
  List<RoleModel> get roles {
    if (_roles is EqualUnmodifiableListView) return _roles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roles);
  }

  @override
  String toString() {
    return 'UserInfoModel(username: $username, email: $email, emailEncrypted: $emailEncrypted, displayName: $displayName, avatarUrl: $avatarUrl, phone: $phone, isActive: $isActive, isEmailVerified: $isEmailVerified, emailVerifiedAt: $emailVerifiedAt, lastLoginAt: $lastLoginAt, lastLoginIp: $lastLoginIp, lastLoginLocation: $lastLoginLocation, loginAttempts: $loginAttempts, lockedUntil: $lockedUntil, passwordChangedAt: $passwordChangedAt, createdAt: $createdAt, updatedAt: $updatedAt, roles: $roles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoModelImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailEncrypted, emailEncrypted) ||
                other.emailEncrypted == emailEncrypted) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.emailVerifiedAt, emailVerifiedAt) ||
                other.emailVerifiedAt == emailVerifiedAt) &&
            (identical(other.lastLoginAt, lastLoginAt) ||
                other.lastLoginAt == lastLoginAt) &&
            (identical(other.lastLoginIp, lastLoginIp) ||
                other.lastLoginIp == lastLoginIp) &&
            (identical(other.lastLoginLocation, lastLoginLocation) ||
                other.lastLoginLocation == lastLoginLocation) &&
            (identical(other.loginAttempts, loginAttempts) ||
                other.loginAttempts == loginAttempts) &&
            (identical(other.lockedUntil, lockedUntil) ||
                other.lockedUntil == lockedUntil) &&
            (identical(other.passwordChangedAt, passwordChangedAt) ||
                other.passwordChangedAt == passwordChangedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._roles, _roles));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      username,
      email,
      emailEncrypted,
      displayName,
      avatarUrl,
      phone,
      isActive,
      isEmailVerified,
      emailVerifiedAt,
      lastLoginAt,
      lastLoginIp,
      lastLoginLocation,
      loginAttempts,
      lockedUntil,
      passwordChangedAt,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_roles));

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoModelImplCopyWith<_$UserInfoModelImpl> get copyWith =>
      __$$UserInfoModelImplCopyWithImpl<_$UserInfoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoModelImplToJson(
      this,
    );
  }
}

abstract class _UserInfoModel implements UserInfoModel {
  const factory _UserInfoModel(
          {@JsonKey(name: 'username') required final String username,
          @JsonKey(name: 'email') required final String email,
          @JsonKey(name: 'email_encrypted') final String? emailEncrypted,
          @JsonKey(name: 'display_name') final String? displayName,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          @JsonKey(name: 'phone') final String? phone,
          @JsonKey(name: 'is_active') final bool? isActive,
          @JsonKey(name: 'is_email_verified') final bool? isEmailVerified,
          @JsonKey(name: 'email_verified_at')
          @NullableTimesConverter()
          final DateTime? emailVerifiedAt,
          @JsonKey(name: 'last_login_at')
          @NullableTimesConverter()
          final DateTime? lastLoginAt,
          @JsonKey(name: 'last_login_ip') final String? lastLoginIp,
          @JsonKey(name: 'last_login_location')
          final LocationModel? lastLoginLocation,
          @JsonKey(name: 'login_attempts') final int? loginAttempts,
          @JsonKey(name: 'locked_until')
          @NullableTimesConverter()
          final DateTime? lockedUntil,
          @JsonKey(name: 'password_changed_at')
          @NullableTimesConverter()
          final DateTime? passwordChangedAt,
          @JsonKey(name: 'created_at')
          @NullableTimesConverter()
          final DateTime? createdAt,
          @JsonKey(name: 'updated_at')
          @NullableTimesConverter()
          final DateTime? updatedAt,
          @JsonKey(name: 'roles') required final List<RoleModel> roles}) =
      _$UserInfoModelImpl;

  factory _UserInfoModel.fromJson(Map<String, dynamic> json) =
      _$UserInfoModelImpl.fromJson;

  /// 用户名
  @override
  @JsonKey(name: 'username')
  String get username;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  String get email;

  /// 加密邮箱
  @override
  @JsonKey(name: 'email_encrypted')
  String? get emailEncrypted;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;

  /// 头像URL
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;

  /// 手机号
  @override
  @JsonKey(name: 'phone')
  String? get phone;

  /// 是否为活跃用户
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;

  /// 是否为邮箱已验证
  @override
  @JsonKey(name: 'is_email_verified')
  bool? get isEmailVerified;

  /// 邮箱验证时间
  @override
  @JsonKey(name: 'email_verified_at')
  @NullableTimesConverter()
  DateTime? get emailVerifiedAt;

  /// 最后登录时间
  @override
  @JsonKey(name: 'last_login_at')
  @NullableTimesConverter()
  DateTime? get lastLoginAt;

  /// 最后登录IP
  @override
  @JsonKey(name: 'last_login_ip')
  String? get lastLoginIp;

  /// 最后登录位置
  @override
  @JsonKey(name: 'last_login_location')
  LocationModel? get lastLoginLocation;

  /// 登录尝试次数
  @override
  @JsonKey(name: 'login_attempts')
  int? get loginAttempts;

  /// 锁定时间
  @override
  @JsonKey(name: 'locked_until')
  @NullableTimesConverter()
  DateTime? get lockedUntil;

  /// 密码修改时间
  @override
  @JsonKey(name: 'password_changed_at')
  @NullableTimesConverter()
  DateTime? get passwordChangedAt;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @NullableTimesConverter()
  DateTime? get createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  @NullableTimesConverter()
  DateTime? get updatedAt;

  /// 角色
  @override
  @JsonKey(name: 'roles')
  List<RoleModel> get roles;

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoModelImplCopyWith<_$UserInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
