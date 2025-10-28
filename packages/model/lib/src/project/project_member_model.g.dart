// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectMemberModelImpl _$$ProjectMemberModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ProjectMemberModelImpl(
      id: (json['id'] as num).toInt(),
      projectId: (json['project_id'] as num).toInt(),
      role: const ProjectRoleEnumConverter().fromJson(json['role'] as String),
      invitedBy: json['invited_by'] as String?,
      invitedAt: const TimesConverter().fromJson(json['invited_at'] as Object),
      joinedAt: const NullableTimesConverter().fromJson(json['joined_at']),
      status:
          const MemberStatusEnumConverter().fromJson(json['status'] as String),
      isActive: json['is_active'] as bool? ?? true,
      inviteCode: json['invite_code'] as String?,
      expiresAt: const NullableTimesConverter().fromJson(json['expires_at']),
      maxUses: (json['max_uses'] as num?)?.toInt(),
      usedCount: (json['used_count'] as num?)?.toInt() ?? 0,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      updatedAt: const TimesConverter().fromJson(json['updated_at'] as Object),
      userId: json['user_id'] as String?,
      username: json['username'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      email: json['email'] as String?,
      inviterUsername: json['inviter_username'] as String?,
      inviterDisplayName: json['inviter_display_name'] as String?,
    );

Map<String, dynamic> _$$ProjectMemberModelImplToJson(
        _$ProjectMemberModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project_id': instance.projectId,
      'role': const ProjectRoleEnumConverter().toJson(instance.role),
      'invited_by': instance.invitedBy,
      'invited_at': const TimesConverter().toJson(instance.invitedAt),
      'joined_at': const NullableTimesConverter().toJson(instance.joinedAt),
      'status': const MemberStatusEnumConverter().toJson(instance.status),
      'is_active': instance.isActive,
      'invite_code': instance.inviteCode,
      'expires_at': const NullableTimesConverter().toJson(instance.expiresAt),
      'max_uses': instance.maxUses,
      'used_count': instance.usedCount,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'updated_at': const TimesConverter().toJson(instance.updatedAt),
      'user_id': instance.userId,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar_url': instance.avatarUrl,
      'email': instance.email,
      'inviter_username': instance.inviterUsername,
      'inviter_display_name': instance.inviterDisplayName,
    };

_$InviteMemberRequestImpl _$$InviteMemberRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$InviteMemberRequestImpl(
      projectId: (json['project_id'] as num).toInt(),
      userId: json['user_id'] as String,
      role: json['role'] == null
          ? ProjectRoleEnum.member
          : const ProjectRoleEnumConverter().fromJson(json['role'] as String),
    );

Map<String, dynamic> _$$InviteMemberRequestImplToJson(
        _$InviteMemberRequestImpl instance) =>
    <String, dynamic>{
      'project_id': instance.projectId,
      'user_id': instance.userId,
      'role': const ProjectRoleEnumConverter().toJson(instance.role),
    };

_$UpdateMemberRoleRequestImpl _$$UpdateMemberRoleRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateMemberRoleRequestImpl(
      projectId: (json['project_id'] as num).toInt(),
      userId: json['user_id'] as String,
      role: json['role'] == null
          ? ProjectRoleEnum.member
          : const ProjectRoleEnumConverter().fromJson(json['role'] as String),
    );

Map<String, dynamic> _$$UpdateMemberRoleRequestImplToJson(
        _$UpdateMemberRoleRequestImpl instance) =>
    <String, dynamic>{
      'project_id': instance.projectId,
      'user_id': instance.userId,
      'role': const ProjectRoleEnumConverter().toJson(instance.role),
    };

_$GenerateInviteRequestImpl _$$GenerateInviteRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$GenerateInviteRequestImpl(
      role: json['role'] == null
          ? ProjectRoleEnum.member
          : const ProjectRoleEnumConverter().fromJson(json['role'] as String),
      expiresIn: (json['expires_in'] as num?)?.toInt(),
      maxUses: (json['max_uses'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$GenerateInviteRequestImplToJson(
        _$GenerateInviteRequestImpl instance) =>
    <String, dynamic>{
      'role': const ProjectRoleEnumConverter().toJson(instance.role),
      'expires_in': instance.expiresIn,
      'max_uses': instance.maxUses,
    };

_$InviteInfoModelImpl _$$InviteInfoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InviteInfoModelImpl(
      inviteCode: json['invite_code'] as String,
      project:
          InviteProjectInfo.fromJson(json['project'] as Map<String, dynamic>),
      inviter: InviteUserInfo.fromJson(json['inviter'] as Map<String, dynamic>),
      role: const ProjectRoleEnumConverter().fromJson(json['role'] as String),
      expiresAt: const NullableTimesConverter().fromJson(json['expires_at']),
      isExpired: json['is_expired'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? true,
      remainingUses: (json['remaining_uses'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$InviteInfoModelImplToJson(
        _$InviteInfoModelImpl instance) =>
    <String, dynamic>{
      'invite_code': instance.inviteCode,
      'project': instance.project,
      'inviter': instance.inviter,
      'role': const ProjectRoleEnumConverter().toJson(instance.role),
      'expires_at': const NullableTimesConverter().toJson(instance.expiresAt),
      'is_expired': instance.isExpired,
      'is_available': instance.isAvailable,
      'remaining_uses': instance.remainingUses,
    };

_$InviteProjectInfoImpl _$$InviteProjectInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$InviteProjectInfoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      currentMemberCount: (json['current_member_count'] as num?)?.toInt() ?? 0,
      memberLimit: (json['member_limit'] as num?)?.toInt() ?? 10,
    );

Map<String, dynamic> _$$InviteProjectInfoImplToJson(
        _$InviteProjectInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'current_member_count': instance.currentMemberCount,
      'member_limit': instance.memberLimit,
    };

_$InviteUserInfoImpl _$$InviteUserInfoImplFromJson(Map<String, dynamic> json) =>
    _$InviteUserInfoImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
    );

Map<String, dynamic> _$$InviteUserInfoImplToJson(
        _$InviteUserInfoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
    };

_$UserSearchResultModelImpl _$$UserSearchResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSearchResultModelImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$$UserSearchResultModelImplToJson(
        _$UserSearchResultModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'display_name': instance.displayName,
      'email': instance.email,
      'avatar_url': instance.avatarUrl,
    };
