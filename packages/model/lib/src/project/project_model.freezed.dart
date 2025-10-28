// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectModel _$ProjectModelFromJson(Map<String, dynamic> json) {
  return _ProjectModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectModel {
  /// 项目ID
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id => throw _privateConstructorUsedError;

  /// 项目名称
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// 项目slug
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;

  /// 项目描述
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// 项目所有者ID
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;

  /// 项目状态
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;

  /// 项目可见性
  @JsonKey(name: 'visibility')
  String get visibility => throw _privateConstructorUsedError;

  /// 项目主语言ID
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  int get primaryLanguageId => throw _privateConstructorUsedError;

  /// 项目总键数
  @JsonKey(name: 'total_keys')
  @FlexibleIntConverter()
  int get totalKeys => throw _privateConstructorUsedError;

  /// 项目已翻译键数
  @JsonKey(name: 'translated_keys')
  @FlexibleIntConverter()
  int get translatedKeys => throw _privateConstructorUsedError;

  /// 项目语言数
  @JsonKey(name: 'languages_count')
  @FlexibleIntConverter()
  int get languagesCount => throw _privateConstructorUsedError;

  /// 项目成员数
  @JsonKey(name: 'members_count')
  @FlexibleIntConverter()
  int get membersCount => throw _privateConstructorUsedError;

  /// 项目成员上限
  @JsonKey(name: 'member_limit')
  @FlexibleIntConverter()
  int get memberLimit => throw _privateConstructorUsedError;

  /// 项目是否公开
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;

  /// 项目是否活跃
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// 项目设置
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;

  /// 项目最后活动时间
  @JsonKey(name: 'last_activity_at')
  @NullableTimesConverter()
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;

  /// 项目创建时间
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 项目更新时间
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// 项目所有者用户名
  @JsonKey(name: 'owner_username')
  String? get ownerUsername => throw _privateConstructorUsedError;

  /// 项目所有者显示名称
  @JsonKey(name: 'owner_display_name')
  String? get ownerDisplayName => throw _privateConstructorUsedError;

  /// 项目所有者头像
  @JsonKey(name: 'owner_avatar')
  String? get ownerAvatar => throw _privateConstructorUsedError;

  /// 项目完成百分比
  @JsonKey(name: 'completion_percentage')
  @FlexibleDoubleConverter()
  double get completionPercentage => throw _privateConstructorUsedError;

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectModelCopyWith<ProjectModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectModelCopyWith<$Res> {
  factory $ProjectModelCopyWith(
          ProjectModel value, $Res Function(ProjectModel) then) =
      _$ProjectModelCopyWithImpl<$Res, ProjectModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'visibility') String visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      int primaryLanguageId,
      @JsonKey(name: 'total_keys') @FlexibleIntConverter() int totalKeys,
      @JsonKey(name: 'translated_keys')
      @FlexibleIntConverter()
      int translatedKeys,
      @JsonKey(name: 'languages_count')
      @FlexibleIntConverter()
      int languagesCount,
      @JsonKey(name: 'members_count') @FlexibleIntConverter() int membersCount,
      @JsonKey(name: 'member_limit') @FlexibleIntConverter() int memberLimit,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'settings') Map<String, dynamic>? settings,
      @JsonKey(name: 'last_activity_at')
      @NullableTimesConverter()
      DateTime? lastActivityAt,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt,
      @JsonKey(name: 'owner_username') String? ownerUsername,
      @JsonKey(name: 'owner_display_name') String? ownerDisplayName,
      @JsonKey(name: 'owner_avatar') String? ownerAvatar,
      @JsonKey(name: 'completion_percentage')
      @FlexibleDoubleConverter()
      double completionPercentage});
}

