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
  /// 成员ID
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;

  /// 项目ID
  @JsonKey(name: 'project_id')
  int get projectId => throw _privateConstructorUsedError;

  /// 成员角色
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role => throw _privateConstructorUsedError;

  /// 邀请人ID
  @JsonKey(name: 'invited_by')
  String? get invitedBy => throw _privateConstructorUsedError;

  /// 邀请时间
  @JsonKey(name: 'invited_at')
  @TimesConverter()
  DateTime get invitedAt => throw _privateConstructorUsedError;

  /// 加入时间
  @JsonKey(name: 'joined_at')
  @NullableTimesConverter()
  DateTime? get joinedAt => throw _privateConstructorUsedError;

  /// 成员状态
  @JsonKey(name: 'status')
  @MemberStatusEnumConverter()
  MemberStatusEnum get status => throw _privateConstructorUsedError;

  /// 是否为活跃成员
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// 邀请码（仅邀请链接记录有值）
  @JsonKey(name: 'invite_code')
  String? get inviteCode => throw _privateConstructorUsedError;

  /// 过期时间（NULL表示永久有效）
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// 最大使用次数（NULL表示无限次）
  @JsonKey(name: 'max_uses')
  int? get maxUses => throw _privateConstructorUsedError;

  /// 已使用次数
  @JsonKey(name: 'used_count')
  int get usedCount => throw _privateConstructorUsedError;

  /// 创建时间
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// 更新时间
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError; // 扩展字段（从联表查询）
  /// 用户ID（仅成员记录有值）
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'username')
  String? get username => throw _privateConstructorUsedError;

  /// 显示名称
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;

  /// 头像URL
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// 邮箱
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;

  /// 邀请人用户名
  @JsonKey(name: 'inviter_username')
  String? get inviterUsername => throw _privateConstructorUsedError;

  /// 邀请人显示名称
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
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role,
      @JsonKey(name: 'invited_by') String? invitedBy,
      @JsonKey(name: 'invited_at') @TimesConverter() DateTime invitedAt,
      @JsonKey(name: 'joined_at') @NullableTimesConverter() DateTime? joinedAt,
      @JsonKey(name: 'status')
      @MemberStatusEnumConverter()
      MemberStatusEnum status,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'invite_code') String? inviteCode,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      DateTime? expiresAt,
      @JsonKey(name: 'max_uses') int? maxUses,
      @JsonKey(name: 'used_count') int usedCount,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt,
      @JsonKey(name: 'user_id') String? userId,
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
    Object? role = null,
    Object? invitedBy = freezed,
    Object? invitedAt = null,
    Object? joinedAt = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? inviteCode = freezed,
    Object? expiresAt = freezed,
    Object? maxUses = freezed,
    Object? usedCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = freezed,
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
      inviteCode: freezed == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maxUses: freezed == maxUses
          ? _value.maxUses
          : maxUses // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: null == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role,
      @JsonKey(name: 'invited_by') String? invitedBy,
      @JsonKey(name: 'invited_at') @TimesConverter() DateTime invitedAt,
      @JsonKey(name: 'joined_at') @NullableTimesConverter() DateTime? joinedAt,
      @JsonKey(name: 'status')
      @MemberStatusEnumConverter()
      MemberStatusEnum status,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'invite_code') String? inviteCode,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      DateTime? expiresAt,
      @JsonKey(name: 'max_uses') int? maxUses,
      @JsonKey(name: 'used_count') int usedCount,
      @JsonKey(name: 'created_at') @TimesConverter() DateTime createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() DateTime updatedAt,
      @JsonKey(name: 'user_id') String? userId,
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
    Object? role = null,
    Object? invitedBy = freezed,
    Object? invitedAt = null,
    Object? joinedAt = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? inviteCode = freezed,
    Object? expiresAt = freezed,
    Object? maxUses = freezed,
    Object? usedCount = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? userId = freezed,
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
      inviteCode: freezed == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      maxUses: freezed == maxUses
          ? _value.maxUses
          : maxUses // ignore: cast_nullable_to_non_nullable
              as int?,
      usedCount: null == usedCount
          ? _value.usedCount
          : usedCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() required this.role,
      @JsonKey(name: 'invited_by') this.invitedBy,
      @JsonKey(name: 'invited_at') @TimesConverter() required this.invitedAt,
      @JsonKey(name: 'joined_at') @NullableTimesConverter() this.joinedAt,
      @JsonKey(name: 'status')
      @MemberStatusEnumConverter()
      required this.status,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'invite_code') this.inviteCode,
      @JsonKey(name: 'expires_at') @NullableTimesConverter() this.expiresAt,
      @JsonKey(name: 'max_uses') this.maxUses,
      @JsonKey(name: 'used_count') this.usedCount = 0,
      @JsonKey(name: 'created_at') @TimesConverter() required this.createdAt,
      @JsonKey(name: 'updated_at') @TimesConverter() required this.updatedAt,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'username') this.username,
      @JsonKey(name: 'display_name') this.displayName,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'inviter_username') this.inviterUsername,
      @JsonKey(name: 'inviter_display_name') this.inviterDisplayName});

  factory _$ProjectMemberModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectMemberModelImplFromJson(json);

  /// 成员ID
  @override
  @JsonKey(name: 'id')
  final int id;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  final int projectId;

  /// 成员角色
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  final ProjectRoleEnum role;

  /// 邀请人ID
  @override
  @JsonKey(name: 'invited_by')
  final String? invitedBy;

  /// 邀请时间
  @override
  @JsonKey(name: 'invited_at')
  @TimesConverter()
  final DateTime invitedAt;

  /// 加入时间
  @override
  @JsonKey(name: 'joined_at')
  @NullableTimesConverter()
  final DateTime? joinedAt;

  /// 成员状态
  @override
  @JsonKey(name: 'status')
  @MemberStatusEnumConverter()
  final MemberStatusEnum status;

  /// 是否为活跃成员
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// 邀请码（仅邀请链接记录有值）
  @override
  @JsonKey(name: 'invite_code')
  final String? inviteCode;

  /// 过期时间（NULL表示永久有效）
  @override
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  final DateTime? expiresAt;

  /// 最大使用次数（NULL表示无限次）
  @override
  @JsonKey(name: 'max_uses')
  final int? maxUses;

  /// 已使用次数
  @override
  @JsonKey(name: 'used_count')
  final int usedCount;

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
// 扩展字段（从联表查询）
  /// 用户ID（仅成员记录有值）
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'username')
  final String? username;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;

  /// 头像URL
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  final String? email;

  /// 邀请人用户名
  @override
  @JsonKey(name: 'inviter_username')
  final String? inviterUsername;

  /// 邀请人显示名称
  @override
  @JsonKey(name: 'inviter_display_name')
  final String? inviterDisplayName;

  @override
  String toString() {
    return 'ProjectMemberModel(id: $id, projectId: $projectId, role: $role, invitedBy: $invitedBy, invitedAt: $invitedAt, joinedAt: $joinedAt, status: $status, isActive: $isActive, inviteCode: $inviteCode, expiresAt: $expiresAt, maxUses: $maxUses, usedCount: $usedCount, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, username: $username, displayName: $displayName, avatarUrl: $avatarUrl, email: $email, inviterUsername: $inviterUsername, inviterDisplayName: $inviterDisplayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectMemberModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
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
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.maxUses, maxUses) || other.maxUses == maxUses) &&
            (identical(other.usedCount, usedCount) ||
                other.usedCount == usedCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
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
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        projectId,
        role,
        invitedBy,
        invitedAt,
        joinedAt,
        status,
        isActive,
        inviteCode,
        expiresAt,
        maxUses,
        usedCount,
        createdAt,
        updatedAt,
        userId,
        username,
        displayName,
        avatarUrl,
        email,
        inviterUsername,
        inviterDisplayName
      ]);

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
      @JsonKey(name: 'invite_code') final String? inviteCode,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      final DateTime? expiresAt,
      @JsonKey(name: 'max_uses') final int? maxUses,
      @JsonKey(name: 'used_count') final int usedCount,
      @JsonKey(name: 'created_at')
      @TimesConverter()
      required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      @TimesConverter()
      required final DateTime updatedAt,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'username') final String? username,
      @JsonKey(name: 'display_name') final String? displayName,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'email') final String? email,
      @JsonKey(name: 'inviter_username') final String? inviterUsername,
      @JsonKey(name: 'inviter_display_name')
      final String? inviterDisplayName}) = _$ProjectMemberModelImpl;

  factory _ProjectMemberModel.fromJson(Map<String, dynamic> json) =
      _$ProjectMemberModelImpl.fromJson;

  /// 成员ID
  @override
  @JsonKey(name: 'id')
  int get id;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  int get projectId;

  /// 成员角色
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role;

  /// 邀请人ID
  @override
  @JsonKey(name: 'invited_by')
  String? get invitedBy;

  /// 邀请时间
  @override
  @JsonKey(name: 'invited_at')
  @TimesConverter()
  DateTime get invitedAt;

  /// 加入时间
  @override
  @JsonKey(name: 'joined_at')
  @NullableTimesConverter()
  DateTime? get joinedAt;

  /// 成员状态
  @override
  @JsonKey(name: 'status')
  @MemberStatusEnumConverter()
  MemberStatusEnum get status;

  /// 是否为活跃成员
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// 邀请码（仅邀请链接记录有值）
  @override
  @JsonKey(name: 'invite_code')
  String? get inviteCode;

  /// 过期时间（NULL表示永久有效）
  @override
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  DateTime? get expiresAt;

  /// 最大使用次数（NULL表示无限次）
  @override
  @JsonKey(name: 'max_uses')
  int? get maxUses;

  /// 已使用次数
  @override
  @JsonKey(name: 'used_count')
  int get usedCount;

  /// 创建时间
  @override
  @JsonKey(name: 'created_at')
  @TimesConverter()
  DateTime get createdAt;

  /// 更新时间
  @override
  @JsonKey(name: 'updated_at')
  @TimesConverter()
  DateTime get updatedAt; // 扩展字段（从联表查询）
  /// 用户ID（仅成员记录有值）
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'username')
  String? get username;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;

  /// 头像URL
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  String? get email;

  /// 邀请人用户名
  @override
  @JsonKey(name: 'inviter_username')
  String? get inviterUsername;

  /// 邀请人显示名称
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
  /// 项目ID
  @JsonKey(name: 'project_id')
  int get projectId => throw _privateConstructorUsedError;

  /// 用户ID
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// 成员角色
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
      {@JsonKey(name: 'project_id') int projectId,
      @JsonKey(name: 'user_id') String userId,
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
      {@JsonKey(name: 'project_id') int projectId,
      @JsonKey(name: 'user_id') String userId,
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
      {@JsonKey(name: 'project_id') required this.projectId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      this.role = ProjectRoleEnum.member});

  factory _$InviteMemberRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteMemberRequestImplFromJson(json);

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  final int projectId;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// 成员角色
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
      {@JsonKey(name: 'project_id') required final int projectId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      final ProjectRoleEnum role}) = _$InviteMemberRequestImpl;

  factory _InviteMemberRequest.fromJson(Map<String, dynamic> json) =
      _$InviteMemberRequestImpl.fromJson;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  int get projectId;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// 成员角色
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
  /// 项目ID
  @JsonKey(name: 'project_id')
  int get projectId => throw _privateConstructorUsedError;

  /// 用户ID
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  /// 成员角色
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
      {@JsonKey(name: 'project_id') int projectId,
      @JsonKey(name: 'user_id') String userId,
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
      {@JsonKey(name: 'project_id') int projectId,
      @JsonKey(name: 'user_id') String userId,
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
      {@JsonKey(name: 'project_id') required this.projectId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      this.role = ProjectRoleEnum.member});

  factory _$UpdateMemberRoleRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateMemberRoleRequestImplFromJson(json);

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  final int projectId;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  /// 成员角色
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
      {@JsonKey(name: 'project_id') required final int projectId,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      final ProjectRoleEnum role}) = _$UpdateMemberRoleRequestImpl;

  factory _UpdateMemberRoleRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateMemberRoleRequestImpl.fromJson;

  /// 项目ID
  @override
  @JsonKey(name: 'project_id')
  int get projectId;

  /// 用户ID
  @override
  @JsonKey(name: 'user_id')
  String get userId;

  /// 成员角色
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

