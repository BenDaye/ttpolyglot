

import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';
import 'base_seed.dart';

/// 种子: 003 - 分配角色权限
/// 创建时间: 2024-12-26
/// 描述: 为默认角色分配相应的权限
class Seed003AssignRolePermissions extends BaseSeed {
  @override
  String get name => '003_assign_role_permissions';

  @override
  String get description => '分配角色权限';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> run() async {
    try {
      LoggerUtils.info('开始分配角色权限');

      // 获取所有角色
      final roles = await queryData('SELECT id, name FROM ${tablePrefix}roles');
      final roleMap = <String, int>{};
      for (final role in roles) {
        roleMap[role['name'] as String] = role['id'] as int;
      }

      // 获取所有权限
      final permissions = await queryData('SELECT id, name FROM ${tablePrefix}permissions');
      final permissionMap = <String, int>{};
      for (final permission in permissions) {
        permissionMap[permission['name'] as String] = permission['id'] as int;
      }

      // 定义角色权限映射
      final rolePermissions = <String, List<String>>{
        // 超级管理员 - 拥有所有权限
        'super_admin': permissionMap.keys.toList(),

        // 管理员 - 拥有大部分权限，但不能管理系统配置
        'admin': [
          // 用户管理
          'users.view',
          'users.create',
          'users.update',
          'users.delete',
          // 角色管理
          'roles.view',
          'roles.update',
          // 权限管理
          'permissions.view',
          // 项目管理
          'projects.view',
          'projects.create',
          'projects.update',
          'projects.delete',
          'projects.manage_members',
          // 翻译管理
          'translations.view',
          'translations.create',
          'translations.update',
          'translations.delete',
          'translations.approve',
          'translations.export',
          'translations.import',
          // 语言管理
          'languages.view',
          'languages.create',
          'languages.update',
          // 文件管理
          'files.view',
          'files.upload',
          'files.delete',
          // 通知管理
          'notifications.view',
          'notifications.create',
          'notifications.delete',
          // 审计日志
          'audit_logs.view',
        ],

        // 项目经理 - 可以管理自己的项目
        'project_manager': [
          // 用户查看
          'users.view',
          // 项目管理
          'projects.view',
          'projects.create',
          'projects.update',
          'projects.manage_members',
          // 翻译管理
          'translations.view',
          'translations.create',
          'translations.update',
          'translations.delete',
          'translations.approve',
          'translations.export',
          'translations.import',
          // 语言查看
          'languages.view',
          // 文件管理
          'files.view',
          'files.upload',
          'files.delete',
          // 通知
          'notifications.view',
          'notifications.create',
        ],

        // 翻译员 - 可以翻译内容
        'translator': [
          // 用户查看
          'users.view',
          // 项目查看
          'projects.view',
          // 翻译管理
          'translations.view',
          'translations.create',
          'translations.update',
          'translations.export',
          // 语言查看
          'languages.view',
          // 文件查看和上传
          'files.view',
          'files.upload',
          // 通知
          'notifications.view',
        ],

        // 审核员 - 可以审核翻译
        'reviewer': [
          // 用户查看
          'users.view',
          // 项目查看
          'projects.view',
          // 翻译管理
          'translations.view',
          'translations.update',
          'translations.approve',
          'translations.export',
          // 语言查看
          'languages.view',
          // 文件查看
          'files.view',
          // 通知
          'notifications.view',
        ],

        // 访客 - 只能查看
        'viewer': [
          // 用户查看
          'users.view',
          // 项目查看
          'projects.view',
          // 翻译查看
          'translations.view',
          'translations.export',
          // 语言查看
          'languages.view',
          // 文件查看
          'files.view',
          // 通知查看
          'notifications.view',
        ],
      };

      // 为每个角色分配权限
      for (final entry in rolePermissions.entries) {
        final roleName = entry.key;
        final permissionNames = entry.value;

        final roleId = roleMap[roleName];
        if (roleId == null) {
          LoggerUtils.info('角色未找到: $roleName');
          continue;
        }

        final rolePermissionData = <Map<String, dynamic>>[];
        for (final permissionName in permissionNames) {
          final permissionId = permissionMap[permissionName];
          if (permissionId != null) {
            rolePermissionData.add({
              'role_id': roleId,
              'permission_id': permissionId,
            });
          }
        }

        if (rolePermissionData.isNotEmpty) {
          await insertData('role_permissions', rolePermissionData);
          LoggerUtils.info('角色 $roleName 已分配 ${rolePermissionData.length} 个权限');
        }
      }

      LoggerUtils.info('角色权限分配完成');
    } catch (error, stackTrace) {
      LoggerUtils.error('分配角色权限失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