/// @nodoc
class _$ProjectModelCopyWithImpl<$Res, $Val extends ProjectModel>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? ownerId = null,
    Object? status = null,
    Object? visibility = null,
    Object? primaryLanguageId = null,
    Object? totalKeys = null,
    Object? translatedKeys = null,
    Object? languagesCount = null,
    Object? membersCount = null,
    Object? memberLimit = null,
    Object? isPublic = null,
    Object? isActive = null,
    Object? settings = freezed,
    Object? lastActivityAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerUsername = freezed,
    Object? ownerDisplayName = freezed,
    Object? ownerAvatar = freezed,
    Object? completionPercentage = null,
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
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLanguageId: null == primaryLanguageId
          ? _value.primaryLanguageId
          : primaryLanguageId // ignore: cast_nullable_to_non_nullable
              as int,
      totalKeys: null == totalKeys
          ? _value.totalKeys
          : totalKeys // ignore: cast_nullable_to_non_nullable
              as int,
      translatedKeys: null == translatedKeys
          ? _value.translatedKeys
          : translatedKeys // ignore: cast_nullable_to_non_nullable
              as int,
      languagesCount: null == languagesCount
          ? _value.languagesCount
          : languagesCount // ignore: cast_nullable_to_non_nullable
              as int,
      membersCount: null == membersCount
          ? _value.membersCount
          : membersCount // ignore: cast_nullable_to_non_nullable
              as int,
      memberLimit: null == memberLimit
          ? _value.memberLimit
          : memberLimit // ignore: cast_nullable_to_non_nullable
              as int,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerUsername: freezed == ownerUsername
          ? _value.ownerUsername
          : ownerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDisplayName: freezed == ownerDisplayName
          ? _value.ownerDisplayName
          : ownerDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerAvatar: freezed == ownerAvatar
          ? _value.ownerAvatar
          : ownerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectModelImplCopyWith<$Res>
    implements $ProjectModelCopyWith<$Res> {
  factory _$$ProjectModelImplCopyWith(
          _$ProjectModelImpl value, $Res Function(_$ProjectModelImpl) then) =
      __$$ProjectModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') @FlexibleIntConverter() int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'visibility') String visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      int primaryLanguageId,
      @JsonKey(name: 'total_keys') @FlexibleIntConverter() int totalKeys,
      @JsonKey(name: 'translated_keys')
      @FlexibleIntConverter()
      int translatedKeys,
      @JsonKey(name: 'languages_count')
      @FlexibleIntConverter()
      int languagesCount,
      @JsonKey(name: 'members_count') @FlexibleIntConverter() int membersCount,
      @JsonKey(name: 'member_limit') @FlexibleIntConverter() int memberLimit,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'settings') Map<String, dynamic>? settings,
      @JsonKey(name: 'last_activity_at')
      @NullableTimesConverter()
      DateTime? lastActivityAt,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt,
      @JsonKey(name: 'owner_username') String? ownerUsername,
      @JsonKey(name: 'owner_display_name') String? ownerDisplayName,
      @JsonKey(name: 'owner_avatar') String? ownerAvatar,
      @JsonKey(name: 'completion_percentage')
      @FlexibleDoubleConverter()
      double completionPercentage});
}

