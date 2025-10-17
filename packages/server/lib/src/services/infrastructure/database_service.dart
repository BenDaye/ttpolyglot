import 'package:postgres/postgres.dart';

import '../../config/server_config.dart';
import '../../utils/logging/logger_utils.dart';

/// 数据库服务类
class DatabaseService {
  static final _logger = LoggerFactory.getLogger('DatabaseService');
  Connection? _connection;

  /// 事务状态标记（防止嵌套事务）
  bool _inTransaction = false;

  /// 初始化数据库连接
  Future<void> initialize() async {
    try {
      // 解析数据库URL
      final uri = Uri.parse(ServerConfig.databaseUrl);

      final endpoint = Endpoint(
        host: uri.host,
        port: uri.port,
        database: uri.pathSegments.isNotEmpty ? uri.pathSegments.first : ServerConfig.dbName,
        username: uri.userInfo.isNotEmpty ? uri.userInfo.split(':').first : ServerConfig.dbUser,
        password: uri.userInfo.isNotEmpty && uri.userInfo.contains(':')
            ? uri.userInfo.split(':').last
            : ServerConfig.dbPassword,
      );

      final connectionSettings = ConnectionSettings(
        sslMode: SslMode.disable,
        connectTimeout: Duration(seconds: ServerConfig.dbConnectionTimeout),
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

  /// 检查是否在事务中
  bool get isInTransaction => _inTransaction;

  /// 开始事务
  Future<void> beginTransaction() async {
    if (_inTransaction) {
      _logger.warn('尝试开启事务，但已在事务中。跳过 BEGIN。');
      return;
    }
    await connection.execute('BEGIN');
    _inTransaction = true;
    _logger.debug('事务已开始');
  }

  /// 提交事务
  Future<void> commitTransaction() async {
    if (!_inTransaction) {
      _logger.warn('尝试提交事务，但不在事务中。跳过 COMMIT。');
      return;
    }
    await connection.execute('COMMIT');
    _inTransaction = false;
    _logger.debug('事务已提交');
  }

  /// 回滚事务
  Future<void> rollbackTransaction() async {
    if (!_inTransaction) {
      _logger.warn('尝试回滚事务，但不在事务中。跳过 ROLLBACK。');
      return;
    }
    await connection.execute('ROLLBACK');
    _inTransaction = false;
    _logger.debug('事务已回滚');
  }

  /// 在事务中执行操作（支持嵌套调用）
  Future<T> transaction<T>(Future<T> Function() operation) async {
    // 如果已在事务中，直接执行操作（避免嵌套事务）
    if (_inTransaction) {
      _logger.debug('已在事务中，直接执行操作（嵌套调用）');
      return await operation();
    }

    // 开启新事务
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
