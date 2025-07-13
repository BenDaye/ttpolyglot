/// 用户角色枚举
enum UserRole {
  /// 管理员
  admin,

  /// 项目经理
  projectManager,

  /// 翻译员
  translator,

  /// 审核员
  reviewer,

  /// 只读用户
  viewer,
}

/// 用户角色扩展
extension UserRoleExtension on UserRole {
  /// 获取角色的中文显示名称
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return '管理员';
      case UserRole.projectManager:
        return '项目经理';
      case UserRole.translator:
        return '翻译员';
      case UserRole.reviewer:
        return '审核员';
      case UserRole.viewer:
        return '只读用户';
    }
  }

  /// 获取角色权限级别
  int get level {
    switch (this) {
      case UserRole.admin:
        return 100;
      case UserRole.projectManager:
        return 80;
      case UserRole.reviewer:
        return 60;
      case UserRole.translator:
        return 40;
      case UserRole.viewer:
        return 20;
    }
  }

  /// 是否可以管理项目
  bool get canManageProject {
    return level >= UserRole.projectManager.level;
  }

  /// 是否可以翻译
  bool get canTranslate {
    return level >= UserRole.translator.level;
  }

  /// 是否可以审核
  bool get canReview {
    return level >= UserRole.reviewer.level;
  }

  /// 是否可以管理用户
  bool get canManageUsers {
    return this == UserRole.admin;
  }
}