/// @nodoc
class __$$ProjectModelImplCopyWithImpl<$Res>
    extends _$ProjectModelCopyWithImpl<$Res, _$ProjectModelImpl>
    implements _$$ProjectModelImplCopyWith<$Res> {
  __$$ProjectModelImplCopyWithImpl(
      _$ProjectModelImpl _value, $Res Function(_$ProjectModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? ownerId = null,
    Object? status = null,
    Object? visibility = null,
    Object? primaryLanguageId = null,
    Object? totalKeys = null,
    Object? translatedKeys = null,
    Object? languagesCount = null,
    Object? membersCount = null,
    Object? memberLimit = null,
    Object? isPublic = null,
    Object? isActive = null,
    Object? settings = freezed,
    Object? lastActivityAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerUsername = freezed,
    Object? ownerDisplayName = freezed,
    Object? ownerAvatar = freezed,
    Object? completionPercentage = null,
  }) {
    return _then(_$ProjectModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLanguageId: null == primaryLanguageId
          ? _value.primaryLanguageId
          : primaryLanguageId // ignore: cast_nullable_to_non_nullable
              as int,
      totalKeys: null == totalKeys
          ? _value.totalKeys
          : totalKeys // ignore: cast_nullable_to_non_nullable
              as int,
      translatedKeys: null == translatedKeys
          ? _value.translatedKeys
          : translatedKeys // ignore: cast_nullable_to_non_nullable
              as int,
      languagesCount: null == languagesCount
          ? _value.languagesCount
          : languagesCount // ignore: cast_nullable_to_non_nullable
              as int,
      membersCount: null == membersCount
          ? _value.membersCount
          : membersCount // ignore: cast_nullable_to_non_nullable
              as int,
      memberLimit: null == memberLimit
          ? _value.memberLimit
          : memberLimit // ignore: cast_nullable_to_non_nullable
              as int,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      lastActivityAt: freezed == lastActivityAt
          ? _value.lastActivityAt
          : lastActivityAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      ownerUsername: freezed == ownerUsername
          ? _value.ownerUsername
          : ownerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerDisplayName: freezed == ownerDisplayName
          ? _value.ownerDisplayName
          : ownerDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerAvatar: freezed == ownerAvatar
          ? _value.ownerAvatar
          : ownerAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectModelImpl implements _ProjectModel {
  const _$ProjectModelImpl(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'slug') required this.slug,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'visibility') required this.visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      required this.primaryLanguageId,
      @JsonKey(name: 'total_keys') @FlexibleIntConverter() this.totalKeys = 0,
      @JsonKey(name: 'translated_keys')
      @FlexibleIntConverter()
      this.translatedKeys = 0,
      @JsonKey(name: 'languages_count')
      @FlexibleIntConverter()
      this.languagesCount = 0,
      @JsonKey(name: 'members_count')
      @FlexibleIntConverter()
      this.membersCount = 1,
      @JsonKey(name: 'member_limit')
      @FlexibleIntConverter()
      this.memberLimit = 10,
      @JsonKey(name: 'is_public') this.isPublic = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'settings') final Map<String, dynamic>? settings,
      @JsonKey(name: 'last_activity_at')
      @NullableTimesConverter()
      this.lastActivityAt,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() required this.updatedAt,
      @JsonKey(name: 'owner_username') this.ownerUsername,
      @JsonKey(name: 'owner_display_name') this.ownerDisplayName,
      @JsonKey(name: 'owner_avatar') this.ownerAvatar,
      @JsonKey(name: 'completion_percentage')
      @FlexibleDoubleConverter()
      this.completionPercentage = 0.0})
      : _settings = settings;

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  /// 项目ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  final int id;

  /// 项目名称
  @override
  @JsonKey(name: 'name')
  final String name;

  /// 项目slug
  @override
  @JsonKey(name: 'slug')
  final String slug;

  /// 项目描述
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// 项目所有者ID
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;

  /// 项目状态
  @override
  @JsonKey(name: 'status')
  final String status;

  /// 项目可见性
  @override
  @JsonKey(name: 'visibility')
  final String visibility;

  /// 项目主语言ID
  @override
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  final int primaryLanguageId;

  /// 项目总键数
  @override
  @JsonKey(name: 'total_keys')
  @FlexibleIntConverter()
  final int totalKeys;

  /// 项目已翻译键数
  @override
  @JsonKey(name: 'translated_keys')
  @FlexibleIntConverter()
  final int translatedKeys;

  /// 项目语言数
  @override
  @JsonKey(name: 'languages_count')
  @FlexibleIntConverter()
  final int languagesCount;

  /// 项目成员数
  @override
  @JsonKey(name: 'members_count')
  @FlexibleIntConverter()
  final int membersCount;

  /// 项目成员上限
  @override
  @JsonKey(name: 'member_limit')
  @FlexibleIntConverter()
  final int memberLimit;

  /// 项目是否公开
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;

  /// 项目是否活跃
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// 项目设置
  final Map<String, dynamic>? _settings;

  /// 项目设置
  @override
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// 项目最后活动时间
  @override
  @JsonKey(name: 'last_activity_at')
  @NullableTimesConverter()
  final DateTime? lastActivityAt;

  /// 项目创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  final DateTime createdAt;

  /// 项目更新时间
  @override
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  final DateTime updatedAt;

  /// 项目所有者用户名
  @override
  @JsonKey(name: 'owner_username')
  final String? ownerUsername;

  /// 项目所有者显示名称
  @override
  @JsonKey(name: 'owner_display_name')
  final String? ownerDisplayName;

  /// 项目所有者头像
  @override
  @JsonKey(name: 'owner_avatar')
  final String? ownerAvatar;

  /// 项目完成百分比
  @override
  @JsonKey(name: 'completion_percentage')
  @FlexibleDoubleConverter()
  final double completionPercentage;

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, slug: $slug, description: $description, ownerId: $ownerId, status: $status, visibility: $visibility, primaryLanguageId: $primaryLanguageId, totalKeys: $totalKeys, translatedKeys: $translatedKeys, languagesCount: $languagesCount, membersCount: $membersCount, memberLimit: $memberLimit, isPublic: $isPublic, isActive: $isActive, settings: $settings, lastActivityAt: $lastActivityAt, createdAt: $createdAt, updatedAt: $updatedAt, ownerUsername: $ownerUsername, ownerDisplayName: $ownerDisplayName, ownerAvatar: $ownerAvatar, completionPercentage: $completionPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.primaryLanguageId, primaryLanguageId) ||
                other.primaryLanguageId == primaryLanguageId) &&
            (identical(other.totalKeys, totalKeys) ||
                other.totalKeys == totalKeys) &&
            (identical(other.translatedKeys, translatedKeys) ||
                other.translatedKeys == translatedKeys) &&
            (identical(other.languagesCount, languagesCount) ||
                other.languagesCount == languagesCount) &&
            (identical(other.membersCount, membersCount) ||
                other.membersCount == membersCount) &&
            (identical(other.memberLimit, memberLimit) ||
                other.memberLimit == memberLimit) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.ownerUsername, ownerUsername) ||
                other.ownerUsername == ownerUsername) &&
            (identical(other.ownerDisplayName, ownerDisplayName) ||
                other.ownerDisplayName == ownerDisplayName) &&
            (identical(other.ownerAvatar, ownerAvatar) ||
                other.ownerAvatar == ownerAvatar) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        slug,
        description,
        ownerId,
        status,
        visibility,
        primaryLanguageId,
        totalKeys,
        translatedKeys,
        languagesCount,
        membersCount,
        memberLimit,
        isPublic,
        isActive,
        const DeepCollectionEquality().hash(_settings),
        lastActivityAt,
        createdAt,
        updatedAt,
        ownerUsername,
        ownerDisplayName,
        ownerAvatar,
        completionPercentage
      ]);

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      __$$ProjectModelImplCopyWithImpl<_$ProjectModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectModel implements ProjectModel {
  const factory _ProjectModel(
      {@JsonKey(name: 'id') @FlexibleIntConverter() required final int id,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'slug') required final String slug,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'owner_id') required final String ownerId,
      @JsonKey(name: 'status') required final String status,
      @JsonKey(name: 'visibility') required final String visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      required final int primaryLanguageId,
      @JsonKey(name: 'total_keys') @FlexibleIntConverter() final int totalKeys,
      @JsonKey(name: 'translated_keys')
      @FlexibleIntConverter()
      final int translatedKeys,
      @JsonKey(name: 'languages_count')
      @FlexibleIntConverter()
      final int languagesCount,
      @JsonKey(name: 'members_count')
      @FlexibleIntConverter()
      final int membersCount,
      @JsonKey(name: 'member_limit')
      @FlexibleIntConverter()
      final int memberLimit,
      @JsonKey(name: 'is_public') final bool isPublic,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'settings') final Map<String, dynamic>? settings,
      @JsonKey(name: 'last_activity_at')
      @NullableTimesConverter()
      final DateTime? lastActivityAt,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      @TimesConverter()
      required final DateTime updatedAt,
      @JsonKey(name: 'owner_username') final String? ownerUsername,
      @JsonKey(name: 'owner_display_name') final String? ownerDisplayName,
      @JsonKey(name: 'owner_avatar') final String? ownerAvatar,
      @JsonKey(name: 'completion_percentage')
      @FlexibleDoubleConverter()
      final double completionPercentage}) = _$ProjectModelImpl;

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  /// 项目ID
  @override
  @JsonKey(name: 'id')
  @FlexibleIntConverter()
  int get id;

  /// 项目名称
  @override
  @JsonKey(name: 'name')
  String get name;

  /// 项目slug
  @override
  @JsonKey(name: 'slug')
  String get slug;

  /// 项目描述
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// 项目所有者ID
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;

  /// 项目状态
  @override
  @JsonKey(name: 'status')
  String get status;

  /// 项目可见性
  @override
  @JsonKey(name: 'visibility')
  String get visibility;

  /// 项目主语言ID
  @override
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  int get primaryLanguageId;

  /// 项目总键数
  @override
  @JsonKey(name: 'total_keys')
  @FlexibleIntConverter()
  int get totalKeys;

  /// 项目已翻译键数
  @override
  @JsonKey(name: 'translated_keys')
  @FlexibleIntConverter()
  int get translatedKeys;

  /// 项目语言数
  @override
  @JsonKey(name: 'languages_count')
  @FlexibleIntConverter()
  int get languagesCount;

  /// 项目成员数
  @override
  @JsonKey(name: 'members_count')
  @FlexibleIntConverter()
  int get membersCount;

  /// 项目成员上限
  @override
  @JsonKey(name: 'member_limit')
  @FlexibleIntConverter()
  int get memberLimit;

  /// 项目是否公开
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;

  /// 项目是否活跃
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// 项目设置
  @override
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings;

  /// 项目最后活动时间
  @override
  @JsonKey(name: 'last_activity_at')
  @NullableTimesConverter()
  DateTime? get lastActivityAt;

  /// 项目创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;

  /// 项目更新时间
  @override
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  DateTime get updatedAt;

  /// 项目所有者用户名
  @override
  @JsonKey(name: 'owner_username')
  String? get ownerUsername;

  /// 项目所有者显示名称
  @override
  @JsonKey(name: 'owner_display_name')
  String? get ownerDisplayName;

  /// 项目所有者头像
  @override
  @JsonKey(name: 'owner_avatar')
  String? get ownerAvatar;

  /// 项目完成百分比
  @override
  @JsonKey(name: 'completion_percentage')
  @FlexibleDoubleConverter()
  double get completionPercentage;

  /// Create a copy of ProjectModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectModelImplCopyWith<_$ProjectModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateProjectRequest _$CreateProjectRequestFromJson(Map<String, dynamic> json) {
  return _CreateProjectRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateProjectRequest {
  /// 项目名称
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// 项目slug
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;

  /// 项目描述
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// 项目状态
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;

  /// 项目可见性
  @JsonKey(name: 'visibility')
  String get visibility => throw _privateConstructorUsedError;

  /// 项目主语言ID
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  int? get primaryLanguageId => throw _privateConstructorUsedError;

  /// 项目设置
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;

  /// Serializes this CreateProjectRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateProjectRequestCopyWith<CreateProjectRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateProjectRequestCopyWith<$Res> {
  factory $CreateProjectRequestCopyWith(CreateProjectRequest value,
          $Res Function(CreateProjectRequest) then) =
      _$CreateProjectRequestCopyWithImpl<$Res, CreateProjectRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'visibility') String visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      int? primaryLanguageId,
      @JsonKey(name: 'settings') Map<String, dynamic>? settings});
}

