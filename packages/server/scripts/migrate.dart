#!/usr/bin/env dart

import 'dart:io';

import 'package:ttpolyglot_server/server.dart';

import '../database/migration_service.dart';
import '../database/migrations/001_users_table.dart';
import '../database/migrations/002_roles_table.dart';
import '../database/migrations/003_permissions_table.dart';
import '../database/migrations/004_role_permissions_table.dart';
import '../database/migrations/005_languages_table.dart';
import '../database/migrations/006_projects_table.dart';
import '../database/migrations/007_user_roles_table.dart';
import '../database/migrations/008_project_languages_table.dart';
import '../database/migrations/009_user_translation_providers_table.dart';
import '../database/migrations/010_translation_entries_table.dart';
import '../database/migrations/011_translation_history_table.dart';
import '../database/migrations/012_system_configs_table.dart';
import '../database/migrations/013_user_sessions_table.dart';
import '../database/migrations/014_file_uploads_table.dart';
import '../database/migrations/015_notifications_table.dart';
import '../database/migrations/016_audit_logs_table.dart';
import '../database/seeds/001_insert_default_roles.dart';
import '../database/seeds/002_insert_permissions.dart';
import '../database/seeds/003_assign_role_permissions.dart';
import '../database/seeds/004_insert_languages.dart';
import '../database/seeds/005_insert_system_configs.dart';
import '../database/seeds/006_insert_default_admin_user.dart';

/// 主函数
Future<void> main(List<String> args) async {
  // 配置日志级别：只显示错误和警告
  LoggerFactory.configure(
    minLevel: LogLevel.error,
    enableConsole: true,
    enableJson: false, // 禁用 JSON 格式输出，只保留控制台输出
  );

  final logger = LoggerFactory.getLogger('MigrationScript');
  DatabaseService? databaseService;

  try {
    // 注册所有迁移
    _registerMigrations();

    // 注册所有种子数据
    _registerSeeds();

    // 加载配置
    await ServerConfig.load();
    ServerConfig.validate();

    // 初始化数据库服务
    databaseService = DatabaseService();
    await databaseService.initialize();

    // 创建迁移服务
    final migrationService = MigrationService(databaseService);

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
        case 'seed-status':
          await _showSeedStatus(migrationService, logger);
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
        case 'create-rollback':
          if (args.length < 2) {
            logger.error('创建回滚迁移需要指定迁移名称');
            exit(1);
          }
          final rollbackPath = await migrationService.createRollbackMigration(args[1]);
          logger.info('回滚迁移文件已创建: $rollbackPath');
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
        case 'validate':
          if (args.length < 2) {
            logger.error('验证表需要指定表名');
            exit(1);
          }
          await _validateTableMigration(migrationService, logger, args[1]);
          break;
        case 'backup':
          final backupPath = await migrationService.backupDatabase();
          if (backupPath.isNotEmpty) {
            logger.info('数据库备份完成: $backupPath');
          } else {
            logger.info('备份功能仅在生产环境中可用');
          }
          break;
        case 'list-backups':
          await _listBackups(migrationService, logger);
          break;
        case 'restore':
          if (args.length < 2) {
            logger.error('恢复数据库需要指定备份文件路径');
            exit(1);
          }
          await migrationService.restoreDatabase(args[1]);
          logger.info('数据库恢复完成');
          break;
        case 'delete-backup':
          if (args.length < 2) {
            logger.error('删除备份需要指定备份文件路径');
            exit(1);
          }
          await migrationService.deleteBackup(args[1]);
          break;
        case 'precheck':
          if (args.length < 2) {
            logger.error('迁移前检查需要指定表名');
            exit(1);
          }
          await _preMigrationCheck(migrationService, logger, args[1]);
          break;
        case 'foreign-keys':
          if (args.length < 2) {
            logger.error('查看外键需要指定表名');
            exit(1);
          }
          await _showTableForeignKeys(migrationService, logger, args[1]);
          break;
        default:
          migrationService.showHelpMigration();
          break;
      }
    }

    // 不再打印成功消息（只在出错时打印）
  } catch (error, stackTrace) {
    logger.error('迁移执行失败', error: error, stackTrace: stackTrace);
    exit(1);
  } finally {
    // 关闭数据库连接
    if (databaseService != null) {
      try {
        await databaseService.close();
      } catch (e) {
        // 忽略关闭错误
      }
    }
    // 强制退出进程
    exit(0);
  }
}

