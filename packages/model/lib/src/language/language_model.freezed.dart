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
  String get code => throw _privateConstructorUsedError;
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
      @JsonKey(name: 'code') String code,
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
              as String,
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
      @JsonKey(name: 'code') String code,
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
              as String,
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
      @JsonKey(name: 'code') required this.code,
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
  final String code;
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
          @JsonKey(name: 'code') required final String code,
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
  String get code;
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

CreateLanguageRequest _$CreateLanguageRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateLanguageRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateLanguageRequest {
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get nativeName => throw _privateConstructorUsedError;
  String? get flagEmoji => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isRtl => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CreateLanguageRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateLanguageRequestCopyWith<CreateLanguageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateLanguageRequestCopyWith<$Res> {
  factory $CreateLanguageRequestCopyWith(CreateLanguageRequest value,
          $Res Function(CreateLanguageRequest) then) =
      _$CreateLanguageRequestCopyWithImpl<$Res, CreateLanguageRequest>;
  @useResult
  $Res call(
      {String code,
      String name,
      String? nativeName,
      String? flagEmoji,
      bool isActive,
      bool isRtl,
      int sortOrder});
}

/// @nodoc
class _$CreateLanguageRequestCopyWithImpl<$Res,
        $Val extends CreateLanguageRequest>
    implements $CreateLanguageRequestCopyWith<$Res> {
  _$CreateLanguageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
    Object? nativeName = freezed,
    Object? flagEmoji = freezed,
    Object? isActive = null,
    Object? isRtl = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateLanguageRequestImplCopyWith<$Res>
    implements $CreateLanguageRequestCopyWith<$Res> {
  factory _$$CreateLanguageRequestImplCopyWith(
          _$CreateLanguageRequestImpl value,
          $Res Function(_$CreateLanguageRequestImpl) then) =
      __$$CreateLanguageRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      String name,
      String? nativeName,
      String? flagEmoji,
      bool isActive,
      bool isRtl,
      int sortOrder});
}

