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
      userId: json['user_id'] as String,
      role: const ProjectRoleEnumConverter().fromJson(json['role'] as String),
      invitedBy: json['invited_by'] as String?,
      invitedAt: const TimesConverter().fromJson(json['invited_at'] as Object),
      joinedAt: const NullableTimesConverter().fromJson(json['joined_at']),
      status:
          const MemberStatusEnumConverter().fromJson(json['status'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: const TimesConverter().fromJson(json['created_at'] as Object),
      updatedAt: const TimesConverter().fromJson(json['updated_at'] as Object),
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
      'user_id': instance.userId,
      'role': const ProjectRoleEnumConverter().toJson(instance.role),
      'invited_by': instance.invitedBy,
      'invited_at': const TimesConverter().toJson(instance.invitedAt),
      'joined_at': const NullableTimesConverter().toJson(instance.joinedAt),
      'status': const MemberStatusEnumConverter().toJson(instance.status),
      'is_active': instance.isActive,
      'created_at': const TimesConverter().toJson(instance.createdAt),
      'updated_at': const TimesConverter().toJson(instance.updatedAt),
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
