// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SystemConfig _$SystemConfigFromJson(Map<String, dynamic> json) {
  return _SystemConfig.fromJson(json);
}

/// @nodoc
mixin _$SystemConfig {
  /// 配置ID
  String? get id => throw _privateConstructorUsedError;

  /// 配置键
  @JsonKey(name: 'config_key')
  String get configKey => throw _privateConstructorUsedError;

  /// 配置值
  @JsonKey(name: 'config_value')
  String get configValue => throw _privateConstructorUsedError;

  /// 值类型 (bool, int, double, string)
  @JsonKey(name: 'value_type')
  String? get valueType => throw _privateConstructorUsedError;

  /// 默认值
  @JsonKey(name: 'default_value')
  String? get defaultValue => throw _privateConstructorUsedError;

  /// 分类
  String? get category => throw _privateConstructorUsedError;

  /// 显示名称
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;

  /// 描述
  String? get description => throw _privateConstructorUsedError;

  /// 排序顺序
  @JsonKey(name: 'sort_order')
  int? get sortOrder => throw _privateConstructorUsedError;

  /// 是否可编辑
  @JsonKey(name: 'is_editable')
  bool get isEditable => throw _privateConstructorUsedError;

  /// 是否公开
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;

  /// 是否激活
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// 更新人
  @JsonKey(name: 'updated_by')
  String? get updatedBy => throw _privateConstructorUsedError;

  /// 变更原因
  @JsonKey(name: 'change_reason')
  String? get changeReason => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SystemConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemConfigCopyWith<SystemConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemConfigCopyWith<$Res> {
  factory $SystemConfigCopyWith(
          SystemConfig value, $Res Function(SystemConfig) then) =
      _$SystemConfigCopyWithImpl<$Res, SystemConfig>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'config_key') String configKey,
      @JsonKey(name: 'config_value') String configValue,
      @JsonKey(name: 'value_type') String? valueType,
      @JsonKey(name: 'default_value') String? defaultValue,
      String? category,
      @JsonKey(name: 'display_name') String? displayName,
      String? description,
      @JsonKey(name: 'sort_order') int? sortOrder,
      @JsonKey(name: 'is_editable') bool isEditable,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'updated_by') String? updatedBy,
      @JsonKey(name: 'change_reason') String? changeReason,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$SystemConfigCopyWithImpl<$Res, $Val extends SystemConfig>
    implements $SystemConfigCopyWith<$Res> {
  _$SystemConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? configKey = null,
    Object? configValue = null,
    Object? valueType = freezed,
    Object? defaultValue = freezed,
    Object? category = freezed,
    Object? displayName = freezed,
    Object? description = freezed,
    Object? sortOrder = freezed,
    Object? isEditable = null,
    Object? isPublic = null,
    Object? isActive = null,
    Object? updatedBy = freezed,
    Object? changeReason = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      configKey: null == configKey
          ? _value.configKey
          : configKey // ignore: cast_nullable_to_non_nullable
              as String,
      configValue: null == configValue
          ? _value.configValue
          : configValue // ignore: cast_nullable_to_non_nullable
              as String,
      valueType: freezed == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      changeReason: freezed == changeReason
          ? _value.changeReason
          : changeReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
}

