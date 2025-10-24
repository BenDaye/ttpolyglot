// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_member_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjectMemberModel _$ProjectMemberModelFromJson(Map<String, dynamic> json) {
  return _ProjectMemberModel.fromJson(json);
}

/// @nodoc
mixin _$ProjectMemberModel {
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'project_id')
  int get projectId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role => throw _privateConstructorUsedError;
  @JsonKey(name: 'invited_by')
  String? get invitedBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'invited_at')
  @TimesConverter()
  DateTime get invitedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'joined_at')
  @NullableTimesConverter()
  DateTime? get joinedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  @MemberStatusEnumConverter()
  MemberStatusEnum get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError; // 扩展字段（从联表查询）
  @JsonKey(name: 'username')
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'inviter_username')
  String? get inviterUsername => throw _privateConstructorUsedError;
  @JsonKey(name: 'inviter_display_name')
  String? get inviterDisplayName => throw _privateConstructorUsedError;

  /// Serializes this ProjectMemberModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjectMemberModelCopyWith<ProjectMemberModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectMemberModelCopyWith<$Res> {
  factory $ProjectMemberModelCopyWith(
          ProjectMemberModel value, $Res Function(ProjectMemberModel) then) =
      _$ProjectMemberModelCopyWithImpl<$Res, ProjectMemberModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'project_id') int projectId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role,
      @JsonKey(name: 'invited_by') String? invitedBy,
      @JsonKey(name: 'invited_at') @TimesConverter() DateTime invitedAt,
      @JsonKey(name: 'joined_at') @NullableTimesConverter() DateTime? joinedAt,
      @JsonKey(name: 'status')
      @MemberStatusEnumConverter()
      MemberStatusEnum status,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt,
      @JsonKey(name: 'username') String? username,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'inviter_username') String? inviterUsername,
      @JsonKey(name: 'inviter_display_name') String? inviterDisplayName});
}

/// @nodoc
class _$ProjectMemberModelCopyWithImpl<$Res, $Val extends ProjectMemberModel>
    implements $ProjectMemberModelCopyWith<$Res> {
  _$ProjectMemberModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? userId = null,
    Object? role = null,
    Object? invitedBy = freezed,
    Object? invitedAt = null,
    Object? joinedAt = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? username = freezed,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? email = freezed,
    Object? inviterUsername = freezed,
    Object? inviterDisplayName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
      invitedBy: freezed == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedAt: null == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MemberStatusEnum,
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
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      inviterUsername: freezed == inviterUsername
          ? _value.inviterUsername
          : inviterUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      inviterDisplayName: freezed == inviterDisplayName
          ? _value.inviterDisplayName
          : inviterDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectMemberModelImplCopyWith<$Res>
    implements $ProjectMemberModelCopyWith<$Res> {
  factory _$$ProjectMemberModelImplCopyWith(_$ProjectMemberModelImpl value,
          $Res Function(_$ProjectMemberModelImpl) then) =
      __$$ProjectMemberModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'project_id') int projectId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role,
      @JsonKey(name: 'invited_by') String? invitedBy,
      @JsonKey(name: 'invited_at') @TimesConverter() DateTime invitedAt,
      @JsonKey(name: 'joined_at') @NullableTimesConverter() DateTime? joinedAt,
      @JsonKey(name: 'status')
      @MemberStatusEnumConverter()
      MemberStatusEnum status,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt,
      @JsonKey(name: 'username') String? username,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'inviter_username') String? inviterUsername,
      @JsonKey(name: 'inviter_display_name') String? inviterDisplayName});
}