/// @nodoc
class __$$CreateLanguageRequestImplCopyWithImpl<$Res>
    extends _$CreateLanguageRequestCopyWithImpl<$Res,
        _$CreateLanguageRequestImpl>
    implements _$$CreateLanguageRequestImplCopyWith<$Res> {
  __$$CreateLanguageRequestImplCopyWithImpl(_$CreateLanguageRequestImpl _value,
      $Res Function(_$CreateLanguageRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? name = null,
    Object? nativeName = freezed,
    Object? flagEmoji = freezed,
    Object? isActive = null,
    Object? isRtl = null,
    Object? sortOrder = null,
  }) {
    return _then(_$CreateLanguageRequestImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateLanguageRequestImpl implements _CreateLanguageRequest {
  const _$CreateLanguageRequestImpl(
      {required this.code,
      required this.name,
      this.nativeName,
      this.flagEmoji,
      this.isActive = true,
      this.isRtl = false,
      this.sortOrder = 0});

  factory _$CreateLanguageRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateLanguageRequestImplFromJson(json);

  @override
  final String code;
  @override
  final String name;
  @override
  final String? nativeName;
  @override
  final String? flagEmoji;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isRtl;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'CreateLanguageRequest(code: $code, name: $name, nativeName: $nativeName, flagEmoji: $flagEmoji, isActive: $isActive, isRtl: $isRtl, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateLanguageRequestImpl &&
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
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, name, nativeName,
      flagEmoji, isActive, isRtl, sortOrder);

  /// Create a copy of CreateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateLanguageRequestImplCopyWith<_$CreateLanguageRequestImpl>
      get copyWith => __$$CreateLanguageRequestImplCopyWithImpl<
          _$CreateLanguageRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateLanguageRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateLanguageRequest implements CreateLanguageRequest {
  const factory _CreateLanguageRequest(
      {required final String code,
      required final String name,
      final String? nativeName,
      final String? flagEmoji,
      final bool isActive,
      final bool isRtl,
      final int sortOrder}) = _$CreateLanguageRequestImpl;

  factory _CreateLanguageRequest.fromJson(Map<String, dynamic> json) =
      _$CreateLanguageRequestImpl.fromJson;

  @override
  String get code;
  @override
  String get name;
  @override
  String? get nativeName;
  @override
  String? get flagEmoji;
  @override
  bool get isActive;
  @override
  bool get isRtl;
  @override
  int get sortOrder;

  /// Create a copy of CreateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateLanguageRequestImplCopyWith<_$CreateLanguageRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateLanguageRequest _$UpdateLanguageRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateLanguageRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateLanguageRequest {
  String? get code => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get nativeName => throw _privateConstructorUsedError;
  String? get flagEmoji => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  bool? get isRtl => throw _privateConstructorUsedError;
  int? get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this UpdateLanguageRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateLanguageRequestCopyWith<UpdateLanguageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateLanguageRequestCopyWith<$Res> {
  factory $UpdateLanguageRequestCopyWith(UpdateLanguageRequest value,
          $Res Function(UpdateLanguageRequest) then) =
      _$UpdateLanguageRequestCopyWithImpl<$Res, UpdateLanguageRequest>;
  @useResult
  $Res call(
      {String? code,
      String? name,
      String? nativeName,
      String? flagEmoji,
      bool? isActive,
      bool? isRtl,
      int? sortOrder});
}

/// @nodoc
class _$UpdateLanguageRequestCopyWithImpl<$Res,
        $Val extends UpdateLanguageRequest>
    implements $UpdateLanguageRequestCopyWith<$Res> {
  _$UpdateLanguageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? name = freezed,
    Object? nativeName = freezed,
    Object? flagEmoji = freezed,
    Object? isActive = freezed,
    Object? isRtl = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nativeName: freezed == nativeName
          ? _value.nativeName
          : nativeName // ignore: cast_nullable_to_non_nullable
              as String?,
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isRtl: freezed == isRtl
          ? _value.isRtl
          : isRtl // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateLanguageRequestImplCopyWith<$Res>
    implements $UpdateLanguageRequestCopyWith<$Res> {
  factory _$$UpdateLanguageRequestImplCopyWith(
          _$UpdateLanguageRequestImpl value,
          $Res Function(_$UpdateLanguageRequestImpl) then) =
      __$$UpdateLanguageRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? code,
      String? name,
      String? nativeName,
      String? flagEmoji,
      bool? isActive,
      bool? isRtl,
      int? sortOrder});
}

/// @nodoc
class __$$UpdateLanguageRequestImplCopyWithImpl<$Res>
    extends _$UpdateLanguageRequestCopyWithImpl<$Res,
        _$UpdateLanguageRequestImpl>
    implements _$$UpdateLanguageRequestImplCopyWith<$Res> {
  __$$UpdateLanguageRequestImplCopyWithImpl(_$UpdateLanguageRequestImpl _value,
      $Res Function(_$UpdateLanguageRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? name = freezed,
    Object? nativeName = freezed,
    Object? flagEmoji = freezed,
    Object? isActive = freezed,
    Object? isRtl = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$UpdateLanguageRequestImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nativeName: freezed == nativeName
          ? _value.nativeName
          : nativeName // ignore: cast_nullable_to_non_nullable
              as String?,
      flagEmoji: freezed == flagEmoji
          ? _value.flagEmoji
          : flagEmoji // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      isRtl: freezed == isRtl
          ? _value.isRtl
          : isRtl // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateLanguageRequestImpl implements _UpdateLanguageRequest {
  const _$UpdateLanguageRequestImpl(
      {this.code,
      this.name,
      this.nativeName,
      this.flagEmoji,
      this.isActive,
      this.isRtl,
      this.sortOrder});

  factory _$UpdateLanguageRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateLanguageRequestImplFromJson(json);

  @override
  final String? code;
  @override
  final String? name;
  @override
  final String? nativeName;
  @override
  final String? flagEmoji;
  @override
  final bool? isActive;
  @override
  final bool? isRtl;
  @override
  final int? sortOrder;

  @override
  String toString() {
    return 'UpdateLanguageRequest(code: $code, name: $name, nativeName: $nativeName, flagEmoji: $flagEmoji, isActive: $isActive, isRtl: $isRtl, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateLanguageRequestImpl &&
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
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, name, nativeName,
      flagEmoji, isActive, isRtl, sortOrder);

  /// Create a copy of UpdateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateLanguageRequestImplCopyWith<_$UpdateLanguageRequestImpl>
      get copyWith => __$$UpdateLanguageRequestImplCopyWithImpl<
          _$UpdateLanguageRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateLanguageRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateLanguageRequest implements UpdateLanguageRequest {
  const factory _UpdateLanguageRequest(
      {final String? code,
      final String? name,
      final String? nativeName,
      final String? flagEmoji,
      final bool? isActive,
      final bool? isRtl,
      final int? sortOrder}) = _$UpdateLanguageRequestImpl;

  factory _UpdateLanguageRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateLanguageRequestImpl.fromJson;

  @override
  String? get code;
  @override
  String? get name;
  @override
  String? get nativeName;
  @override
  String? get flagEmoji;
  @override
  bool? get isActive;
  @override
  bool? get isRtl;
  @override
  int? get sortOrder;

  /// Create a copy of UpdateLanguageRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateLanguageRequestImplCopyWith<_$UpdateLanguageRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
