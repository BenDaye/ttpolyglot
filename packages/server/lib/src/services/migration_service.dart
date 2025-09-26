import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart' as path;

import '../config/server_config.dart';
import 'database_service.dart';

/// 数据库迁移服务
class MigrationService {
  final DatabaseService _databaseService;
  final ServerConfig _config;

  MigrationService(this._databaseService, this._config);

  /// 运行所有未执行的迁移
  Future<void> runMigrations() async {
    try {
      log('开始运行数据库迁移...', name: 'MigrationService');

      // 确保迁移记录表存在
      await _ensureMigrationTableExists();

      // 获取所有迁移文件
      final migrationFiles = await _getMigrationFiles();

      // 获取已执行的迁移
      final executedMigrations = await _getExecutedMigrations();

      // 筛选未执行的迁移
      final pendingMigrations =
          migrationFiles.where((file) => !executedMigrations.contains(_getFileNameWithoutExtension(file))).toList();

      if (pendingMigrations.isEmpty) {
        log('没有待执行的迁移', name: 'MigrationService');
        return;
      }

      log('发现 ${pendingMigrations.length} 个待执行的迁移', name: 'MigrationService');

      // 按文件名排序执行迁移
      pendingMigrations.sort((a, b) => path.basename(a).compareTo(path.basename(b)));

      for (final migrationFile in pendingMigrations) {
        await _executeMigration(migrationFile);
      }

      log('所有迁移执行完成', name: 'MigrationService');
    } catch (error, stackTrace) {
      log('迁移执行失败', error: error, stackTrace: stackTrace, name: 'MigrationService');
      rethrow;
    }
  }

  /// 运行种子数据
  Future<void> runSeeds() async {
    try {
      log('开始运行种子数据...', name: 'MigrationService');

      // 检查是否已经有数据（避免重复插入）
      final userCount = await _getUserCount();
      if (userCount > 0) {
        log('检测到已有用户数据，跳过种子数据执行', name: 'MigrationService');
        return;
      }

      // 获取所有种子文件
      final seedFiles = await _getSeedFiles();

      if (seedFiles.isEmpty) {
        log('没有找到种子数据文件', name: 'MigrationService');
        return;
      }

      log('发现 ${seedFiles.length} 个种子数据文件', name: 'MigrationService');

      // 按文件名排序执行种子数据
      seedFiles.sort((a, b) => path.basename(a).compareTo(path.basename(b)));

      for (final seedFile in seedFiles) {
        await _executeSeedFile(seedFile);
      }

      log('所有种子数据执行完成', name: 'MigrationService');
    } catch (error, stackTrace) {
      log('种子数据执行失败', error: error, stackTrace: stackTrace, name: 'MigrationService');
      rethrow;
    }
  }

  /// 确保迁移记录表存在
  Future<void> _ensureMigrationTableExists() async {
    final sql = '''
      CREATE TABLE IF NOT EXISTS schema_migrations (
        id SERIAL PRIMARY KEY,
        migration_name VARCHAR(255) UNIQUE NOT NULL,
        executed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
      );
    ''';

    await _databaseService.query(sql);
  }

  /// 获取所有迁移文件
  Future<List<String>> _getMigrationFiles() async {
    final migrationsDir = Directory('database/migrations');

    if (!await migrationsDir.exists()) {
      log('迁移目录不存在: ${migrationsDir.path}', name: 'MigrationService');
      return [];
    }

    final files = await migrationsDir
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.sql'))
        .cast<File>()
        .map((file) => file.path)
        .toList();

    return files;
  }

  /// 获取所有种子文件
  Future<List<String>> _getSeedFiles() async {
    final seedsDir = Directory('database/seeds');

    if (!await seedsDir.exists()) {
      log('种子数据目录不存在: ${seedsDir.path}', name: 'MigrationService');
      return [];
    }

    final files = await seedsDir
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.sql'))
        .cast<File>()
        .map((file) => file.path)
        .toList();

    return files;
  }