GenerateInviteRequest _$GenerateInviteRequestFromJson(
    Map<String, dynamic> json) {
  return _GenerateInviteRequest.fromJson(json);
}

/// @nodoc
mixin _$GenerateInviteRequest {
  /// 角色
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role => throw _privateConstructorUsedError;

  /// 有效期（天数）
  @JsonKey(name: 'expires_in')
  int? get expiresIn => throw _privateConstructorUsedError;

  /// 最大使用次数
  @JsonKey(name: 'max_uses')
  int? get maxUses => throw _privateConstructorUsedError;

  /// Serializes this GenerateInviteRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GenerateInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GenerateInviteRequestCopyWith<GenerateInviteRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenerateInviteRequestCopyWith<$Res> {
  factory $GenerateInviteRequestCopyWith(GenerateInviteRequest value,
          $Res Function(GenerateInviteRequest) then) =
      _$GenerateInviteRequestCopyWithImpl<$Res, GenerateInviteRequest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role,
      @JsonKey(name: 'expires_in') int? expiresIn,
      @JsonKey(name: 'max_uses') int? maxUses});
}

/// @nodoc
class _$GenerateInviteRequestCopyWithImpl<$Res,
        $Val extends GenerateInviteRequest>
    implements $GenerateInviteRequestCopyWith<$Res> {
  _$GenerateInviteRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GenerateInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? expiresIn = freezed,
    Object? maxUses = freezed,
  }) {
    return _then(_value.copyWith(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
      expiresIn: freezed == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int?,
      maxUses: freezed == maxUses
          ? _value.maxUses
          : maxUses // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GenerateInviteRequestImplCopyWith<$Res>
    implements $GenerateInviteRequestCopyWith<$Res> {
  factory _$$GenerateInviteRequestImplCopyWith(
          _$GenerateInviteRequestImpl value,
          $Res Function(_$GenerateInviteRequestImpl) then) =
      __$$GenerateInviteRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role,
      @JsonKey(name: 'expires_in') int? expiresIn,
      @JsonKey(name: 'max_uses') int? maxUses});
}

/// @nodoc
class __$$GenerateInviteRequestImplCopyWithImpl<$Res>
    extends _$GenerateInviteRequestCopyWithImpl<$Res,
        _$GenerateInviteRequestImpl>
    implements _$$GenerateInviteRequestImplCopyWith<$Res> {
  __$$GenerateInviteRequestImplCopyWithImpl(_$GenerateInviteRequestImpl _value,
      $Res Function(_$GenerateInviteRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of GenerateInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? expiresIn = freezed,
    Object? maxUses = freezed,
  }) {
    return _then(_$GenerateInviteRequestImpl(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
      expiresIn: freezed == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int?,
      maxUses: freezed == maxUses
          ? _value.maxUses
          : maxUses // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GenerateInviteRequestImpl implements _GenerateInviteRequest {
  const _$GenerateInviteRequestImpl(
      {@JsonKey(name: 'role')
      @ProjectRoleEnumConverter()
      this.role = ProjectRoleEnum.member,
      @JsonKey(name: 'expires_in') this.expiresIn,
      @JsonKey(name: 'max_uses') this.maxUses});

  factory _$GenerateInviteRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenerateInviteRequestImplFromJson(json);

  /// 角色
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  final ProjectRoleEnum role;

  /// 有效期（天数）
  @override
  @JsonKey(name: 'expires_in')
  final int? expiresIn;

  /// 最大使用次数
  @override
  @JsonKey(name: 'max_uses')
  final int? maxUses;

  @override
  String toString() {
    return 'GenerateInviteRequest(role: $role, expiresIn: $expiresIn, maxUses: $maxUses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenerateInviteRequestImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.maxUses, maxUses) || other.maxUses == maxUses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, role, expiresIn, maxUses);

  /// Create a copy of GenerateInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GenerateInviteRequestImplCopyWith<_$GenerateInviteRequestImpl>
      get copyWith => __$$GenerateInviteRequestImplCopyWithImpl<
          _$GenerateInviteRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenerateInviteRequestImplToJson(
      this,
    );
  }
}

abstract class _GenerateInviteRequest implements GenerateInviteRequest {
  const factory _GenerateInviteRequest(
          {@JsonKey(name: 'role')
          @ProjectRoleEnumConverter()
          final ProjectRoleEnum role,
          @JsonKey(name: 'expires_in') final int? expiresIn,
          @JsonKey(name: 'max_uses') final int? maxUses}) =
      _$GenerateInviteRequestImpl;

  factory _GenerateInviteRequest.fromJson(Map<String, dynamic> json) =
      _$GenerateInviteRequestImpl.fromJson;

  /// 角色
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role;

  /// 有效期（天数）
  @override
  @JsonKey(name: 'expires_in')
  int? get expiresIn;

  /// 最大使用次数
  @override
  @JsonKey(name: 'max_uses')
  int? get maxUses;

  /// Create a copy of GenerateInviteRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GenerateInviteRequestImplCopyWith<_$GenerateInviteRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

InviteInfoModel _$InviteInfoModelFromJson(Map<String, dynamic> json) {
  return _InviteInfoModel.fromJson(json);
}

/// @nodoc
mixin _$InviteInfoModel {
  /// 邀请码
  @JsonKey(name: 'invite_code')
  String get inviteCode => throw _privateConstructorUsedError;

  /// 项目信息
  @JsonKey(name: 'project')
  InviteProjectInfo get project => throw _privateConstructorUsedError;

  /// 邀请人信息
  @JsonKey(name: 'inviter')
  InviteUserInfo get inviter => throw _privateConstructorUsedError;

  /// 角色
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role => throw _privateConstructorUsedError;

  /// 过期时间
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// 是否过期
  @JsonKey(name: 'is_expired')
  bool get isExpired => throw _privateConstructorUsedError;

  /// 是否可用
  @JsonKey(name: 'is_available')
  bool get isAvailable => throw _privateConstructorUsedError;

  /// 剩余使用次数
  @JsonKey(name: 'remaining_uses')
  int? get remainingUses => throw _privateConstructorUsedError;

  /// Serializes this InviteInfoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteInfoModelCopyWith<InviteInfoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteInfoModelCopyWith<$Res> {
  factory $InviteInfoModelCopyWith(
          InviteInfoModel value, $Res Function(InviteInfoModel) then) =
      _$InviteInfoModelCopyWithImpl<$Res, InviteInfoModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'invite_code') String inviteCode,
      @JsonKey(name: 'project') InviteProjectInfo project,
      @JsonKey(name: 'inviter') InviteUserInfo inviter,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      DateTime? expiresAt,
      @JsonKey(name: 'is_expired') bool isExpired,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'remaining_uses') int? remainingUses});

  $InviteProjectInfoCopyWith<$Res> get project;
  $InviteUserInfoCopyWith<$Res> get inviter;
}

/// @nodoc
class _$InviteInfoModelCopyWithImpl<$Res, $Val extends InviteInfoModel>
    implements $InviteInfoModelCopyWith<$Res> {
  _$InviteInfoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inviteCode = null,
    Object? project = null,
    Object? inviter = null,
    Object? role = null,
    Object? expiresAt = freezed,
    Object? isExpired = null,
    Object? isAvailable = null,
    Object? remainingUses = freezed,
  }) {
    return _then(_value.copyWith(
      inviteCode: null == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      project: null == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as InviteProjectInfo,
      inviter: null == inviter
          ? _value.inviter
          : inviter // ignore: cast_nullable_to_non_nullable
              as InviteUserInfo,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      remainingUses: freezed == remainingUses
          ? _value.remainingUses
          : remainingUses // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of InviteInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InviteProjectInfoCopyWith<$Res> get project {
    return $InviteProjectInfoCopyWith<$Res>(_value.project, (value) {
      return _then(_value.copyWith(project: value) as $Val);
    });
  }

  /// Create a copy of InviteInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $InviteUserInfoCopyWith<$Res> get inviter {
    return $InviteUserInfoCopyWith<$Res>(_value.inviter, (value) {
      return _then(_value.copyWith(inviter: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$InviteInfoModelImplCopyWith<$Res>
    implements $InviteInfoModelCopyWith<$Res> {
  factory _$$InviteInfoModelImplCopyWith(_$InviteInfoModelImpl value,
          $Res Function(_$InviteInfoModelImpl) then) =
      __$$InviteInfoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'invite_code') String inviteCode,
      @JsonKey(name: 'project') InviteProjectInfo project,
      @JsonKey(name: 'inviter') InviteUserInfo inviter,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() ProjectRoleEnum role,
      @JsonKey(name: 'expires_at')
      @NullableTimesConverter()
      DateTime? expiresAt,
      @JsonKey(name: 'is_expired') bool isExpired,
      @JsonKey(name: 'is_available') bool isAvailable,
      @JsonKey(name: 'remaining_uses') int? remainingUses});

  @override
  $InviteProjectInfoCopyWith<$Res> get project;
  @override
  $InviteUserInfoCopyWith<$Res> get inviter;
}

/// @nodoc
class __$$InviteInfoModelImplCopyWithImpl<$Res>
    extends _$InviteInfoModelCopyWithImpl<$Res, _$InviteInfoModelImpl>
    implements _$$InviteInfoModelImplCopyWith<$Res> {
  __$$InviteInfoModelImplCopyWithImpl(
      _$InviteInfoModelImpl _value, $Res Function(_$InviteInfoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InviteInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inviteCode = null,
    Object? project = null,
    Object? inviter = null,
    Object? role = null,
    Object? expiresAt = freezed,
    Object? isExpired = null,
    Object? isAvailable = null,
    Object? remainingUses = freezed,
  }) {
    return _then(_$InviteInfoModelImpl(
      inviteCode: null == inviteCode
          ? _value.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      project: null == project
          ? _value.project
          : project // ignore: cast_nullable_to_non_nullable
              as InviteProjectInfo,
      inviter: null == inviter
          ? _value.inviter
          : inviter // ignore: cast_nullable_to_non_nullable
              as InviteUserInfo,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as ProjectRoleEnum,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      remainingUses: freezed == remainingUses
          ? _value.remainingUses
          : remainingUses // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteInfoModelImpl implements _InviteInfoModel {
  const _$InviteInfoModelImpl(
      {@JsonKey(name: 'invite_code') required this.inviteCode,
      @JsonKey(name: 'project') required this.project,
      @JsonKey(name: 'inviter') required this.inviter,
      @JsonKey(name: 'role') @ProjectRoleEnumConverter() required this.role,
      @JsonKey(name: 'expires_at') @NullableTimesConverter() this.expiresAt,
      @JsonKey(name: 'is_expired') this.isExpired = false,
      @JsonKey(name: 'is_available') this.isAvailable = true,
      @JsonKey(name: 'remaining_uses') this.remainingUses});

  factory _$InviteInfoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteInfoModelImplFromJson(json);

  /// 邀请码
  @override
  @JsonKey(name: 'invite_code')
  final String inviteCode;

  /// 项目信息
  @override
  @JsonKey(name: 'project')
  final InviteProjectInfo project;

  /// 邀请人信息
  @override
  @JsonKey(name: 'inviter')
  final InviteUserInfo inviter;

  /// 角色
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  final ProjectRoleEnum role;

  /// 过期时间
  @override
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  final DateTime? expiresAt;

  /// 是否过期
  @override
  @JsonKey(name: 'is_expired')
  final bool isExpired;

  /// 是否可用
  @override
  @JsonKey(name: 'is_available')
  final bool isAvailable;

  /// 剩余使用次数
  @override
  @JsonKey(name: 'remaining_uses')
  final int? remainingUses;

  @override
  String toString() {
    return 'InviteInfoModel(inviteCode: $inviteCode, project: $project, inviter: $inviter, role: $role, expiresAt: $expiresAt, isExpired: $isExpired, isAvailable: $isAvailable, remainingUses: $remainingUses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteInfoModelImpl &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.project, project) || other.project == project) &&
            (identical(other.inviter, inviter) || other.inviter == inviter) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.remainingUses, remainingUses) ||
                other.remainingUses == remainingUses));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, inviteCode, project, inviter,
      role, expiresAt, isExpired, isAvailable, remainingUses);

  /// Create a copy of InviteInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteInfoModelImplCopyWith<_$InviteInfoModelImpl> get copyWith =>
      __$$InviteInfoModelImplCopyWithImpl<_$InviteInfoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteInfoModelImplToJson(
      this,
    );
  }
}

abstract class _InviteInfoModel implements InviteInfoModel {
  const factory _InviteInfoModel(
          {@JsonKey(name: 'invite_code') required final String inviteCode,
          @JsonKey(name: 'project') required final InviteProjectInfo project,
          @JsonKey(name: 'inviter') required final InviteUserInfo inviter,
          @JsonKey(name: 'role')
          @ProjectRoleEnumConverter()
          required final ProjectRoleEnum role,
          @JsonKey(name: 'expires_at')
          @NullableTimesConverter()
          final DateTime? expiresAt,
          @JsonKey(name: 'is_expired') final bool isExpired,
          @JsonKey(name: 'is_available') final bool isAvailable,
          @JsonKey(name: 'remaining_uses') final int? remainingUses}) =
      _$InviteInfoModelImpl;

  factory _InviteInfoModel.fromJson(Map<String, dynamic> json) =
      _$InviteInfoModelImpl.fromJson;

  /// 邀请码
  @override
  @JsonKey(name: 'invite_code')
  String get inviteCode;

  /// 项目信息
  @override
  @JsonKey(name: 'project')
  InviteProjectInfo get project;

  /// 邀请人信息
  @override
  @JsonKey(name: 'inviter')
  InviteUserInfo get inviter;

  /// 角色
  @override
  @JsonKey(name: 'role')
  @ProjectRoleEnumConverter()
  ProjectRoleEnum get role;

  /// 过期时间
  @override
  @JsonKey(name: 'expires_at')
  @NullableTimesConverter()
  DateTime? get expiresAt;

  /// 是否过期
  @override
  @JsonKey(name: 'is_expired')
  bool get isExpired;

  /// 是否可用
  @override
  @JsonKey(name: 'is_available')
  bool get isAvailable;

  /// 剩余使用次数
  @override
  @JsonKey(name: 'remaining_uses')
  int? get remainingUses;

  /// Create a copy of InviteInfoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteInfoModelImplCopyWith<_$InviteInfoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InviteProjectInfo _$InviteProjectInfoFromJson(Map<String, dynamic> json) {
  return _InviteProjectInfo.fromJson(json);
}

/// @nodoc
mixin _$InviteProjectInfo {
  /// 项目ID
  @JsonKey(name: 'id')
  int get id => throw _privateConstructorUsedError;

  /// 项目名称
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// 项目描述
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// 当前成员数
  @JsonKey(name: 'current_member_count')
  int get currentMemberCount => throw _privateConstructorUsedError;

  /// 成员上限
  @JsonKey(name: 'member_limit')
  int get memberLimit => throw _privateConstructorUsedError;

  /// Serializes this InviteProjectInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteProjectInfoCopyWith<InviteProjectInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteProjectInfoCopyWith<$Res> {
  factory $InviteProjectInfoCopyWith(
          InviteProjectInfo value, $Res Function(InviteProjectInfo) then) =
      _$InviteProjectInfoCopyWithImpl<$Res, InviteProjectInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'current_member_count') int currentMemberCount,
      @JsonKey(name: 'member_limit') int memberLimit});
}

