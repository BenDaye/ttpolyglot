// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_permission_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectPermission _$ProjectPermissionFromJson(Map<String, dynamic> json) {
  return _ProjectPermission.fromJson(json);
}

/// @nodoc
mixin _$ProjectPermission {
  /// 权限ID
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;

  /// 权限名称
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// 权限代码
  @JsonKey(name: 'code')
  String get code => throw _privateConstructorUsedError;

  /// 权限描述
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// 是否可用
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

  /// Serializes this ProjectPermission to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectPermission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectPermissionCopyWith<ProjectPermission> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectPermissionCopyWith<$Res> {
  factory $ProjectPermissionCopyWith(
          ProjectPermission value, $Res Function(ProjectPermission) then) =
      _$ProjectPermissionCopyWithImpl<$Res, ProjectPermission>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'code') String code,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt});
}

/// @nodoc
class _$ProjectPermissionCopyWithImpl<$Res, $Val extends ProjectPermission>
    implements $ProjectPermissionCopyWith<$Res> {
  _$ProjectPermissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectPermission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$ProjectPermissionImplCopyWith<$Res>
    implements $ProjectPermissionCopyWith<$Res> {
  factory _$$ProjectPermissionImplCopyWith(_$ProjectPermissionImpl value,
          $Res Function(_$ProjectPermissionImpl) then) =
      __$$ProjectPermissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'code') String code,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt});
}

/// @nodoc
class __$$ProjectPermissionImplCopyWithImpl<$Res>
    extends _$ProjectPermissionCopyWithImpl<$Res, _$ProjectPermissionImpl>
    implements _$$ProjectPermissionImplCopyWith<$Res> {
  __$$ProjectPermissionImplCopyWithImpl(_$ProjectPermissionImpl _value,
      $Res Function(_$ProjectPermissionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectPermission
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? code = null,
    Object? description = freezed,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProjectPermissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$ProjectPermissionImpl implements _ProjectPermission {
  const _$ProjectPermissionImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'code') required this.code,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() required this.updatedAt});

  factory _$ProjectPermissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectPermissionImplFromJson(json);

  /// 权限ID
  @override
  @JsonKey(name: 'id')
  final int id;

  /// 权限名称
  @override
  @JsonKey(name: 'name')
  final String name;

  /// 权限代码
  @override
  @JsonKey(name: 'code')
  final String code;

  /// 权限描述
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// 是否可用
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
    return 'ProjectPermission(id: $id, name: $name, code: $code, description: $description, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectPermissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description) &&
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
      runtimeType, id, name, code, description, isActive, createdAt, updatedAt);

  /// Create a copy of ProjectPermission
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectPermissionImplCopyWith<_$ProjectPermissionImpl> get copyWith =>
      __$$ProjectPermissionImplCopyWithImpl<_$ProjectPermissionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectPermissionImplToJson(
      this,
    );
  }
}

abstract class _ProjectPermission implements ProjectPermission {
  const factory _ProjectPermission(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'code') required final String code,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      @TimesConverter()
      required final DateTime updatedAt}) = _$ProjectPermissionImpl;

  factory _ProjectPermission.fromJson(Map<String, dynamic> json) =
      _$ProjectPermissionImpl.fromJson;

  /// 权限ID
  @override
  @JsonKey(name: 'id')
  int get id;

  /// 权限名称
  @override
  @JsonKey(name: 'name')
  String get name;

  /// 权限代码
  @override
  @JsonKey(name: 'code')
  String get code;

  /// 权限描述
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// 是否可用
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

  /// Create a copy of ProjectPermission
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectPermissionImplCopyWith<_$ProjectPermissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