/// @nodoc
class __$$ProjectMemberModelImplCopyWithImpl<$Res>
    extends _$ProjectMemberModelCopyWithImpl<$Res, _$ProjectMemberModelImpl>
    implements _$$ProjectMemberModelImplCopyWith<$Res> {
  __$$ProjectMemberModelImplCopyWithImpl(_$ProjectMemberModelImpl _value,
      $Res Function(_$ProjectMemberModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? userId = null,
    Object? role = null,
    Object? invitedBy = freezed,
    Object? invitedAt = null,
    Object? joinedAt = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? username = freezed,
    Object? displayName = freezed,
    Object? avatarUrl = freezed,
    Object? email = freezed,
    Object? inviterUsername = freezed,
    Object? inviterDisplayName = freezed,
  }) {
    return _then(_$ProjectMemberModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
      invitedBy: freezed == invitedBy
          ? _value.invitedBy
          : invitedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      invitedAt: null == invitedAt
          ? _value.invitedAt
          : invitedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MemberStatusEnum,
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
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      inviterUsername: freezed == inviterUsername
          ? _value.inviterUsername
          : inviterUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      inviterDisplayName: freezed == inviterDisplayName
          ? _value.inviterDisplayName
          : inviterDisplayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectMemberModelImpl implements _ProjectMemberModel {
  const _$ProjectMemberModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'project_id') required this.projectId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() required this.role,
      @JsonKey(name: 'invited_by') this.invitedBy,
      @JsonKey(name: 'invited_at') @TimesConverter() required this.invitedAt,
      @JsonKey(name: 'joined_at') @NullableTimesConverter() this.joinedAt,
      @JsonKey(name: 'status')
      @MemberStatusEnumConverter()
      required this.status,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() required this.updatedAt,
      @JsonKey(name: 'username') this.username,
      @JsonKey(name: 'display_name') this.displayName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'inviter_username') this.inviterUsername,
      @JsonKey(name: 'inviter_display_name') this.inviterDisplayName});

  factory _$ProjectMemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectMemberModelImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int id;
  @override
  @JsonKey(name: 'project_id')
  final int projectId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  final ProjectRoleEnum role;
  @override
  @JsonKey(name: 'invited_by')
  final String? invitedBy;
  @override
  @JsonKey(name: 'invited_at')
  @TimesConverter()
  final DateTime invitedAt;
  @override
  @JsonKey(name: 'joined_at')
  @NullableTimesConverter()
  final DateTime? joinedAt;
  @override
  @JsonKey(name: 'status')
  @MemberStatusEnumConverter()
  final MemberStatusEnum status;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  final DateTime updatedAt;
// 扩展字段（从联表查询）
  @override
  @JsonKey(name: 'username')
  final String? username;
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'email')
  final String? email;
  @override
  @JsonKey(name: 'inviter_username')
  final String? inviterUsername;
  @override
  @JsonKey(name: 'inviter_display_name')
  final String? inviterDisplayName;

  @override
  String toString() {
    return 'ProjectMemberModel(id: $id, projectId: $projectId, userId: $userId, role: $role, invitedBy: $invitedBy, invitedAt: $invitedAt, joinedAt: $joinedAt, status: $status, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, email: $email, inviterUsername: $inviterUsername, inviterDisplayName: $inviterDisplayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectMemberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.invitedBy, invitedBy) ||
                other.invitedBy == invitedBy) &&
            (identical(other.invitedAt, invitedAt) ||
                other.invitedAt == invitedAt) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.inviterUsername, inviterUsername) ||
                other.inviterUsername == inviterUsername) &&
            (identical(other.inviterDisplayName, inviterDisplayName) ||
                other.inviterDisplayName == inviterDisplayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      projectId,
      userId,
      role,
      invitedBy,
      invitedAt,
      joinedAt,
      status,
      isActive,
      createdAt,
      updatedAt,
      username,
      displayName,
      avatarUrl,
      email,
      inviterUsername,
      inviterDisplayName);

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectMemberModelImplCopyWith<_$ProjectMemberModelImpl> get copyWith =>
      __$$ProjectMemberModelImplCopyWithImpl<_$ProjectMemberModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectMemberModelImplToJson(
      this,
    );
  }
}