/// @nodoc
class _$InviteProjectInfoCopyWithImpl<$Res, $Val extends InviteProjectInfo>
    implements $InviteProjectInfoCopyWith<$Res> {
  _$InviteProjectInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? currentMemberCount = null,
    Object? memberLimit = null,
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
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      currentMemberCount: null == currentMemberCount
          ? _value.currentMemberCount
          : currentMemberCount // ignore: cast_nullable_to_non_nullable
              as int,
      memberLimit: null == memberLimit
          ? _value.memberLimit
          : memberLimit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InviteProjectInfoImplCopyWith<$Res>
    implements $InviteProjectInfoCopyWith<$Res> {
  factory _$$InviteProjectInfoImplCopyWith(_$InviteProjectInfoImpl value,
          $Res Function(_$InviteProjectInfoImpl) then) =
      __$$InviteProjectInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'current_member_count') int currentMemberCount,
      @JsonKey(name: 'member_limit') int memberLimit});
}

/// @nodoc
class __$$InviteProjectInfoImplCopyWithImpl<$Res>
    extends _$InviteProjectInfoCopyWithImpl<$Res, _$InviteProjectInfoImpl>
    implements _$$InviteProjectInfoImplCopyWith<$Res> {
  __$$InviteProjectInfoImplCopyWithImpl(_$InviteProjectInfoImpl _value,
      $Res Function(_$InviteProjectInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of InviteProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? currentMemberCount = null,
    Object? memberLimit = null,
  }) {
    return _then(_$InviteProjectInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      currentMemberCount: null == currentMemberCount
          ? _value.currentMemberCount
          : currentMemberCount // ignore: cast_nullable_to_non_nullable
              as int,
      memberLimit: null == memberLimit
          ? _value.memberLimit
          : memberLimit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteProjectInfoImpl implements _InviteProjectInfo {
  const _$InviteProjectInfoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'current_member_count') this.currentMemberCount = 0,
      @JsonKey(name: 'member_limit') this.memberLimit = 10});

  factory _$InviteProjectInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteProjectInfoImplFromJson(json);

  /// 项目ID
  @override
  @JsonKey(name: 'id')
  final int id;

  /// 项目名称
  @override
  @JsonKey(name: 'name')
  final String name;

  /// 项目描述
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// 当前成员数
  @override
  @JsonKey(name: 'current_member_count')
  final int currentMemberCount;

  /// 成员上限
  @override
  @JsonKey(name: 'member_limit')
  final int memberLimit;

  @override
  String toString() {
    return 'InviteProjectInfo(id: $id, name: $name, description: $description, currentMemberCount: $currentMemberCount, memberLimit: $memberLimit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteProjectInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.currentMemberCount, currentMemberCount) ||
                other.currentMemberCount == currentMemberCount) &&
            (identical(other.memberLimit, memberLimit) ||
                other.memberLimit == memberLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, description, currentMemberCount, memberLimit);

  /// Create a copy of InviteProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteProjectInfoImplCopyWith<_$InviteProjectInfoImpl> get copyWith =>
      __$$InviteProjectInfoImplCopyWithImpl<_$InviteProjectInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteProjectInfoImplToJson(
      this,
    );
  }
}

