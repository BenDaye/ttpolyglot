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
  String? get id => throw _privateConstructorUsedError; // ID 为可选，后端不返回真实ID
  String get username => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_encrypted')
  String? get emailEncrypted => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone')
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'timezone')
  String? get timezone => throw _privateConstructorUsedError;
  @JsonKey(name: 'locale')
  String? get locale => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool? get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_email_verified')
  bool? get isEmailVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_verified_at')
  DateTime? get emailVerifiedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login_at')
  DateTime? get lastLoginAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login_ip')
  String? get lastLoginIp => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_login_location')
  LocationModel? get lastLoginLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'login_attempts')
  int? get loginAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'locked_until')
  DateTime? get lockedUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'password_changed_at')
  DateTime? get passwordChangedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

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
      {String? id,
      String username,
      String email,
      @JsonKey(name: 'email_encrypted') String? emailEncrypted,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'phone') String? phone,
      @JsonKey(name: 'timezone') String? timezone,
      @JsonKey(name: 'locale') String? locale,
      @JsonKey(name: 'is_active') bool? isActive,
      @JsonKey(name: 'is_email_verified') bool? isEmailVerified,
      @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
      @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
      @JsonKey(name: 'last_login_ip') String? lastLoginIp,
      @JsonKey(name: 'last_login_location') LocationModel? lastLoginLocation,
      @JsonKey(name: 'login_attempts') int? loginAttempts,
      @JsonKey(name: 'locked_until') DateTime? lockedUntil,
      @JsonKey(name: 'password_changed_at') DateTime? passwordChangedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

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
    Object? id = freezed,
    Object? username = null,
    Object? email = null,
    Object? emailEncrypted = freezed,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? phone = freezed,
    Object? timezone = freezed,
    Object? locale = freezed,
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
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
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
      {String? id,
      String username,
      String email,
      @JsonKey(name: 'email_encrypted') String? emailEncrypted,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'phone') String? phone,
      @JsonKey(name: 'timezone') String? timezone,
      @JsonKey(name: 'locale') String? locale,
      @JsonKey(name: 'is_active') bool? isActive,
      @JsonKey(name: 'is_email_verified') bool? isEmailVerified,
      @JsonKey(name: 'email_verified_at') DateTime? emailVerifiedAt,
      @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
      @JsonKey(name: 'last_login_ip') String? lastLoginIp,
      @JsonKey(name: 'last_login_location') LocationModel? lastLoginLocation,
      @JsonKey(name: 'login_attempts') int? loginAttempts,
      @JsonKey(name: 'locked_until') DateTime? lockedUntil,
      @JsonKey(name: 'password_changed_at') DateTime? passwordChangedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});

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
    Object? id = freezed,
    Object? username = null,
    Object? email = null,
    Object? emailEncrypted = freezed,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? phone = freezed,
    Object? timezone = freezed,
    Object? locale = freezed,
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
  }) {
    return _then(_$UserInfoModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoModelImpl implements _UserInfoModel {
  const _$UserInfoModelImpl(
      {this.id,
      required this.username,
      required this.email,
      @JsonKey(name: 'email_encrypted') this.emailEncrypted,
      @JsonKey(name: 'display_name') this.displayName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'phone') this.phone,
      @JsonKey(name: 'timezone') this.timezone,
      @JsonKey(name: 'locale') this.locale,
      @JsonKey(name: 'is_active') this.isActive,
      @JsonKey(name: 'is_email_verified') this.isEmailVerified,
      @JsonKey(name: 'email_verified_at') this.emailVerifiedAt,
      @JsonKey(name: 'last_login_at') this.lastLoginAt,
      @JsonKey(name: 'last_login_ip') this.lastLoginIp,
      @JsonKey(name: 'last_login_location') this.lastLoginLocation,
      @JsonKey(name: 'login_attempts') this.loginAttempts,
      @JsonKey(name: 'locked_until') this.lockedUntil,
      @JsonKey(name: 'password_changed_at') this.passwordChangedAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt});

  factory _$UserInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoModelImplFromJson(json);

  @override
  final String? id;
// ID 为可选，后端不返回真实ID
  @override
  final String username;
  @override
  final String email;
  @override
  @JsonKey(name: 'email_encrypted')
  final String? emailEncrypted;
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'phone')
  final String? phone;
  @override
  @JsonKey(name: 'timezone')
  final String? timezone;
  @override
  @JsonKey(name: 'locale')
  final String? locale;
  @override
  @JsonKey(name: 'is_active')
  final bool? isActive;
  @override
  @JsonKey(name: 'is_email_verified')
  final bool? isEmailVerified;
  @override
  @JsonKey(name: 'email_verified_at')
  final DateTime? emailVerifiedAt;
  @override
  @JsonKey(name: 'last_login_at')
  final DateTime? lastLoginAt;
  @override
  @JsonKey(name: 'last_login_ip')
  final String? lastLoginIp;
  @override
  @JsonKey(name: 'last_login_location')
  final LocationModel? lastLoginLocation;
  @override
  @JsonKey(name: 'login_attempts')
  final int? loginAttempts;
  @override
  @JsonKey(name: 'locked_until')
  final DateTime? lockedUntil;
  @override
  @JsonKey(name: 'password_changed_at')
  final DateTime? passwordChangedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'UserInfoModel(id: $id, username: $username, email: $email, emailEncrypted: $emailEncrypted, displayName: $displayName, avatarUrl: $avatarUrl, phone: $phone, timezone: $timezone, locale: $locale, isActive: $isActive, isEmailVerified: $isEmailVerified, emailVerifiedAt: $emailVerifiedAt, lastLoginAt: $lastLoginAt, lastLoginIp: $lastLoginIp, lastLoginLocation: $lastLoginLocation, loginAttempts: $loginAttempts, lockedUntil: $lockedUntil, passwordChangedAt: $passwordChangedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
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
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.locale, locale) || other.locale == locale) &&
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
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        username,
        email,
        emailEncrypted,
        displayName,
        avatarUrl,
        phone,
        timezone,
        locale,
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
        updatedAt
      ]);

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
      {final String? id,
      required final String username,
      required final String email,
      @JsonKey(name: 'email_encrypted') final String? emailEncrypted,
      @JsonKey(name: 'display_name') final String? displayName,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'phone') final String? phone,
      @JsonKey(name: 'timezone') final String? timezone,
      @JsonKey(name: 'locale') final String? locale,
      @JsonKey(name: 'is_active') final bool? isActive,
      @JsonKey(name: 'is_email_verified') final bool? isEmailVerified,
      @JsonKey(name: 'email_verified_at') final DateTime? emailVerifiedAt,
      @JsonKey(name: 'last_login_at') final DateTime? lastLoginAt,
      @JsonKey(name: 'last_login_ip') final String? lastLoginIp,
      @JsonKey(name: 'last_login_location')
      final LocationModel? lastLoginLocation,
      @JsonKey(name: 'login_attempts') final int? loginAttempts,
      @JsonKey(name: 'locked_until') final DateTime? lockedUntil,
      @JsonKey(name: 'password_changed_at') final DateTime? passwordChangedAt,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$UserInfoModelImpl;

  factory _UserInfoModel.fromJson(Map<String, dynamic> json) =
      _$UserInfoModelImpl.fromJson;

  @override
  String? get id; // ID 为可选，后端不返回真实ID
  @override
  String get username;
  @override
  String get email;
  @override
  @JsonKey(name: 'email_encrypted')
  String? get emailEncrypted;
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'phone')
  String? get phone;
  @override
  @JsonKey(name: 'timezone')
  String? get timezone;
  @override
  @JsonKey(name: 'locale')
  String? get locale;
  @override
  @JsonKey(name: 'is_active')
  bool? get isActive;
  @override
  @JsonKey(name: 'is_email_verified')
  bool? get isEmailVerified;
  @override
  @JsonKey(name: 'email_verified_at')
  DateTime? get emailVerifiedAt;
  @override
  @JsonKey(name: 'last_login_at')
  DateTime? get lastLoginAt;
  @override
  @JsonKey(name: 'last_login_ip')
  String? get lastLoginIp;
  @override
  @JsonKey(name: 'last_login_location')
  LocationModel? get lastLoginLocation;
  @override
  @JsonKey(name: 'login_attempts')
  int? get loginAttempts;
  @override
  @JsonKey(name: 'locked_until')
  DateTime? get lockedUntil;
  @override
  @JsonKey(name: 'password_changed_at')
  DateTime? get passwordChangedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of UserInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserInfoModelImplCopyWith<_$UserInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
