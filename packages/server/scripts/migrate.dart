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
          await _showMigrationStatus(migrationService, logger);
          break;
        case 'rollback':
          if (args.length < 2) {
            logger.error('回滚需要指定迁移名称');
            exit(1);
          }
          await migrationService.rollbackMigration(args[1]);
          break;
        case 'check':
          if (args.length < 2) {
            logger.error('检查表结构需要指定表名');
            exit(1);
          }
          final tableInfo = await migrationService.checkTableStructure(args[1]);
          if (tableInfo['exists']) {
            logger.info('表 ${tableInfo['table_name']} 存在，包含以下列：');
            for (final column in tableInfo['columns']) {
              logger.info('  - ${column['name']}: ${column['type']} (${column['nullable'] ? '可空' : '非空'})');
            }
          } else {
            logger.info(tableInfo['message']);
          }
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

/// 显示迁移状态
Future<void> _showMigrationStatus(MigrationService migrationService, StructuredLogger logger) async {
  try {
    final status = await migrationService.getMigrationStatus();

    if (status.isEmpty) {
      logger.info('没有找到迁移文件');
      return;
    }

    logger.info('迁移状态:');
    logger.info('=' * 80);

    for (final migration in status) {
      final name = migration['name'] as String;
      final statusText = migration['status'] as String;
      final executed = migration['executed'] as bool;
      final changed = migration['changed'] as bool;
      final filePath = migration['file_path'] as String;
      final fileHash = migration['file_hash'] as String;

      String statusIcon = '❓';
      String statusDesc = '';

      switch (statusText) {
        case 'completed':
          statusIcon = '✅';
          statusDesc = '已完成';
          break;
        case 'changed':
          statusIcon = '🔄';
          statusDesc = '已更改，需要重新执行';
          break;
        case 'pending':
          statusIcon = '⏳';
          statusDesc = '待执行';
          break;
      }

      logger.info('$statusIcon $name - $statusDesc');
      logger.info('   文件路径: $filePath');
      logger.info('   文件哈希: ${fileHash.substring(0, 8)}...');

      if (executed) {
        final executedAt = migration['executed_at'];
        final executedHash = migration['executed_hash'] as String;
        final executedPath = migration['executed_path'] as String;

        logger.info('   执行时间: $executedAt');
        logger.info('   执行时哈希: ${executedHash.substring(0, 8)}...');
        logger.info('   执行时路径: $executedPath');

        if (changed) {
          logger.info('   ⚠️  文件已更改，将在下次运行时重新执行');
        }
      }

      logger.info('');
    }

    // 统计信息
    final completed = status.where((m) => m['status'] == 'completed').length;
    final changed = status.where((m) => m['status'] == 'changed').length;
    final pending = status.where((m) => m['status'] == 'pending').length;

    logger.info('统计信息:');
    logger.info('  总迁移数: ${status.length}');
    logger.info('  已完成: $completed');
    logger.info('  已更改: $changed');
    logger.info('  待执行: $pending');
  } catch (error, stackTrace) {
    logger.error('获取迁移状态失败', error: error, stackTrace: stackTrace);
    rethrow;
  }
}
