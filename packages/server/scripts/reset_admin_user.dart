#!/usr/bin/env dart

import 'dart:developer';
import 'dart:io';

import 'package:ttpolyglot_server/src/config/server_config.dart';
import 'package:ttpolyglot_server/src/services/database_service.dart';
import 'package:ttpolyglot_server/src/utils/structured_logger.dart';

import '../database/seeds/006_insert_default_admin_user.dart';

/// 重置管理员用户脚本
/// 删除现有的 admin 用户并重新创建
Future<void> main() async {
  // 配置日志级别
  LoggerFactory.configure(
    minLevel: LogLevel.info,
    enableConsole: true,
    enableJson: false,
  );

  DatabaseService? databaseService;

  try {
    log('开始重置管理员用户...', name: 'ResetAdminUser');

    // 加载配置
    await ServerConfig.load();
    ServerConfig.validate();

    // 初始化数据库服务
    databaseService = DatabaseService();
    await databaseService.initialize();

    // 获取表前缀
    final tablePrefix = ServerConfig.tablePrefix;

    // 1. 查找现有的 admin 用户
    log('查找现有的 admin 用户...', name: 'ResetAdminUser');
    final userResult = await databaseService.query(
      'SELECT id FROM ${tablePrefix}users WHERE username = @username',
      {'username': 'admin'},
    );

    if (userResult.isNotEmpty) {
      final adminUserId = userResult.first[0];
      log('找到现有 admin 用户，ID: $adminUserId', name: 'ResetAdminUser');

      // 2. 删除用户角色关联
      log('删除用户角色关联...', name: 'ResetAdminUser');
      await databaseService.query(
        'DELETE FROM ${tablePrefix}user_roles WHERE user_id = @user_id',
        {'user_id': adminUserId},
      );

      // 3. 删除用户会话
      log('删除用户会话...', name: 'ResetAdminUser');
      await databaseService.query(
        'DELETE FROM ${tablePrefix}user_sessions WHERE user_id = @user_id',
        {'user_id': adminUserId},
      );

      // 4. 删除用户
      log('删除用户...', name: 'ResetAdminUser');
      await databaseService.query(
        'DELETE FROM ${tablePrefix}users WHERE id = @user_id',
        {'user_id': adminUserId},
      );

      log('✓ 已删除现有的 admin 用户', name: 'ResetAdminUser');
    } else {
      log('未找到现有的 admin 用户', name: 'ResetAdminUser');
    }

    // 5. 删除种子数据执行记录
    log('删除种子数据执行记录...', name: 'ResetAdminUser');
    await databaseService.query(
      'DELETE FROM ${tablePrefix}schema_seeds WHERE seed_name = @name',
      {'name': '006_insert_default_admin_user'},
    );

    // 6. 重新创建 admin 用户
    log('重新创建 admin 用户...', name: 'ResetAdminUser');
    final seed = Seed006InsertDefaultAdminUser();

    // 设置数据库连接
    seed.setConnection(databaseService.connection);

    // 在事务中执行种子数据
    await databaseService.transaction(() async {
      // 执行种子数据的 run 方法
      await seed.run();
    });

    // 记录种子数据执行
    final seedsTableName = '${tablePrefix}schema_seeds';
    await databaseService.query('''
      INSERT INTO $seedsTableName (seed_name, file_path, file_hash) 
      VALUES (@name, @path, @hash)
    ''', {
      'name': '006_insert_default_admin_user',
      'path': 'class://006_insert_default_admin_user',
      'hash': 'reset-${DateTime.now().millisecondsSinceEpoch}',
    });

    log('', name: 'ResetAdminUser');
    log('========================================', name: 'ResetAdminUser');
    log('✓ 管理员用户重置成功！', name: 'ResetAdminUser');
    log('========================================', name: 'ResetAdminUser');
    log('用户名: admin', name: 'ResetAdminUser');
    log('密码: 123456', name: 'ResetAdminUser');
    log('邮箱: admin@ttpolyglot.com', name: 'ResetAdminUser');
    log('========================================', name: 'ResetAdminUser');
    log('', name: 'ResetAdminUser');
  } catch (error, stackTrace) {
    log('重置管理员用户失败', error: error, stackTrace: stackTrace, name: 'ResetAdminUser');
    exit(1);
  } finally {
    await databaseService?.close();
  }
}