abstract class _InviteProjectInfo implements InviteProjectInfo {
  const factory _InviteProjectInfo(
          {@JsonKey(name: 'id') required final int id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'current_member_count') final int currentMemberCount,
          @JsonKey(name: 'member_limit') final int memberLimit}) =
      _$InviteProjectInfoImpl;

  factory _InviteProjectInfo.fromJson(Map<String, dynamic> json) =
      _$InviteProjectInfoImpl.fromJson;

  /// 项目ID
  @override
  @JsonKey(name: 'id')
  int get id;

  /// 项目名称
  @override
  @JsonKey(name: 'name')
  String get name;

  /// 项目描述
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// 当前成员数
  @override
  @JsonKey(name: 'current_member_count')
  int get currentMemberCount;

  /// 成员上限
  @override
  @JsonKey(name: 'member_limit')
  int get memberLimit;

  /// Create a copy of InviteProjectInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteProjectInfoImplCopyWith<_$InviteProjectInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InviteUserInfo _$InviteUserInfoFromJson(Map<String, dynamic> json) {
  return _InviteUserInfo.fromJson(json);
}

/// @nodoc
mixin _$InviteUserInfo {
  /// 用户ID
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// 用户名
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;

  /// 显示名称
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;

  /// Serializes this InviteUserInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InviteUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InviteUserInfoCopyWith<InviteUserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InviteUserInfoCopyWith<$Res> {
  factory $InviteUserInfoCopyWith(
          InviteUserInfo value, $Res Function(InviteUserInfo) then) =
      _$InviteUserInfoCopyWithImpl<$Res, InviteUserInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'display_name') String? displayName});
}

