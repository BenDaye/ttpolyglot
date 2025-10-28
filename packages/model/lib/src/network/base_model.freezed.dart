// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BaseModel<T> _$BaseModelFromJson<T>(
    Map<String, dynamic> json, T Function(Object?) fromJsonT) {
  return _BaseModel<T>.fromJson(json, fromJsonT);
}

/// @nodoc
mixin _$BaseModel<T> {
  /// 响应码
  @JsonKey(name: 'code')
  @DataCodeEnumConverter()
  DataCodeEnum get code => throw _privateConstructorUsedError;

  /// 提示信息
  @JsonKey(name: 'message')
  String get message => throw _privateConstructorUsedError;

  /// 提示类型
  @JsonKey(name: 'type')
  @DataMessageTipsEnumConverter()
  DataMessageTipsEnum get type => throw _privateConstructorUsedError;

  /// 数据
  @JsonKey(name: 'data')
  T? get data => throw _privateConstructorUsedError;

  /// Serializes this BaseModel to a JSON map.
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) =>
      throw _privateConstructorUsedError;

  /// Create a copy of BaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseModelCopyWith<T, BaseModel<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseModelCopyWith<T, $Res> {
  factory $BaseModelCopyWith(
          BaseModel<T> value, $Res Function(BaseModel<T>) then) =
      _$BaseModelCopyWithImpl<T, $Res, BaseModel<T>>;
  @useResult
  $Res call(
      {@JsonKey(name: 'code') @DataCodeEnumConverter() DataCodeEnum code,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'type')
      @DataMessageTipsEnumConverter()
      DataMessageTipsEnum type,
      @JsonKey(name: 'data') T? data});
}

/// @nodoc
class _$BaseModelCopyWithImpl<T, $Res, $Val extends BaseModel<T>>
    implements $BaseModelCopyWith<T, $Res> {
  _$BaseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? type = null,
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as DataCodeEnum,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DataMessageTipsEnum,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BaseModelImplCopyWith<T, $Res>
    implements $BaseModelCopyWith<T, $Res> {
  factory _$$BaseModelImplCopyWith(
          _$BaseModelImpl<T> value, $Res Function(_$BaseModelImpl<T>) then) =
      __$$BaseModelImplCopyWithImpl<T, $Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code') @DataCodeEnumConverter() DataCodeEnum code,
      @JsonKey(name: 'message') String message,
      @JsonKey(name: 'type')
      @DataMessageTipsEnumConverter()
      DataMessageTipsEnum type,
      @JsonKey(name: 'data') T? data});
}

/// @nodoc
class __$$BaseModelImplCopyWithImpl<T, $Res>
    extends _$BaseModelCopyWithImpl<T, $Res, _$BaseModelImpl<T>>
    implements _$$BaseModelImplCopyWith<T, $Res> {
  __$$BaseModelImplCopyWithImpl(
      _$BaseModelImpl<T> _value, $Res Function(_$BaseModelImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of BaseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? type = null,
    Object? data = freezed,
  }) {
    return _then(_$BaseModelImpl<T>(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as DataCodeEnum,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as DataMessageTipsEnum,
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc
@JsonSerializable(genericArgumentFactories: true)
class _$BaseModelImpl<T> extends _BaseModel<T> {
  const _$BaseModelImpl(
      {@JsonKey(name: 'code') @DataCodeEnumConverter() required this.code,
      @JsonKey(name: 'message') this.message = "",
      @JsonKey(name: 'type')
      @DataMessageTipsEnumConverter()
      this.type = DataMessageTipsEnum.showToast,
      @JsonKey(name: 'data') this.data})
      : super._();

  factory _$BaseModelImpl.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$$BaseModelImplFromJson(json, fromJsonT);

  /// 响应码
  @override
  @JsonKey(name: 'code')
  @DataCodeEnumConverter()
  final DataCodeEnum code;

  /// 提示信息
  @override
  @JsonKey(name: 'message')
  final String message;

  /// 提示类型
  @override
  @JsonKey(name: 'type')
  @DataMessageTipsEnumConverter()
  final DataMessageTipsEnum type;

  /// 数据
  @override
  @JsonKey(name: 'data')
  final T? data;

  @override
  String toString() {
    return 'BaseModel<$T>(code: $code, message: $message, type: $type, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BaseModelImpl<T> &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, message, type,
      const DeepCollectionEquality().hash(data));

  /// Create a copy of BaseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BaseModelImplCopyWith<T, _$BaseModelImpl<T>> get copyWith =>
      __$$BaseModelImplCopyWithImpl<T, _$BaseModelImpl<T>>(this, _$identity);

  @override
  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return _$$BaseModelImplToJson<T>(this, toJsonT);
  }
}

abstract class _BaseModel<T> extends BaseModel<T> {
  const factory _BaseModel(
      {@JsonKey(name: 'code')
      @DataCodeEnumConverter()
      required final DataCodeEnum code,
      @JsonKey(name: 'message') final String message,
      @JsonKey(name: 'type')
      @DataMessageTipsEnumConverter()
      final DataMessageTipsEnum type,
      @JsonKey(name: 'data') final T? data}) = _$BaseModelImpl<T>;
  const _BaseModel._() : super._();

  factory _BaseModel.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =
      _$BaseModelImpl<T>.fromJson;

  /// 响应码
  @override
  @JsonKey(name: 'code')
  @DataCodeEnumConverter()
  DataCodeEnum get code;

  /// 提示信息
  @override
  @JsonKey(name: 'message')
  String get message;

  /// 提示类型
  @override
  @JsonKey(name: 'type')
  @DataMessageTipsEnumConverter()
  DataMessageTipsEnum get type;

  /// 数据
  @override
  @JsonKey(name: 'data')
  T? get data;

  /// Create a copy of BaseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BaseModelImplCopyWith<T, _$BaseModelImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
