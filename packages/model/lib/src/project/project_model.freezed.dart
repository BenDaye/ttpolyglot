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
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'slug')
  String get slug => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String get ownerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'visibility')
  String get visibility => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_language_code')
  String? get primaryLanguageCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_keys')
  int get totalKeys => throw _privateConstructorUsedError;
  @JsonKey(name: 'translated_keys')
  int get translatedKeys => throw _privateConstructorUsedError;
  @JsonKey(name: 'languages_count')
  int get languagesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'members_count')
  int get membersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_public')
  bool get isPublic => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_activity_at')
  DateTime? get lastActivityAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError; // 扩展字段（从联表查询）
  @JsonKey(name: 'owner_username')
  String? get ownerUsername => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_display_name')
  String? get ownerDisplayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_avatar')
  String? get ownerAvatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_language_name')
  String? get primaryLanguageName => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_language_native_name')
  String? get primaryLanguageNativeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_percentage')
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
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'visibility') String visibility,
      @JsonKey(name: 'primary_language_code') String? primaryLanguageCode,
      @JsonKey(name: 'total_keys') int totalKeys,
      @JsonKey(name: 'translated_keys') int translatedKeys,
      @JsonKey(name: 'languages_count') int languagesCount,
      @JsonKey(name: 'members_count') int membersCount,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'settings') Map<String, dynamic>? settings,
      @JsonKey(name: 'last_activity_at') DateTime? lastActivityAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'owner_username') String? ownerUsername,
      @JsonKey(name: 'owner_display_name') String? ownerDisplayName,
      @JsonKey(name: 'owner_avatar') String? ownerAvatar,
      @JsonKey(name: 'primary_language_name') String? primaryLanguageName,
      @JsonKey(name: 'primary_language_native_name')
      String? primaryLanguageNativeName,
      @JsonKey(name: 'completion_percentage') double completionPercentage});
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
    Object? primaryLanguageCode = freezed,
    Object? totalKeys = null,
    Object? translatedKeys = null,
    Object? languagesCount = null,
    Object? membersCount = null,
    Object? isPublic = null,
    Object? isActive = null,
    Object? settings = freezed,
    Object? lastActivityAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerUsername = freezed,
    Object? ownerDisplayName = freezed,
    Object? ownerAvatar = freezed,
    Object? primaryLanguageName = freezed,
    Object? primaryLanguageNativeName = freezed,
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
      primaryLanguageCode: freezed == primaryLanguageCode
          ? _value.primaryLanguageCode
          : primaryLanguageCode // ignore: cast_nullable_to_non_nullable
              as String?,
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
      primaryLanguageName: freezed == primaryLanguageName
          ? _value.primaryLanguageName
          : primaryLanguageName // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryLanguageNativeName: freezed == primaryLanguageNativeName
          ? _value.primaryLanguageNativeName
          : primaryLanguageNativeName // ignore: cast_nullable_to_non_nullable
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
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'slug') String slug,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'owner_id') String ownerId,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'visibility') String visibility,
      @JsonKey(name: 'primary_language_code') String? primaryLanguageCode,
      @JsonKey(name: 'total_keys') int totalKeys,
      @JsonKey(name: 'translated_keys') int translatedKeys,
      @JsonKey(name: 'languages_count') int languagesCount,
      @JsonKey(name: 'members_count') int membersCount,
      @JsonKey(name: 'is_public') bool isPublic,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'settings') Map<String, dynamic>? settings,
      @JsonKey(name: 'last_activity_at') DateTime? lastActivityAt,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'owner_username') String? ownerUsername,
      @JsonKey(name: 'owner_display_name') String? ownerDisplayName,
      @JsonKey(name: 'owner_avatar') String? ownerAvatar,
      @JsonKey(name: 'primary_language_name') String? primaryLanguageName,
      @JsonKey(name: 'primary_language_native_name')
      String? primaryLanguageNativeName,
      @JsonKey(name: 'completion_percentage') double completionPercentage});
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
    Object? primaryLanguageCode = freezed,
    Object? totalKeys = null,
    Object? translatedKeys = null,
    Object? languagesCount = null,
    Object? membersCount = null,
    Object? isPublic = null,
    Object? isActive = null,
    Object? settings = freezed,
    Object? lastActivityAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? ownerUsername = freezed,
    Object? ownerDisplayName = freezed,
    Object? ownerAvatar = freezed,
    Object? primaryLanguageName = freezed,
    Object? primaryLanguageNativeName = freezed,
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
      primaryLanguageCode: freezed == primaryLanguageCode
          ? _value.primaryLanguageCode
          : primaryLanguageCode // ignore: cast_nullable_to_non_nullable
              as String?,
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
      primaryLanguageName: freezed == primaryLanguageName
          ? _value.primaryLanguageName
          : primaryLanguageName // ignore: cast_nullable_to_non_nullable
              as String?,
      primaryLanguageNativeName: freezed == primaryLanguageNativeName
          ? _value.primaryLanguageNativeName
          : primaryLanguageNativeName // ignore: cast_nullable_to_non_nullable
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
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'slug') required this.slug,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'owner_id') required this.ownerId,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'visibility') required this.visibility,
      @JsonKey(name: 'primary_language_code') this.primaryLanguageCode,
      @JsonKey(name: 'total_keys') this.totalKeys = 0,
      @JsonKey(name: 'translated_keys') this.translatedKeys = 0,
      @JsonKey(name: 'languages_count') this.languagesCount = 0,
      @JsonKey(name: 'members_count') this.membersCount = 1,
      @JsonKey(name: 'is_public') this.isPublic = false,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'settings') final Map<String, dynamic>? settings,
      @JsonKey(name: 'last_activity_at') this.lastActivityAt,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt,
      @JsonKey(name: 'owner_username') this.ownerUsername,
      @JsonKey(name: 'owner_display_name') this.ownerDisplayName,
      @JsonKey(name: 'owner_avatar') this.ownerAvatar,
      @JsonKey(name: 'primary_language_name') this.primaryLanguageName,
      @JsonKey(name: 'primary_language_native_name')
      this.primaryLanguageNativeName,
      @JsonKey(name: 'completion_percentage') this.completionPercentage = 0.0})
      : _settings = settings;

  factory _$ProjectModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'name')
  final String name;
  @override
  @JsonKey(name: 'slug')
  final String slug;
  @override
  @JsonKey(name: 'description')
  final String? description;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'visibility')
  final String visibility;
  @override
  @JsonKey(name: 'primary_language_code')
  final String? primaryLanguageCode;
  @override
  @JsonKey(name: 'total_keys')
  final int totalKeys;
  @override
  @JsonKey(name: 'translated_keys')
  final int translatedKeys;
  @override
  @JsonKey(name: 'languages_count')
  final int languagesCount;
  @override
  @JsonKey(name: 'members_count')
  final int membersCount;
  @override
  @JsonKey(name: 'is_public')
  final bool isPublic;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  final Map<String, dynamic>? _settings;
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
  @JsonKey(name: 'last_activity_at')
  final DateTime? lastActivityAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
