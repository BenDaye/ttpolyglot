#!/usr/bin/env dart

import 'dart:io';

import 'package:ttpolyglot_server/src/config/server_config.dart';
import 'package:ttpolyglot_server/src/services/database_service.dart';
import 'package:ttpolyglot_server/src/services/migration_service.dart';
import 'package:ttpolyglot_server/src/utils/structured_logger.dart';

/// 主函数
Future<void> main(List<String> args) async {
  final logger = LoggerFactory.getLogger('MigrationScript');
  try {
    logger.info('开始数据库迁移和种子数据执行');

    // 加载配置
    final config = ServerConfig();
    await config.load();
    config.validate();

    // 初始化数据库服务
    final databaseService = DatabaseService(config);
    await databaseService.initialize();

    // 创建迁移服务
    final migrationService = MigrationService(databaseService, config);

    // 解析命令行参数
    if (args.isEmpty) {
      await migrationService.runMigrationsAndSeeds();
    } else {
      switch (args[0]) {
        case 'migrate':
          await migrationService.runMigrations();
          break;
        case 'seed':
          await migrationService.runSeeds();
          break;
        case 'status':
          await migrationService.getMigrationStatus();
          break;
        case 'rollback':
          if (args.length < 2) {
            logger.error('回滚需要指定迁移名称');
            exit(1);
          }
          await migrationService.rollbackMigration(args[1]);
          break;
        default:
          migrationService.showHelpMigration();
          break;
      }
    }

    logger.info('数据库迁移和种子数据执行完成');
  } catch (error, stackTrace) {
    logger.error('迁移执行失败', error: error, stackTrace: stackTrace);
    exit(1);
  }
}