/// 显示迁移状态
Future<void> _showMigrationStatus(MigrationService migrationService, StructuredLogger logger) async {
  try {
    final status = await migrationService.getMigrationStatus();

    if (status.isEmpty) {
      logger.info('没有找到已注册的迁移类');
      return;
    }

    logger.info('迁移状态:');
    logger.info('=' * 80);

    for (final migration in status) {
      final name = migration['name'] as String;
      final description = migration['description'] as String;
      final statusText = migration['status'] as String;
      final executed = migration['executed'] as bool;
      final changed = migration['changed'] as bool;
      final classHash = migration['class_hash'] as String;
      final createdAt = migration['created_at'] as String;

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
      logger.info('   描述: $description');
      logger.info('   创建时间: $createdAt');
      logger.info('   类哈希: ${classHash.substring(0, 8)}...');

      if (executed) {
        final executedAt = migration['executed_at'];
        final executedHash = migration['executed_hash'] as String;

        logger.info('   执行时间: $executedAt');
        logger.info('   执行时哈希: ${executedHash.substring(0, 8)}...');

        if (changed) {
          logger.info('   ⚠️  迁移类已更改，将在下次运行时重新执行');
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

/// 显示种子数据状态
Future<void> _showSeedStatus(MigrationService migrationService, StructuredLogger logger) async {
  try {
    final status = await migrationService.getSeedStatus();

    if (status.isEmpty) {
      logger.info('没有找到已注册的种子数据类');
      return;
    }

    logger.info('种子数据状态:');
    logger.info('=' * 80);

    for (final seed in status) {
      final name = seed['name'] as String;
      final description = seed['description'] as String;
      final statusText = seed['status'] as String;
      final executed = seed['executed'] as bool;
      final changed = seed['changed'] as bool;
      final seedHash = seed['seed_hash'] as String;
      final createdAt = seed['created_at'] as String;

      String statusIcon = '❓';
      String statusDesc = '';

      switch (statusText) {
        case 'completed':
          statusIcon = '✅';
          statusDesc = '已完成';
          break;
        case 'changed':
          statusIcon = '🔄';
          statusDesc = '已更改';
          break;
        case 'pending':
          statusIcon = '⏳';
          statusDesc = '待执行';
          break;
      }

      logger.info('$statusIcon $name - $statusDesc');
      logger.info('   描述: $description');
      logger.info('   创建时间: $createdAt');
      logger.info('   种子哈希: ${seedHash.substring(0, 8)}...');

      if (executed) {
        final executedAt = seed['executed_at'];
        final executedHash = seed['executed_hash'] as String;

        logger.info('   执行时间: $executedAt');
        logger.info('   执行时哈希: ${executedHash.substring(0, 8)}...');

        if (changed) {
          logger.info('   ⚠️  种子数据类已更改');
        }
      }

      logger.info('');
    }

    // 统计信息
    final completed = status.where((s) => s['status'] == 'completed').length;
    final changed = status.where((s) => s['status'] == 'changed').length;
    final pending = status.where((s) => s['status'] == 'pending').length;

    logger.info('统计信息:');
    logger.info('  总种子数: ${status.length}');
    logger.info('  已完成: $completed');
    logger.info('  已更改: $changed');
    logger.info('  待执行: $pending');
  } catch (error, stackTrace) {
    logger.error('获取种子数据状态失败', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 验证表迁移
Future<void> _validateTableMigration(
    MigrationService migrationService, StructuredLogger logger, String tableName) async {
  try {
    logger.info('开始验证表迁移: $tableName');

    // 迁移前检查
    final preCheckResults = await migrationService.preMigrationCheck(tableName);
    logger.info('迁移前检查完成');

    // 模拟迁移（这里只是示例，实际应该执行真实的迁移）
    logger.info('执行迁移操作...');

    // 迁移后验证
    final validationResults = await migrationService.postMigrationValidation(tableName, preCheckResults);

    if (validationResults['passed']) {
      logger.info('✅ 迁移验证通过');
      final rowCountChange = validationResults['row_count_change'] as int? ?? 0;
      if (rowCountChange != 0) {
        logger.info('数据行数变化: $rowCountChange');
      }
    } else {
      logger.error('❌ 迁移验证失败');
      final errors = validationResults['errors'] as List<String>;
      for (final error in errors) {
        logger.error('  - $error');
      }
    }
  } catch (error, stackTrace) {
    logger.error('验证表迁移失败: $tableName', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 迁移前检查
Future<void> _preMigrationCheck(MigrationService migrationService, StructuredLogger logger, String tableName) async {
  try {
    logger.info('开始迁移前检查: $tableName');

    final preCheckResults = await migrationService.preMigrationCheck(tableName);

    logger.info('检查结果:');
    logger.info('  表存在: ${preCheckResults['table_exists']}');

    if (preCheckResults['table_exists']) {
      final columns = preCheckResults['columns'] as List<dynamic>;
      final constraints = preCheckResults['constraints'] as List<dynamic>;
      final indexes = preCheckResults['indexes'] as List<dynamic>;
      final rowCount = preCheckResults['row_count'] as int;

      logger.info('  列数: ${columns.length}');
      logger.info('  约束数: ${constraints.length}');
      logger.info('  索引数: ${indexes.length}');
      logger.info('  行数: $rowCount');

      logger.info('列详情:');
      for (final column in columns) {
        final name = column['name'] as String;
        final type = column['type'] as String;
        final nullable = column['nullable'] as bool;
        final maxLength = column['max_length'];
        logger.info('  - $name: $type${maxLength != null ? '($maxLength)' : ''} (${nullable ? '可空' : '非空'})');
      }
    }
  } catch (error, stackTrace) {
    logger.error('迁移前检查失败: $tableName', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 显示表外键
Future<void> _showTableForeignKeys(MigrationService migrationService, StructuredLogger logger, String tableName) async {
  try {
    logger.info('查看表外键: $tableName');

    final foreignKeys = await migrationService.getTableForeignKeys(tableName);

    if (foreignKeys.isEmpty) {
      logger.info('该表没有外键约束');
      return;
    }

    logger.info('外键约束:');
    for (final fk in foreignKeys) {
      final constraintName = fk['constraint_name'] as String;
      final columnName = fk['column_name'] as String;
      final foreignTableName = fk['foreign_table_name'] as String;
      final foreignColumnName = fk['foreign_column_name'] as String;

      logger.info('  - $constraintName: $columnName -> $foreignTableName.$foreignColumnName');
    }
  } catch (error, stackTrace) {
    logger.error('获取表外键失败: $tableName', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 列出备份文件
Future<void> _listBackups(MigrationService migrationService, StructuredLogger logger) async {
  try {
    logger.info('数据库备份列表:');

    final backups = await migrationService.listBackups();

    if (backups.isEmpty) {
      logger.info('没有找到备份文件');
      return;
    }

    logger.info('=' * 80);

    for (final backup in backups) {
      final name = backup['name'] as String;
      final path = backup['path'] as String;
      final size = backup['size'] as String;
      final createdAt = backup['created_at'] as DateTime;

      logger.info('📁 $name');
      logger.info('   路径: $path');
      logger.info('   大小: $size');
      logger.info('   创建时间: $createdAt');
      logger.info('');
    }

    logger.info('总计: ${backups.length} 个备份文件');
  } catch (error, stackTrace) {
    logger.error('获取备份列表失败', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 注册所有迁移
void _registerMigrations() {
  MigrationService.registerMigration('001_users_table', () => Migration001UsersTable());
  MigrationService.registerMigration('002_roles_table', () => Migration002RolesTable());
  MigrationService.registerMigration('003_permissions_table', () => Migration003PermissionsTable());
  MigrationService.registerMigration('004_role_permissions_table', () => Migration004RolePermissionsTable());
  MigrationService.registerMigration('005_languages_table', () => Migration005LanguagesTable());
  MigrationService.registerMigration('006_projects_table', () => Migration006ProjectsTable());
  MigrationService.registerMigration('007_user_roles_table', () => Migration007UserRolesTable());
  MigrationService.registerMigration('008_project_languages_table', () => Migration008ProjectLanguagesTable());
  MigrationService.registerMigration(
      '009_user_translation_providers_table', () => Migration009UserTranslationProvidersTable());
  MigrationService.registerMigration('010_translation_entries_table', () => Migration010TranslationEntriesTable());
  MigrationService.registerMigration('011_translation_history_table', () => Migration011TranslationHistoryTable());
  MigrationService.registerMigration('012_system_configs_table', () => Migration012SystemConfigsTable());
  MigrationService.registerMigration('013_user_sessions_table', () => Migration013UserSessionsTable());
  MigrationService.registerMigration('014_file_uploads_table', () => Migration014FileUploadsTable());
  MigrationService.registerMigration('015_notifications_table', () => Migration015NotificationsTable());
  MigrationService.registerMigration('016_audit_logs_table', () => Migration016AuditLogsTable());
}

/// 注册所有种子数据
void _registerSeeds() {
  MigrationService.registerSeed('001_insert_default_roles', () => Seed001InsertDefaultRoles());
  MigrationService.registerSeed('002_insert_permissions', () => Seed002InsertPermissions());
  MigrationService.registerSeed('003_assign_role_permissions', () => Seed003AssignRolePermissions());
  MigrationService.registerSeed('004_insert_languages', () => Seed004InsertLanguages());
  MigrationService.registerSeed('005_insert_system_configs', () => Seed005InsertSystemConfigs());
  MigrationService.registerSeed('006_insert_default_admin_user', () => Seed006InsertDefaultAdminUser());
}
