import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_member_model.freezed.dart';
part 'project_member_model.g.dart';

/// 项目成员模型
@freezed
class ProjectMemberModel with _$ProjectMemberModel {
  const factory ProjectMemberModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'project_id') required int projectId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'role') required String role,
    @JsonKey(name: 'invited_by') String? invitedBy,
    @JsonKey(name: 'invited_at') required DateTime invitedAt,
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
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
    @Default('member') String role,
  }) = _InviteMemberRequest;

  factory InviteMemberRequest.fromJson(Map<String, dynamic> json) => _$InviteMemberRequestFromJson(json);
}

/// 更新成员角色请求模型
@freezed
class UpdateMemberRoleRequest with _$UpdateMemberRoleRequest {
  const factory UpdateMemberRoleRequest({
    required int projectId,
    required String userId,
    required String role,
  }) = _UpdateMemberRoleRequest;

  factory UpdateMemberRoleRequest.fromJson(Map<String, dynamic> json) => _$UpdateMemberRoleRequestFromJson(json);
}

/// 项目角色枚举
class ProjectRole {
  static const String owner = 'owner';
  static const String admin = 'admin';
  static const String member = 'member';
  static const String viewer = 'viewer';

  static const List<String> all = [owner, admin, member, viewer];

  static bool isValid(String role) => all.contains(role);

  static String getDisplayName(String role) {
    switch (role) {
      case owner:
        return '所有者';
      case admin:
        return '管理员';
      case member:
        return '成员';
      case viewer:
        return '查看者';
      default:
        return role;
    }
  }
}

/// 成员状态枚举
class MemberStatus {
  static const String pending = 'pending';
  static const String active = 'active';
  static const String inactive = 'inactive';

  static const List<String> all = [pending, active, inactive];

  static bool isValid(String status) => all.contains(status);

  static String getDisplayName(String status) {
    switch (status) {
      case pending:
        return '待加入';
      case active:
        return '活跃';
      case inactive:
        return '已停用';
      default:
        return status;
    }
  }
}
