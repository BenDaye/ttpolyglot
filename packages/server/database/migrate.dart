#!/usr/bin/env dart

import 'dart:io';

import 'package:ttpolyglot_server/server.dart';
import 'package:ttpolyglot_model/model.dart';

import './migration_service.dart';
import './migrations/001_users_table.dart';
import './migrations/002_roles_table.dart';
import './migrations/003_permissions_table.dart';
import './migrations/004_role_permissions_table.dart';
import './migrations/005_languages_table.dart';
import './migrations/006_projects_table.dart';
import './migrations/007_user_roles_table.dart';
import './migrations/008_project_languages_table.dart';
import './migrations/009_translation_entries_table.dart';
import './migrations/010_translation_history_table.dart';
import './migrations/011_system_configs_table.dart';
import './migrations/012_user_sessions_table.dart';
import './migrations/013_file_uploads_table.dart';
import './migrations/014_notifications_table.dart';
import './migrations/015_audit_logs_table.dart';
import './migrations/016_user_settings_table.dart';
import './migrations/017_user_translation_configs_table.dart';
import './seeds/001_insert_default_roles.dart';
import './seeds/002_insert_permissions.dart';
import './seeds/003_assign_role_permissions.dart';
import './seeds/004_insert_languages.dart';
import './seeds/005_insert_system_configs.dart';
import './seeds/006_insert_default_admin_user.dart';
import 'migrations/018_project_members_table.dart';
import 'migrations/019_notification_settings_table.dart';
import 'migrations/020_project_member_invite_logs_table.dart';
import 'migrations/021_project_translation_stats_table.dart';
import 'migrations/022_translation_batch_jobs_table.dart';

