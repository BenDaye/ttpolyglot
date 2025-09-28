import 'dart:developer';

/// 种子数据: 002 - 插入系统权限
/// 创建时间: 2024-12-26
/// 描述: 插入系统权限数据
class Seed002InsertPermissions {
  static const String name = '002_insert_permissions';
  static const String description = '插入系统权限数据';
  static const String createdAt = '2024-12-26';

  /// 执行种子数据插入
  static Future<void> up() async {
    try {
      log('开始执行种子数据: $name', name: 'Seed002InsertPermissions');

      // 插入系统权限
      await _insertPermissions();

      log('种子数据完成: $name', name: 'Seed002InsertPermissions');
    } catch (error, stackTrace) {
      log('种子数据失败: $name', error: error, stackTrace: stackTrace, name: 'Seed002InsertPermissions');
      rethrow;
    }
  }

  /// 回滚种子数据
  static Future<void> down() async {
    try {
      log('开始回滚种子数据: $name', name: 'Seed002InsertPermissions');

      // 删除系统权限
      await _deletePermissions();

      log('回滚完成: $name', name: 'Seed002InsertPermissions');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Seed002InsertPermissions');
      rethrow;
    }
  }

  /// 插入系统权限
  static Future<void> _insertPermissions() async {
    final permissions = [
      // 项目权限
      {
        'name': 'project.create',
        'display_name': '创建项目',
        'description': '创建新项目',
        'resource': 'project',
        'action': 'create',
        'scope': 'global',
      },
      {
        'name': 'project.read',
        'display_name': '查看项目',
        'description': '查看项目信息',
        'resource': 'project',
        'action': 'read',
        'scope': 'project',
      },
      {
        'name': 'project.update',
        'display_name': '编辑项目',
        'description': '编辑项目信息',
        'resource': 'project',
        'action': 'update',
        'scope': 'project',
      },
      {
        'name': 'project.delete',
        'display_name': '删除项目',
        'description': '删除项目',
        'resource': 'project',
        'action': 'delete',
        'scope': 'project',
      },
      {
        'name': 'project.manage',
        'display_name': '管理项目',
        'description': '管理项目成员和权限',
        'resource': 'project',
        'action': 'manage',
        'scope': 'project',
      },
      // 翻译权限
      {
        'name': 'translation.create',
        'display_name': '创建翻译',
        'description': '创建翻译条目',
        'resource': 'translation',
        'action': 'create',
        'scope': 'project',
      },
      {
        'name': 'translation.read',
        'display_name': '查看翻译',
        'description': '查看翻译条目',
        'resource': 'translation',
        'action': 'read',
        'scope': 'project',
      },
      {
        'name': 'translation.update',
        'display_name': '编辑翻译',
        'description': '编辑翻译条目',
        'resource': 'translation',
        'action': 'update',
        'scope': 'project',
      },
      {
        'name': 'translation.delete',
        'display_name': '删除翻译',
        'description': '删除翻译条目',
        'resource': 'translation',
        'action': 'delete',
        'scope': 'project',
      },
      {
        'name': 'translation.review',
        'display_name': '审核翻译',
        'description': '审核翻译条目',
        'resource': 'translation',
        'action': 'review',
        'scope': 'project',
      },
      {
        'name': 'translation.approve',
        'display_name': '批准翻译',
        'description': '批准翻译条目',
        'resource': 'translation',
        'action': 'approve',
        'scope': 'project',
      },
      // 用户权限
      {
        'name': 'user.read',
        'display_name': '查看用户',
        'description': '查看用户信息',
        'resource': 'user',
        'action': 'read',
        'scope': 'global',
      },
      {
        'name': 'user.update',
        'display_name': '编辑用户',
        'description': '编辑用户信息',
        'resource': 'user',
        'action': 'update',
        'scope': 'global',
      },
      {
        'name': 'user.delete',
        'display_name': '删除用户',
        'description': '删除用户',
        'resource': 'user',
        'action': 'delete',
        'scope': 'global',
      },
      {
        'name': 'user.manage_roles',
        'display_name': '管理用户角色',
        'description': '分配和撤销用户角色',
        'resource': 'user',
        'action': 'manage',
        'scope': 'global',
      },
      // 系统权限
      {
        'name': 'system.admin',
        'display_name': '系统管理',
        'description': '系统管理权限',
        'resource': 'system',
        'action': 'manage',
        'scope': 'global',
      },
      {
        'name': 'system.backup',
        'display_name': '数据备份',
        'description': '数据备份权限',
        'resource': 'system',
        'action': 'create',
        'scope': 'global',
      },
      {
        'name': 'system.restore',
        'display_name': '数据恢复',
        'description': '数据恢复权限',
        'resource': 'system',
        'action': 'update',
        'scope': 'global',
      },
      // 配置权限
      {
        'name': 'config.read',
        'display_name': '查看配置',
        'description': '查看系统配置',
        'resource': 'config',
        'action': 'read',
        'scope': 'global',
      },
      {
        'name': 'config.update',
        'display_name': '修改配置',
        'description': '修改系统配置',
        'resource': 'config',
        'action': 'update',
        'scope': 'global',
      },
      {
        'name': 'config.create',
        'display_name': '创建配置',
        'description': '创建系统配置',
        'resource': 'config',
        'action': 'create',
        'scope': 'global',
      },
      {
        'name': 'config.delete',
        'display_name': '删除配置',
        'description': '删除系统配置',
        'resource': 'config',
        'action': 'delete',
        'scope': 'global',
      },
      // 翻译接口权限
      {
        'name': 'provider.create',
        'display_name': '创建翻译接口',
        'description': '创建翻译接口配置',
        'resource': 'provider',
        'action': 'create',
        'scope': 'resource',
      },
      {
        'name': 'provider.read',
        'display_name': '查看翻译接口',
        'description': '查看翻译接口配置',
        'resource': 'provider',
        'action': 'read',
        'scope': 'resource',
      },
      {
        'name': 'provider.update',
        'display_name': '编辑翻译接口',
        'description': '编辑翻译接口配置',
        'resource': 'provider',
        'action': 'update',
        'scope': 'resource',
      },
      {
        'name': 'provider.delete',
        'display_name': '删除翻译接口',
        'description': '删除翻译接口配置',
        'resource': 'provider',
        'action': 'delete',
        'scope': 'resource',
      },
      {
        'name': 'provider.use',
        'display_name': '使用翻译接口',
        'description': '使用翻译接口进行翻译',
        'resource': 'provider',
        'action': 'read',
        'scope': 'resource',
      },
    ];

    for (final permission in permissions) {
      log('插入权限: ${permission['name']}', name: 'Seed002InsertPermissions');
    }
  }

  /// 删除系统权限
  static Future<void> _deletePermissions() async {
    final permissionNames = [
      'project.create',
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
      'user.update',
      'user.delete',
      'user.manage_roles',
      'system.admin',
      'system.backup',
      'system.restore',
      'config.read',
      'config.update',
      'config.create',
      'config.delete',
      'provider.create',
      'provider.read',
      'provider.update',
      'provider.delete',
      'provider.use',
    ];

    for (final permissionName in permissionNames) {
      log('删除权限: $permissionName', name: 'Seed002InsertPermissions');
    }
  }
}
