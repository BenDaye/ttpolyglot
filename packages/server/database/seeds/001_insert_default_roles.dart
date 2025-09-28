import 'dart:developer';

/// 种子数据: 001 - 插入默认角色
/// 创建时间: 2024-12-26
/// 描述: 插入系统默认角色
class Seed001InsertDefaultRoles {
  static const String name = '001_insert_default_roles';
  static const String description = '插入系统默认角色';
  static const String createdAt = '2024-12-26';

  /// 执行种子数据插入
  static Future<void> up() async {
    try {
      log('开始执行种子数据: $name', name: 'Seed001InsertDefaultRoles');

      // 插入默认角色
      await _insertDefaultRoles();

      log('种子数据完成: $name', name: 'Seed001InsertDefaultRoles');
    } catch (error, stackTrace) {
      log('种子数据失败: $name', error: error, stackTrace: stackTrace, name: 'Seed001InsertDefaultRoles');
      rethrow;
    }
  }

  /// 回滚种子数据
  static Future<void> down() async {
    try {
      log('开始回滚种子数据: $name', name: 'Seed001InsertDefaultRoles');

      // 删除默认角色
      await _deleteDefaultRoles();

      log('回滚完成: $name', name: 'Seed001InsertDefaultRoles');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Seed001InsertDefaultRoles');
      rethrow;
    }
  }

  /// 插入默认角色
  static Future<void> _insertDefaultRoles() async {
    final roles = [
      {
        'name': 'super_admin',
        'display_name': '超级管理员',
        'description': '拥有系统所有权限',
        'is_system': true,
        'priority': 1000,
      },
      {
        'name': 'project_owner',
        'display_name': '项目所有者',
        'description': '项目创建者，拥有项目所有权限',
        'is_system': true,
        'priority': 900,
      },
      {
        'name': 'project_manager',
        'display_name': '项目管理员',
        'description': '项目管理权限，可管理成员和设置',
        'is_system': true,
        'priority': 800,
      },
      {
        'name': 'translator',
        'display_name': '翻译员',
        'description': '翻译权限',
        'is_system': true,
        'priority': 500,
      },
      {
        'name': 'reviewer',
        'display_name': '审核员',
        'description': '审核翻译权限',
        'is_system': true,
        'priority': 600,
      },
      {
        'name': 'viewer',
        'display_name': '查看者',
        'description': '只读权限',
        'is_system': true,
        'priority': 100,
      },
    ];

    for (final role in roles) {
      log('插入角色: ${role['name']}', name: 'Seed001InsertDefaultRoles');
    }
  }

  /// 删除默认角色
  static Future<void> _deleteDefaultRoles() async {
    final roleNames = [
      'super_admin',
      'project_owner',
      'project_manager',
      'translator',
      'reviewer',
      'viewer',
    ];

    for (final roleName in roleNames) {
      log('删除角色: $roleName', name: 'Seed001InsertDefaultRoles');
    }
  }
}