// 扩展字段（从联表查询）
  @override
  @JsonKey(name: 'owner_username')
  final String? ownerUsername;
  @override
  @JsonKey(name: 'owner_display_name')
  final String? ownerDisplayName;
  @override
  @JsonKey(name: 'owner_avatar')
  final String? ownerAvatar;
  @override
  @JsonKey(name: 'primary_language_name')
  final String? primaryLanguageName;
  @override
  @JsonKey(name: 'primary_language_native_name')
  final String? primaryLanguageNativeName;
  @override
  @JsonKey(name: 'completion_percentage')
  final double completionPercentage;

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, slug: $slug, description: $description, ownerId: $ownerId, status: $status, visibility: $visibility, primaryLanguageCode: $primaryLanguageCode, totalKeys: $totalKeys, translatedKeys: $translatedKeys, languagesCount: $languagesCount, membersCount: $membersCount, isPublic: $isPublic, isActive: $isActive, settings: $settings, lastActivityAt: $lastActivityAt, createdAt: $createdAt, updatedAt: $updatedAt, ownerUsername: $ownerUsername, ownerDisplayName: $ownerDisplayName, ownerAvatar: $ownerAvatar, primaryLanguageName: $primaryLanguageName, primaryLanguageNativeName: $primaryLanguageNativeName, completionPercentage: $completionPercentage)';
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
            (identical(other.primaryLanguageCode, primaryLanguageCode) ||
                other.primaryLanguageCode == primaryLanguageCode) &&
            (identical(other.totalKeys, totalKeys) ||
                other.totalKeys == totalKeys) &&
            (identical(other.translatedKeys, translatedKeys) ||
                other.translatedKeys == translatedKeys) &&
            (identical(other.languagesCount, languagesCount) ||
                other.languagesCount == languagesCount) &&
            (identical(other.membersCount, membersCount) ||
                other.membersCount == membersCount) &&
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
            (identical(other.primaryLanguageName, primaryLanguageName) ||
                other.primaryLanguageName == primaryLanguageName) &&
            (identical(other.primaryLanguageNativeName,
                    primaryLanguageNativeName) ||
                other.primaryLanguageNativeName == primaryLanguageNativeName) &&
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
        primaryLanguageCode,
        totalKeys,
        translatedKeys,
        languagesCount,
        membersCount,
        isPublic,
        isActive,
        const DeepCollectionEquality().hash(_settings),
        lastActivityAt,
        createdAt,
        updatedAt,
        ownerUsername,
        ownerDisplayName,
        ownerAvatar,
        primaryLanguageName,
        primaryLanguageNativeName,
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
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'slug') required final String slug,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'owner_id') required final String ownerId,
      @JsonKey(name: 'status') required final String status,
      @JsonKey(name: 'visibility') required final String visibility,
      @JsonKey(name: 'primary_language_code') final String? primaryLanguageCode,
      @JsonKey(name: 'total_keys') final int totalKeys,
      @JsonKey(name: 'translated_keys') final int translatedKeys,
      @JsonKey(name: 'languages_count') final int languagesCount,
      @JsonKey(name: 'members_count') final int membersCount,
      @JsonKey(name: 'is_public') final bool isPublic,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'settings') final Map<String, dynamic>? settings,
      @JsonKey(name: 'last_activity_at') final DateTime? lastActivityAt,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at') required final DateTime updatedAt,
      @JsonKey(name: 'owner_username') final String? ownerUsername,
      @JsonKey(name: 'owner_display_name') final String? ownerDisplayName,
      @JsonKey(name: 'owner_avatar') final String? ownerAvatar,
      @JsonKey(name: 'primary_language_name') final String? primaryLanguageName,
      @JsonKey(name: 'primary_language_native_name')
      final String? primaryLanguageNativeName,
      @JsonKey(name: 'completion_percentage')
      final double completionPercentage}) = _$ProjectModelImpl;

  factory _ProjectModel.fromJson(Map<String, dynamic> json) =
      _$ProjectModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'name')
  String get name;
  @override
  @JsonKey(name: 'slug')
  String get slug;
  @override
  @JsonKey(name: 'description')
  String? get description;
  @override
  @JsonKey(name: 'owner_id')
  String get ownerId;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'visibility')
  String get visibility;
  @override
  @JsonKey(name: 'primary_language_code')
  String? get primaryLanguageCode;
  @override
  @JsonKey(name: 'total_keys')
  int get totalKeys;
  @override
  @JsonKey(name: 'translated_keys')
  int get translatedKeys;
  @override
  @JsonKey(name: 'languages_count')
  int get languagesCount;
  @override
  @JsonKey(name: 'members_count')
  int get membersCount;
  @override
  @JsonKey(name: 'is_public')
  bool get isPublic;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'settings')
  Map<String, dynamic>? get settings;
  @override
  @JsonKey(name: 'last_activity_at')
  DateTime? get lastActivityAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt; // 扩展字段（从联表查询）
  @override
  @JsonKey(name: 'owner_username')
  String? get ownerUsername;
  @override
  @JsonKey(name: 'owner_display_name')
  String? get ownerDisplayName;
  @override
  @JsonKey(name: 'owner_avatar')
  String? get ownerAvatar;
  @override
  @JsonKey(name: 'primary_language_name')
  String? get primaryLanguageName;
  @override
  @JsonKey(name: 'primary_language_native_name')
  String? get primaryLanguageNativeName;
  @override
  @JsonKey(name: 'completion_percentage')
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
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get visibility => throw _privateConstructorUsedError;
  String? get primaryLanguageCode => throw _privateConstructorUsedError;
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
      {String name,
      String slug,
      String? description,
      String status,
      String visibility,
      String? primaryLanguageCode,
      Map<String, dynamic>? settings});
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
    Object? primaryLanguageCode = freezed,
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
      primaryLanguageCode: freezed == primaryLanguageCode
          ? _value.primaryLanguageCode
          : primaryLanguageCode // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String name,
      String slug,
      String? description,
      String status,
      String visibility,
      String? primaryLanguageCode,
      Map<String, dynamic>? settings});
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
    Object? primaryLanguageCode = freezed,
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
      primaryLanguageCode: freezed == primaryLanguageCode
          ? _value.primaryLanguageCode
          : primaryLanguageCode // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {required this.name,
      required this.slug,
      this.description,
      this.status = 'active',
      this.visibility = 'private',
      this.primaryLanguageCode,
      final Map<String, dynamic>? settings})
      : _settings = settings;

  factory _$CreateProjectRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateProjectRequestImplFromJson(json);

  @override
  final String name;
  @override
  final String slug;
  @override
  final String? description;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String visibility;
  @override
  final String? primaryLanguageCode;
  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'CreateProjectRequest(name: $name, slug: $slug, description: $description, status: $status, visibility: $visibility, primaryLanguageCode: $primaryLanguageCode, settings: $settings)';
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
            (identical(other.primaryLanguageCode, primaryLanguageCode) ||
                other.primaryLanguageCode == primaryLanguageCode) &&
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
      primaryLanguageCode,
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
      {required final String name,
      required final String slug,
      final String? description,
      final String status,
      final String visibility,
      final String? primaryLanguageCode,
      final Map<String, dynamic>? settings}) = _$CreateProjectRequestImpl;

  factory _CreateProjectRequest.fromJson(Map<String, dynamic> json) =
      _$CreateProjectRequestImpl.fromJson;

  @override
  String get name;
  @override
  String get slug;
  @override
  String? get description;
  @override
  String get status;
  @override
  String get visibility;
  @override
  String? get primaryLanguageCode;
  @override
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
  String? get name => throw _privateConstructorUsedError;
  String? get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get visibility => throw _privateConstructorUsedError;
  String? get primaryLanguageCode => throw _privateConstructorUsedError;
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
      {String? name,
      String? slug,
      String? description,
      String? status,
      String? visibility,
      String? primaryLanguageCode,
      Map<String, dynamic>? settings});
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
    Object? primaryLanguageCode = freezed,
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
      primaryLanguageCode: freezed == primaryLanguageCode
          ? _value.primaryLanguageCode
          : primaryLanguageCode // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {String? name,
      String? slug,
      String? description,
      String? status,
      String? visibility,
      String? primaryLanguageCode,
      Map<String, dynamic>? settings});
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
    Object? primaryLanguageCode = freezed,
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
      primaryLanguageCode: freezed == primaryLanguageCode
          ? _value.primaryLanguageCode
          : primaryLanguageCode // ignore: cast_nullable_to_non_nullable
              as String?,
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
      {this.name,
      this.slug,
      this.description,
      this.status,
      this.visibility,
      this.primaryLanguageCode,
      final Map<String, dynamic>? settings})
      : _settings = settings;

  factory _$UpdateProjectRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateProjectRequestImplFromJson(json);

  @override
  final String? name;
  @override
  final String? slug;
  @override
  final String? description;
  @override
  final String? status;
  @override
  final String? visibility;
  @override
  final String? primaryLanguageCode;
  final Map<String, dynamic>? _settings;
  @override
  Map<String, dynamic>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'UpdateProjectRequest(name: $name, slug: $slug, description: $description, status: $status, visibility: $visibility, primaryLanguageCode: $primaryLanguageCode, settings: $settings)';
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
            (identical(other.primaryLanguageCode, primaryLanguageCode) ||
                other.primaryLanguageCode == primaryLanguageCode) &&
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
      primaryLanguageCode,
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
      {final String? name,
      final String? slug,
      final String? description,
      final String? status,
      final String? visibility,
      final String? primaryLanguageCode,
      final Map<String, dynamic>? settings}) = _$UpdateProjectRequestImpl;

  factory _UpdateProjectRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateProjectRequestImpl.fromJson;

  @override
  String? get name;
  @override
  String? get slug;
  @override
  String? get description;
  @override
  String? get status;
  @override
  String? get visibility;
  @override
  String? get primaryLanguageCode;
  @override
  Map<String, dynamic>? get settings;

  /// Create a copy of UpdateProjectRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateProjectRequestImplCopyWith<_$UpdateProjectRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ProjectDetailModel _$ProjectDetailModelFromJson(Map<String, dynamic> json) {
  return _ProjectDetailModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectDetailModel {
  ProjectModel get project => throw _privateConstructorUsedError;
  List<ProjectLanguageInfo>? get languages =>
      throw _privateConstructorUsedError;
  List<ProjectMemberInfo>? get members => throw _privateConstructorUsedError;

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
      {ProjectModel project,
      List<ProjectLanguageInfo>? languages,
      List<ProjectMemberInfo>? members});

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
              as List<ProjectLanguageInfo>?,
      members: freezed == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ProjectMemberInfo>?,
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
      {ProjectModel project,
      List<ProjectLanguageInfo>? languages,
      List<ProjectMemberInfo>? members});

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
              as List<ProjectLanguageInfo>?,
      members: freezed == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ProjectMemberInfo>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectDetailModelImpl implements _ProjectDetailModel {
  const _$ProjectDetailModelImpl(
      {required this.project,
      final List<ProjectLanguageInfo>? languages,
      final List<ProjectMemberInfo>? members})
      : _languages = languages,
        _members = members;

  factory _$ProjectDetailModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectDetailModelImplFromJson(json);

  @override
  final ProjectModel project;
  final List<ProjectLanguageInfo>? _languages;
  @override
  List<ProjectLanguageInfo>? get languages {
    final value = _languages;
    if (value == null) return null;
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ProjectMemberInfo>? _members;
  @override
  List<ProjectMemberInfo>? get members {
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
      {required final ProjectModel project,
      final List<ProjectLanguageInfo>? languages,
      final List<ProjectMemberInfo>? members}) = _$ProjectDetailModelImpl;

  factory _ProjectDetailModel.fromJson(Map<String, dynamic> json) =
      _$ProjectDetailModelImpl.fromJson;

  @override
  ProjectModel get project;
  @override
  List<ProjectLanguageInfo>? get languages;
  @override
  List<ProjectMemberInfo>? get members;

  /// Create a copy of ProjectDetailModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectDetailModelImplCopyWith<_$ProjectDetailModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectLanguageInfo _$ProjectLanguageInfoFromJson(Map<String, dynamic> json) {
  return _ProjectLanguageInfo.fromJson(json);
}

/// @nodoc
mixin _$ProjectLanguageInfo {
  @JsonKey(name: 'language_code')
  String get languageCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'language_name')
  String get languageName => throw _privateConstructorUsedError;
  @JsonKey(name: 'native_name')
  String? get nativeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;
  @JsonKey(name: 'translated_keys')
  int get translatedKeys => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_keys')
  int get totalKeys => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_percentage')
  double get completionPercentage => throw _privateConstructorUsedError;

  /// Serializes this ProjectLanguageInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectLanguageInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectLanguageInfoCopyWith<ProjectLanguageInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectLanguageInfoCopyWith<$Res> {
  factory $ProjectLanguageInfoCopyWith(
          ProjectLanguageInfo value, $Res Function(ProjectLanguageInfo) then) =
      _$ProjectLanguageInfoCopyWithImpl<$Res, ProjectLanguageInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'language_code') String languageCode,
      @JsonKey(name: 'language_name') String languageName,
      @JsonKey(name: 'native_name') String? nativeName,
      @JsonKey(name: 'is_primary') bool isPrimary,
      @JsonKey(name: 'translated_keys') int translatedKeys,
      @JsonKey(name: 'total_keys') int totalKeys,
      @JsonKey(name: 'completion_percentage') double completionPercentage});
}

