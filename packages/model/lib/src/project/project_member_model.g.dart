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
      role: json['role'] as String,
      invitedBy: json['invited_by'] as String?,
      invitedAt: DateTime.parse(json['invited_at'] as String),
      joinedAt: json['joined_at'] == null
          ? null
          : DateTime.parse(json['joined_at'] as String),
      status: json['status'] as String,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'role': instance.role,
      'invited_by': instance.invitedBy,
      'invited_at': instance.invitedAt.toIso8601String(),
      'joined_at': instance.joinedAt?.toIso8601String(),
      'status': instance.status,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
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
      projectId: (json['projectId'] as num).toInt(),
      userId: json['userId'] as String,
      role: json['role'] as String? ?? 'member',
    );

Map<String, dynamic> _$$InviteMemberRequestImplToJson(
        _$InviteMemberRequestImpl instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'userId': instance.userId,
      'role': instance.role,
    };

_$UpdateMemberRoleRequestImpl _$$UpdateMemberRoleRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateMemberRoleRequestImpl(
      projectId: (json['projectId'] as num).toInt(),
      userId: json['userId'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$$UpdateMemberRoleRequestImplToJson(
        _$UpdateMemberRoleRequestImpl instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'userId': instance.userId,
      'role': instance.role,
    };