/// @nodoc
class _$InviteUserInfoCopyWithImpl<$Res, $Val extends InviteUserInfo>
    implements $InviteUserInfoCopyWith<$Res> {
  _$InviteUserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InviteUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InviteUserInfoImplCopyWith<$Res>
    implements $InviteUserInfoCopyWith<$Res> {
  factory _$$InviteUserInfoImplCopyWith(_$InviteUserInfoImpl value,
          $Res Function(_$InviteUserInfoImpl) then) =
      __$$InviteUserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'display_name') String? displayName});
}

/// @nodoc
class __$$InviteUserInfoImplCopyWithImpl<$Res>
    extends _$InviteUserInfoCopyWithImpl<$Res, _$InviteUserInfoImpl>
    implements _$$InviteUserInfoImplCopyWith<$Res> {
  __$$InviteUserInfoImplCopyWithImpl(
      _$InviteUserInfoImpl _value, $Res Function(_$InviteUserInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of InviteUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
  }) {
    return _then(_$InviteUserInfoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InviteUserInfoImpl implements _InviteUserInfo {
  const _$InviteUserInfoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'display_name') this.displayName});

  factory _$InviteUserInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$InviteUserInfoImplFromJson(json);

  /// 用户ID
  @override
  @JsonKey(name: 'id')
  final String id;

  /// 用户名
  @override
  @JsonKey(name: 'username')
  final String username;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;

  @override
  String toString() {
    return 'InviteUserInfo(id: $id, username: $username, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InviteUserInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, displayName);

  /// Create a copy of InviteUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InviteUserInfoImplCopyWith<_$InviteUserInfoImpl> get copyWith =>
      __$$InviteUserInfoImplCopyWithImpl<_$InviteUserInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InviteUserInfoImplToJson(
      this,
    );
  }
}

