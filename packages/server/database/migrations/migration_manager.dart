import 'dart:developer';

import 'package:postgres/postgres.dart';

// 导入所有迁移文件
import '001_users_table.dart';
import '002_roles_table.dart';
import '003_permissions_table.dart';
import '004_role_permissions_table.dart';
import '005_languages_table.dart';
import '006_projects_table.dart';
import '007_user_roles_table.dart';
import '008_project_languages_table.dart';
import '009_user_translation_providers_table.dart';
import '010_translation_entries_table.dart';
import '011_translation_history_table.dart';
import '012_system_configs_table.dart';
import '013_user_sessions_table.dart';
import '014_file_uploads_table.dart';
import '015_notifications_table.dart';
import '016_audit_logs_table.dart';
import 'base_migration.dart';

/// 迁移管理器
/// 创建时间: 2024-12-26
/// 描述: 管理和执行数据库迁移
class MigrationManager {
  late PostgreSQLConnection _connection;
  late String _tablePrefix;
  final List<BaseMigration> _migrations = [];

  /// 初始化迁移管理器
  Future<void> initialize({
    required String host,
    required int port,
    required String database,
    required String username,
    required String password,
    required String tablePrefix,
  }) async {
    try {
      _connection = PostgreSQLConnection(
        host,
        port,
        database,
        username: username,
        password: password,
      );

      _tablePrefix = tablePrefix;

      await _connection.open();
      log('数据库连接成功', name: 'MigrationManager');

      // 初始化所有迁移
      _initializeMigrations();
    } catch (error, stackTrace) {
      log('数据库连接失败', error: error, stackTrace: stackTrace, name: 'MigrationManager');
      rethrow;
    }
  }

  /// 初始化所有迁移
  void _initializeMigrations() {
    _migrations.addAll([
      Migration001UsersTable(),
      Migration002RolesTable(),
      Migration003PermissionsTable(),
      Migration004RolePermissionsTable(),
      Migration005LanguagesTable(),
      Migration006ProjectsTable(),
      Migration007UserRolesTable(),
      Migration008ProjectLanguagesTable(),
      Migration009UserTranslationProvidersTable(),
      Migration010TranslationEntriesTable(),
      Migration011TranslationHistoryTable(),
      Migration012SystemConfigsTable(),
      Migration013UserSessionsTable(),
      Migration014FileUploadsTable(),
      Migration015NotificationsTable(),
      Migration016AuditLogsTable(),
    ]);

    // 为每个迁移设置连接和表前缀
    for (final migration in _migrations) {
      _setMigrationConnection(migration);
    }

    log('已初始化 ${_migrations.length} 个迁移', name: 'MigrationManager');
  }

  /// 为迁移设置连接
  void _setMigrationConnection(BaseMigration migration) {
    // 设置数据库连接
    migration.setConnection(_connection);
  }

  /// 创建迁移记录表
  Future<void> _createMigrationsTable() async {
    try {
      await _connection.execute('''
        CREATE TABLE IF NOT EXISTS ${_tablePrefix}migrations (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) UNIQUE NOT NULL,
          description TEXT,
          created_at VARCHAR(50),
          executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
      ''');
      log('迁移记录表创建成功', name: 'MigrationManager');
    } catch (error, stackTrace) {
      log('创建迁移记录表失败', error: error, stackTrace: stackTrace, name: 'MigrationManager');
      rethrow;
    }
  }

  /// 检查迁移是否已执行
  Future<bool> _isMigrationExecuted(String migrationName) async {
    try {
      final result = await _connection.query(
        'SELECT COUNT(*) FROM ${_tablePrefix}migrations WHERE name = @name',
        substitutionValues: {'name': migrationName},
      );
      return result.first.first > 0;
    } catch (error, stackTrace) {
      log('检查迁移状态失败', error: error, stackTrace: stackTrace, name: 'MigrationManager');
      return false;
    }
  }