  /// 获取已执行的迁移
  Future<Set<String>> _getExecutedMigrations() async {
    try {
      final result = await _databaseService.query('SELECT migration_name FROM schema_migrations ORDER BY executed_at');

      return result.map((row) => row[0] as String).toSet();
    } catch (error) {
      // 如果表不存在，返回空集合
      return <String>{};
    }
  }

  /// 执行单个迁移文件
  Future<void> _executeMigration(String filePath) async {
    final fileName = _getFileNameWithoutExtension(filePath);
    log('执行迁移: $fileName', name: 'MigrationService');

    try {
      // 读取SQL文件
      final file = File(filePath);
      final sqlContent = await file.readAsString();

      // 在事务中执行迁移
      await _databaseService.transaction(() async {
        // 执行迁移SQL
        await _databaseService.query(sqlContent);

        // 记录迁移执行
        await _databaseService
            .query('INSERT INTO schema_migrations (migration_name) VALUES (@name)', {'name': fileName});
      });

      log('迁移执行成功: $fileName', name: 'MigrationService');
    } catch (error, stackTrace) {
      log('迁移执行失败: $fileName', error: error, stackTrace: stackTrace, name: 'MigrationService');
      rethrow;
    }
  }

  /// 执行种子数据文件
  Future<void> _executeSeedFile(String filePath) async {
    final fileName = path.basename(filePath);
    log('执行种子数据: $fileName', name: 'MigrationService');

    try {
      // 读取SQL文件
      final file = File(filePath);
      final sqlContent = await file.readAsString();

      // 执行种子数据SQL
      await _databaseService.query(sqlContent);

      log('种子数据执行成功: $fileName', name: 'MigrationService');
    } catch (error, stackTrace) {
      log('种子数据执行失败: $fileName', error: error, stackTrace: stackTrace, name: 'MigrationService');
      rethrow;
    }
  }

  /// 获取用户数量（用于判断是否需要执行种子数据）
  Future<int> _getUserCount() async {
    try {
      final result = await _databaseService.query('SELECT COUNT(*) FROM users');
      return result.first[0] as int;
    } catch (error) {
      // 如果表不存在，返回0
      return 0;
    }
  }

  /// 获取不带扩展名的文件名
  String _getFileNameWithoutExtension(String filePath) {
    return path.basenameWithoutExtension(filePath);
  }

  /// 获取迁移状态
  Future<List<Map<String, dynamic>>> getMigrationStatus() async {
    try {
      // 获取所有迁移文件
      final migrationFiles = await _getMigrationFiles();
      migrationFiles.sort((a, b) => path.basename(a).compareTo(path.basename(b)));

      // 获取已执行的迁移
      final executedMigrations = await _getExecutedMigrations();

      final status = migrationFiles.map((file) {
        final fileName = _getFileNameWithoutExtension(file);
        final isExecuted = executedMigrations.contains(fileName);

        return {
          'name': fileName,
          'file_path': file,
          'executed': isExecuted,
          'status': isExecuted ? 'completed' : 'pending',
        };
      }).toList();

      return status;
    } catch (error, stackTrace) {
      log('获取迁移状态失败', error: error, stackTrace: stackTrace, name: 'MigrationService');
      rethrow;
    }
  }

  /// 回滚迁移（仅用于开发环境）
  Future<void> rollbackMigration(String migrationName) async {
    if (!_config.isDevelopment) {
      throw Exception('迁移回滚仅在开发环境中可用');
    }

    try {
      log('回滚迁移: $migrationName', name: 'MigrationService');

      // 从记录中删除迁移
      await _databaseService
          .query('DELETE FROM schema_migrations WHERE migration_name = @name', {'name': migrationName});

      log('迁移回滚成功: $migrationName', name: 'MigrationService');
    } catch (error, stackTrace) {
      log('迁移回滚失败: $migrationName', error: error, stackTrace: stackTrace, name: 'MigrationService');
      rethrow;
    }
  }
}
