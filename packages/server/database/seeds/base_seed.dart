import 'dart:developer';

import 'package:postgres/postgres.dart';
import 'package:ttpolyglot_server/src/config/server_config.dart';

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
  Future<void> insertData(
    String tableName,
    List<Map<String, dynamic>> dataList,
  ) async {
    try {
      final fullTableName = '$tablePrefix$tableName';

      for (final data in dataList) {
        final columns = data.keys.join(', ');
        final placeholders = data.keys.map((key) => '@$key').join(', ');

        final sql = '''
          INSERT INTO $fullTableName ($columns)
          VALUES ($placeholders)
          ON CONFLICT DO NOTHING
        ''';

        await connection.execute(
          Sql.named(sql),
          parameters: data,
        );
      }

      log('插入数据完成: $fullTableName, ${dataList.length} 条记录', name: runtimeType.toString());
    } catch (error, stackTrace) {
      log('插入数据失败: $tableName', error: error, stackTrace: stackTrace, name: runtimeType.toString());
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
      log('查询数据失败', error: error, stackTrace: stackTrace, name: runtimeType.toString());
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
      log('检查表数据失败: $tableName', error: error, stackTrace: stackTrace, name: runtimeType.toString());
      rethrow;
    }
  }
}