/// @nodoc
class _$ProjectLanguageInfoCopyWithImpl<$Res, $Val extends ProjectLanguageInfo>
    implements $ProjectLanguageInfoCopyWith<$Res> {
  _$ProjectLanguageInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectLanguageInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
    Object? languageName = null,
    Object? nativeName = freezed,
    Object? isPrimary = null,
    Object? translatedKeys = null,
    Object? totalKeys = null,
    Object? completionPercentage = null,
  }) {
    return _then(_value.copyWith(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      languageName: null == languageName
          ? _value.languageName
          : languageName // ignore: cast_nullable_to_non_nullable
              as String,
      nativeName: freezed == nativeName
          ? _value.nativeName
          : nativeName // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      translatedKeys: null == translatedKeys
          ? _value.translatedKeys
          : translatedKeys // ignore: cast_nullable_to_non_nullable
              as int,
      totalKeys: null == totalKeys
          ? _value.totalKeys
          : totalKeys // ignore: cast_nullable_to_non_nullable
              as int,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectLanguageInfoImplCopyWith<$Res>
    implements $ProjectLanguageInfoCopyWith<$Res> {
  factory _$$ProjectLanguageInfoImplCopyWith(_$ProjectLanguageInfoImpl value,
          $Res Function(_$ProjectLanguageInfoImpl) then) =
      __$$ProjectLanguageInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'language_code') String languageCode,
      @JsonKey(name: 'language_name') String languageName,
      @JsonKey(name: 'native_name') String? nativeName,
      @JsonKey(name: 'is_primary') bool isPrimary,
      @JsonKey(name: 'translated_keys') int translatedKeys,
      @JsonKey(name: 'total_keys') int totalKeys,
      @JsonKey(name: 'completion_percentage') double completionPercentage});
}

