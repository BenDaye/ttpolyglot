// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'language_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LanguageModel _$LanguageModelFromJson(Map<String, dynamic> json) {
  return _LanguageModel.fromJson(json);
}

/// @nodoc
mixin _$LanguageModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'code')
  @LanguageEnumConverter()
  LanguageEnum get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'native_name')
  String? get nativeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'flag_emoji')
  String? get flagEmoji => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_rtl')
  bool get isRtl => throw _privateConstructorUsedError;
  @JsonKey(name: 'sort_order')
  int get sortOrder => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this LanguageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LanguageModelCopyWith<LanguageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageModelCopyWith<$Res> {
  factory $LanguageModelCopyWith(
          LanguageModel value, $Res Function(LanguageModel) then) =
      _$LanguageModelCopyWithImpl<$Res, LanguageModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'code') @LanguageEnumConverter() LanguageEnum code,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'native_name') String? nativeName,
      @JsonKey(name: 'flag_emoji') String? flagEmoji,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_rtl') bool isRtl,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$LanguageModelCopyWithImpl<$Res, $Val extends LanguageModel>
    implements $LanguageModelCopyWith<$Res> {
  _$LanguageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? nativeName = freezed,
    Object? flagEmoji = freezed,
    Object? isActive = null,
    Object? isRtl = null,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nativeName: freezed == nativeName
          ? _value.nativeName
          : nativeName // ignore: cast_nullable_to_non_nullable
              as String?,
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isRtl: null == isRtl
          ? _value.isRtl
          : isRtl // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$LanguageModelImplCopyWith<$Res>
    implements $LanguageModelCopyWith<$Res> {
  factory _$$LanguageModelImplCopyWith(
          _$LanguageModelImpl value, $Res Function(_$LanguageModelImpl) then) =
      __$$LanguageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'code') @LanguageEnumConverter() LanguageEnum code,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'native_name') String? nativeName,
      @JsonKey(name: 'flag_emoji') String? flagEmoji,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'is_rtl') bool isRtl,
      @JsonKey(name: 'sort_order') int sortOrder,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$LanguageModelImplCopyWithImpl<$Res>
    extends _$LanguageModelCopyWithImpl<$Res, _$LanguageModelImpl>
    implements _$$LanguageModelImplCopyWith<$Res> {
  __$$LanguageModelImplCopyWithImpl(
      _$LanguageModelImpl _value, $Res Function(_$LanguageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? nativeName = freezed,
    Object? flagEmoji = freezed,
    Object? isActive = null,
    Object? isRtl = null,
    Object? sortOrder = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$LanguageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as LanguageEnum,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      nativeName: freezed == nativeName
          ? _value.nativeName
          : nativeName // ignore: cast_nullable_to_non_nullable
              as String?,
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isRtl: null == isRtl
          ? _value.isRtl
          : isRtl // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$LanguageModelImpl implements _LanguageModel {
  const _$LanguageModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'code') @LanguageEnumConverter() required this.code,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'native_name') this.nativeName,
      @JsonKey(name: 'flag_emoji') this.flagEmoji,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'is_rtl') this.isRtl = false,
      @JsonKey(name: 'sort_order') this.sortOrder = 0,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$LanguageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'code')
  @LanguageEnumConverter()
  final LanguageEnum code;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'native_name')
  final String? nativeName;
  @override
  @JsonKey(name: 'flag_emoji')
  final String? flagEmoji;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'is_rtl')
  final bool isRtl;
  @override
  @JsonKey(name: 'sort_order')
  final int sortOrder;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'LanguageModel(id: $id, code: $code, name: $name, nativeName: $nativeName, flagEmoji: $flagEmoji, isActive: $isActive, isRtl: $isRtl, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nativeName, nativeName) ||
                other.nativeName == nativeName) &&
            (identical(other.flagEmoji, flagEmoji) ||
                other.flagEmoji == flagEmoji) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isRtl, isRtl) || other.isRtl == isRtl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, code, name, nativeName,
      flagEmoji, isActive, isRtl, sortOrder, createdAt, updatedAt);

  /// Create a copy of LanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageModelImplCopyWith<_$LanguageModelImpl> get copyWith =>
      __$$LanguageModelImplCopyWithImpl<_$LanguageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageModelImplToJson(
      this,
    );
  }
}

abstract class _LanguageModel implements LanguageModel {
  const factory _LanguageModel(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'code')
          @LanguageEnumConverter()
          required final LanguageEnum code,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'native_name') final String? nativeName,
          @JsonKey(name: 'flag_emoji') final String? flagEmoji,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'is_rtl') final bool isRtl,
          @JsonKey(name: 'sort_order') final int sortOrder,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$LanguageModelImpl;

  factory _LanguageModel.fromJson(Map<String, dynamic> json) =
      _$LanguageModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'code')
  @LanguageEnumConverter()
  LanguageEnum get code;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'native_name')
  String? get nativeName;
  @override
  @JsonKey(name: 'flag_emoji')
  String? get flagEmoji;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'is_rtl')
  bool get isRtl;
  @override
  @JsonKey(name: 'sort_order')
  int get sortOrder;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of LanguageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LanguageModelImplCopyWith<_$LanguageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