abstract class _ProjectMemberModel implements ProjectMemberModel {
  const factory _ProjectMemberModel(
      {@JsonKey(name: 'id') required final int id,
      @JsonKey(name: 'project_id') required final int projectId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      required final ProjectRoleEnum role,
      @JsonKey(name: 'invited_by') final String? invitedBy,
      @JsonKey(name: 'invited_at')
      @TimesConverter()
      required final DateTime invitedAt,
      @JsonKey(name: 'joined_at')
      @NullableTimesConverter()
      final DateTime? joinedAt,
      @JsonKey(name: 'status')
      @MemberStatusEnumConverter()
      required final MemberStatusEnum status,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      @TimesConverter()
      required final DateTime updatedAt,
      @JsonKey(name: 'username') final String? username,
      @JsonKey(name: 'display_name') final String? displayName,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'email') final String? email,
      @JsonKey(name: 'inviter_username') final String? inviterUsername,
      @JsonKey(name: 'inviter_display_name')
      final String? inviterDisplayName}) = _$ProjectMemberModelImpl;

  factory _ProjectMemberModel.fromJson(Map<String, dynamic> json) =
      _$ProjectMemberModelImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int get id;
  @override
  @JsonKey(name: 'project_id')
  int get projectId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role;
  @override
  @JsonKey(name: 'invited_by')
  String? get invitedBy;
  @override
  @JsonKey(name: 'invited_at')
  @TimesConverter()
  DateTime get invitedAt;
  @override
  @JsonKey(name: 'joined_at')
  @NullableTimesConverter()
  DateTime? get joinedAt;
  @override
  @JsonKey(name: 'status')
  @MemberStatusEnumConverter()
  MemberStatusEnum get status;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  DateTime get updatedAt; // 扩展字段（从联表查询）
  @override
  @JsonKey(name: 'username')
  String? get username;
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'email')
  String? get email;
  @override
  @JsonKey(name: 'inviter_username')
  String? get inviterUsername;
  @override
  @JsonKey(name: 'inviter_display_name')
  String? get inviterDisplayName;

  /// Create a copy of ProjectMemberModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjectMemberModelImplCopyWith<_$ProjectMemberModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InviteMemberRequest _$InviteMemberRequestFromJson(Map<String, dynamic> json) {
  return _InviteMemberRequest.fromJson(json);
}

/// @nodoc
mixin _$InviteMemberRequest {
  int get projectId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role => throw _privateConstructorUsedError;

  /// Serializes this InviteMemberRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteMemberRequestCopyWith<InviteMemberRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteMemberRequestCopyWith<$Res> {
  factory $InviteMemberRequestCopyWith(
          InviteMemberRequest value, $Res Function(InviteMemberRequest) then) =
      _$InviteMemberRequestCopyWithImpl<$Res, InviteMemberRequest>;
  @useResult
  $Res call(
      {int projectId,
      String userId,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role});
}

/// @nodoc
class _$InviteMemberRequestCopyWithImpl<$Res, $Val extends InviteMemberRequest>
    implements $InviteMemberRequestCopyWith<$Res> {
  _$InviteMemberRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? userId = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InviteMemberRequestImplCopyWith<$Res>
    implements $InviteMemberRequestCopyWith<$Res> {
  factory _$$InviteMemberRequestImplCopyWith(_$InviteMemberRequestImpl value,
          $Res Function(_$InviteMemberRequestImpl) then) =
      __$$InviteMemberRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int projectId,
      String userId,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role});
}

