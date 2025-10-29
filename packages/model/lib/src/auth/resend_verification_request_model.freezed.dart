// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resend_verification_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResendVerificationRequestModel _$ResendVerificationRequestModelFromJson(
    Map<String, dynamic> json) {
  return _ResendVerificationRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ResendVerificationRequestModel {
  /// 邮箱
  @JsonKey(name: 'email')
  String get email => throw _privateConstructorUsedError;

  /// Serializes this ResendVerificationRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ResendVerificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResendVerificationRequestModelCopyWith<ResendVerificationRequestModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResendVerificationRequestModelCopyWith<$Res> {
  factory $ResendVerificationRequestModelCopyWith(
          ResendVerificationRequestModel value,
          $Res Function(ResendVerificationRequestModel) then) =
      _$ResendVerificationRequestModelCopyWithImpl<$Res,
          ResendVerificationRequestModel>;
  @useResult
  $Res call({@JsonKey(name: 'email') String email});
}

/// @nodoc
class _$ResendVerificationRequestModelCopyWithImpl<$Res,
        $Val extends ResendVerificationRequestModel>
    implements $ResendVerificationRequestModelCopyWith<$Res> {
  _$ResendVerificationRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResendVerificationRequestModel
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
abstract class _$$ResendVerificationRequestModelImplCopyWith<$Res>
    implements $ResendVerificationRequestModelCopyWith<$Res> {
  factory _$$ResendVerificationRequestModelImplCopyWith(
          _$ResendVerificationRequestModelImpl value,
          $Res Function(_$ResendVerificationRequestModelImpl) then) =
      __$$ResendVerificationRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'email') String email});
}

/// @nodoc
class __$$ResendVerificationRequestModelImplCopyWithImpl<$Res>
    extends _$ResendVerificationRequestModelCopyWithImpl<$Res,
        _$ResendVerificationRequestModelImpl>
    implements _$$ResendVerificationRequestModelImplCopyWith<$Res> {
  __$$ResendVerificationRequestModelImplCopyWithImpl(
      _$ResendVerificationRequestModelImpl _value,
      $Res Function(_$ResendVerificationRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResendVerificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
  }) {
    return _then(_$ResendVerificationRequestModelImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResendVerificationRequestModelImpl
    implements _ResendVerificationRequestModel {
  const _$ResendVerificationRequestModelImpl(
      {@JsonKey(name: 'email') required this.email});

  factory _$ResendVerificationRequestModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ResendVerificationRequestModelImplFromJson(json);

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  final String email;

  @override
  String toString() {
    return 'ResendVerificationRequestModel(email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResendVerificationRequestModelImpl &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email);

  /// Create a copy of ResendVerificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResendVerificationRequestModelImplCopyWith<
          _$ResendVerificationRequestModelImpl>
      get copyWith => __$$ResendVerificationRequestModelImplCopyWithImpl<
          _$ResendVerificationRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResendVerificationRequestModelImplToJson(
      this,
    );
  }
}

abstract class _ResendVerificationRequestModel
    implements ResendVerificationRequestModel {
  const factory _ResendVerificationRequestModel(
          {@JsonKey(name: 'email') required final String email}) =
      _$ResendVerificationRequestModelImpl;

  factory _ResendVerificationRequestModel.fromJson(Map<String, dynamic> json) =
      _$ResendVerificationRequestModelImpl.fromJson;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  String get email;

  /// Create a copy of ResendVerificationRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResendVerificationRequestModelImplCopyWith<
          _$ResendVerificationRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
