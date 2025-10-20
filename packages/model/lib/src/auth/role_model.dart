import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_model.freezed.dart';
part 'role_model.g.dart';

/// 用户位置信息模型
@freezed
class RoleModel with _$RoleModel {
  const factory RoleModel({
    @JsonKey(name: 'role_id') required int roleId,
    @JsonKey(name: 'role_name') required String roleName,
    @JsonKey(name: 'role_display_name') required String roleDisplayName,
    @JsonKey(name: 'is_system_role') required bool isSystemRole,
    @JsonKey(name: 'assigned_at') required DateTime assignedAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _RoleModel;

  factory RoleModel.fromJson(Map<String, dynamic> json) => _$RoleModelFromJson(json);
}
