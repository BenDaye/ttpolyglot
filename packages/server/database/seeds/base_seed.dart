import 'package:postgres/postgres.dart';
import 'package:ttpolyglot_server/src/config/server_config.dart';
import 'package:ttpolyglot_server/src/utils/logging/logger_utils.dart';

/// 种子数据基础类
/// 创建时间: 2024-12-26
/// 描述: 提供种子数据的基础功能和表前缀支持
abstract class BaseSeed {
  /// 种子名称
  String get name;

  /// 种子描述
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

  /// 执行种子数据
  Future<void> run();

  /// 执行插入操作的辅助方法
  ///
  /// ⚠️  重要提示：此方法使用 ON CONFLICT DO NOTHING 来避免重复插入
  ///
  /// 要求：目标表必须有主键或唯一约束，否则数据可能会重复插入！
  ///
  /// 最佳实践：
  /// 1. 确保表有 PRIMARY KEY 或 UNIQUE 约束
  /// 2. 如果表没有唯一约束，建议在迁移中添加
  /// 3. 或者使用自定义的 checkDataExists 逻辑
  Future<void> insertData(
    String tableName,
    List<Map<String, dynamic>> dataList,
  ) async {
    try {
      final fullTableName = '$tablePrefix$tableName';

      int insertedCount = 0;
      int skippedCount = 0;

      for (final data in dataList) {
        final columns = data.keys.join(', ');
        final placeholders = data.keys.map((key) => '@$key').join(', ');

        // 使用 ON CONFLICT DO NOTHING 需要表有唯一约束
        final sql = '''
          INSERT INTO $fullTableName ($columns)
          VALUES ($placeholders)
          ON CONFLICT DO NOTHING
          RETURNING *
        ''';

        final result = await connection.execute(
          Sql.named(sql),
          parameters: data,
        );

        if (result.isNotEmpty) {
          insertedCount++;
        } else {
          skippedCount++;
        }
      }

      if (skippedCount > 0) {
        LoggerUtils.info('插入数据完成: $fullTableName, 新插入: $insertedCount 条, 跳过(已存在): $skippedCount 条');
      } else {
        LoggerUtils.info('插入数据完成: $fullTableName, ${dataList.length} 条记录');
      }

      // 如果所有数据都被跳过，可能是表没有唯一约束
      if (insertedCount == 0 && skippedCount == dataList.length) {
        LoggerUtils.warn('⚠️  警告：所有数据都被跳过，请确认表 $fullTableName 是否有正确的唯一约束');
      }
    } catch (error, stackTrace) {
      // 检查是否是缺少唯一约束导致的错误
      final errorMessage = error.toString().toLowerCase();
      if (errorMessage.contains('conflict') || errorMessage.contains('constraint')) {
        LoggerUtils.error(
            '插入数据失败: $tableName\n'
            '⚠️  提示：请确保表有主键或唯一约束，否则 ON CONFLICT DO NOTHING 无法正常工作',
            error: error,
            stackTrace: stackTrace);
      } else {
        LoggerUtils.error('插入数据失败: $tableName', error: error, stackTrace: stackTrace);
      }
      rethrow;
    }
  }

  /// 查询数据的辅助方法
  Future<List<Map<String, dynamic>>> queryData(String sql, {Map<String, dynamic>? parameters}) async {
    try {
      final Result result;
      if (parameters != null && parameters.isNotEmpty) {
        result = await connection.execute(
          Sql.named(sql),
          parameters: parameters,
        );
      } else {
        result = await connection.execute(sql);
      }

      return result
          .map((row) => row.toColumnMap().map(
                (key, value) => MapEntry(key, value),
              ))
          .toList();
    } catch (error, stackTrace) {
      LoggerUtils.error('查询数据失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查表中是否存在数据
  Future<bool> tableHasData(String tableName) async {
    try {
      final fullTableName = '$tablePrefix$tableName';
      final result = await connection.execute(
        'SELECT COUNT(*) FROM $fullTableName',
      );

      final count = result.first[0] as int;
      return count > 0;
    } catch (error, stackTrace) {
      LoggerUtils.error('检查表数据失败: $tableName', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
