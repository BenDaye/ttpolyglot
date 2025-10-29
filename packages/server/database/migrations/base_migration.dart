import 'package:postgres/postgres.dart';
import 'package:ttpolyglot_server/src/config/server_config.dart';
import 'package:ttpolyglot_model/model.dart';

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

  /// 获取表前缀
  String get tablePrefix {
    return ServerConfig.tablePrefix;
  }

  /// 数据库连接
  Connection? _connection;

  /// 设置数据库连接
  void setConnection(Connection connection) {
    _connection = connection;
  }

  /// 获取数据库连接
  Connection get connection {
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

      ServerLogger.info('创建表: $fullTableName');
      await connection.execute(fullSql);
      ServerLogger.info('表创建完成: $fullTableName');
    } catch (error, stackTrace) {
      ServerLogger.error('创建表失败: $tableName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除表
  Future<void> dropTable(String tableName) async {
    try {
      final fullTableName = '$tablePrefix$tableName';

      ServerLogger.info('删除表: $fullTableName');
      await connection.execute('DROP TABLE IF EXISTS $fullTableName CASCADE;');
      ServerLogger.info('表删除完成: $fullTableName');
    } catch (error, stackTrace) {
      ServerLogger.error('删除表失败: $tableName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 创建索引
  Future<void> createIndex(String indexName, String tableName, String columns) async {
    try {
      final fullIndexName = '${tablePrefix}idx_$indexName';
      final fullTableName = '$tablePrefix$tableName';

      ServerLogger.info('创建索引: $fullIndexName');
      await connection.execute('CREATE INDEX IF NOT EXISTS $fullIndexName ON $fullTableName ($columns);');
      ServerLogger.info('索引创建完成: $fullIndexName');
    } catch (error, stackTrace) {
      ServerLogger.error('创建索引失败: $indexName', error: error, stackTrace: stackTrace);
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

      ServerLogger.info('添加外键约束: $fullConstraintName');

      // PostgreSQL 不支持 ADD CONSTRAINT IF NOT EXISTS，使用 DO 块来处理
      await connection.execute('''
        DO \$\$
        BEGIN
          IF NOT EXISTS (
            SELECT 1 FROM pg_constraint WHERE conname = '$fullConstraintName'
          ) THEN
            ALTER TABLE $fullTableName 
            ADD CONSTRAINT $fullConstraintName 
            FOREIGN KEY ($column) REFERENCES $fullRefTable($refColumn) ON DELETE $onDelete;
          END IF;
        END \$\$;
      ''');
      ServerLogger.info('外键约束添加完成: $fullConstraintName');
    } catch (error, stackTrace) {
      ServerLogger.error('添加外键约束失败: $constraintName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 添加表注释
  Future<void> addTableComment(String tableName, String comment) async {
    try {
      final fullTableName = '$tablePrefix$tableName';

      ServerLogger.info('添加表注释: $fullTableName');
      await connection.execute('COMMENT ON TABLE $fullTableName IS \'$comment\';');
      ServerLogger.info('表注释添加完成: $fullTableName');
    } catch (error, stackTrace) {
      ServerLogger.error('添加表注释失败: $tableName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 添加列注释
  Future<void> addColumnComment(String tableName, String column, String comment) async {
    try {
      final fullTableName = '$tablePrefix$tableName';

      ServerLogger.info('添加列注释: $fullTableName.$column');
      await connection.execute('COMMENT ON COLUMN $fullTableName.$column IS \'$comment\';');
      ServerLogger.info('列注释添加完成: $fullTableName.$column');
    } catch (error, stackTrace) {
      ServerLogger.error('添加列注释失败: $tableName.$column', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
