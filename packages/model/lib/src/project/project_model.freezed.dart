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

  /// 项目成员上限
  @JsonKey(name: 'member_limit')
  @FlexibleIntConverter()
  int get memberLimit => throw _privateConstructorUsedError;

  /// 是否激活
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

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

  /// 项目语言
  @JsonKey(name: 'languages')
  List<LanguageModel> get languages => throw _privateConstructorUsedError;

  /// 项目成员
  @JsonKey(name: 'members')
  List<ProjectMemberModel> get members => throw _privateConstructorUsedError;

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
      @JsonKey(name: 'member_limit') @FlexibleIntConverter() int memberLimit,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_activity_at')
      @NullableTimesConverter()
      DateTime? lastActivityAt,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt,
      @JsonKey(name: 'languages') List<LanguageModel> languages,
      @JsonKey(name: 'members') List<ProjectMemberModel> members});
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
    Object? memberLimit = null,
    Object? isActive = null,
    Object? lastActivityAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? languages = null,
    Object? members = null,
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
      memberLimit: null == memberLimit
          ? _value.memberLimit
          : memberLimit // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<LanguageModel>,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ProjectMemberModel>,
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
      @JsonKey(name: 'member_limit') @FlexibleIntConverter() int memberLimit,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_activity_at')
      @NullableTimesConverter()
      DateTime? lastActivityAt,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt,
      @JsonKey(name: 'languages') List<LanguageModel> languages,
      @JsonKey(name: 'members') List<ProjectMemberModel> members});
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
    Object? memberLimit = null,
    Object? isActive = null,
    Object? lastActivityAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? languages = null,
    Object? members = null,
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
      memberLimit: null == memberLimit
          ? _value.memberLimit
          : memberLimit // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<LanguageModel>,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<ProjectMemberModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectModelImpl extends _ProjectModel {
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
      @JsonKey(name: 'member_limit')
      @FlexibleIntConverter()
      this.memberLimit = 10,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'last_activity_at')
      @NullableTimesConverter()
      this.lastActivityAt,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() required this.updatedAt,
      @JsonKey(name: 'languages') required final List<LanguageModel> languages,
      @JsonKey(name: 'members')
      required final List<ProjectMemberModel> members})
      : _languages = languages,
        _members = members,
        super._();

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

  /// 项目成员上限
  @override
  @JsonKey(name: 'member_limit')
  @FlexibleIntConverter()
  final int memberLimit;

  /// 是否激活
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

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

  /// 项目语言
  final List<LanguageModel> _languages;

  /// 项目语言
  @override
  @JsonKey(name: 'languages')
  List<LanguageModel> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  /// 项目成员
  final List<ProjectMemberModel> _members;

  /// 项目成员
  @override
  @JsonKey(name: 'members')
  List<ProjectMemberModel> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString() {
    return 'ProjectModel(id: $id, name: $name, slug: $slug, description: $description, ownerId: $ownerId, status: $status, visibility: $visibility, primaryLanguageId: $primaryLanguageId, totalKeys: $totalKeys, translatedKeys: $translatedKeys, memberLimit: $memberLimit, isActive: $isActive, lastActivityAt: $lastActivityAt, createdAt: $createdAt, updatedAt: $updatedAt, languages: $languages, members: $members)';
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
            (identical(other.memberLimit, memberLimit) ||
                other.memberLimit == memberLimit) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastActivityAt, lastActivityAt) ||
                other.lastActivityAt == lastActivityAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
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
      memberLimit,
      isActive,
      lastActivityAt,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_languages),
      const DeepCollectionEquality().hash(_members));

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

abstract class _ProjectModel extends ProjectModel {
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
      @JsonKey(name: 'member_limit')
      @FlexibleIntConverter()
      final int memberLimit,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'last_activity_at')
      @NullableTimesConverter()
      final DateTime? lastActivityAt,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      @TimesConverter()
      required final DateTime updatedAt,
      @JsonKey(name: 'languages') required final List<LanguageModel> languages,
      @JsonKey(name: 'members')
      required final List<ProjectMemberModel> members}) = _$ProjectModelImpl;
  const _ProjectModel._() : super._();

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

  /// 项目成员上限
  @override
  @JsonKey(name: 'member_limit')
  @FlexibleIntConverter()
  int get memberLimit;

  /// 是否激活
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

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

  /// 项目语言
  @override
  @JsonKey(name: 'languages')
  List<LanguageModel> get languages;

  /// 项目成员
  @override
  @JsonKey(name: 'members')
  List<ProjectMemberModel> get members;

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
      int? primaryLanguageId});
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
      int? primaryLanguageId});
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
      this.primaryLanguageId});

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

  @override
  String toString() {
    return 'CreateProjectRequest(name: $name, slug: $slug, description: $description, status: $status, visibility: $visibility, primaryLanguageId: $primaryLanguageId)';
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
                other.primaryLanguageId == primaryLanguageId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, slug, description, status,
      visibility, primaryLanguageId);

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
      final int? primaryLanguageId}) = _$CreateProjectRequestImpl;

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
      int? primaryLanguageId});
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
      int? primaryLanguageId});
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
      this.primaryLanguageId});

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

  @override
  String toString() {
    return 'UpdateProjectRequest(name: $name, slug: $slug, description: $description, status: $status, visibility: $visibility, primaryLanguageId: $primaryLanguageId)';
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
                other.primaryLanguageId == primaryLanguageId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, slug, description, status,
      visibility, primaryLanguageId);

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
      final int? primaryLanguageId}) = _$UpdateProjectRequestImpl;

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
