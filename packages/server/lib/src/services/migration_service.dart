import 'dart:io';

import 'package:path/path.dart' as path;

import '../config/server_config.dart';
import '../utils/structured_logger.dart';
import 'database_service.dart';

/// 数据库迁移服务
class MigrationService {
  final DatabaseService _databaseService;
  final ServerConfig _config;
  static final _logger = LoggerFactory.getLogger('MigrationService');

  MigrationService(this._databaseService, this._config);

  /// 运行所有未执行的迁移
  Future<void> runMigrations() async {
    try {
      _logger.info('开始运行数据库迁移...');

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
        _logger.info('没有待执行的迁移');
        return;
      }

      _logger.info('发现 ${pendingMigrations.length} 个待执行的迁移');

      // 按文件名排序执行迁移
      pendingMigrations.sort((a, b) => path.basename(a).compareTo(path.basename(b)));

      for (final migrationFile in pendingMigrations) {
        await _executeMigration(migrationFile);
      }

      _logger.info('所有迁移执行完成');
    } catch (error, stackTrace) {
      _logger.error('迁移执行失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 运行种子数据
  Future<void> runSeeds() async {
    try {
      _logger.info('开始运行种子数据...');

      // 检查是否已经有数据（避免重复插入）
      final userCount = await _getUserCount();
      if (userCount > 0) {
        _logger.info('检测到已有用户数据，跳过种子数据执行');
        return;
      }

      // 获取所有种子文件
      final seedFiles = await _getSeedFiles();

      if (seedFiles.isEmpty) {
        _logger.info('没有找到种子数据文件');
        return;
      }

      _logger.info('发现 ${seedFiles.length} 个种子数据文件');

      // 按文件名排序执行种子数据
      seedFiles.sort((a, b) => path.basename(a).compareTo(path.basename(b)));

      for (final seedFile in seedFiles) {
        await _executeSeedFile(seedFile);
      }

      _logger.info('所有种子数据执行完成');
    } catch (error, stackTrace) {
      _logger.error('种子数据执行失败', error: error, stackTrace: stackTrace);
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
      _logger.info('迁移目录不存在: ${migrationsDir.path}');
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
      _logger.info('种子数据目录不存在: ${seedsDir.path}');
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
    _logger.info('执行迁移: $fileName');

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

      _logger.info('迁移执行成功: $fileName');
    } catch (error, stackTrace) {
      _logger.error('迁移执行失败: $fileName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 执行种子数据文件
  Future<void> _executeSeedFile(String filePath) async {
    final fileName = path.basename(filePath);
    _logger.info('执行种子数据: $fileName');

    try {
      // 读取SQL文件
      final file = File(filePath);
      final sqlContent = await file.readAsString();

      // 执行种子数据SQL
      await _databaseService.query(sqlContent);

      _logger.info('种子数据执行成功: $fileName');
    } catch (error, stackTrace) {
      _logger.error('种子数据执行失败: $fileName', error: error, stackTrace: stackTrace);
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
      _logger.error('获取迁移状态失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 回滚迁移（仅用于开发环境）
  Future<void> rollbackMigration(String migrationName) async {
    if (!_config.isDevelopment) {
      throw Exception('迁移回滚仅在开发环境中可用');
    }

    try {
      _logger.info('回滚迁移: $migrationName');

      // 从记录中删除迁移
      await _databaseService
          .query('DELETE FROM schema_migrations WHERE migration_name = @name', {'name': migrationName});

      _logger.info('迁移回滚成功: $migrationName');
    } catch (error, stackTrace) {
      _logger.error('迁移回滚失败: $migrationName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
