import 'package:json_annotation/json_annotation.dart';

part 'project_members.g.dart';

/// 项目成员模型
@JsonSerializable()
class ProjectMember {
  final String id;
  final String projectId;
  final String userId;
  final String roleId;
  final String status; // 'active', 'inactive', 'pending', 'suspended'
  final String invitedBy;
  final String? invitedByEmail;
  final DateTime? expiresAt;
  final DateTime invitedAt;
  final DateTime? joinedAt;
  final DateTime? lastActivityAt;
  final Map<String, dynamic>? permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProjectMember({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.roleId,
    this.status = 'pending',
    required this.invitedBy,
    this.invitedByEmail,
    this.expiresAt,
    required this.invitedAt,
    this.joinedAt,
    this.lastActivityAt,
    this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProjectMember.fromJson(Map<String, dynamic> json) => _$ProjectMemberFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectMemberToJson(this);

  factory ProjectMember.fromMap(Map<String, dynamic> map) {
    return ProjectMember(
      id: map['id'] as String,
      projectId: map['project_id'] as String,
      userId: map['user_id'] as String,
      roleId: map['role_id'] as String,
      status: map['status'] as String,
      invitedBy: map['invited_by'] as String,
      invitedByEmail: map['invited_by_email'] as String?,
      expiresAt: map['expires_at'] as DateTime?,
      invitedAt: map['invited_at'] as DateTime,
      joinedAt: map['joined_at'] as DateTime?,
      lastActivityAt: map['last_activity_at'] as DateTime?,
      permissions: map['permissions'] as Map<String, dynamic>?,
      createdAt: map['created_at'] as DateTime,
      updatedAt: map['updated_at'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project_id': projectId,
      'user_id': userId,
      'role_id': roleId,
      'status': status,
      'invited_by': invitedBy,
      'invited_by_email': invitedByEmail,
      'expires_at': expiresAt,
      'invited_at': invitedAt,
      'joined_at': joinedAt,
      'last_activity_at': lastActivityAt,
      'permissions': permissions,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// 接受邀请
  ProjectMember acceptInvitation() {
    return ProjectMember(
      id: id,
      projectId: projectId,
      userId: userId,
      roleId: roleId,
      status: 'active',
      invitedBy: invitedBy,
      invitedByEmail: invitedByEmail,
      expiresAt: expiresAt,
      invitedAt: invitedAt,
      joinedAt: DateTime.now(),
      lastActivityAt: DateTime.now(),
      permissions: permissions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// 拒绝邀请
  ProjectMember rejectInvitation() {
    return ProjectMember(
      id: id,
      projectId: projectId,
      userId: userId,
      roleId: roleId,
      status: 'rejected',
      invitedBy: invitedBy,
      invitedByEmail: invitedByEmail,
      expiresAt: expiresAt,
      invitedAt: invitedAt,
      joinedAt: joinedAt,
      lastActivityAt: lastActivityAt,
      permissions: permissions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// 更新最后活动时间
  ProjectMember updateLastActivity() {
    return ProjectMember(
      id: id,
      projectId: projectId,
      userId: userId,
      roleId: roleId,
      status: status,
      invitedBy: invitedBy,
      invitedByEmail: invitedByEmail,
      expiresAt: expiresAt,
      invitedAt: invitedAt,
      joinedAt: joinedAt,
      lastActivityAt: DateTime.now(),
      permissions: permissions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// 检查是否过期
  bool get isExpired {
    return expiresAt != null && DateTime.now().isAfter(expiresAt!);
  }

  /// 检查是否活跃
  bool get isActive => status == 'active';

  /// 检查是否待处理
  bool get isPending => status == 'pending';

  /// 检查是否被暂停
  bool get isSuspended => status == 'suspended';

  /// 获取状态显示文本
  String get statusText {
    switch (status) {
      case 'pending':
        return '待接受';
      case 'active':
        return '活跃';
      case 'inactive':
        return '非活跃';
      case 'suspended':
        return '暂停';
      case 'rejected':
        return '已拒绝';
      case 'expired':
        return '已过期';
      default:
        return status;
    }
  }
}

/// 项目成员状态枚举
enum ProjectMemberStatus {
  pending,
  active,
  inactive,
  suspended,
  rejected,
  expired,
}
