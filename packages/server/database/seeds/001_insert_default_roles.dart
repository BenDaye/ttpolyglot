import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

import 'base_seed.dart';

/// 种子: 001 - 插入默认角色
/// 创建时间: 2024-12-26
/// 描述: 插入默认角色（超级管理员、管理员、项目所有者、项目经理、翻译员、审核员、访客）
class Seed001InsertDefaultRoles extends BaseSeed {
  @override
  String get name => '001_insert_default_roles';

  @override
  String get description => '插入默认角色';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> run() async {
    try {
      LoggerUtils.info('开始插入默认角色数据');

      // 定义默认角色
      final roles = [
        {
          'name': 'super_admin',
          'display_name': '超级管理员',
          'description': '拥有系统所有权限，可以管理系统配置、用户和所有项目',
          'is_system_role': true,
          'is_active': true,
        },
        {
          'name': 'admin',
          'display_name': '管理员',
          'description': '拥有大部分管理权限，可以管理用户和项目',
          'is_system_role': true,
          'is_active': true,
        },
        {
          'name': 'project_owner',
          'display_name': '项目所有者',
          'description': '项目的创建者和所有者，拥有项目的所有权限，可以管理项目设置、成员和翻译内容',
          'is_system_role': true,
          'is_active': true,
        },
        {
          'name': 'project_manager',
          'display_name': '项目经理',
          'description': '可以创建和管理自己的项目，管理项目成员和翻译内容',
          'is_system_role': true,
          'is_active': true,
        },
        {
          'name': 'translator',
          'display_name': '翻译员',
          'description': '可以翻译项目中的内容，查看和编辑翻译条目',
          'is_system_role': true,
          'is_active': true,
        },
        {
          'name': 'reviewer',
          'display_name': '审核员',
          'description': '可以审核和批准翻译内容',
          'is_system_role': true,
          'is_active': true,
        },
        {
          'name': 'viewer',
          'display_name': '访客',
          'description': '只能查看项目和翻译内容，无编辑权限',
          'is_system_role': true,
          'is_active': true,
        },
      ];

      // 插入角色数据
      await insertData('roles', roles);

      LoggerUtils.info('默认角色数据插入完成');
    } catch (error, stackTrace) {
      LoggerUtils.error('插入默认角色数据失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
