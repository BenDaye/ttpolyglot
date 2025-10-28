import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

/// 用户位置信息模型
@freezed
class RoleModel with _$RoleModel {
  const factory RoleModel({
    /// 角色ID
    @JsonKey(name: 'role_id') required int roleId,

    /// 角色名称
    @JsonKey(name: 'role_name') required String roleName,

    /// 角色显示名称
    @JsonKey(name: 'role_display_name') required String roleDisplayName,

    /// 是否为系统角色
    @JsonKey(name: 'is_system_role') required bool isSystemRole,

    /// 分配时间
    @JsonKey(name: 'assigned_at') required DateTime assignedAt,

    /// 过期时间
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
}