/// @nodoc
class __$$ProjectLanguageInfoImplCopyWithImpl<$Res>
    extends _$ProjectLanguageInfoCopyWithImpl<$Res, _$ProjectLanguageInfoImpl>
    implements _$$ProjectLanguageInfoImplCopyWith<$Res> {
  __$$ProjectLanguageInfoImplCopyWithImpl(_$ProjectLanguageInfoImpl _value,
      $Res Function(_$ProjectLanguageInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectLanguageInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? languageCode = null,
    Object? languageName = null,
    Object? nativeName = freezed,
    Object? isPrimary = null,
    Object? translatedKeys = null,
    Object? totalKeys = null,
    Object? completionPercentage = null,
  }) {
    return _then(_$ProjectLanguageInfoImpl(
      languageCode: null == languageCode
          ? _value.languageCode
          : languageCode // ignore: cast_nullable_to_non_nullable
              as String,
      languageName: null == languageName
          ? _value.languageName
          : languageName // ignore: cast_nullable_to_non_nullable
              as String,
      nativeName: freezed == nativeName
          ? _value.nativeName
          : nativeName // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
      translatedKeys: null == translatedKeys
          ? _value.translatedKeys
          : translatedKeys // ignore: cast_nullable_to_non_nullable
              as int,
      totalKeys: null == totalKeys
          ? _value.totalKeys
          : totalKeys // ignore: cast_nullable_to_non_nullable
              as int,
      completionPercentage: null == completionPercentage
          ? _value.completionPercentage
          : completionPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectLanguageInfoImpl implements _ProjectLanguageInfo {
  const _$ProjectLanguageInfoImpl(
      {@JsonKey(name: 'language_code') required this.languageCode,
      @JsonKey(name: 'language_name') required this.languageName,
      @JsonKey(name: 'native_name') this.nativeName,
      @JsonKey(name: 'is_primary') this.isPrimary = false,
      @JsonKey(name: 'translated_keys') this.translatedKeys = 0,
      @JsonKey(name: 'total_keys') this.totalKeys = 0,
      @JsonKey(name: 'completion_percentage') this.completionPercentage = 0.0});

  factory _$ProjectLanguageInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectLanguageInfoImplFromJson(json);

  @override
  @JsonKey(name: 'language_code')
  final String languageCode;
  @override
  @JsonKey(name: 'language_name')
  final String languageName;
  @override
  @JsonKey(name: 'native_name')
  final String? nativeName;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @override
  @JsonKey(name: 'translated_keys')
  final int translatedKeys;
  @override
  @JsonKey(name: 'total_keys')
  final int totalKeys;
  @override
  @JsonKey(name: 'completion_percentage')
  final double completionPercentage;

  @override
  String toString() {
    return 'ProjectLanguageInfo(languageCode: $languageCode, languageName: $languageName, nativeName: $nativeName, isPrimary: $isPrimary, translatedKeys: $translatedKeys, totalKeys: $totalKeys, completionPercentage: $completionPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectLanguageInfoImpl &&
            (identical(other.languageCode, languageCode) ||
                other.languageCode == languageCode) &&
            (identical(other.languageName, languageName) ||
                other.languageName == languageName) &&
            (identical(other.nativeName, nativeName) ||
                other.nativeName == nativeName) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary) &&
            (identical(other.translatedKeys, translatedKeys) ||
                other.translatedKeys == translatedKeys) &&
            (identical(other.totalKeys, totalKeys) ||
                other.totalKeys == totalKeys) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, languageCode, languageName,
      nativeName, isPrimary, translatedKeys, totalKeys, completionPercentage);

  /// Create a copy of ProjectLanguageInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectLanguageInfoImplCopyWith<_$ProjectLanguageInfoImpl> get copyWith =>
      __$$ProjectLanguageInfoImplCopyWithImpl<_$ProjectLanguageInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectLanguageInfoImplToJson(
      this,
    );
  }
}

abstract class _ProjectLanguageInfo implements ProjectLanguageInfo {
  const factory _ProjectLanguageInfo(
      {@JsonKey(name: 'language_code') required final String languageCode,
      @JsonKey(name: 'language_name') required final String languageName,
      @JsonKey(name: 'native_name') final String? nativeName,
      @JsonKey(name: 'is_primary') final bool isPrimary,
      @JsonKey(name: 'translated_keys') final int translatedKeys,
      @JsonKey(name: 'total_keys') final int totalKeys,
      @JsonKey(name: 'completion_percentage')
      final double completionPercentage}) = _$ProjectLanguageInfoImpl;

  factory _ProjectLanguageInfo.fromJson(Map<String, dynamic> json) =
      _$ProjectLanguageInfoImpl.fromJson;

  @override
  @JsonKey(name: 'language_code')
  String get languageCode;
  @override
  @JsonKey(name: 'language_name')
  String get languageName;
  @override
  @JsonKey(name: 'native_name')
  String? get nativeName;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;
  @override
  @JsonKey(name: 'translated_keys')
  int get translatedKeys;
  @override
  @JsonKey(name: 'total_keys')
  int get totalKeys;
  @override
  @JsonKey(name: 'completion_percentage')
  double get completionPercentage;

  /// Create a copy of ProjectLanguageInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectLanguageInfoImplCopyWith<_$ProjectLanguageInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProjectMemberInfo _$ProjectMemberInfoFromJson(Map<String, dynamic> json) {
  return _ProjectMemberInfo.fromJson(json);
}

/// @nodoc
mixin _$ProjectMemberInfo {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'role')
  String get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'joined_at')
  DateTime? get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this ProjectMemberInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectMemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectMemberInfoCopyWith<ProjectMemberInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectMemberInfoCopyWith<$Res> {
  factory $ProjectMemberInfoCopyWith(
          ProjectMemberInfo value, $Res Function(ProjectMemberInfo) then) =
      _$ProjectMemberInfoCopyWithImpl<$Res, ProjectMemberInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'role') String role,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'joined_at') DateTime? joinedAt});
}

