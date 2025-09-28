import 'dart:io';

import 'package:path/path.dart' as path;

import '../config/server_config.dart';
import '../utils/sql_parser.dart';
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
      _logger.info('开始运行种子数据');

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
        // 检查种子数据是否需要执行
        if (await _shouldExecuteSeedFile(seedFile)) {
          await _executeSeedFile(seedFile);
        } else {
          final fileName = path.basename(seedFile);
          _logger.info('跳过种子数据执行: $fileName (数据已存在)');
          _logger.info('跳过种子数据执行: $fileName');
        }
      }

      _logger.info('所有种子数据执行完成');
    } catch (error, stackTrace) {
      _logger.error('种子数据执行失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 确保迁移记录表存在
  Future<void> _ensureMigrationTableExists() async {
    final tableName = '${_config.tablePrefix}schema_migrations';
    final sql = '''
      CREATE TABLE IF NOT EXISTS $tableName (
        id SERIAL PRIMARY KEY,
        migration_name VARCHAR(255) UNIQUE NOT NULL,
        executed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
      );
    ''';

    await _databaseService.query(sql);
    _logger.info('确保迁移记录表存在: $tableName');
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
      final tableName = '${_config.tablePrefix}schema_migrations';
      final result = await _databaseService.query('SELECT migration_name FROM $tableName ORDER BY executed_at');

      return result.map((row) => row[0] as String).toSet();
    } catch (error) {
      // 如果表不存在，返回空集合
      _logger.info('获取已执行迁移失败，可能表不存在');
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

      // 应用表前缀
      final prefixedSql = SqlParser.applyTablePrefix(sqlContent, _config.tablePrefix);
      _logger.info('应用表前缀: ${_config.tablePrefix}');

      // 在事务中执行迁移
      await _databaseService.transaction(() async {
        // 分割SQL语句并逐个执行
        final statements = SqlParser.splitSqlStatements(prefixedSql);
        for (final statement in statements) {
          if (statement.trim().isNotEmpty) {
            await _databaseService.query(statement);
          }
        }

        // 记录迁移执行（使用带前缀的表名）
        final migrationsTableName = '${_config.tablePrefix}schema_migrations';
        await _databaseService
            .query('INSERT INTO $migrationsTableName (migration_name) VALUES (@name)', {'name': fileName});
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

      // 应用表前缀
      final prefixedSql = SqlParser.applyTablePrefix(sqlContent, _config.tablePrefix);
      _logger.info('应用表前缀到种子数据: ${_config.tablePrefix}');

      // 执行种子数据SQL
      await _databaseService.query(prefixedSql);

      _logger.info('种子数据执行成功: $fileName');
    } catch (error, stackTrace) {
      _logger.error('种子数据执行失败: $fileName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查表中是否有数据
  Future<bool> _tableHasData(String tableName) async {
    try {
      final query = SqlParser.buildTableHasDataQuery(tableName, _config.tablePrefix);
      final result = await _databaseService.query(query);
      return (result.first[0] as int) > 0;
    } catch (error, stackTrace) {
      _logger.error('检查表数据失败: $tableName', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 判断种子数据文件是否需要执行
  Future<bool> _shouldExecuteSeedFile(String filePath) async {
    try {
      final fileName = path.basename(filePath);

      // 根据文件名判断需要检查的表
      if (fileName.contains('roles')) {
        return !await _tableHasData('roles');
      } else if (fileName.contains('permissions')) {
        return !await _tableHasData('permissions');
      } else if (fileName.contains('languages')) {
        return !await _tableHasData('languages');
      } else if (fileName.contains('system_configs')) {
        return !await _tableHasData('system_configs');
      } else if (fileName.contains('users')) {
        return !await _tableHasData('users');
      }

      // 默认检查用户表（作为通用判断）
      return !await _tableHasData('users');
    } catch (error, stackTrace) {
      _logger.error('判断种子数据执行失败: $filePath', error: error, stackTrace: stackTrace);
      // 如果判断失败，默认执行
      return true;
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

      // 从记录中删除迁移（使用带前缀的表名）
      final tableName = '${_config.tablePrefix}schema_migrations';
      await _databaseService.query('DELETE FROM $tableName WHERE migration_name = @name', {'name': migrationName});

      _logger.info('迁移回滚成功: $migrationName');
    } catch (error, stackTrace) {
      _logger.error('迁移回滚失败: $migrationName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 运行迁移和种子数据
  Future<void> runMigrationsAndSeeds() async {
    try {
      _logger.info('开始运行迁移和种子数据...');

      // 先运行迁移
      await runMigrations();

      // 再运行种子数据
      await runSeeds();

      _logger.info('迁移和种子数据执行完成');
    } catch (error, stackTrace) {
      _logger.error('迁移和种子数据执行失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查表结构差异
  Future<Map<String, dynamic>> checkTableStructure(String tableName) async {
    try {
      final prefixedTableName = '${_config.tablePrefix}$tableName';

      // 检查表是否存在
      final tableExistsQuery = SqlParser.buildTableExistsQuery(tableName, '');
      final tableExists = await _databaseService.query(tableExistsQuery);
      final exists = (tableExists.first[0] as bool);

      if (!exists) {
        return {'exists': false, 'message': '表 $prefixedTableName 不存在'};
      }

      // 获取表结构信息
      final structureQuery = '''
        SELECT 
          column_name,
          data_type,
          character_maximum_length,
          is_nullable,
          column_default
        FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = '$prefixedTableName'
        ORDER BY ordinal_position;
      ''';

      final columns = await _databaseService.query(structureQuery);

      return {
        'exists': true,
        'table_name': prefixedTableName,
        'columns': columns
            .map((row) => {
                  'name': row[0],
                  'type': row[1],
                  'max_length': row[2],
                  'nullable': row[3] == 'YES',
                  'default': row[4],
                })
            .toList()
      };
    } catch (error, stackTrace) {
      _logger.error('检查表结构失败: $tableName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地添加列
  Future<void> addColumnSafely(String tableName, String columnName, String columnDefinition) async {
    try {
      final prefixedTableName = '${_config.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName ADD COLUMN IF NOT EXISTS $columnName $columnDefinition';

      await _databaseService.query(sql);
      _logger.info('成功添加列: $prefixedTableName.$columnName');
    } catch (error, stackTrace) {
      _logger.error('添加列失败: $tableName.$columnName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地删除列
  Future<void> dropColumnSafely(String tableName, String columnName) async {
    try {
      final prefixedTableName = '${_config.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName DROP COLUMN IF EXISTS $columnName';

      await _databaseService.query(sql);
      _logger.info('成功删除列: $prefixedTableName.$columnName');
    } catch (error, stackTrace) {
      _logger.error('删除列失败: $tableName.$columnName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地修改列类型
  Future<void> alterColumnTypeSafely(String tableName, String columnName, String newType) async {
    try {
      final prefixedTableName = '${_config.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName ALTER COLUMN $columnName TYPE $newType';

      await _databaseService.query(sql);
      _logger.info('成功修改列类型: $prefixedTableName.$columnName -> $newType');
    } catch (error, stackTrace) {
      _logger.error('修改列类型失败: $tableName.$columnName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地添加约束
  Future<void> addConstraintSafely(String tableName, String constraintName, String constraintDefinition) async {
    try {
      final prefixedTableName = '${_config.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName ADD CONSTRAINT IF NOT EXISTS $constraintName $constraintDefinition';

      await _databaseService.query(sql);
      _logger.info('成功添加约束: $prefixedTableName.$constraintName');
    } catch (error, stackTrace) {
      _logger.error('添加约束失败: $tableName.$constraintName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地删除约束
  Future<void> dropConstraintSafely(String tableName, String constraintName) async {
    try {
      final prefixedTableName = '${_config.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName DROP CONSTRAINT IF EXISTS $constraintName';

      await _databaseService.query(sql);
      _logger.info('成功删除约束: $prefixedTableName.$constraintName');
    } catch (error, stackTrace) {
      _logger.error('删除约束失败: $tableName.$constraintName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 显示帮助信息
  void showHelpMigration() {
    _logger.info('''
数据库迁移工具使用说明:

用法: dart migrate.dart [命令] [参数]

命令:
  migrate     运行所有未执行的迁移
  seed        运行种子数据
  status      显示迁移状态
  rollback    回滚指定的迁移 (仅开发环境)
  check       检查表结构
  help        显示此帮助信息

示例:
  dart migrate.dart                    # 运行迁移和种子数据
  dart migrate.dart migrate            # 仅运行迁移
  dart migrate.dart seed               # 仅运行种子数据
  dart migrate.dart status             # 查看迁移状态
  dart migrate.dart rollback 001_create_core_tables  # 回滚指定迁移
  dart migrate.dart check users        # 检查用户表结构
''');
  }
}
