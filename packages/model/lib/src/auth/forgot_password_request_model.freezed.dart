// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ForgotPasswordRequestModel _$ForgotPasswordRequestModelFromJson(
    Map<String, dynamic> json) {
  return _ForgotPasswordRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ForgotPasswordRequestModel {
  /// 邮箱
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ForgotPasswordRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ForgotPasswordRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForgotPasswordRequestModelCopyWith<ForgotPasswordRequestModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForgotPasswordRequestModelCopyWith<$Res> {
  factory $ForgotPasswordRequestModelCopyWith(ForgotPasswordRequestModel value,
          $Res Function(ForgotPasswordRequestModel) then) =
      _$ForgotPasswordRequestModelCopyWithImpl<$Res,
          ForgotPasswordRequestModel>;
  @useResult
  $Res call({@JsonKey(name: 'email') String email});
}

/// @nodoc
class _$ForgotPasswordRequestModelCopyWithImpl<$Res,
        $Val extends ForgotPasswordRequestModel>
    implements $ForgotPasswordRequestModelCopyWith<$Res> {
  _$ForgotPasswordRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ForgotPasswordRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ForgotPasswordRequestModelImplCopyWith<$Res>
    implements $ForgotPasswordRequestModelCopyWith<$Res> {
  factory _$$ForgotPasswordRequestModelImplCopyWith(
          _$ForgotPasswordRequestModelImpl value,
          $Res Function(_$ForgotPasswordRequestModelImpl) then) =
      __$$ForgotPasswordRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'email') String email});
}

/// @nodoc
class __$$ForgotPasswordRequestModelImplCopyWithImpl<$Res>
    extends _$ForgotPasswordRequestModelCopyWithImpl<$Res,
        _$ForgotPasswordRequestModelImpl>
    implements _$$ForgotPasswordRequestModelImplCopyWith<$Res> {
  __$$ForgotPasswordRequestModelImplCopyWithImpl(
      _$ForgotPasswordRequestModelImpl _value,
      $Res Function(_$ForgotPasswordRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ForgotPasswordRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$ForgotPasswordRequestModelImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ForgotPasswordRequestModelImpl implements _ForgotPasswordRequestModel {
  const _$ForgotPasswordRequestModelImpl(
      {@JsonKey(name: 'email') required this.email});

  factory _$ForgotPasswordRequestModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ForgotPasswordRequestModelImplFromJson(json);

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  final String email;

  @override
  String toString() {
    return 'ForgotPasswordRequestModel(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForgotPasswordRequestModelImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of ForgotPasswordRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForgotPasswordRequestModelImplCopyWith<_$ForgotPasswordRequestModelImpl>
      get copyWith => __$$ForgotPasswordRequestModelImplCopyWithImpl<
          _$ForgotPasswordRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForgotPasswordRequestModelImplToJson(
      this,
    );
  }
}

abstract class _ForgotPasswordRequestModel
    implements ForgotPasswordRequestModel {
  const factory _ForgotPasswordRequestModel(
          {@JsonKey(name: 'email') required final String email}) =
      _$ForgotPasswordRequestModelImpl;

  factory _ForgotPasswordRequestModel.fromJson(Map<String, dynamic> json) =
      _$ForgotPasswordRequestModelImpl.fromJson;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  String get email;

  /// Create a copy of ForgotPasswordRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForgotPasswordRequestModelImplCopyWith<_$ForgotPasswordRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