/// @nodoc
class __$$InviteMemberRequestImplCopyWithImpl<$Res>
    extends _$InviteMemberRequestCopyWithImpl<$Res, _$InviteMemberRequestImpl>
    implements _$$InviteMemberRequestImplCopyWith<$Res> {
  __$$InviteMemberRequestImplCopyWithImpl(_$InviteMemberRequestImpl _value,
      $Res Function(_$InviteMemberRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? userId = null,
    Object? role = null,
  }) {
    return _then(_$InviteMemberRequestImpl(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteMemberRequestImpl implements _InviteMemberRequest {
  const _$InviteMemberRequestImpl(
      {required this.projectId,
      required this.userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      this.role = ProjectRoleEnum.member});

  factory _$InviteMemberRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteMemberRequestImplFromJson(json);

  @override
  final int projectId;
  @override
  final String userId;
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  final ProjectRoleEnum role;

  @override
  String toString() {
    return 'InviteMemberRequest(projectId: $projectId, userId: $userId, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteMemberRequestImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, projectId, userId, role);

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteMemberRequestImplCopyWith<_$InviteMemberRequestImpl> get copyWith =>
      __$$InviteMemberRequestImplCopyWithImpl<_$InviteMemberRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteMemberRequestImplToJson(
      this,
    );
  }
}

abstract class _InviteMemberRequest implements InviteMemberRequest {
  const factory _InviteMemberRequest(
      {required final int projectId,
      required final String userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      final ProjectRoleEnum role}) = _$InviteMemberRequestImpl;

  factory _InviteMemberRequest.fromJson(Map<String, dynamic> json) =
      _$InviteMemberRequestImpl.fromJson;

  @override
  int get projectId;
  @override
  String get userId;
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role;

  /// Create a copy of InviteMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteMemberRequestImplCopyWith<_$InviteMemberRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateMemberRoleRequest _$UpdateMemberRoleRequestFromJson(
    Map<String, dynamic> json) {
  return _UpdateMemberRoleRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateMemberRoleRequest {
  int get projectId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role => throw _privateConstructorUsedError;

  /// Serializes this UpdateMemberRoleRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateMemberRoleRequestCopyWith<UpdateMemberRoleRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateMemberRoleRequestCopyWith<$Res> {
  factory $UpdateMemberRoleRequestCopyWith(UpdateMemberRoleRequest value,
          $Res Function(UpdateMemberRoleRequest) then) =
      _$UpdateMemberRoleRequestCopyWithImpl<$Res, UpdateMemberRoleRequest>;
  @useResult
  $Res call(
      {int projectId,
      String userId,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role});
}

/// @nodoc
class _$UpdateMemberRoleRequestCopyWithImpl<$Res,
        $Val extends UpdateMemberRoleRequest>
    implements $UpdateMemberRoleRequestCopyWith<$Res> {
  _$UpdateMemberRoleRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? userId = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateMemberRoleRequestImplCopyWith<$Res>
    implements $UpdateMemberRoleRequestCopyWith<$Res> {
  factory _$$UpdateMemberRoleRequestImplCopyWith(
          _$UpdateMemberRoleRequestImpl value,
          $Res Function(_$UpdateMemberRoleRequestImpl) then) =
      __$$UpdateMemberRoleRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int projectId,
      String userId,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role});
}

/// @nodoc
class __$$UpdateMemberRoleRequestImplCopyWithImpl<$Res>
    extends _$UpdateMemberRoleRequestCopyWithImpl<$Res,
        _$UpdateMemberRoleRequestImpl>
    implements _$$UpdateMemberRoleRequestImplCopyWith<$Res> {
  __$$UpdateMemberRoleRequestImplCopyWithImpl(
      _$UpdateMemberRoleRequestImpl _value,
      $Res Function(_$UpdateMemberRoleRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? projectId = null,
    Object? userId = null,
    Object? role = null,
  }) {
    return _then(_$UpdateMemberRoleRequestImpl(
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateMemberRoleRequestImpl implements _UpdateMemberRoleRequest {
  const _$UpdateMemberRoleRequestImpl(
      {required this.projectId,
      required this.userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      this.role = ProjectRoleEnum.member});

  factory _$UpdateMemberRoleRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateMemberRoleRequestImplFromJson(json);

  @override
  final int projectId;
  @override
  final String userId;
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  final ProjectRoleEnum role;

  @override
  String toString() {
    return 'UpdateMemberRoleRequest(projectId: $projectId, userId: $userId, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateMemberRoleRequestImpl &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, projectId, userId, role);

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateMemberRoleRequestImplCopyWith<_$UpdateMemberRoleRequestImpl>
      get copyWith => __$$UpdateMemberRoleRequestImplCopyWithImpl<
          _$UpdateMemberRoleRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateMemberRoleRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateMemberRoleRequest implements UpdateMemberRoleRequest {
  const factory _UpdateMemberRoleRequest(
      {required final int projectId,
      required final String userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      final ProjectRoleEnum role}) = _$UpdateMemberRoleRequestImpl;

  factory _UpdateMemberRoleRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateMemberRoleRequestImpl.fromJson;

  @override
  int get projectId;
  @override
  String get userId;
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role;

  /// Create a copy of UpdateMemberRoleRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateMemberRoleRequestImplCopyWith<_$UpdateMemberRoleRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
