import 'dart:developer';

import 'base_seed.dart';

/// 种子: 002 - 插入默认权限
/// 创建时间: 2024-12-26
/// 描述: 插入系统所有默认权限
class Seed002InsertPermissions extends BaseSeed {
  @override
  String get name => '002_insert_permissions';

  @override
  String get description => '插入默认权限';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> run() async {
    try {
      log('开始插入默认权限数据', name: 'Seed002InsertPermissions');

      // 定义所有权限
      final permissions = [
        // ========== 用户管理权限 ==========
        {
          'name': 'users.view',
          'display_name': '查看用户',
          'description': '可以查看用户列表和用户详情',
          'resource': 'users',
          'action': 'view',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'users.create',
          'display_name': '创建用户',
          'description': '可以创建新用户',
          'resource': 'users',
          'action': 'create',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'users.update',
          'display_name': '更新用户',
          'description': '可以更新用户信息',
          'resource': 'users',
          'action': 'update',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'users.delete',
          'display_name': '删除用户',
          'description': '可以删除用户',
          'resource': 'users',
          'action': 'delete',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'users.manage_roles',
          'display_name': '管理用户角色',
          'description': '可以分配和移除用户角色',
          'resource': 'users',
          'action': 'manage_roles',
          'is_system_permission': true,
          'is_active': true,
        },

        // ========== 角色管理权限 ==========
        {
          'name': 'roles.view',
          'display_name': '查看角色',
          'description': '可以查看角色列表和角色详情',
          'resource': 'roles',
          'action': 'view',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'roles.create',
          'display_name': '创建角色',
          'description': '可以创建新角色',
          'resource': 'roles',
          'action': 'create',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'roles.update',
          'display_name': '更新角色',
          'description': '可以更新角色信息',
          'resource': 'roles',
          'action': 'update',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'roles.delete',
          'display_name': '删除角色',
          'description': '可以删除角色',
          'resource': 'roles',
          'action': 'delete',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'roles.manage_permissions',
          'display_name': '管理角色权限',
          'description': '可以分配和移除角色权限',
          'resource': 'roles',
          'action': 'manage_permissions',
          'is_system_permission': true,
          'is_active': true,
        },

        // ========== 权限管理权限 ==========
        {
          'name': 'permissions.view',
          'display_name': '查看权限',
          'description': '可以查看权限列表和权限详情',
          'resource': 'permissions',
          'action': 'view',
          'is_system_permission': true,
          'is_active': true,
        },

        // ========== 项目管理权限 ==========
        {
          'name': 'projects.view',
          'display_name': '查看项目',
          'description': '可以查看项目列表和项目详情',
          'resource': 'projects',
          'action': 'view',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'projects.create',
          'display_name': '创建项目',
          'description': '可以创建新项目',
          'resource': 'projects',
          'action': 'create',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'projects.update',
          'display_name': '更新项目',
          'description': '可以更新项目信息',
          'resource': 'projects',
          'action': 'update',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'projects.delete',
          'display_name': '删除项目',
          'description': '可以删除项目',
          'resource': 'projects',
          'action': 'delete',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'projects.manage_members',
          'display_name': '管理项目成员',
          'description': '可以添加、移除项目成员',
          'resource': 'projects',
          'action': 'manage_members',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'projects.manage_languages',
          'display_name': '管理项目语言',
          'description': '可以添加、移除项目支持的语言',
          'resource': 'projects',
          'action': 'manage_languages',
          'is_system_permission': true,
          'is_active': true,
        },

        // ========== 翻译管理权限 ==========
        {
          'name': 'translations.view',
          'display_name': '查看翻译',
          'description': '可以查看翻译条目',
          'resource': 'translations',
          'action': 'view',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'translations.create',
          'display_name': '创建翻译',
          'description': '可以创建新的翻译条目',
          'resource': 'translations',
          'action': 'create',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'translations.update',
          'display_name': '更新翻译',
          'description': '可以更新翻译内容',
          'resource': 'translations',
          'action': 'update',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'translations.delete',
          'display_name': '删除翻译',
          'description': '可以删除翻译条目',
          'resource': 'translations',
          'action': 'delete',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'translations.review',
          'display_name': '审核翻译',
          'description': '可以审核和批准翻译内容',
          'resource': 'translations',
          'action': 'review',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'translations.import',
          'display_name': '导入翻译',
          'description': '可以导入翻译文件',
          'resource': 'translations',
          'action': 'import',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'translations.export',
          'display_name': '导出翻译',
          'description': '可以导出翻译文件',
          'resource': 'translations',
          'action': 'export',
          'is_system_permission': true,
          'is_active': true,
        },

        // ========== 语言管理权限 ==========
        {
          'name': 'languages.view',
          'display_name': '查看语言',
          'description': '可以查看语言列表',
          'resource': 'languages',
          'action': 'view',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'languages.create',
          'display_name': '创建语言',
          'description': '可以添加新语言',
          'resource': 'languages',
          'action': 'create',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'languages.update',
          'display_name': '更新语言',
          'description': '可以更新语言信息',
          'resource': 'languages',
          'action': 'update',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'languages.delete',
          'display_name': '删除语言',
          'description': '可以删除语言',
          'resource': 'languages',
          'action': 'delete',
          'is_system_permission': true,
          'is_active': true,
        },

        // ========== 系统配置权限 ==========
        {
          'name': 'system.config.view',
          'display_name': '查看系统配置',
          'description': '可以查看系统配置',
          'resource': 'system',
          'action': 'config.view',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'system.config.update',
          'display_name': '更新系统配置',
          'description': '可以更新系统配置',
          'resource': 'system',
          'action': 'config.update',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'system.logs.view',
          'display_name': '查看系统日志',
          'description': '可以查看系统日志',
          'resource': 'system',
          'action': 'logs.view',
          'is_system_permission': true,
          'is_active': true,
        },

        // ========== 文件管理权限 ==========
        {
          'name': 'files.upload',
          'display_name': '上传文件',
          'description': '可以上传文件',
          'resource': 'files',
          'action': 'upload',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'files.download',
          'display_name': '下载文件',
          'description': '可以下载文件',
          'resource': 'files',
          'action': 'download',
          'is_system_permission': true,
          'is_active': true,
        },
        {
          'name': 'files.delete',
          'display_name': '删除文件',
          'description': '可以删除文件',
          'resource': 'files',
          'action': 'delete',
          'is_system_permission': true,
          'is_active': true,
        },
      ];

      // 插入权限数据
      await insertData('permissions', permissions);

      log('默认权限数据插入完成', name: 'Seed002InsertPermissions');
    } catch (error, stackTrace) {
      log('插入默认权限数据失败', error: error, stackTrace: stackTrace, name: 'Seed002InsertPermissions');
      rethrow;
    }
  }
}
