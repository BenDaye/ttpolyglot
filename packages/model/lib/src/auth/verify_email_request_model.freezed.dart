// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_email_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerifyEmailRequestModel _$VerifyEmailRequestModelFromJson(
    Map<String, dynamic> json) {
  return _VerifyEmailRequestModel.fromJson(json);
}

/// @nodoc
mixin _$VerifyEmailRequestModel {
  /// 验证令牌
  @JsonKey(name: 'token')
  String get token => throw _privateConstructorUsedError;

  /// Serializes this VerifyEmailRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyEmailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyEmailRequestModelCopyWith<VerifyEmailRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyEmailRequestModelCopyWith<$Res> {
  factory $VerifyEmailRequestModelCopyWith(VerifyEmailRequestModel value,
          $Res Function(VerifyEmailRequestModel) then) =
      _$VerifyEmailRequestModelCopyWithImpl<$Res, VerifyEmailRequestModel>;
  @useResult
  $Res call({@JsonKey(name: 'token') String token});
}

/// @nodoc
class _$VerifyEmailRequestModelCopyWithImpl<$Res,
        $Val extends VerifyEmailRequestModel>
    implements $VerifyEmailRequestModelCopyWith<$Res> {
  _$VerifyEmailRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyEmailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyEmailRequestModelImplCopyWith<$Res>
    implements $VerifyEmailRequestModelCopyWith<$Res> {
  factory _$$VerifyEmailRequestModelImplCopyWith(
          _$VerifyEmailRequestModelImpl value,
          $Res Function(_$VerifyEmailRequestModelImpl) then) =
      __$$VerifyEmailRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'token') String token});
}

/// @nodoc
class __$$VerifyEmailRequestModelImplCopyWithImpl<$Res>
    extends _$VerifyEmailRequestModelCopyWithImpl<$Res,
        _$VerifyEmailRequestModelImpl>
    implements _$$VerifyEmailRequestModelImplCopyWith<$Res> {
  __$$VerifyEmailRequestModelImplCopyWithImpl(
      _$VerifyEmailRequestModelImpl _value,
      $Res Function(_$VerifyEmailRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyEmailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
  }) {
    return _then(_$VerifyEmailRequestModelImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyEmailRequestModelImpl implements _VerifyEmailRequestModel {
  const _$VerifyEmailRequestModelImpl(
      {@JsonKey(name: 'token') required this.token});

  factory _$VerifyEmailRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyEmailRequestModelImplFromJson(json);

  /// 验证令牌
  @override
  @JsonKey(name: 'token')
  final String token;

  @override
  String toString() {
    return 'VerifyEmailRequestModel(token: $token)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyEmailRequestModelImpl &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token);

  /// Create a copy of VerifyEmailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyEmailRequestModelImplCopyWith<_$VerifyEmailRequestModelImpl>
      get copyWith => __$$VerifyEmailRequestModelImplCopyWithImpl<
          _$VerifyEmailRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyEmailRequestModelImplToJson(
      this,
    );
  }
}

abstract class _VerifyEmailRequestModel implements VerifyEmailRequestModel {
  const factory _VerifyEmailRequestModel(
          {@JsonKey(name: 'token') required final String token}) =
      _$VerifyEmailRequestModelImpl;

  factory _VerifyEmailRequestModel.fromJson(Map<String, dynamic> json) =
      _$VerifyEmailRequestModelImpl.fromJson;

  /// 验证令牌
  @override
  @JsonKey(name: 'token')
  String get token;

  /// Create a copy of VerifyEmailRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyEmailRequestModelImplCopyWith<_$VerifyEmailRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
