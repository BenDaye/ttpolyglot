// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RegisterRequestModel _$RegisterRequestModelFromJson(Map<String, dynamic> json) {
  return _RegisterRequestModel.fromJson(json);
}

/// @nodoc
mixin _$RegisterRequestModel {
  /// 用户名
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;

  /// 邮箱
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;

  /// 密码
  @JsonKey(name: 'password')
  String get password => throw _privateConstructorUsedError;

  /// 显示名称（可选）
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;

  /// 语言代码（可选）
  @JsonKey(name: 'language_code')
  String? get languageCode => throw _privateConstructorUsedError;

  /// Serializes this RegisterRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RegisterRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterRequestModelCopyWith<RegisterRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterRequestModelCopyWith<$Res> {
  factory $RegisterRequestModelCopyWith(RegisterRequestModel value,
          $Res Function(RegisterRequestModel) then) =
      _$RegisterRequestModelCopyWithImpl<$Res, RegisterRequestModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'password') String password,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'language_code') String? languageCode});
}

/// @nodoc
class _$RegisterRequestModelCopyWithImpl<$Res,
        $Val extends RegisterRequestModel>
    implements $RegisterRequestModelCopyWith<$Res> {
  _$RegisterRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
    Object? displayName = freezed,
    Object? languageCode = freezed,
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
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterRequestModelImplCopyWith<$Res>
    implements $RegisterRequestModelCopyWith<$Res> {
  factory _$$RegisterRequestModelImplCopyWith(_$RegisterRequestModelImpl value,
          $Res Function(_$RegisterRequestModelImpl) then) =
      __$$RegisterRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'username') String username,
      @JsonKey(name: 'email') String email,
      @JsonKey(name: 'password') String password,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'language_code') String? languageCode});
}

/// @nodoc
class __$$RegisterRequestModelImplCopyWithImpl<$Res>
    extends _$RegisterRequestModelCopyWithImpl<$Res, _$RegisterRequestModelImpl>
    implements _$$RegisterRequestModelImplCopyWith<$Res> {
  __$$RegisterRequestModelImplCopyWithImpl(_$RegisterRequestModelImpl _value,
      $Res Function(_$RegisterRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RegisterRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? email = null,
    Object? password = null,
    Object? displayName = freezed,
    Object? languageCode = freezed,
  }) {
    return _then(_$RegisterRequestModelImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      languageCode: freezed == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RegisterRequestModelImpl implements _RegisterRequestModel {
  const _$RegisterRequestModelImpl(
      {@JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'email') required this.email,
      @JsonKey(name: 'password') required this.password,
      @JsonKey(name: 'display_name') this.displayName,
      @JsonKey(name: 'language_code') this.languageCode});

  factory _$RegisterRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RegisterRequestModelImplFromJson(json);

  /// 用户名
  @override
  @JsonKey(name: 'username')
  final String username;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  final String email;

  /// 密码
  @override
  @JsonKey(name: 'password')
  final String password;

  /// 显示名称（可选）
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;

  /// 语言代码（可选）
  @override
  @JsonKey(name: 'language_code')
  final String? languageCode;

  @override
  String toString() {
    return 'RegisterRequestModel(username: $username, email: $email, password: $password, displayName: $displayName, languageCode: $languageCode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterRequestModelImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, username, email, password, displayName, languageCode);

  /// Create a copy of RegisterRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterRequestModelImplCopyWith<_$RegisterRequestModelImpl>
      get copyWith =>
          __$$RegisterRequestModelImplCopyWithImpl<_$RegisterRequestModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RegisterRequestModelImplToJson(
      this,
    );
  }
}

abstract class _RegisterRequestModel implements RegisterRequestModel {
  const factory _RegisterRequestModel(
          {@JsonKey(name: 'username') required final String username,
          @JsonKey(name: 'email') required final String email,
          @JsonKey(name: 'password') required final String password,
          @JsonKey(name: 'display_name') final String? displayName,
          @JsonKey(name: 'language_code') final String? languageCode}) =
      _$RegisterRequestModelImpl;

  factory _RegisterRequestModel.fromJson(Map<String, dynamic> json) =
      _$RegisterRequestModelImpl.fromJson;

  /// 用户名
  @override
  @JsonKey(name: 'username')
  String get username;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  String get email;

  /// 密码
  @override
  @JsonKey(name: 'password')
  String get password;

  /// 显示名称（可选）
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;

  /// 语言代码（可选）
  @override
  @JsonKey(name: 'language_code')
  String? get languageCode;

  /// Create a copy of RegisterRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterRequestModelImplCopyWith<_$RegisterRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
