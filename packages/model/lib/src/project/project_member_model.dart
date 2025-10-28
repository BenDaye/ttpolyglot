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

    /// 创建时间
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,

    /// 更新时间
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,

    // 扩展字段（从联表查询）
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