  /// 记录迁移执行
  Future<void> _recordMigration(BaseMigration migration) async {
    try {
      await _connection.execute('''
        INSERT INTO ${_tablePrefix}migrations (name, description, created_at) 
        VALUES (@name, @description, @createdAt)
      ''', substitutionValues: {
        'name': migration.name,
        'description': migration.description,
        'createdAt': migration.createdAt,
      });
      log('迁移记录已保存: ${migration.name}', name: 'MigrationManager');
    } catch (error, stackTrace) {
      log('保存迁移记录失败', error: error, stackTrace: stackTrace, name: 'MigrationManager');
      rethrow;
    }
  }

  /// 执行所有迁移
  Future<void> runMigrations() async {
    try {
      log('开始执行数据库迁移', name: 'MigrationManager');

      // 创建迁移记录表
      await _createMigrationsTable();

      // 按名称排序迁移
      _migrations.sort((a, b) => a.name.compareTo(b.name));

      for (final migration in _migrations) {
        if (await _isMigrationExecuted(migration.name)) {
          log('迁移已执行，跳过: ${migration.name}', name: 'MigrationManager');
          continue;
        }

        log('执行迁移: ${migration.name} - ${migration.description}', name: 'MigrationManager');

        try {
          // 执行迁移
          await migration.up();

          // 记录迁移执行
          await _recordMigration(migration);

          log('迁移完成: ${migration.name}', name: 'MigrationManager');
        } catch (error, stackTrace) {
          log('迁移执行失败: ${migration.name}', error: error, stackTrace: stackTrace, name: 'MigrationManager');
          rethrow;
        }
      }

      log('所有迁移执行完成', name: 'MigrationManager');
    } catch (error, stackTrace) {
      log('执行迁移失败', error: error, stackTrace: stackTrace, name: 'MigrationManager');
      rethrow;
    }
  }

  /// 回滚到指定迁移
  Future<void> rollbackTo(String migrationName) async {
    try {
      log('开始回滚到迁移: $migrationName', name: 'MigrationManager');

      // 获取需要回滚的迁移（按时间倒序）
      final result = await _connection.query('''
        SELECT name FROM ${_tablePrefix}migrations 
        WHERE executed_at > (
          SELECT executed_at FROM ${_tablePrefix}migrations WHERE name = @name
        )
        ORDER BY executed_at DESC
      ''', substitutionValues: {'name': migrationName});

      for (final row in result) {
        final name = row.first as String;
        final migration = _migrations.firstWhere((m) => m.name == name);

        log('回滚迁移: $name', name: 'MigrationManager');

        try {
          // 执行回滚
          await migration.down();

          // 删除迁移记录
          await _connection.execute(
            'DELETE FROM ${_tablePrefix}migrations WHERE name = @name',
            substitutionValues: {'name': name},
          );

          log('迁移回滚完成: $name', name: 'MigrationManager');
        } catch (error, stackTrace) {
          log('迁移回滚失败: $name', error: error, stackTrace: stackTrace, name: 'MigrationManager');
          rethrow;
        }
      }

      log('回滚到 $migrationName 完成', name: 'MigrationManager');
    } catch (error, stackTrace) {
      log('回滚迁移失败', error: error, stackTrace: stackTrace, name: 'MigrationManager');
      rethrow;
    }
  }

  /// 获取迁移状态
  Future<List<Map<String, dynamic>>> getMigrationStatus() async {
    try {
      final result = await _connection.query('''
        SELECT name, description, created_at, executed_at 
        FROM ${_tablePrefix}migrations 
        ORDER BY executed_at ASC
      ''');

      return result
          .map((row) => {
                'name': row[0],
                'description': row[1],
                'createdAt': row[2],
                'executedAt': row[3],
              })
          .toList();
    } catch (error, stackTrace) {
      log('获取迁移状态失败', error: error, stackTrace: stackTrace, name: 'MigrationManager');
      return [];
    }
  }

  /// 关闭数据库连接
  Future<void> close() async {
    try {
      await _connection.close();
      log('数据库连接已关闭', name: 'MigrationManager');
    } catch (error, stackTrace) {
      log('关闭数据库连接失败', error: error, stackTrace: stackTrace, name: 'MigrationManager');
      rethrow;
    }
  }
}
