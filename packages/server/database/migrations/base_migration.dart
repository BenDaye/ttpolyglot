import 'dart:developer';

import 'package:postgres/postgres.dart';

/// 迁移基础类
/// 创建时间: 2024-12-26
/// 描述: 提供迁移的基础功能和表前缀支持
abstract class BaseMigration {
  /// 迁移名称
  String get name;

  /// 迁移描述
  String get description;

  /// 创建时间
  String get createdAt;

  /// 表前缀
  String get tablePrefix;

  /// 数据库连接
  PostgreSQLConnection? _connection;

  /// 设置数据库连接
  void setConnection(PostgreSQLConnection connection) {
    _connection = connection;
  }

  /// 获取数据库连接
  PostgreSQLConnection get connection {
    if (_connection == null) {
      throw StateError('数据库连接未设置，请先调用 setConnection()');
    }
    return _connection!;
  }

  /// 执行迁移
  Future<void> up();

  /// 回滚迁移
  Future<void> down();

  /// 创建表
  Future<void> createTable(String tableName, String sql) async {
    try {
      final fullTableName = '$tablePrefix$tableName';
      final fullSql = sql.replaceAll('{table_name}', fullTableName);

      log('创建表: $fullTableName', name: runtimeType.toString());
      await connection.execute(fullSql);
      log('表创建完成: $fullTableName', name: runtimeType.toString());
    } catch (error, stackTrace) {
      log('创建表失败: $tableName', error: error, stackTrace: stackTrace, name: runtimeType.toString());
      rethrow;
    }
  }

  /// 删除表
  Future<void> dropTable(String tableName) async {
    try {
      final fullTableName = '$tablePrefix$tableName';

      log('删除表: $fullTableName', name: runtimeType.toString());
      await connection.execute('DROP TABLE IF EXISTS $fullTableName CASCADE;');
      log('表删除完成: $fullTableName', name: runtimeType.toString());
    } catch (error, stackTrace) {
      log('删除表失败: $tableName', error: error, stackTrace: stackTrace, name: runtimeType.toString());
      rethrow;
    }
  }

  /// 创建索引
  Future<void> createIndex(String indexName, String tableName, String columns) async {
    try {
      final fullIndexName = '${tablePrefix}idx_$indexName';
      final fullTableName = '$tablePrefix$tableName';

      log('创建索引: $fullIndexName', name: runtimeType.toString());
      await connection.execute('CREATE INDEX IF NOT EXISTS $fullIndexName ON $fullTableName ($columns);');
      log('索引创建完成: $fullIndexName', name: runtimeType.toString());
    } catch (error, stackTrace) {
      log('创建索引失败: $indexName', error: error, stackTrace: stackTrace, name: runtimeType.toString());
      rethrow;
    }
  }

  /// 添加外键约束
  Future<void> addForeignKey(String constraintName, String tableName, String column, String refTable, String refColumn,
      {String onDelete = 'CASCADE'}) async {
    try {
      final fullTableName = '$tablePrefix$tableName';
      final fullRefTable = '$tablePrefix$refTable';
      final fullConstraintName = '${tablePrefix}fk_$constraintName';

      log('添加外键约束: $fullConstraintName', name: runtimeType.toString());
      await connection.execute('''
        ALTER TABLE $fullTableName 
        ADD CONSTRAINT IF NOT EXISTS $fullConstraintName 
        FOREIGN KEY ($column) REFERENCES $fullRefTable($refColumn) ON DELETE $onDelete;
      ''');
      log('外键约束添加完成: $fullConstraintName', name: runtimeType.toString());
    } catch (error, stackTrace) {
      log('添加外键约束失败: $constraintName', error: error, stackTrace: stackTrace, name: runtimeType.toString());
      rethrow;
    }
  }

  /// 添加表注释
  Future<void> addTableComment(String tableName, String comment) async {
    try {
      final fullTableName = '$tablePrefix$tableName';

      log('添加表注释: $fullTableName', name: runtimeType.toString());
      await connection.execute('COMMENT ON TABLE $fullTableName IS \'$comment\';');
      log('表注释添加完成: $fullTableName', name: runtimeType.toString());
    } catch (error, stackTrace) {
      log('添加表注释失败: $tableName', error: error, stackTrace: stackTrace, name: runtimeType.toString());
      rethrow;
    }
  }

  /// 添加列注释
  Future<void> addColumnComment(String tableName, String column, String comment) async {
    try {
      final fullTableName = '$tablePrefix$tableName';

      log('添加列注释: $fullTableName.$column', name: runtimeType.toString());
      await connection.execute('COMMENT ON COLUMN $fullTableName.$column IS \'$comment\';');
      log('列注释添加完成: $fullTableName.$column', name: runtimeType.toString());
    } catch (error, stackTrace) {
      log('添加列注释失败: $tableName.$column', error: error, stackTrace: stackTrace, name: runtimeType.toString());
      rethrow;
    }
  }
}