/// 主函数
Future<void> main(List<String> args) async {
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
          await _showSeedStatus(migrationService);
          break;
        case 'status':
          await _showMigrationStatus(migrationService);
          break;
        case 'rollback':
          if (args.length < 2) {
            ServerLogger.error('回滚需要指定迁移名称');
            exit(1);
          }
          await migrationService.rollbackMigration(args[1]);
          break;
        case 'create-rollback':
          if (args.length < 2) {
            ServerLogger.error('创建回滚迁移需要指定迁移名称');
            exit(1);
          }
          final rollbackPath = await migrationService.createRollbackMigration(args[1]);
          ServerLogger.info('回滚迁移文件已创建: $rollbackPath');
          break;
        case 'check':
          if (args.length < 2) {
            ServerLogger.error('检查表结构需要指定表名');
            exit(1);
          }
          final tableInfo = await migrationService.checkTableStructure(args[1]);
          if (tableInfo['exists']) {
            ServerLogger.info('表 ${tableInfo['table_name']} 存在，包含以下列：');
            for (final column in tableInfo['columns']) {
              ServerLogger.info('  - ${column['name']}: ${column['type']} (${column['nullable'] ? '可空' : '非空'})');
            }
          } else {
            ServerLogger.info(tableInfo['message']);
          }
          break;
        case 'validate':
          if (args.length < 2) {
            ServerLogger.error('验证表需要指定表名');
            exit(1);
          }
          await _validateTableMigration(migrationService, args[1]);
          break;
        case 'backup':
          final backupPath = await migrationService.backupDatabase();
          if (backupPath.isNotEmpty) {
            ServerLogger.info('数据库备份完成: $backupPath');
          } else {
            ServerLogger.info('备份功能仅在生产环境中可用');
          }
          break;
        case 'list-backups':
          await _listBackups(migrationService);
          break;
        case 'restore':
          if (args.length < 2) {
            ServerLogger.error('恢复数据库需要指定备份文件路径');
            exit(1);
          }
          await migrationService.restoreDatabase(args[1]);
          ServerLogger.info('数据库恢复完成');
          break;
        case 'delete-backup':
          if (args.length < 2) {
            ServerLogger.error('删除备份需要指定备份文件路径');
            exit(1);
          }
          await migrationService.deleteBackup(args[1]);
          break;
        case 'precheck':
          if (args.length < 2) {
            ServerLogger.error('迁移前检查需要指定表名');
            exit(1);
          }
          await _preMigrationCheck(migrationService, args[1]);
          break;
        case 'foreign-keys':
          if (args.length < 2) {
            ServerLogger.error('查看外键需要指定表名');
            exit(1);
          }
          await _showTableForeignKeys(migrationService, args[1]);
          break;
        default:
          migrationService.showHelpMigration();
          break;
      }
    }

    // 不再打印成功消息（只在出错时打印）
  } catch (error, stackTrace) {
    ServerLogger.error('迁移执行失败', error: error, stackTrace: stackTrace);
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
Future<void> _showMigrationStatus(MigrationService migrationService) async {
  try {
    final status = await migrationService.getMigrationStatus();

    if (status.isEmpty) {
      ServerLogger.info('没有找到已注册的迁移类');
      return;
    }

    ServerLogger.info('迁移状态:');
    ServerLogger.info('=' * 80);

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

      ServerLogger.info('$statusIcon $name - $statusDesc');
      ServerLogger.info('   描述: $description');
      ServerLogger.info('   创建时间: $createdAt');
      ServerLogger.info('   类哈希: ${classHash.substring(0, 8)}...');

      if (executed) {
        final executedAt = migration['executed_at'];
        final executedHash = migration['executed_hash'] as String;

        ServerLogger.info('   执行时间: $executedAt');
        ServerLogger.info('   执行时哈希: ${executedHash.substring(0, 8)}...');

        if (changed) {
          ServerLogger.info('   ⚠️  迁移类已更改，将在下次运行时重新执行');
        }
      }

      ServerLogger.info('');
    }

    // 统计信息
    final completed = status.where((m) => m['status'] == 'completed').length;
    final changed = status.where((m) => m['status'] == 'changed').length;
    final pending = status.where((m) => m['status'] == 'pending').length;

    ServerLogger.info('统计信息:');
    ServerLogger.info('  总迁移数: ${status.length}');
    ServerLogger.info('  已完成: $completed');
    ServerLogger.info('  已更改: $changed');
    ServerLogger.info('  待执行: $pending');
  } catch (error, stackTrace) {
    ServerLogger.error('获取迁移状态失败', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 显示种子数据状态
Future<void> _showSeedStatus(MigrationService migrationService) async {
  try {
    final status = await migrationService.getSeedStatus();

    if (status.isEmpty) {
      ServerLogger.info('没有找到已注册的种子数据类');
      return;
    }

    ServerLogger.info('种子数据状态:');
    ServerLogger.info('=' * 80);

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

      ServerLogger.info('$statusIcon $name - $statusDesc');
      ServerLogger.info('   描述: $description');
      ServerLogger.info('   创建时间: $createdAt');
      ServerLogger.info('   种子哈希: ${seedHash.substring(0, 8)}...');

      if (executed) {
        final executedAt = seed['executed_at'];
        final executedHash = seed['executed_hash'] as String;

        ServerLogger.info('   执行时间: $executedAt');
        ServerLogger.info('   执行时哈希: ${executedHash.substring(0, 8)}...');

        if (changed) {
          ServerLogger.info('   ⚠️  种子数据类已更改');
        }
      }

      ServerLogger.info('');
    }

    // 统计信息
    final completed = status.where((s) => s['status'] == 'completed').length;
    final changed = status.where((s) => s['status'] == 'changed').length;
    final pending = status.where((s) => s['status'] == 'pending').length;

    ServerLogger.info('统计信息:');
    ServerLogger.info('  总种子数: ${status.length}');
    ServerLogger.info('  已完成: $completed');
    ServerLogger.info('  已更改: $changed');
    ServerLogger.info('  待执行: $pending');
  } catch (error, stackTrace) {
    ServerLogger.error('获取种子数据状态失败', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 验证表迁移
Future<void> _validateTableMigration(MigrationService migrationService, String tableName) async {
  try {
    ServerLogger.info('开始验证表迁移: $tableName');

    // 迁移前检查
    final preCheckResults = await migrationService.preMigrationCheck(tableName);
    ServerLogger.info('迁移前检查完成');

    // 模拟迁移（这里只是示例，实际应该执行真实的迁移）
    ServerLogger.info('执行迁移操作...');

    // 迁移后验证
    final validationResults = await migrationService.postMigrationValidation(tableName, preCheckResults);

    if (validationResults['passed']) {
      ServerLogger.info('✅ 迁移验证通过');
      final rowCountChange = validationResults['row_count_change'] as int? ?? 0;
      if (rowCountChange != 0) {
        ServerLogger.info('数据行数变化: $rowCountChange');
      }
    } else {
      ServerLogger.error('❌ 迁移验证失败');
      final errors = validationResults['errors'] as List<String>;
      for (final error in errors) {
        ServerLogger.error('  - $error');
      }
    }
  } catch (error, stackTrace) {
    ServerLogger.error('验证表迁移失败: $tableName', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 迁移前检查
Future<void> _preMigrationCheck(MigrationService migrationService, String tableName) async {
  try {
    ServerLogger.info('开始迁移前检查: $tableName');

    final preCheckResults = await migrationService.preMigrationCheck(tableName);

    ServerLogger.info('检查结果:');
    ServerLogger.info('  表存在: ${preCheckResults['table_exists']}');

    if (preCheckResults['table_exists']) {
      final columns = preCheckResults['columns'] as List<dynamic>;
      final constraints = preCheckResults['constraints'] as List<dynamic>;
      final indexes = preCheckResults['indexes'] as List<dynamic>;
      final rowCount = preCheckResults['row_count'] as int;

      ServerLogger.info('  列数: ${columns.length}');
      ServerLogger.info('  约束数: ${constraints.length}');
      ServerLogger.info('  索引数: ${indexes.length}');
      ServerLogger.info('  行数: $rowCount');

      ServerLogger.info('列详情:');
      for (final column in columns) {
        final name = column['name'] as String;
        final type = column['type'] as String;
        final nullable = column['nullable'] as bool;
        final maxLength = column['max_length'];
        ServerLogger.info('  - $name: $type${maxLength != null ? '($maxLength)' : ''} (${nullable ? '可空' : '非空'})');
      }
    }
  } catch (error, stackTrace) {
    ServerLogger.error('迁移前检查失败: $tableName', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 显示表外键
Future<void> _showTableForeignKeys(MigrationService migrationService, String tableName) async {
  try {
    ServerLogger.info('查看表外键: $tableName');

    final foreignKeys = await migrationService.getTableForeignKeys(tableName);

    if (foreignKeys.isEmpty) {
      ServerLogger.info('该表没有外键约束');
      return;
    }

    ServerLogger.info('外键约束:');
    for (final fk in foreignKeys) {
      final constraintName = fk['constraint_name'] as String;
      final columnName = fk['column_name'] as String;
      final foreignTableName = fk['foreign_table_name'] as String;
      final foreignColumnName = fk['foreign_column_name'] as String;

      ServerLogger.info('  - $constraintName: $columnName -> $foreignTableName.$foreignColumnName');
    }
  } catch (error, stackTrace) {
    ServerLogger.error('获取表外键失败: $tableName', error: error, stackTrace: stackTrace);
    rethrow;
  }
}

/// 列出备份文件
Future<void> _listBackups(MigrationService migrationService) async {
  try {
    ServerLogger.info('数据库备份列表:');

    final backups = await migrationService.listBackups();

    if (backups.isEmpty) {
      ServerLogger.info('没有找到备份文件');
      return;
    }

    ServerLogger.info('=' * 80);

    for (final backup in backups) {
      final name = backup['name'] as String;
      final path = backup['path'] as String;
      final size = backup['size'] as String;
      final createdAt = backup['created_at'] as DateTime;

      ServerLogger.info('📁 $name');
      ServerLogger.info('   路径: $path');
      ServerLogger.info('   大小: $size');
      ServerLogger.info('   创建时间: $createdAt');
      ServerLogger.info('');
    }

    ServerLogger.info('总计: ${backups.length} 个备份文件');
  } catch (error, stackTrace) {
    ServerLogger.error('获取备份列表失败', error: error, stackTrace: stackTrace);
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
  MigrationService.registerMigration('009_translation_entries_table', () => Migration009TranslationEntriesTable());
  MigrationService.registerMigration('010_translation_history_table', () => Migration010TranslationHistoryTable());
  MigrationService.registerMigration('011_system_configs_table', () => Migration011SystemConfigsTable());
  MigrationService.registerMigration('012_user_sessions_table', () => Migration012UserSessionsTable());
  MigrationService.registerMigration('013_file_uploads_table', () => Migration013FileUploadsTable());
  MigrationService.registerMigration('014_notifications_table', () => Migration014NotificationsTable());
  MigrationService.registerMigration('015_audit_logs_table', () => Migration015AuditLogsTable());
  MigrationService.registerMigration('016_user_settings_table', () => Migration016UserSettingsTable());
  MigrationService.registerMigration(
      '017_user_translation_configs_table', () => Migration017UserTranslationConfigsTable());
  MigrationService.registerMigration('018_project_members_table', () => Migration018ProjectMembersTable());
  MigrationService.registerMigration('019_notification_settings_table', () => Migration019NotificationSettingsTable());
  MigrationService.registerMigration(
      '020_project_member_invite_logs_table', () => Migration020ProjectMemberInviteLogsTable());
  MigrationService.registerMigration(
      '021_project_translation_stats_table', () => Migration021ProjectTranslationStatsTable());
  MigrationService.registerMigration(
      '022_translation_batch_jobs_table', () => Migration022TranslationBatchJobsTable());
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