/// @nodoc
class _$CreateProjectRequestCopyWithImpl<$Res,
        $Val extends CreateProjectRequest>
    implements $CreateProjectRequestCopyWith<$Res> {
  _$CreateProjectRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? status = null,
    Object? visibility = null,
    Object? primaryLanguageId = freezed,
    Object? settings = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLanguageId: freezed == primaryLanguageId
          ? _value.primaryLanguageId
          : primaryLanguageId // ignore: cast_nullable_to_non_nullable
              as int?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateProjectRequestImplCopyWith<$Res>
    implements $CreateProjectRequestCopyWith<$Res> {
  factory _$$CreateProjectRequestImplCopyWith(_$CreateProjectRequestImpl value,
          $Res Function(_$CreateProjectRequestImpl) then) =
      __$$CreateProjectRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'visibility') String visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      int? primaryLanguageId,
      @JsonKey(name: 'settings') Map<String, dynamic>? settings});
}

/// @nodoc
class __$$CreateProjectRequestImplCopyWithImpl<$Res>
    extends _$CreateProjectRequestCopyWithImpl<$Res, _$CreateProjectRequestImpl>
    implements _$$CreateProjectRequestImplCopyWith<$Res> {
  __$$CreateProjectRequestImplCopyWithImpl(_$CreateProjectRequestImpl _value,
      $Res Function(_$CreateProjectRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? slug = null,
    Object? description = freezed,
    Object? status = null,
    Object? visibility = null,
    Object? primaryLanguageId = freezed,
    Object? settings = freezed,
  }) {
    return _then(_$CreateProjectRequestImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String,
      primaryLanguageId: freezed == primaryLanguageId
          ? _value.primaryLanguageId
          : primaryLanguageId // ignore: cast_nullable_to_non_nullable
              as int?,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateProjectRequestImpl implements _CreateProjectRequest {
  const _$CreateProjectRequestImpl(
      {@JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'slug') required this.slug,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'status') this.status = 'active',
      @JsonKey(name: 'visibility') this.visibility = 'private',
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      this.primaryLanguageId,
      @JsonKey(name: 'settings') final Map<String, dynamic>? settings})
      : _settings = settings;

  factory _$CreateProjectRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateProjectRequestImplFromJson(json);

  /// 项目名称
  @override
  @JsonKey(name: 'name')
  final String name;

  /// 项目slug
  @override
  @JsonKey(name: 'slug')
  final String slug;

  /// 项目描述
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// 项目状态
  @override
  @JsonKey(name: 'status')
  final String status;

  /// 项目可见性
  @override
  @JsonKey(name: 'visibility')
  final String visibility;

  /// 项目主语言ID
  @override
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  final int? primaryLanguageId;

  /// 项目设置
  final Map<String, dynamic>? _settings;

  /// 项目设置
  @override
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CreateProjectRequest(name: $name, slug: $slug, description: $description, status: $status, visibility: $visibility, primaryLanguageId: $primaryLanguageId, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateProjectRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.primaryLanguageId, primaryLanguageId) ||
                other.primaryLanguageId == primaryLanguageId) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      slug,
      description,
      status,
      visibility,
      primaryLanguageId,
      const DeepCollectionEquality().hash(_settings));

  /// Create a copy of CreateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateProjectRequestImplCopyWith<_$CreateProjectRequestImpl>
      get copyWith =>
          __$$CreateProjectRequestImplCopyWithImpl<_$CreateProjectRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateProjectRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateProjectRequest implements CreateProjectRequest {
  const factory _CreateProjectRequest(
          {@JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'slug') required final String slug,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'status') final String status,
          @JsonKey(name: 'visibility') final String visibility,
          @JsonKey(name: 'primary_language_id')
          @FlexibleIntConverter()
          final int? primaryLanguageId,
          @JsonKey(name: 'settings') final Map<String, dynamic>? settings}) =
      _$CreateProjectRequestImpl;

  factory _CreateProjectRequest.fromJson(Map<String, dynamic> json) =
      _$CreateProjectRequestImpl.fromJson;

  /// 项目名称
  @override
  @JsonKey(name: 'name')
  String get name;

  /// 项目slug
  @override
  @JsonKey(name: 'slug')
  String get slug;

  /// 项目描述
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// 项目状态
  @override
  @JsonKey(name: 'status')
  String get status;

  /// 项目可见性
  @override
  @JsonKey(name: 'visibility')
  String get visibility;

  /// 项目主语言ID
  @override
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  int? get primaryLanguageId;

  /// 项目设置
  @override
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings;

  /// Create a copy of CreateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateProjectRequestImplCopyWith<_$CreateProjectRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateProjectRequest _$UpdateProjectRequestFromJson(Map<String, dynamic> json) {
  return _UpdateProjectRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateProjectRequest {
  /// 项目名称
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// 项目slug
  @JsonKey(name: 'slug')
  String? get slug => throw _privateConstructorUsedError;

  /// 项目描述
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// 项目状态
  @JsonKey(name: 'status')
  String? get status => throw _privateConstructorUsedError;

  /// 项目可见性
  @JsonKey(name: 'visibility')
  String? get visibility => throw _privateConstructorUsedError;

  /// 项目主语言ID
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  int? get primaryLanguageId => throw _privateConstructorUsedError;

  /// 项目设置
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;

  /// Serializes this UpdateProjectRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateProjectRequestCopyWith<UpdateProjectRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateProjectRequestCopyWith<$Res> {
  factory $UpdateProjectRequestCopyWith(UpdateProjectRequest value,
          $Res Function(UpdateProjectRequest) then) =
      _$UpdateProjectRequestCopyWithImpl<$Res, UpdateProjectRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'slug') String? slug,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'status') String? status,
      @JsonKey(name: 'visibility') String? visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      int? primaryLanguageId,
      @JsonKey(name: 'settings') Map<String, dynamic>? settings});
}