/// @nodoc
class _$ProjectMemberInfoCopyWithImpl<$Res, $Val extends ProjectMemberInfo>
    implements $ProjectMemberInfoCopyWith<$Res> {
  _$ProjectMemberInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectMemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? status = null,
    Object? joinedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectMemberInfoImplCopyWith<$Res>
    implements $ProjectMemberInfoCopyWith<$Res> {
  factory _$$ProjectMemberInfoImplCopyWith(_$ProjectMemberInfoImpl value,
          $Res Function(_$ProjectMemberInfoImpl) then) =
      __$$ProjectMemberInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'role') String role,
      @JsonKey(name: 'status') String status,
      @JsonKey(name: 'joined_at') DateTime? joinedAt});
}

/// @nodoc
class __$$ProjectMemberInfoImplCopyWithImpl<$Res>
    extends _$ProjectMemberInfoCopyWithImpl<$Res, _$ProjectMemberInfoImpl>
    implements _$$ProjectMemberInfoImplCopyWith<$Res> {
  __$$ProjectMemberInfoImplCopyWithImpl(_$ProjectMemberInfoImpl _value,
      $Res Function(_$ProjectMemberInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectMemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? role = null,
    Object? status = null,
    Object? joinedAt = freezed,
  }) {
    return _then(_$ProjectMemberInfoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectMemberInfoImpl implements _ProjectMemberInfo {
  const _$ProjectMemberInfoImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'display_name') this.displayName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'role') required this.role,
      @JsonKey(name: 'status') required this.status,
      @JsonKey(name: 'joined_at') this.joinedAt});

  factory _$ProjectMemberInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectMemberInfoImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'username')
  final String username;
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'role')
  final String role;
  @override
  @JsonKey(name: 'status')
  final String status;
  @override
  @JsonKey(name: 'joined_at')
  final DateTime? joinedAt;

  @override
  String toString() {
    return 'ProjectMemberInfo(userId: $userId, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, role: $role, status: $status, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectMemberInfoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, username, displayName,
      avatarUrl, role, status, joinedAt);

  /// Create a copy of ProjectMemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectMemberInfoImplCopyWith<_$ProjectMemberInfoImpl> get copyWith =>
      __$$ProjectMemberInfoImplCopyWithImpl<_$ProjectMemberInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectMemberInfoImplToJson(
      this,
    );
  }
}

abstract class _ProjectMemberInfo implements ProjectMemberInfo {
  const factory _ProjectMemberInfo(
          {@JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'username') required final String username,
          @JsonKey(name: 'display_name') final String? displayName,
          @JsonKey(name: 'avatar_url') final String? avatarUrl,
          @JsonKey(name: 'role') required final String role,
          @JsonKey(name: 'status') required final String status,
          @JsonKey(name: 'joined_at') final DateTime? joinedAt}) =
      _$ProjectMemberInfoImpl;

  factory _ProjectMemberInfo.fromJson(Map<String, dynamic> json) =
      _$ProjectMemberInfoImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'username')
  String get username;
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'role')
  String get role;
  @override
  @JsonKey(name: 'status')
  String get status;
  @override
  @JsonKey(name: 'joined_at')
  DateTime? get joinedAt;

  /// Create a copy of ProjectMemberInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectMemberInfoImplCopyWith<_$ProjectMemberInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
