import 'dart:developer';

import 'migrations/migration_manager.dart';

/// 运行数据库迁移的示例
/// 创建时间: 2024-12-26
/// 描述: 演示如何使用迁移管理器
Future<void> main() async {
  final migrationManager = MigrationManager();

  try {
    // 初始化数据库连接
    await migrationManager.initialize(
      host: 'localhost',
      port: 5432,
      database: 'ttpolyglot',
      username: 'ttpolyglot',
      password: 'password',
      tablePrefix: 'tt_',
    );

    // 执行迁移
    await migrationManager.runMigrations();

    // 查看迁移状态
    final status = await migrationManager.getMigrationStatus();
    log('迁移状态:', name: 'RunMigrations');
    for (final migration in status) {
      log('  ${migration['name']}: ${migration['executedAt']}', name: 'RunMigrations');
    }
  } catch (error, stackTrace) {
    log('运行迁移失败', error: error, stackTrace: stackTrace, name: 'RunMigrations');
  } finally {
    await migrationManager.close();
  }
}