/// @nodoc
class _$UpdateProjectRequestCopyWithImpl<$Res,
        $Val extends UpdateProjectRequest>
    implements $UpdateProjectRequestCopyWith<$Res> {
  _$UpdateProjectRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? slug = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? visibility = freezed,
    Object? primaryLanguageId = freezed,
    Object? settings = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: freezed == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryLanguageId: freezed == primaryLanguageId
          ? _value.primaryLanguageId
          : primaryLanguageId // ignore: cast_nullable_to_non_nullable
              as int?,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateProjectRequestImplCopyWith<$Res>
    implements $UpdateProjectRequestCopyWith<$Res> {
  factory _$$UpdateProjectRequestImplCopyWith(_$UpdateProjectRequestImpl value,
          $Res Function(_$UpdateProjectRequestImpl) then) =
      __$$UpdateProjectRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'slug') String? slug,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'status') String? status,
      @JsonKey(name: 'visibility') String? visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      int? primaryLanguageId,
      @JsonKey(name: 'settings') Map<String, dynamic>? settings});
}

/// @nodoc
class __$$UpdateProjectRequestImplCopyWithImpl<$Res>
    extends _$UpdateProjectRequestCopyWithImpl<$Res, _$UpdateProjectRequestImpl>
    implements _$$UpdateProjectRequestImplCopyWith<$Res> {
  __$$UpdateProjectRequestImplCopyWithImpl(_$UpdateProjectRequestImpl _value,
      $Res Function(_$UpdateProjectRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? slug = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? visibility = freezed,
    Object? primaryLanguageId = freezed,
    Object? settings = freezed,
  }) {
    return _then(_$UpdateProjectRequestImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: freezed == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryLanguageId: freezed == primaryLanguageId
          ? _value.primaryLanguageId
          : primaryLanguageId // ignore: cast_nullable_to_non_nullable
              as int?,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateProjectRequestImpl implements _UpdateProjectRequest {
  const _$UpdateProjectRequestImpl(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'slug') this.slug,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'status') this.status,
      @JsonKey(name: 'visibility') this.visibility,
      @JsonKey(name: 'primary_language_id')
      @FlexibleIntConverter()
      this.primaryLanguageId,
      @JsonKey(name: 'settings') final Map<String, dynamic>? settings})
      : _settings = settings;

  factory _$UpdateProjectRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateProjectRequestImplFromJson(json);

  /// 项目名称
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// 项目slug
  @override
  @JsonKey(name: 'slug')
  final String? slug;

  /// 项目描述
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// 项目状态
  @override
  @JsonKey(name: 'status')
  final String? status;

  /// 项目可见性
  @override
  @JsonKey(name: 'visibility')
  final String? visibility;

  /// 项目主语言ID
  @override
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  final int? primaryLanguageId;

  /// 项目设置
  final Map<String, dynamic>? _settings;

  /// 项目设置
  @override
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UpdateProjectRequest(name: $name, slug: $slug, description: $description, status: $status, visibility: $visibility, primaryLanguageId: $primaryLanguageId, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateProjectRequestImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.primaryLanguageId, primaryLanguageId) ||
                other.primaryLanguageId == primaryLanguageId) &&
            const DeepCollectionEquality().equals(other._settings, _settings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      slug,
      description,
      status,
      visibility,
      primaryLanguageId,
      const DeepCollectionEquality().hash(_settings));

  /// Create a copy of UpdateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateProjectRequestImplCopyWith<_$UpdateProjectRequestImpl>
      get copyWith =>
          __$$UpdateProjectRequestImplCopyWithImpl<_$UpdateProjectRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateProjectRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateProjectRequest implements UpdateProjectRequest {
  const factory _UpdateProjectRequest(
          {@JsonKey(name: 'name') final String? name,
          @JsonKey(name: 'slug') final String? slug,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'status') final String? status,
          @JsonKey(name: 'visibility') final String? visibility,
          @JsonKey(name: 'primary_language_id')
          @FlexibleIntConverter()
          final int? primaryLanguageId,
          @JsonKey(name: 'settings') final Map<String, dynamic>? settings}) =
      _$UpdateProjectRequestImpl;

  factory _UpdateProjectRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateProjectRequestImpl.fromJson;

  /// 项目名称
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// 项目slug
  @override
  @JsonKey(name: 'slug')
  String? get slug;

  /// 项目描述
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// 项目状态
  @override
  @JsonKey(name: 'status')
  String? get status;

  /// 项目可见性
  @override
  @JsonKey(name: 'visibility')
  String? get visibility;

  /// 项目主语言ID
  @override
  @JsonKey(name: 'primary_language_id')
  @FlexibleIntConverter()
  int? get primaryLanguageId;

  /// 项目设置
  @override
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings;

  /// Create a copy of UpdateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProjectRequestImplCopyWith<_$UpdateProjectRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UpdateMemberLimitRequest _$UpdateMemberLimitRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateMemberLimitRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateMemberLimitRequest {
  /// 新的成员上限
  @JsonKey(name: 'member_limit')
  int get memberLimit => throw _privateConstructorUsedError;

  /// Serializes this UpdateMemberLimitRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateMemberLimitRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateMemberLimitRequestCopyWith<UpdateMemberLimitRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateMemberLimitRequestCopyWith<$Res> {
  factory $UpdateMemberLimitRequestCopyWith(UpdateMemberLimitRequest value,
          $Res Function(UpdateMemberLimitRequest) then) =
      _$UpdateMemberLimitRequestCopyWithImpl<$Res, UpdateMemberLimitRequest>;
  @useResult
  $Res call({@JsonKey(name: 'member_limit') int memberLimit});
}

