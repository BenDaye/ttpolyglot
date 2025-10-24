import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/model.dart';

part 'project_member_model.freezed.dart';
part 'project_member_model.g.dart';

/// 项目成员模型
@freezed
class ProjectMemberModel with _$ProjectMemberModel {
  const factory ProjectMemberModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'project_id') required int projectId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'role') @ProjectRoleEnumConverter() required ProjectRoleEnum role,
    @JsonKey(name: 'invited_by') String? invitedBy,
    @JsonKey(name: 'invited_at') @TimesConverter() required DateTime invitedAt,
    @JsonKey(name: 'joined_at') @NullableTimesConverter() DateTime? joinedAt,
    @JsonKey(name: 'status') @MemberStatusEnumConverter() required MemberStatusEnum status,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') @TimesConverter() required DateTime createdAt,
    @JsonKey(name: 'updated_at') @TimesConverter() required DateTime updatedAt,
    // 扩展字段（从联表查询）
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'display_name') String? displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'inviter_username') String? inviterUsername,
    @JsonKey(name: 'inviter_display_name') String? inviterDisplayName,
  }) = _ProjectMemberModel;

  factory ProjectMemberModel.fromJson(Map<String, dynamic> json) => _$ProjectMemberModelFromJson(json);
}

/// 邀请成员请求模型
@freezed
class InviteMemberRequest with _$InviteMemberRequest {
  const factory InviteMemberRequest({
    required int projectId,
    required String userId,
    @JsonKey(name: 'role') @ProjectRoleEnumConverter() @Default(ProjectRoleEnum.member) ProjectRoleEnum role,
  }) = _InviteMemberRequest;

  factory InviteMemberRequest.fromJson(Map<String, dynamic> json) => _$InviteMemberRequestFromJson(json);
}

/// 更新成员角色请求模型
@freezed
class UpdateMemberRoleRequest with _$UpdateMemberRoleRequest {
  const factory UpdateMemberRoleRequest({
    required int projectId,
    required String userId,
    @JsonKey(name: 'role') @ProjectRoleEnumConverter() @Default(ProjectRoleEnum.member) ProjectRoleEnum role,
  }) = _UpdateMemberRoleRequest;

  factory UpdateMemberRoleRequest.fromJson(Map<String, dynamic> json) => _$UpdateMemberRoleRequestFromJson(json);
}
