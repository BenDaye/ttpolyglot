import 'package:postgres/postgres.dart';

import '../config/server_config.dart';
import '../utils/structured_logger.dart';

/// 数据库服务类
class DatabaseService {
  static final _logger = LoggerFactory.getLogger('DatabaseService');
  final ServerConfig _config;
  Connection? _connection;

  DatabaseService(this._config);

  /// 初始化数据库连接
  Future<void> initialize() async {
    try {
      // 解析数据库URL
      final uri = Uri.parse(_config.databaseUrl);

      final endpoint = Endpoint(
        host: uri.host,
        port: uri.port,
        database: uri.pathSegments.isNotEmpty ? uri.pathSegments.first : _config.dbName,
        username: uri.userInfo.isNotEmpty ? uri.userInfo.split(':').first : _config.dbUser,
        password:
            uri.userInfo.isNotEmpty && uri.userInfo.contains(':') ? uri.userInfo.split(':').last : _config.dbPassword,
      );

      final connectionSettings = ConnectionSettings(
        sslMode: SslMode.require,
        connectTimeout: Duration(seconds: _config.dbConnectionTimeout),
        queryTimeout: Duration(seconds: 30),
      );

      _connection = await Connection.open(
        endpoint,
        settings: connectionSettings,
      );

      _logger.info('数据库连接成功: ${uri.host}:${uri.port}/${endpoint.database}');
    } catch (error, stackTrace) {
      _logger.error('数据库连接失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取数据库连接
  Connection get connection {
    if (_connection == null) {
      throw Exception('数据库连接未初始化');
    }
    return _connection!;
  }

  /// 检查数据库健康状态
  Future<bool> isHealthy() async {
    try {
      if (_connection == null) return false;

      final result = await _connection!.execute('SELECT 1');
      return result.isNotEmpty;
    } catch (error) {
      _logger.warn('数据库健康检查失败', error: error);
      return false;
    }
  }

  /// 执行查询
  Future<Result> query(String sql, [Map<String, dynamic>? parameters]) async {
    try {
      if (parameters != null && parameters.isNotEmpty) {
        return await connection.execute(
          Sql.named(sql),
          parameters: parameters,
        );
      } else {
        return await connection.execute(sql);
      }
    } catch (error, stackTrace) {
      _logger.error('数据库查询失败: $sql', error: error, stackTrace: stackTrace, context: LogContext().field('sql', sql));
      rethrow;
    }
  }

  /// 开始事务
  Future<void> beginTransaction() async {
    await connection.execute('BEGIN');
  }

  /// 提交事务
  Future<void> commitTransaction() async {
    await connection.execute('COMMIT');
  }

  /// 回滚事务
  Future<void> rollbackTransaction() async {
    await connection.execute('ROLLBACK');
  }

  /// 在事务中执行操作
  Future<T> transaction<T>(Future<T> Function() operation) async {
    await beginTransaction();
    try {
      final result = await operation();
      await commitTransaction();
      return result;
    } catch (error) {
      await rollbackTransaction();
      rethrow;
    }
  }

  /// 关闭数据库连接
  Future<void> close() async {
    try {
      if (_connection != null) {
        await _connection!.close();
        _connection = null;
        _logger.info('数据库连接已关闭');
      }
    } catch (error, stackTrace) {
      _logger.error('关闭数据库连接时出错', error: error, stackTrace: stackTrace);
    }
  }
}