abstract class _InviteUserInfo implements InviteUserInfo {
  const factory _InviteUserInfo(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'username') required final String username,
          @JsonKey(name: 'display_name') final String? displayName}) =
      _$InviteUserInfoImpl;

  factory _InviteUserInfo.fromJson(Map<String, dynamic> json) =
      _$InviteUserInfoImpl.fromJson;

  /// 用户ID
  @override
  @JsonKey(name: 'id')
  String get id;

  /// 用户名
  @override
  @JsonKey(name: 'username')
  String get username;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;

  /// Create a copy of InviteUserInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InviteUserInfoImplCopyWith<_$InviteUserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserSearchResultModel _$UserSearchResultModelFromJson(
    Map<String, dynamic> json) {
  return _UserSearchResultModel.fromJson(json);
}

/// @nodoc
mixin _$UserSearchResultModel {
  /// 用户ID
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// 用户名
  @JsonKey(name: 'username')
  String get username => throw _privateConstructorUsedError;

  /// 显示名称
  @JsonKey(name: 'display_name')
  String? get displayName => throw _privateConstructorUsedError;

  /// 邮箱
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;

  /// 头像URL
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;

  /// Serializes this UserSearchResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSearchResultModelCopyWith<UserSearchResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSearchResultModelCopyWith<$Res> {
  factory $UserSearchResultModelCopyWith(UserSearchResultModel value,
          $Res Function(UserSearchResultModel) then) =
      _$UserSearchResultModelCopyWithImpl<$Res, UserSearchResultModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class _$UserSearchResultModelCopyWithImpl<$Res,
        $Val extends UserSearchResultModel>
    implements $UserSearchResultModelCopyWith<$Res> {
  _$UserSearchResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? email = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSearchResultModelImplCopyWith<$Res>
    implements $UserSearchResultModelCopyWith<$Res> {
  factory _$$UserSearchResultModelImplCopyWith(
          _$UserSearchResultModelImpl value,
          $Res Function(_$UserSearchResultModelImpl) then) =
      __$$UserSearchResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'username') String username,
      @JsonKey(name: 'display_name') String? displayName,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class __$$UserSearchResultModelImplCopyWithImpl<$Res>
    extends _$UserSearchResultModelCopyWithImpl<$Res,
        _$UserSearchResultModelImpl>
    implements _$$UserSearchResultModelImplCopyWith<$Res> {
  __$$UserSearchResultModelImplCopyWithImpl(_$UserSearchResultModelImpl _value,
      $Res Function(_$UserSearchResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? displayName = freezed,
    Object? email = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$UserSearchResultModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSearchResultModelImpl implements _UserSearchResultModel {
  const _$UserSearchResultModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'username') required this.username,
      @JsonKey(name: 'display_name') this.displayName,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'avatar_url') this.avatarUrl});

  factory _$UserSearchResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSearchResultModelImplFromJson(json);

  /// 用户ID
  @override
  @JsonKey(name: 'id')
  final String id;

  /// 用户名
  @override
  @JsonKey(name: 'username')
  final String username;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  final String? displayName;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  final String? email;

  /// 头像URL
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @override
  String toString() {
    return 'UserSearchResultModel(id: $id, username: $username, displayName: $displayName, email: $email, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSearchResultModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, username, displayName, email, avatarUrl);

  /// Create a copy of UserSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSearchResultModelImplCopyWith<_$UserSearchResultModelImpl>
      get copyWith => __$$UserSearchResultModelImplCopyWithImpl<
          _$UserSearchResultModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSearchResultModelImplToJson(
      this,
    );
  }
}

abstract class _UserSearchResultModel implements UserSearchResultModel {
  const factory _UserSearchResultModel(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'username') required final String username,
          @JsonKey(name: 'display_name') final String? displayName,
          @JsonKey(name: 'email') final String? email,
          @JsonKey(name: 'avatar_url') final String? avatarUrl}) =
      _$UserSearchResultModelImpl;

  factory _UserSearchResultModel.fromJson(Map<String, dynamic> json) =
      _$UserSearchResultModelImpl.fromJson;

  /// 用户ID
  @override
  @JsonKey(name: 'id')
  String get id;

  /// 用户名
  @override
  @JsonKey(name: 'username')
  String get username;

  /// 显示名称
  @override
  @JsonKey(name: 'display_name')
  String? get displayName;

  /// 邮箱
  @override
  @JsonKey(name: 'email')
  String? get email;

  /// 头像URL
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;

  /// Create a copy of UserSearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSearchResultModelImplCopyWith<_$UserSearchResultModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
