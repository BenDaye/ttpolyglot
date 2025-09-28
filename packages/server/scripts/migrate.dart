#!/usr/bin/env dart

import 'dart:developer' as developer;
import 'dart:io';

import 'package:ttpolyglot_server/src/config/server_config.dart';
import 'package:ttpolyglot_server/src/services/database_service.dart';
import 'package:ttpolyglot_server/src/services/migration_service.dart';

/// 主函数
Future<void> main(List<String> args) async {
  try {
    developer.log('开始数据库迁移和种子数据执行', name: 'MigrationScript');

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
      await _runAllMigrationsAndSeeds(migrationService);
    } else {
      switch (args[0]) {
        case 'migrate':
          await _runMigrations(migrationService);
          break;
        case 'seed':
          await _runSeeds(migrationService);
          break;
        case 'status':
          await _showStatus(migrationService);
          break;
        case 'rollback':
          if (args.length < 2) {
            developer.log('回滚需要指定迁移名称', name: 'MigrationScript');
            exit(1);
          }
          await _rollbackMigration(migrationService, args[1]);
          break;
        default:
          _showHelp();
      }
    }

    developer.log('数据库迁移和种子数据执行完成', name: 'MigrationScript');
  } catch (error, stackTrace) {
    developer.log('迁移执行失败', error: error, stackTrace: stackTrace, name: 'MigrationScript');
    exit(1);
  }
}

/// 运行所有迁移和种子数据
Future<void> _runAllMigrationsAndSeeds(MigrationService migrationService) async {
  developer.log('执行所有迁移和种子数据', name: 'MigrationScript');
  await migrationService.runMigrations();
  await migrationService.runSeeds();
}

/// 只运行迁移
Future<void> _runMigrations(MigrationService migrationService) async {
  developer.log('执行数据库迁移', name: 'MigrationScript');
  await migrationService.runMigrations();
}

/// 只运行种子数据
Future<void> _runSeeds(MigrationService migrationService) async {
  developer.log('执行种子数据', name: 'MigrationScript');
  await migrationService.runSeeds();
}

/// 显示迁移状态
Future<void> _showStatus(MigrationService migrationService) async {
  developer.log('获取迁移状态', name: 'MigrationScript');
  final status = await migrationService.getMigrationStatus();

  print('\n迁移状态:');
  print('=' * 80);
  for (final migration in status) {
    final statusText = migration['executed'] ? '✓ 已完成' : '○ 待执行';
    print('${migration['name']}: $statusText');
  }
}

/// 回滚迁移
Future<void> _rollbackMigration(MigrationService migrationService, String migrationName) async {
  developer.log('回滚迁移: $migrationName', name: 'MigrationScript');
  await migrationService.rollbackMigration(migrationName);
}

/// 显示帮助信息
void _showHelp() {
  print('''
数据库迁移工具

用法:
  dart migrate.dart                    # 运行所有迁移和种子数据
  dart migrate.dart migrate           # 只运行迁移
  dart migrate.dart seed              # 只运行种子数据
  dart migrate.dart status            # 显示迁移状态
  dart migrate.dart rollback <name>   # 回滚指定迁移（仅开发环境）

选项:
  --help, -h                          # 显示此帮助信息
''');
}