/// @nodoc
abstract class _$$SystemConfigImplCopyWith<$Res>
    implements $SystemConfigCopyWith<$Res> {
  factory _$$SystemConfigImplCopyWith(
          _$SystemConfigImpl value, $Res Function(_$SystemConfigImpl) then) =
      __$$SystemConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'config_key') String configKey,
      @JsonKey(name: 'config_value') String configValue,
      @JsonKey(name: 'value_type') String? valueType,
      @JsonKey(name: 'default_value') String? defaultValue,
      String? category,
      @JsonKey(name: 'display_name') String? displayName,
      String? description,
      @JsonKey(name: 'sort_order') int? sortOrder,
      @JsonKey(name: 'is_editable') bool isEditable,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'updated_by') String? updatedBy,
      @JsonKey(name: 'change_reason') String? changeReason,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$SystemConfigImplCopyWithImpl<$Res>
    extends _$SystemConfigCopyWithImpl<$Res, _$SystemConfigImpl>
    implements _$$SystemConfigImplCopyWith<$Res> {
  __$$SystemConfigImplCopyWithImpl(
      _$SystemConfigImpl _value, $Res Function(_$SystemConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of SystemConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? configKey = null,
    Object? configValue = null,
    Object? valueType = freezed,
    Object? defaultValue = freezed,
    Object? category = freezed,
    Object? displayName = freezed,
    Object? description = freezed,
    Object? sortOrder = freezed,
    Object? isEditable = null,
    Object? isPublic = null,
    Object? isActive = null,
    Object? updatedBy = freezed,
    Object? changeReason = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$SystemConfigImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      configKey: null == configKey
          ? _value.configKey
          : configKey // ignore: cast_nullable_to_non_nullable
              as String,
      configValue: null == configValue
          ? _value.configValue
          : configValue // ignore: cast_nullable_to_non_nullable
              as String,
      valueType: freezed == valueType
          ? _value.valueType
          : valueType // ignore: cast_nullable_to_non_nullable
              as String?,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      isEditable: null == isEditable
          ? _value.isEditable
          : isEditable // ignore: cast_nullable_to_non_nullable
              as bool,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedBy: freezed == updatedBy
          ? _value.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      changeReason: freezed == changeReason
          ? _value.changeReason
          : changeReason // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$SystemConfigImpl extends _SystemConfig {
  const _$SystemConfigImpl(
      {this.id,
      @JsonKey(name: 'config_key') required this.configKey,
      @JsonKey(name: 'config_value') required this.configValue,
      @JsonKey(name: 'value_type') this.valueType,
      @JsonKey(name: 'default_value') this.defaultValue,
      this.category,
      @JsonKey(name: 'display_name') this.displayName,
      this.description,
      @JsonKey(name: 'sort_order') this.sortOrder,
      @JsonKey(name: 'is_editable') this.isEditable = true,
      @JsonKey(name: 'is_public') this.isPublic = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'updated_by') this.updatedBy,
      @JsonKey(name: 'change_reason') this.changeReason,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  factory _$SystemConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemConfigImplFromJson(json);

  /// 配置ID
  @override
  final String? id;

  /// 配置键
  @override
  @JsonKey(name: 'config_key')
  final String configKey;

  /// 配置值
  @override
  @JsonKey(name: 'config_value')
  final String configValue;

  /// 值类型 (bool, int, double, string)
  @override
  @JsonKey(name: 'value_type')
  final String? valueType;

  /// 默认值
  @override
  @JsonKey(name: 'default_value')
  final String? defaultValue;

  /// 分类
  @override
  final String? category;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;

  /// 描述
  @override
  final String? description;

  /// 排序顺序
  @override
  @JsonKey(name: 'sort_order')
  final int? sortOrder;

  /// 是否可编辑
  @override
  @JsonKey(name: 'is_editable')
  final bool isEditable;

  /// 是否公开
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;

  /// 是否激活
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// 更新人
  @override
  @JsonKey(name: 'updated_by')
  final String? updatedBy;

  /// 变更原因
  @override
  @JsonKey(name: 'change_reason')
  final String? changeReason;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'SystemConfig(id: $id, configKey: $configKey, configValue: $configValue, valueType: $valueType, defaultValue: $defaultValue, category: $category, displayName: $displayName, description: $description, sortOrder: $sortOrder, isEditable: $isEditable, isPublic: $isPublic, isActive: $isActive, updatedBy: $updatedBy, changeReason: $changeReason, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.configKey, configKey) ||
                other.configKey == configKey) &&
            (identical(other.configValue, configValue) ||
                other.configValue == configValue) &&
            (identical(other.valueType, valueType) ||
                other.valueType == valueType) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isEditable, isEditable) ||
                other.isEditable == isEditable) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.changeReason, changeReason) ||
                other.changeReason == changeReason) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      configKey,
      configValue,
      valueType,
      defaultValue,
      category,
      displayName,
      description,
      sortOrder,
      isEditable,
      isPublic,
      isActive,
      updatedBy,
      changeReason,
      createdAt,
      updatedAt);

  /// Create a copy of SystemConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemConfigImplCopyWith<_$SystemConfigImpl> get copyWith =>
      __$$SystemConfigImplCopyWithImpl<_$SystemConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemConfigImplToJson(
      this,
    );
  }
}

abstract class _SystemConfig extends SystemConfig {
  const factory _SystemConfig(
          {final String? id,
          @JsonKey(name: 'config_key') required final String configKey,
          @JsonKey(name: 'config_value') required final String configValue,
          @JsonKey(name: 'value_type') final String? valueType,
          @JsonKey(name: 'default_value') final String? defaultValue,
          final String? category,
          @JsonKey(name: 'display_name') final String? displayName,
          final String? description,
          @JsonKey(name: 'sort_order') final int? sortOrder,
          @JsonKey(name: 'is_editable') final bool isEditable,
          @JsonKey(name: 'is_public') final bool isPublic,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'updated_by') final String? updatedBy,
          @JsonKey(name: 'change_reason') final String? changeReason,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$SystemConfigImpl;
  const _SystemConfig._() : super._();

  factory _SystemConfig.fromJson(Map<String, dynamic> json) =
      _$SystemConfigImpl.fromJson;

  /// 配置ID
  @override
  String? get id;

  /// 配置键
  @override
  @JsonKey(name: 'config_key')
  String get configKey;

  /// 配置值
  @override
  @JsonKey(name: 'config_value')
  String get configValue;

  /// 值类型 (bool, int, double, string)
  @override
  @JsonKey(name: 'value_type')
  String? get valueType;

  /// 默认值
  @override
  @JsonKey(name: 'default_value')
  String? get defaultValue;

  /// 分类
  @override
  String? get category;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;

  /// 描述
  @override
  String? get description;

  /// 排序顺序
  @override
  @JsonKey(name: 'sort_order')
  int? get sortOrder;

  /// 是否可编辑
  @override
  @JsonKey(name: 'is_editable')
  bool get isEditable;

  /// 是否公开
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;

  /// 是否激活
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// 更新人
  @override
  @JsonKey(name: 'updated_by')
  String? get updatedBy;

  /// 变更原因
  @override
  @JsonKey(name: 'change_reason')
  String? get changeReason;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of SystemConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemConfigImplCopyWith<_$SystemConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
