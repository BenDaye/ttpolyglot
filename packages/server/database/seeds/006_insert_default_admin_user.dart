import 'package:bcrypt/bcrypt.dart';
import 'package:ttpolyglot_utils/utils.dart';

import 'base_seed.dart';

/// 种子: 006 - 插入默认管理员用户
/// 创建时间: 2025-01-15
/// 描述: 插入默认的admin管理员账号（用户名: admin, 密码: 123456）
class Seed006InsertDefaultAdminUser extends BaseSeed {
  @override
  String get name => '006_insert_default_admin_user';

  @override
  String get description => '插入默认管理员用户';

  @override
  String get createdAt => '2025-01-15';

  @override
  Future<void> run() async {
    try {
      LoggerUtils.info('开始插入默认管理员用户数据');

      // 生成密码哈希（密码：123456）
      final passwordHash = BCrypt.hashpw('123456', BCrypt.gensalt(logRounds: 10));

      // 查询super_admin角色ID
      final rolesResult = await queryData(
        'SELECT id FROM ${tablePrefix}roles WHERE name = @role_name',
        parameters: {'role_name': 'super_admin'},
      );

      if (rolesResult.isEmpty) {
        LoggerUtils.warning('警告：未找到super_admin角色，跳过用户创建');
        return;
      }

      final superAdminRoleId = rolesResult.first['id'];

      // 定义默认管理员用户
      final adminUsers = [
        {
          'username': 'admin',
          'email': 'admin@ttpolyglot.com',
          'password_hash': passwordHash,
          'display_name': 'Admin User',
          'timezone': 'UTC',
          'locale': 'en-US',
          'is_active': true,
          'is_email_verified': true,
        },
      ];

      // 插入用户数据
      await insertData('users', adminUsers);

      // 查询刚插入的admin用户ID
      final usersResult = await queryData(
        'SELECT id FROM ${tablePrefix}users WHERE username = @username',
        parameters: {'username': 'admin'},
      );

      if (usersResult.isNotEmpty) {
        final adminUserId = usersResult.first['id'];

        // 为admin用户分配super_admin角色
        final userRoles = [
          {
            'user_id': adminUserId,
            'role_id': superAdminRoleId,
            'assigned_at': DateTime.now().toIso8601String(),
          },
        ];

        await insertData('user_roles', userRoles);
        LoggerUtils.info('已为admin用户分配super_admin角色');
      }

      LoggerUtils.info('默认管理员用户数据插入完成');
    } catch (error, stackTrace) {
      LoggerUtils.error('插入默认管理员用户数据失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
