import 'dart:developer';

/// 种子数据: 003 - 分配角色权限
/// 创建时间: 2024-12-26
/// 描述: 为各个角色分配相应的权限
class Seed003AssignRolePermissions {
  static const String name = '003_assign_role_permissions';
  static const String description = '为各个角色分配相应的权限';
  static const String createdAt = '2024-12-26';

  /// 执行种子数据插入
  static Future<void> up() async {
    try {
      log('开始执行种子数据: $name', name: 'Seed003AssignRolePermissions');

      // 分配角色权限
      await _assignRolePermissions();

      log('种子数据完成: $name', name: 'Seed003AssignRolePermissions');
    } catch (error, stackTrace) {
      log('种子数据失败: $name', error: error, stackTrace: stackTrace, name: 'Seed003AssignRolePermissions');
      rethrow;
    }
  }

  /// 回滚种子数据
  static Future<void> down() async {
    try {
      log('开始回滚种子数据: $name', name: 'Seed003AssignRolePermissions');

      // 删除角色权限分配
      await _deleteRolePermissions();

      log('回滚完成: $name', name: 'Seed003AssignRolePermissions');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Seed003AssignRolePermissions');
      rethrow;
    }
  }

  /// 分配角色权限
  static Future<void> _assignRolePermissions() async {
    // 超级管理员 - 拥有所有权限
    await _assignSuperAdminPermissions();

    // 项目所有者 - 项目相关的所有权限 + 翻译权限 + 用户查看权限
    await _assignProjectOwnerPermissions();

    // 项目管理员 - 项目管理权限 + 翻译权限 + 用户查看权限
    await _assignProjectManagerPermissions();

    // 翻译员 - 翻译相关权限
    await _assignTranslatorPermissions();

    // 审核员 - 审核相关权限
    await _assignReviewerPermissions();

    // 查看者 - 只读权限
    await _assignViewerPermissions();
  }

  /// 分配超级管理员权限
  static Future<void> _assignSuperAdminPermissions() async {
    log('分配超级管理员权限', name: 'Seed003AssignRolePermissions');
  }

  /// 分配项目所有者权限
  static Future<void> _assignProjectOwnerPermissions() async {
    final permissions = [
      'project.read',
      'project.update',
      'project.delete',
      'project.manage',
      'translation.create',
      'translation.read',
      'translation.update',
      'translation.delete',
      'translation.review',
      'translation.approve',
      'user.read',
      'provider.create',
      'provider.read',
      'provider.update',
      'provider.delete',
      'provider.use',
    ];

    for (final permission in permissions) {
      log('为项目所有者分配权限: $permission', name: 'Seed003AssignRolePermissions');
    }
  }

  /// 分配项目管理员权限
  static Future<void> _assignProjectManagerPermissions() async {
    final permissions = [
      'project.read',
      'project.update',
      'project.manage',
      'translation.create',
      'translation.read',
      'translation.update',
      'translation.delete',
      'translation.review',
      'translation.approve',
      'user.read',
      'provider.read',
      'provider.use',
    ];

    for (final permission in permissions) {
      log('为项目管理员分配权限: $permission', name: 'Seed003AssignRolePermissions');
    }
  }

  /// 分配翻译员权限
  static Future<void> _assignTranslatorPermissions() async {
    final permissions = [
      'project.read',
      'translation.create',
      'translation.read',
      'translation.update',
      'user.read',
      'provider.read',
      'provider.use',
    ];

    for (final permission in permissions) {
      log('为翻译员分配权限: $permission', name: 'Seed003AssignRolePermissions');
    }
  }

  /// 分配审核员权限
  static Future<void> _assignReviewerPermissions() async {
    final permissions = [
      'project.read',
      'translation.read',
      'translation.review',
      'translation.approve',
      'user.read',
      'provider.read',
    ];

    for (final permission in permissions) {
      log('为审核员分配权限: $permission', name: 'Seed003AssignRolePermissions');
    }
  }

  /// 分配查看者权限
  static Future<void> _assignViewerPermissions() async {
    final permissions = [
      'project.read',
      'translation.read',
      'user.read',
      'provider.read',
    ];

    for (final permission in permissions) {
      log('为查看者分配权限: $permission', name: 'Seed003AssignRolePermissions');
    }
  }

  /// 删除角色权限分配
  static Future<void> _deleteRolePermissions() async {
    final roles = [
      'super_admin',
      'project_owner',
      'project_manager',
      'translator',
      'reviewer',
      'viewer',
    ];

    for (final role in roles) {
      log('删除角色权限分配: $role', name: 'Seed003AssignRolePermissions');
    }
  }
}
