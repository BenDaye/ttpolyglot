import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'project_member_model.freezed.dart';
part 'project_member_model.g.dart';

/// 项目成员模型
@freezed
class ProjectMemberModel with _$ProjectMemberModel {
  const factory ProjectMemberModel({
    /// 成员ID
    @JsonKey(name: 'id') required int id,

    /// 项目ID
    @JsonKey(name: 'project_id') required int projectId,

    /// 成员角色
    @JsonKey(name: 'role') @ProjectRoleEnumConverter() required ProjectRoleEnum role,

    /// 邀请人ID
    @JsonKey(name: 'invited_by') String? invitedBy,

    /// 邀请时间
    @JsonKey(name: 'invited_at') @TimesConverter() required DateTime invitedAt,

    /// 加入时间
    @JsonKey(name: 'joined_at') @NullableTimesConverter() DateTime? joinedAt,

    /// 成员状态
    @JsonKey(name: 'status') @MemberStatusEnumConverter() required MemberStatusEnum status,

    /// 是否为活跃成员
    @JsonKey(name: 'is_active') @Default(true) bool isActive,

    /// 邀请码（仅邀请链接记录有值）
    @JsonKey(name: 'invite_code') String? inviteCode,

    /// 过期时间（NULL表示永久有效）
    @JsonKey(name: 'expires_at') @NullableTimesConverter() DateTime? expiresAt,

    /// 最大使用次数（NULL表示无限次）
    @JsonKey(name: 'max_uses') int? maxUses,

    /// 已使用次数
    @JsonKey(name: 'used_count') @Default(0) int usedCount,

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,

    // 扩展字段（从联表查询）
    /// 用户ID（仅成员记录有值）
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'username') String? username,

    /// 显示名称
    @JsonKey(name: 'display_name') String? displayName,

    /// 头像URL
    @JsonKey(name: 'avatar_url') String? avatarUrl,

    /// 邮箱
    @JsonKey(name: 'email') String? email,

    /// 邀请人用户名
    @JsonKey(name: 'inviter_username') String? inviterUsername,

    /// 邀请人显示名称
    @JsonKey(name: 'inviter_display_name') String? inviterDisplayName,
  }) = _ProjectMemberModel;

  factory ProjectMemberModel.fromJson(Map<String, dynamic> json) => _$ProjectMemberModelFromJson(json);
}

/// 邀请成员请求模型
@freezed
class InviteMemberRequest with _$InviteMemberRequest {
  const factory InviteMemberRequest({
    /// 项目ID
    @JsonKey(name: 'project_id') required int projectId,

    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 成员角色
    @JsonKey(name: 'role') @ProjectRoleEnumConverter() @Default(ProjectRoleEnum.member) ProjectRoleEnum role,
  }) = _InviteMemberRequest;

  factory InviteMemberRequest.fromJson(Map<String, dynamic> json) => _$InviteMemberRequestFromJson(json);
}

/// 更新成员角色请求模型
@freezed
class UpdateMemberRoleRequest with _$UpdateMemberRoleRequest {
  const factory UpdateMemberRoleRequest({
    /// 项目ID
    @JsonKey(name: 'project_id') required int projectId,

    /// 用户ID
    @JsonKey(name: 'user_id') required String userId,

    /// 成员角色
    @JsonKey(name: 'role') @ProjectRoleEnumConverter() @Default(ProjectRoleEnum.member) ProjectRoleEnum role,
  }) = _UpdateMemberRoleRequest;

  factory UpdateMemberRoleRequest.fromJson(Map<String, dynamic> json) => _$UpdateMemberRoleRequestFromJson(json);
}

/// 生成邀请链接请求模型
@freezed
class GenerateInviteRequest with _$GenerateInviteRequest {
  const factory GenerateInviteRequest({
    /// 角色
    @JsonKey(name: 'role') @ProjectRoleEnumConverter() @Default(ProjectRoleEnum.member) ProjectRoleEnum role,

    /// 有效期（天数）
    @JsonKey(name: 'expires_in') int? expiresIn,

    /// 最大使用次数
    @JsonKey(name: 'max_uses') int? maxUses,
  }) = _GenerateInviteRequest;

  factory GenerateInviteRequest.fromJson(Map<String, dynamic> json) => _$GenerateInviteRequestFromJson(json);
}

/// 邀请信息模型（用于显示邀请详情）
@freezed
class InviteInfoModel with _$InviteInfoModel {
  const factory InviteInfoModel({
    /// 邀请码
    @JsonKey(name: 'invite_code') required String inviteCode,

    /// 项目信息
    @JsonKey(name: 'project') required InviteProjectInfo project,

    /// 邀请人信息
    @JsonKey(name: 'inviter') required InviteUserInfo inviter,

    /// 角色
    @JsonKey(name: 'role') @ProjectRoleEnumConverter() required ProjectRoleEnum role,

    /// 过期时间
    @JsonKey(name: 'expires_at') @NullableTimesConverter() DateTime? expiresAt,

    /// 是否过期
    @JsonKey(name: 'is_expired') @Default(false) bool isExpired,

    /// 是否可用
    @JsonKey(name: 'is_available') @Default(true) bool isAvailable,

    /// 剩余使用次数
    @JsonKey(name: 'remaining_uses') int? remainingUses,
  }) = _InviteInfoModel;

  factory InviteInfoModel.fromJson(Map<String, dynamic> json) => _$InviteInfoModelFromJson(json);
}

/// 邀请中的项目信息
@freezed
class InviteProjectInfo with _$InviteProjectInfo {
  const factory InviteProjectInfo({
    /// 项目ID
    @JsonKey(name: 'id') required int id,

    /// 项目名称
    @JsonKey(name: 'name') required String name,

    /// 项目描述
    @JsonKey(name: 'description') String? description,

    /// 当前成员数
    @JsonKey(name: 'current_member_count') @Default(0) int currentMemberCount,

    /// 成员上限
    @JsonKey(name: 'member_limit') @Default(10) int memberLimit,
  }) = _InviteProjectInfo;

  factory InviteProjectInfo.fromJson(Map<String, dynamic> json) => _$InviteProjectInfoFromJson(json);
}

/// 邀请中的用户信息
@freezed
class InviteUserInfo with _$InviteUserInfo {
  const factory InviteUserInfo({
    /// 用户ID
    @JsonKey(name: 'id') required String id,

    /// 用户名
    @JsonKey(name: 'username') required String username,

    /// 显示名称
    @JsonKey(name: 'display_name') String? displayName,
  }) = _InviteUserInfo;

  factory InviteUserInfo.fromJson(Map<String, dynamic> json) => _$InviteUserInfoFromJson(json);
}

/// 用户搜索结果模型
@freezed
class UserSearchResultModel with _$UserSearchResultModel {
  const factory UserSearchResultModel({
    /// 用户ID
    @JsonKey(name: 'id') required String id,

    /// 用户名
    @JsonKey(name: 'username') required String username,

    /// 显示名称
    @JsonKey(name: 'display_name') String? displayName,

    /// 邮箱
    @JsonKey(name: 'email') String? email,

    /// 头像URL
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserSearchResultModel;

  factory UserSearchResultModel.fromJson(Map<String, dynamic> json) => _$UserSearchResultModelFromJson(json);
}