/// @nodoc
class _$UpdateMemberLimitRequestCopyWithImpl<$Res,
        $Val extends UpdateMemberLimitRequest>
    implements $UpdateMemberLimitRequestCopyWith<$Res> {
  _$UpdateMemberLimitRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateMemberLimitRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberLimit = null,
  }) {
    return _then(_value.copyWith(
      memberLimit: null == memberLimit
          ? _value.memberLimit
          : memberLimit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateMemberLimitRequestImplCopyWith<$Res>
    implements $UpdateMemberLimitRequestCopyWith<$Res> {
  factory _$$UpdateMemberLimitRequestImplCopyWith(
          _$UpdateMemberLimitRequestImpl value,
          $Res Function(_$UpdateMemberLimitRequestImpl) then) =
      __$$UpdateMemberLimitRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'member_limit') int memberLimit});
}

/// @nodoc
class __$$UpdateMemberLimitRequestImplCopyWithImpl<$Res>
    extends _$UpdateMemberLimitRequestCopyWithImpl<$Res,
        _$UpdateMemberLimitRequestImpl>
    implements _$$UpdateMemberLimitRequestImplCopyWith<$Res> {
  __$$UpdateMemberLimitRequestImplCopyWithImpl(
      _$UpdateMemberLimitRequestImpl _value,
      $Res Function(_$UpdateMemberLimitRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateMemberLimitRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberLimit = null,
  }) {
    return _then(_$UpdateMemberLimitRequestImpl(
      memberLimit: null == memberLimit
          ? _value.memberLimit
          : memberLimit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateMemberLimitRequestImpl implements _UpdateMemberLimitRequest {
  const _$UpdateMemberLimitRequestImpl(
      {@JsonKey(name: 'member_limit') required this.memberLimit});

  factory _$UpdateMemberLimitRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateMemberLimitRequestImplFromJson(json);

  /// 新的成员上限
  @override
  @JsonKey(name: 'member_limit')
  final int memberLimit;

  @override
  String toString() {
    return 'UpdateMemberLimitRequest(memberLimit: $memberLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateMemberLimitRequestImpl &&
            (identical(other.memberLimit, memberLimit) ||
                other.memberLimit == memberLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, memberLimit);

  /// Create a copy of UpdateMemberLimitRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateMemberLimitRequestImplCopyWith<_$UpdateMemberLimitRequestImpl>
      get copyWith => __$$UpdateMemberLimitRequestImplCopyWithImpl<
          _$UpdateMemberLimitRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateMemberLimitRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateMemberLimitRequest implements UpdateMemberLimitRequest {
  const factory _UpdateMemberLimitRequest(
          {@JsonKey(name: 'member_limit') required final int memberLimit}) =
      _$UpdateMemberLimitRequestImpl;

  factory _UpdateMemberLimitRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateMemberLimitRequestImpl.fromJson;

  /// 新的成员上限
  @override
  @JsonKey(name: 'member_limit')
  int get memberLimit;

  /// Create a copy of UpdateMemberLimitRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateMemberLimitRequestImplCopyWith<_$UpdateMemberLimitRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProjectDetailModel _$ProjectDetailModelFromJson(Map<String, dynamic> json) {
  return _ProjectDetailModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectDetailModel {
  /// 项目
  @JsonKey(name: 'project')
  ProjectModel get project => throw _privateConstructorUsedError;

  /// 项目语言
  @JsonKey(name: 'languages')
  List<LanguageModel>? get languages => throw _privateConstructorUsedError;

  /// 项目成员
  @JsonKey(name: 'members')
  List<ProjectMemberModel>? get members => throw _privateConstructorUsedError;

  /// Serializes this ProjectDetailModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectDetailModelCopyWith<ProjectDetailModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectDetailModelCopyWith<$Res> {
  factory $ProjectDetailModelCopyWith(
          ProjectDetailModel value, $Res Function(ProjectDetailModel) then) =
      _$ProjectDetailModelCopyWithImpl<$Res, ProjectDetailModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'project') ProjectModel project,
      @JsonKey(name: 'languages') List<LanguageModel>? languages,
      @JsonKey(name: 'members') List<ProjectMemberModel>? members});

  $ProjectModelCopyWith<$Res> get project;
}

/// @nodoc
class _$ProjectDetailModelCopyWithImpl<$Res, $Val extends ProjectDetailModel>
    implements $ProjectDetailModelCopyWith<$Res> {
  _$ProjectDetailModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? project = null,
    Object? languages = freezed,
    Object? members = freezed,
  }) {
    return _then(_value.copyWith(
      project: null == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as ProjectModel,
      languages: freezed == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<LanguageModel>?,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ProjectMemberModel>?,
    ) as $Val);
  }

  /// Create a copy of ProjectDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjectModelCopyWith<$Res> get project {
    return $ProjectModelCopyWith<$Res>(_value.project, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProjectDetailModelImplCopyWith<$Res>
    implements $ProjectDetailModelCopyWith<$Res> {
  factory _$$ProjectDetailModelImplCopyWith(_$ProjectDetailModelImpl value,
          $Res Function(_$ProjectDetailModelImpl) then) =
      __$$ProjectDetailModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'project') ProjectModel project,
      @JsonKey(name: 'languages') List<LanguageModel>? languages,
      @JsonKey(name: 'members') List<ProjectMemberModel>? members});

  @override
  $ProjectModelCopyWith<$Res> get project;
}

/// @nodoc
class __$$ProjectDetailModelImplCopyWithImpl<$Res>
    extends _$ProjectDetailModelCopyWithImpl<$Res, _$ProjectDetailModelImpl>
    implements _$$ProjectDetailModelImplCopyWith<$Res> {
  __$$ProjectDetailModelImplCopyWithImpl(_$ProjectDetailModelImpl _value,
      $Res Function(_$ProjectDetailModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? project = null,
    Object? languages = freezed,
    Object? members = freezed,
  }) {
    return _then(_$ProjectDetailModelImpl(
      project: null == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as ProjectModel,
      languages: freezed == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<LanguageModel>?,
      members: freezed == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ProjectMemberModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectDetailModelImpl implements _ProjectDetailModel {
  const _$ProjectDetailModelImpl(
      {@JsonKey(name: 'project') required this.project,
      @JsonKey(name: 'languages') final List<LanguageModel>? languages,
      @JsonKey(name: 'members') final List<ProjectMemberModel>? members})
      : _languages = languages,
        _members = members;

  factory _$ProjectDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectDetailModelImplFromJson(json);

  /// 项目
  @override
  @JsonKey(name: 'project')
  final ProjectModel project;

  /// 项目语言
  final List<LanguageModel>? _languages;

  /// 项目语言
  @override
  @JsonKey(name: 'languages')
  List<LanguageModel>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 项目成员
  final List<ProjectMemberModel>? _members;

  /// 项目成员
  @override
  @JsonKey(name: 'members')
  List<ProjectMemberModel>? get members {
    final value = _members;
    if (value == null) return null;
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProjectDetailModel(project: $project, languages: $languages, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectDetailModelImpl &&
            (identical(other.project, project) || other.project == project) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      project,
      const DeepCollectionEquality().hash(_languages),
      const DeepCollectionEquality().hash(_members));

  /// Create a copy of ProjectDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectDetailModelImplCopyWith<_$ProjectDetailModelImpl> get copyWith =>
      __$$ProjectDetailModelImplCopyWithImpl<_$ProjectDetailModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectDetailModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectDetailModel implements ProjectDetailModel {
  const factory _ProjectDetailModel(
          {@JsonKey(name: 'project') required final ProjectModel project,
          @JsonKey(name: 'languages') final List<LanguageModel>? languages,
          @JsonKey(name: 'members') final List<ProjectMemberModel>? members}) =
      _$ProjectDetailModelImpl;

  factory _ProjectDetailModel.fromJson(Map<String, dynamic> json) =
      _$ProjectDetailModelImpl.fromJson;

  /// 项目
  @override
  @JsonKey(name: 'project')
  ProjectModel get project;

  /// 项目语言
  @override
  @JsonKey(name: 'languages')
  List<LanguageModel>? get languages;

  /// 项目成员
  @override
  @JsonKey(name: 'members')
  List<ProjectMemberModel>? get members;

  /// Create a copy of ProjectDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectDetailModelImplCopyWith<_$ProjectDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
