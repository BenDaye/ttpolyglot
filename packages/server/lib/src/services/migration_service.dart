import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;

import '../config/server_config.dart';
import '../utils/structured_logger.dart';
import 'database_service.dart';

/// 迁移类基础接口
abstract class BaseMigration {
  String get name;
  String get description;
  String get createdAt;
  Future<void> up();
  Future<void> down();
}

/// 数据库迁移服务
/// 根据字段更新最佳实践指南实现的安全迁移服务
class MigrationService {
  final DatabaseService _databaseService;
  static final _logger = LoggerFactory.getLogger('MigrationService');

  MigrationService(this._databaseService);

  /// 迁移类工厂函数映射
  static final Map<String, BaseMigration Function()> _migrationFactories = {};

  /// 注册迁移类
  static void registerMigration(String name, BaseMigration Function() factory) {
    _migrationFactories[name] = factory;
  }

  /// 获取所有已注册的迁移
  static Map<String, BaseMigration Function()> get registeredMigrations => Map.unmodifiable(_migrationFactories);

  /// 运行所有未执行的迁移
  Future<void> runMigrations() async {
    try {
      _logger.info('开始运行数据库迁移...');

      // 确保迁移记录表存在
      await _ensureMigrationTableExists();

      // 获取已注册的迁移
      final registeredMigrations = _migrationFactories;

      // 获取已执行的迁移
      final executedMigrations = await _getExecutedMigrations();

      // 筛选未执行的迁移
      final pendingMigrations = <String>[];
      for (final migrationName in registeredMigrations.keys) {
        // 检查迁移是否已执行
        if (!executedMigrations.containsKey(migrationName)) {
          // 新迁移
          pendingMigrations.add(migrationName);
          _logger.info('发现新迁移: $migrationName');
        } else {
          // 迁移已执行，跳过
          _logger.info('迁移已执行，跳过: $migrationName');
        }
      }

      if (pendingMigrations.isEmpty) {
        _logger.info('没有待执行的迁移');
        return;
      }

      _logger.info('发现 ${pendingMigrations.length} 个待执行的迁移');

      // 按迁移名称排序执行迁移
      pendingMigrations.sort();

      for (final migrationName in pendingMigrations) {
        await _executeMigrationClass(migrationName);
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
    final tableName = '${ServerConfig.tablePrefix}schema_migrations';
    final sql = '''CREATE TABLE IF NOT EXISTS $tableName (
        id SERIAL PRIMARY KEY,
        migration_name VARCHAR(255) UNIQUE NOT NULL,
        file_path VARCHAR(500) NOT NULL,
        file_hash VARCHAR(64) NOT NULL,
        executed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
      )''';

    await _databaseService.query(sql);
    _logger.info('确保迁移记录表存在: $tableName');
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
  Future<Map<String, Map<String, dynamic>>> _getExecutedMigrations() async {
    try {
      final tableName = '${ServerConfig.tablePrefix}schema_migrations';
      final result = await _databaseService.query('''
        SELECT migration_name, file_path, file_hash, executed_at 
        FROM $tableName 
        ORDER BY executed_at
      ''');

      final executedMigrations = <String, Map<String, dynamic>>{};
      for (final row in result) {
        final migrationName = row[0] as String;
        executedMigrations[migrationName] = {
          'name': migrationName,
          'file_path': row[1] as String,
          'file_hash': row[2] as String,
          'executed_at': row[3],
        };
      }

      return executedMigrations;
    } catch (error) {
      // 如果表不存在，返回空集合
      _logger.info('获取已执行迁移失败，可能表不存在');
      return <String, Map<String, dynamic>>{};
    }
  }

  /// 执行单个迁移类
  Future<void> _executeMigrationClass(String migrationName) async {
    _logger.info('执行迁移: $migrationName');

    try {
      // 获取迁移工厂函数
      final factory = _migrationFactories[migrationName];
      if (factory == null) {
        throw Exception('未找到迁移: $migrationName');
      }

      // 创建迁移实例
      final migration = factory();

      // 在事务中执行迁移
      await _databaseService.transaction(() async {
        // 执行迁移的 up 方法
        await migration.up();

        // 记录迁移执行（使用带前缀的表名）
        final migrationsTableName = '${ServerConfig.tablePrefix}schema_migrations';

        // 插入迁移记录
        await _databaseService.query('''
          INSERT INTO $migrationsTableName (migration_name, file_path, file_hash) 
          VALUES (@name, @path, @hash)
        ''', {
          'name': migrationName,
          'path': 'class://$migrationName',
          'hash': _calculateClassHash(migrationName),
        });
        _logger.info('创建迁移记录: $migrationName');
      });

      _logger.info('迁移执行成功: $migrationName');
    } catch (error, stackTrace) {
      _logger.error('迁移执行失败: $migrationName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 计算迁移类的哈希值
  String _calculateClassHash(String migrationName) {
    // 对于类迁移，我们使用类名和描述的组合作为哈希
    final factory = _migrationFactories[migrationName];
    if (factory == null) return '';

    final migration = factory();
    final content = '${migration.name}:${migration.description}:${migration.createdAt}';
    final bytes = content.codeUnits;
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 执行种子数据文件
  Future<void> _executeSeedFile(String filePath) async {
    final fileName = path.basename(filePath);
    _logger.info('执行种子数据: $fileName');

    try {
      // 读取SQL文件
      final file = File(filePath);
      final sqlContent = await file.readAsString();

      // 应用表前缀（种子数据文件应该已经包含正确的表前缀）
      _logger.info('应用表前缀到种子数据: ${ServerConfig.tablePrefix}');

      // 执行种子数据SQL
      await _databaseService.query(sqlContent);

      _logger.info('种子数据执行成功: $fileName');
    } catch (error, stackTrace) {
      _logger.error('种子数据执行失败: $fileName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查表中是否有数据
  Future<bool> _tableHasData(String tableName) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final query = 'SELECT COUNT(*) FROM $prefixedTableName';
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

  /// 获取迁移状态
  Future<List<Map<String, dynamic>>> getMigrationStatus() async {
    try {
      // 获取所有已注册的迁移
      final registeredMigrations = _migrationFactories;

      // 获取已执行的迁移
      final executedMigrations = await _getExecutedMigrations();

      final status = <Map<String, dynamic>>[];
      for (final migrationName in registeredMigrations.keys) {
        final factory = registeredMigrations[migrationName]!;
        final migration = factory();
        final classHash = _calculateClassHash(migrationName);
        final executedMigration = executedMigrations[migrationName];

        bool isExecuted = false;
        bool isChanged = false;
        String statusText = 'pending';

        if (executedMigration != null) {
          isExecuted = true;
          final executedHash = executedMigration['file_hash'] as String;

          if (executedHash != classHash) {
            isChanged = true;
            statusText = 'changed';
          } else {
            statusText = 'completed';
          }
        }

        status.add({
          'name': migrationName,
          'description': migration.description,
          'created_at': migration.createdAt,
          'class_hash': classHash,
          'executed': isExecuted,
          'changed': isChanged,
          'status': statusText,
          'executed_at': executedMigration?['executed_at'],
          'executed_hash': executedMigration?['file_hash'],
        });
      }

      return status;
    } catch (error, stackTrace) {
      _logger.error('获取迁移状态失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 回滚迁移（仅用于开发环境）
  Future<void> rollbackMigration(String migrationName) async {
    if (!ServerConfig.isDevelopment) {
      throw Exception('迁移回滚仅在开发环境中可用');
    }

    try {
      _logger.info('回滚迁移: $migrationName');

      // 获取迁移工厂函数
      final factory = _migrationFactories[migrationName];
      if (factory == null) {
        throw Exception('未找到迁移: $migrationName');
      }

      // 创建迁移实例并执行 down 方法
      final migration = factory();

      // 在事务中执行回滚
      await _databaseService.transaction(() async {
        // 执行迁移的 down 方法
        await migration.down();

        // 从记录中删除迁移（使用带前缀的表名）
        final tableName = '${ServerConfig.tablePrefix}schema_migrations';
        final result = await _databaseService
            .query('DELETE FROM $tableName WHERE migration_name = @name', {'name': migrationName});

        if (result.isEmpty) {
          _logger.warn('未找到迁移记录: $migrationName');
        } else {
          _logger.info('迁移回滚成功: $migrationName');
        }
      });
    } catch (error, stackTrace) {
      _logger.error('迁移回滚失败: $migrationName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 生产环境回滚策略 - 创建回滚迁移文件
  Future<String> createRollbackMigration(String migrationName) async {
    try {
      _logger.info('为生产环境创建回滚迁移: $migrationName');

      // 查找原始迁移类
      final factory = _migrationFactories[migrationName];
      if (factory == null) {
        throw Exception('未找到迁移: $migrationName');
      }

      final migration = factory();

      // 生成回滚 SQL（基于迁移描述）
      final rollbackSql = _generateRollbackSqlFromClass(migration, migrationName);

      // 生成回滚迁移文件名
      final rollbackFileName = '${_getNextMigrationNumber()}_rollback_${migrationName}.sql';
      final rollbackPath = 'database/migrations/$rollbackFileName';

      // 创建回滚迁移文件
      final rollbackFile = File(rollbackPath);
      await rollbackFile.writeAsString(rollbackSql);

      _logger.info('回滚迁移文件已创建: $rollbackPath');
      return rollbackPath;
    } catch (error, stackTrace) {
      _logger.error('创建回滚迁移失败: $migrationName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 从迁移类生成回滚 SQL
  String _generateRollbackSqlFromClass(BaseMigration migration, String migrationName) {
    final timestamp = DateTime.now().toIso8601String().substring(0, 19).replaceAll(':', '-');
    final buffer = StringBuffer();

    buffer.writeln('-- 回滚迁移: ${migration.name}');
    buffer.writeln('-- 创建时间: $timestamp');
    buffer.writeln('-- 描述: 回滚 $migrationName 的更改');
    buffer.writeln('-- 原始迁移: ${migration.description}');
    buffer.writeln('');

    // 基于迁移名称生成回滚操作
    if (migrationName.contains('users')) {
      buffer.writeln('-- 回滚用户表相关操作');
      buffer.writeln('DROP TABLE IF EXISTS ${ServerConfig.tablePrefix}users CASCADE;');
    } else if (migrationName.contains('roles')) {
      buffer.writeln('-- 回滚角色表相关操作');
      buffer.writeln('DROP TABLE IF EXISTS ${ServerConfig.tablePrefix}roles CASCADE;');
    } else if (migrationName.contains('permissions')) {
      buffer.writeln('-- 回滚权限表相关操作');
      buffer.writeln('DROP TABLE IF EXISTS ${ServerConfig.tablePrefix}permissions CASCADE;');
    } else if (migrationName.contains('projects')) {
      buffer.writeln('-- 回滚项目表相关操作');
      buffer.writeln('DROP TABLE IF EXISTS ${ServerConfig.tablePrefix}projects CASCADE;');
    } else if (migrationName.contains('translations')) {
      buffer.writeln('-- 回滚翻译表相关操作');
      buffer.writeln('DROP TABLE IF EXISTS ${ServerConfig.tablePrefix}translations CASCADE;');
      buffer.writeln('DROP TABLE IF EXISTS ${ServerConfig.tablePrefix}translation_keys CASCADE;');
      buffer.writeln('DROP TABLE IF EXISTS ${ServerConfig.tablePrefix}translation_values CASCADE;');
    } else {
      buffer.writeln('-- 通用回滚操作');
      buffer.writeln('-- 请根据具体迁移内容手动编写回滚 SQL');
    }

    buffer.writeln('');
    buffer.writeln('-- 注意事项:');
    buffer.writeln('-- 1. 请仔细检查自动生成的回滚 SQL');
    buffer.writeln('-- 2. 某些操作可能无法完全回滚');
    buffer.writeln('-- 3. 数据迁移操作需要手动处理');
    buffer.writeln('-- 4. 建议在测试环境验证后再在生产环境执行');

    return buffer.toString();
  }

  /// 获取下一个迁移编号
  String _getNextMigrationNumber() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
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
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';

      // 检查表是否存在
      final tableExistsQuery = '''
        SELECT EXISTS (
          SELECT 1 
          FROM information_schema.tables 
          WHERE table_schema = 'public' 
          AND table_name = '$prefixedTableName'
        );
      ''';
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
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
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
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
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
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
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
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
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
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName DROP CONSTRAINT IF EXISTS $constraintName';

      await _databaseService.query(sql);
      _logger.info('成功删除约束: $prefixedTableName.$constraintName');
    } catch (error, stackTrace) {
      _logger.error('删除约束失败: $tableName.$constraintName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地添加索引
  Future<void> addIndexSafely(String tableName, String indexName, String indexDefinition, {bool unique = false}) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final uniqueKeyword = unique ? 'UNIQUE ' : '';
      final sql = 'CREATE ${uniqueKeyword}INDEX IF NOT EXISTS $indexName ON $prefixedTableName $indexDefinition';

      await _databaseService.query(sql);
      _logger.info('成功添加索引: $indexName on $prefixedTableName');
    } catch (error, stackTrace) {
      _logger.error('添加索引失败: $indexName on $tableName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地删除索引
  Future<void> dropIndexSafely(String indexName) async {
    try {
      final sql = 'DROP INDEX IF EXISTS $indexName';

      await _databaseService.query(sql);
      _logger.info('成功删除索引: $indexName');
    } catch (error, stackTrace) {
      _logger.error('删除索引失败: $indexName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地重命名列
  Future<void> renameColumnSafely(String tableName, String oldColumnName, String newColumnName) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName RENAME COLUMN $oldColumnName TO $newColumnName';

      await _databaseService.query(sql);
      _logger.info('成功重命名列: $prefixedTableName.$oldColumnName -> $newColumnName');
    } catch (error, stackTrace) {
      _logger.error('重命名列失败: $tableName.$oldColumnName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地设置列默认值
  Future<void> setColumnDefaultSafely(String tableName, String columnName, String defaultValue) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName ALTER COLUMN $columnName SET DEFAULT $defaultValue';

      await _databaseService.query(sql);
      _logger.info('成功设置列默认值: $prefixedTableName.$columnName = $defaultValue');
    } catch (error, stackTrace) {
      _logger.error('设置列默认值失败: $tableName.$columnName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地删除列默认值
  Future<void> dropColumnDefaultSafely(String tableName, String columnName) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName ALTER COLUMN $columnName DROP DEFAULT';

      await _databaseService.query(sql);
      _logger.info('成功删除列默认值: $prefixedTableName.$columnName');
    } catch (error, stackTrace) {
      _logger.error('删除列默认值失败: $tableName.$columnName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地设置列为非空
  Future<void> setColumnNotNullSafely(String tableName, String columnName) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName ALTER COLUMN $columnName SET NOT NULL';

      await _databaseService.query(sql);
      _logger.info('成功设置列为非空: $prefixedTableName.$columnName');
    } catch (error, stackTrace) {
      _logger.error('设置列非空失败: $tableName.$columnName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 安全地设置列为可空
  Future<void> setColumnNullableSafely(String tableName, String columnName) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final sql = 'ALTER TABLE $prefixedTableName ALTER COLUMN $columnName DROP NOT NULL';

      await _databaseService.query(sql);
      _logger.info('成功设置列为可空: $prefixedTableName.$columnName');
    } catch (error, stackTrace) {
      _logger.error('设置列可空失败: $tableName.$columnName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 迁移前检查
  Future<Map<String, dynamic>> preMigrationCheck(String tableName) async {
    try {
      _logger.info('执行迁移前检查: $tableName');

      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final results = <String, dynamic>{};

      // 检查表是否存在
      final tableExistsQuery = '''
        SELECT EXISTS (
          SELECT FROM information_schema.tables 
          WHERE table_schema = 'public' 
          AND table_name = '$prefixedTableName'
        );
      ''';
      final tableExistsResult = await _databaseService.query(tableExistsQuery);
      results['table_exists'] = tableExistsResult.first[0] as bool;

      if (results['table_exists']) {
        // 获取表结构
        final structureQuery = '''
          SELECT 
            column_name,
            data_type,
            character_maximum_length,
            is_nullable,
            column_default,
            ordinal_position
          FROM information_schema.columns 
          WHERE table_schema = 'public' 
          AND table_name = '$prefixedTableName'
          ORDER BY ordinal_position;
        ''';
        final columns = await _databaseService.query(structureQuery);
        results['columns'] = columns
            .map((row) => {
                  'name': row[0],
                  'type': row[1],
                  'max_length': row[2],
                  'nullable': row[3] == 'YES',
                  'default': row[4],
                  'position': row[5],
                })
            .toList();

        // 获取约束信息
        final constraintsQuery = '''
          SELECT 
            constraint_name,
            constraint_type
          FROM information_schema.table_constraints 
          WHERE table_schema = 'public' 
          AND table_name = '$prefixedTableName';
        ''';
        final constraints = await _databaseService.query(constraintsQuery);
        results['constraints'] = constraints
            .map((row) => {
                  'name': row[0],
                  'type': row[1],
                })
            .toList();

        // 获取索引信息
        final indexesQuery = '''
          SELECT 
            indexname,
            indexdef
          FROM pg_indexes 
          WHERE tablename = '$prefixedTableName';
        ''';
        final indexes = await _databaseService.query(indexesQuery);
        results['indexes'] = indexes
            .map((row) => {
                  'name': row[0],
                  'definition': row[1],
                })
            .toList();

        // 获取行数
        final countQuery = 'SELECT COUNT(*) FROM $prefixedTableName';
        final countResult = await _databaseService.query(countQuery);
        results['row_count'] = countResult.first[0] as int;
      }

      _logger.info('迁移前检查完成: $prefixedTableName');
      return results;
    } catch (error, stackTrace) {
      _logger.error('迁移前检查失败: $tableName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 迁移后验证
  Future<Map<String, dynamic>> postMigrationValidation(String tableName, Map<String, dynamic> preCheckResults) async {
    try {
      _logger.info('执行迁移后验证: $tableName');

      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final validationResults = <String, dynamic>{};
      validationResults['passed'] = true;
      validationResults['errors'] = <String>[];

      // 验证表仍然存在
      final tableExistsQuery = '''
        SELECT EXISTS (
          SELECT FROM information_schema.tables 
          WHERE table_schema = 'public' 
          AND table_name = '$prefixedTableName'
        );
      ''';
      final tableExistsResult = await _databaseService.query(tableExistsQuery);
      final tableStillExists = tableExistsResult.first[0] as bool;

      if (!tableStillExists && preCheckResults['table_exists']) {
        validationResults['passed'] = false;
        validationResults['errors'].add('表 $prefixedTableName 在迁移后不存在');
      }

      if (tableStillExists) {
        // 验证数据完整性
        final countQuery = 'SELECT COUNT(*) FROM $prefixedTableName';
        final countResult = await _databaseService.query(countQuery);
        final currentRowCount = countResult.first[0] as int;
        final previousRowCount = preCheckResults['row_count'] as int? ?? 0;

        // 记录行数变化（但不一定报错）
        validationResults['row_count_change'] = currentRowCount - previousRowCount;

        // 验证列结构
        final structureQuery = '''
          SELECT 
            column_name,
            data_type,
            is_nullable
          FROM information_schema.columns 
          WHERE table_schema = 'public' 
          AND table_name = '$prefixedTableName'
          ORDER BY ordinal_position;
        ''';
        final currentColumns = await _databaseService.query(structureQuery);
        final currentColumnMap = <String, Map<String, dynamic>>{};
        for (final row in currentColumns) {
          currentColumnMap[row[0] as String] = {
            'type': row[1],
            'nullable': row[2] == 'YES',
          };
        }

        // 检查关键列是否仍然存在
        final previousColumns = preCheckResults['columns'] as List<dynamic>? ?? [];
        for (final prevCol in previousColumns) {
          final colName = prevCol['name'] as String;
          if (!currentColumnMap.containsKey(colName)) {
            validationResults['passed'] = false;
            validationResults['errors'].add('列 $colName 在迁移后丢失');
          }
        }
      }

      _logger.info('迁移后验证完成: $prefixedTableName, 通过: ${validationResults['passed']}');
      return validationResults;
    } catch (error, stackTrace) {
      _logger.error('迁移后验证失败: $tableName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 备份数据库（生产环境）
  Future<String> backupDatabase({String? backupPath}) async {
    try {
      _logger.info('执行数据库备份');

      if (ServerConfig.isDevelopment) {
        _logger.warn('备份功能仅在生产环境中使用');
        return '';
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final defaultBackupPath = 'database/backups/backup_$timestamp.sql';
      final finalBackupPath = backupPath ?? defaultBackupPath;

      // 创建备份目录
      final backupDir = Directory(path.dirname(finalBackupPath));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // 构建 pg_dump 命令
      final pgDumpCommand = [
        'pg_dump',
        '--host=${ServerConfig.dbHost}',
        '--port=${ServerConfig.dbPort}',
        '--username=${ServerConfig.dbUser}',
        '--dbname=${ServerConfig.dbName}',
        '--no-password',
        '--verbose',
        '--clean',
        '--no-owner',
        '--no-privileges',
        '--file=$finalBackupPath'
      ];

      _logger.info('执行备份命令: ${pgDumpCommand.join(' ')}');

      // 设置环境变量
      final environment = <String, String>{
        'PGPASSWORD': ServerConfig.dbPassword,
      };

      // 执行备份命令
      final result = await Process.run(
        'pg_dump',
        pgDumpCommand.sublist(1), // 移除第一个元素 'pg_dump'
        environment: environment,
      );

      if (result.exitCode == 0) {
        _logger.info('数据库备份成功: $finalBackupPath');
        _logger.info('备份大小: ${await _getFileSize(finalBackupPath)}');
        return finalBackupPath;
      } else {
        throw Exception('备份失败: ${result.stderr}');
      }
    } catch (error, stackTrace) {
      _logger.error('数据库备份失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 恢复数据库
  Future<void> restoreDatabase(String backupPath) async {
    try {
      _logger.info('执行数据库恢复: $backupPath');

      // 检查备份文件是否存在
      final backupFile = File(backupPath);
      if (!await backupFile.exists()) {
        throw Exception('备份文件不存在: $backupPath');
      }

      // 构建 psql 命令
      final psqlCommand = [
        'psql',
        '--host=${ServerConfig.dbHost}',
        '--port=${ServerConfig.dbPort}',
        '--username=${ServerConfig.dbUser}',
        '--dbname=${ServerConfig.dbName}',
        '--no-password',
        '--file=$backupPath'
      ];

      _logger.info('执行恢复命令: ${psqlCommand.join(' ')}');

      // 设置环境变量
      final environment = <String, String>{
        'PGPASSWORD': ServerConfig.dbPassword,
      };

      // 执行恢复命令
      final result = await Process.run(
        'psql',
        psqlCommand.sublist(1), // 移除第一个元素 'psql'
        environment: environment,
      );

      if (result.exitCode == 0) {
        _logger.info('数据库恢复成功');
      } else {
        throw Exception('恢复失败: ${result.stderr}');
      }
    } catch (error, stackTrace) {
      _logger.error('数据库恢复失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取文件大小
  Future<String> _getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      final stat = await file.stat();
      final bytes = stat.size;

      if (bytes < 1024) {
        return '$bytes B';
      } else if (bytes < 1024 * 1024) {
        return '${(bytes / 1024).toStringAsFixed(1)} KB';
      } else {
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (error) {
      return '未知大小';
    }
  }

  /// 列出备份文件
  Future<List<Map<String, dynamic>>> listBackups() async {
    try {
      final backupDir = Directory('database/backups');
      if (!await backupDir.exists()) {
        return [];
      }

      final files = await backupDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.sql'))
          .cast<File>()
          .toList();

      final backups = <Map<String, dynamic>>[];
      for (final file in files) {
        final stat = await file.stat();
        backups.add({
          'name': path.basename(file.path),
          'path': file.path,
          'size': await _getFileSize(file.path),
          'created_at': stat.modified,
          'size_bytes': stat.size,
        });
      }

      // 按创建时间排序（最新的在前）
      backups.sort((a, b) => (b['created_at'] as DateTime).compareTo(a['created_at'] as DateTime));

      return backups;
    } catch (error, stackTrace) {
      _logger.error('获取备份列表失败', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  /// 删除备份文件
  Future<void> deleteBackup(String backupPath) async {
    try {
      final file = File(backupPath);
      if (await file.exists()) {
        await file.delete();
        _logger.info('备份文件已删除: $backupPath');
      } else {
        _logger.warn('备份文件不存在: $backupPath');
      }
    } catch (error, stackTrace) {
      _logger.error('删除备份文件失败: $backupPath', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查字段是否被引用
  Future<bool> isColumnReferenced(String tableName, String columnName) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final query = '''
        SELECT COUNT(*) FROM information_schema.key_column_usage 
        WHERE table_schema = 'public' 
        AND referenced_table_name = '$prefixedTableName' 
        AND referenced_column_name = '$columnName';
      ''';
      final result = await _databaseService.query(query);
      final referenceCount = result.first[0] as int;

      _logger.info('列引用检查: $prefixedTableName.$columnName, 引用数: $referenceCount');
      return referenceCount > 0;
    } catch (error, stackTrace) {
      _logger.error('检查列引用失败: $tableName.$columnName', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 获取表的所有外键约束
  Future<List<Map<String, dynamic>>> getTableForeignKeys(String tableName) async {
    try {
      final prefixedTableName = '${ServerConfig.tablePrefix}$tableName';
      final query = '''
        SELECT 
          tc.constraint_name,
          tc.table_name,
          kcu.column_name,
          ccu.table_name AS foreign_table_name,
          ccu.column_name AS foreign_column_name
        FROM information_schema.table_constraints AS tc 
        JOIN information_schema.key_column_usage AS kcu
          ON tc.constraint_name = kcu.constraint_name
          AND tc.table_schema = kcu.table_schema
        JOIN information_schema.constraint_column_usage AS ccu
          ON ccu.constraint_name = tc.constraint_name
          AND ccu.table_schema = tc.table_schema
        WHERE tc.constraint_type = 'FOREIGN KEY' 
        AND tc.table_name = '$prefixedTableName';
      ''';
      final result = await _databaseService.query(query);

      return result
          .map((row) => {
                'constraint_name': row[0],
                'table_name': row[1],
                'column_name': row[2],
                'foreign_table_name': row[3],
                'foreign_column_name': row[4],
              })
          .toList();
    } catch (error, stackTrace) {
      _logger.error('获取表外键失败: $tableName', error: error, stackTrace: stackTrace);
      return [];
    }
  }

  /// 显示帮助信息
  void showHelpMigration() {
    _logger.info('''
数据库迁移工具使用说明:

用法: dart migrate.dart [命令] [参数]

命令:
  migrate         运行所有未执行的迁移（基于注册的迁移类）
  seed            运行种子数据
  status          显示详细的迁移状态（包括类哈希和更改检测）
  rollback        回滚指定的迁移 (仅开发环境)
  create-rollback 为生产环境创建回滚迁移文件
  check           检查表结构
  validate        验证迁移前后数据完整性
  precheck        迁移前检查表结构和数据
  foreign-keys    查看表的外键约束
  backup          备份数据库 (仅生产环境)
  list-backups    列出所有备份文件
  restore         从备份文件恢复数据库
  delete-backup   删除指定的备份文件
  help            显示此帮助信息

新功能:
  - 类迁移系统：使用 Dart 类进行迁移，支持 up() 和 down() 方法
  - 迁移注册：通过 registerMigration() 注册迁移类
  - 类哈希检测：自动检测迁移类是否已更改
  - 智能重新执行：已更改的迁移类会自动重新执行
  - 详细状态显示：显示类哈希、执行时间、描述等信息
  - 迁移前检查：执行迁移前检查表结构和数据
  - 迁移后验证：执行迁移后验证数据完整性
  - 安全字段操作：提供安全的字段添加、删除、修改方法
  - 备份功能：生产环境数据库备份支持

示例:
  dart migrate.dart                           # 运行迁移和种子数据
  dart migrate.dart migrate                   # 仅运行迁移（基于注册的迁移类）
  dart migrate.dart seed                      # 仅运行种子数据
  dart migrate.dart status                    # 查看详细迁移状态
  dart migrate.dart rollback 001_users_table  # 回滚指定迁移
  dart migrate.dart create-rollback 001_users_table  # 创建回滚迁移
  dart migrate.dart check users               # 检查用户表结构
  dart migrate.dart validate users            # 验证用户表迁移
  dart migrate.dart precheck users            # 迁移前检查用户表
  dart migrate.dart foreign-keys users        # 查看用户表外键
  dart migrate.dart backup                    # 备份数据库
  dart migrate.dart list-backups              # 列出备份文件
  dart migrate.dart restore backup_file.sql   # 恢复数据库
  dart migrate.dart delete-backup backup_file.sql  # 删除备份文件

状态说明:
  ✅ 已完成    - 迁移已执行且类未更改
  🔄 已更改    - 迁移已执行但类内容已更改，需要重新执行
  ⏳ 待执行    - 新迁移类，尚未执行

迁移注册:
  在迁移服务初始化前，需要注册所有迁移类：
  MigrationService.registerMigration('001_users_table', () => Migration001UsersTable());
  MigrationService.registerMigration('002_roles_table', () => Migration002RolesTable());

安全操作:
  - 所有字段操作都使用 IF EXISTS/IF NOT EXISTS
  - 支持事务回滚
  - 迁移前后验证
  - 生产环境备份保护
''');
  }
}
