import 'dart:async';
import 'dart:collection';

import 'package:postgres/postgres.dart';
import 'package:ttpolyglot_utils/utils.dart';

import '../../config/server_config.dart';

/// 数据库连接池
class DatabaseConnectionPool {
  final List<Connection> _availableConnections = [];
  final List<Connection> _usedConnections = [];
  final Queue<Completer<Connection>> _waitingQueue = Queue<Completer<Connection>>();

  Timer? _healthCheckTimer;
  Timer? _cleanupTimer;

  // 连接池配置
  late final int _minConnections;
  late final int _maxConnections;
  late final Duration _connectionTimeout;

  // 统计信息
  int _totalConnections = 0;
  int _activeConnections = 0;
  int _connectionErrors = 0;
  int _poolHits = 0;
  int _poolMisses = 0;

  DatabaseConnectionPool() {
    _minConnections = ServerConfig.dbPoolSize;
    _maxConnections = ServerConfig.dbPoolSize * 2;
    _connectionTimeout = Duration(seconds: ServerConfig.dbConnectionTimeout);
  }

  /// 初始化连接池
  Future<void> initialize() async {
    try {
      // final logger = LoggerFactory.getLogger('DatabaseConnectionPool');
      LoggerUtils.info('初始化数据库连接池...');

      // 创建最小连接数
      await _createInitialConnections();

      // 启动健康检查定时器
      _startHealthCheckTimer();

      // 启动清理定时器
      _startCleanupTimer();

      LoggerUtils.info('数据库连接池初始化完成: ${_availableConnections.length}/${_maxConnections}');
    } catch (error, stackTrace) {
      LoggerUtils.error('数据库连接池初始化失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取连接
  Future<Connection> getConnection() async {
    try {
      // 尝试从可用连接中获取
      if (_availableConnections.isNotEmpty) {
        final connection = _availableConnections.removeLast();
        _usedConnections.add(connection);
        _activeConnections++;
        _poolHits++;

        LoggerUtils.debug('从连接池获取连接: ${_activeConnections}/${_totalConnections}');
        return connection;
      }

      _poolMisses++;

      // 如果未达到最大连接数，创建新连接
      if (_totalConnections < _maxConnections) {
        final connection = await _createConnection();
        _usedConnections.add(connection);
        _activeConnections++;
        _totalConnections++;

        LoggerUtils.debug('创建新连接: ${_activeConnections}/${_totalConnections}');
        return connection;
      }

      // 等待可用连接
      return await _waitForConnection();
    } catch (error, stackTrace) {
      _connectionErrors++;
      LoggerUtils.error('获取连接失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 释放连接
  Future<void> releaseConnection(Connection connection) async {
    try {
      if (_usedConnections.contains(connection)) {
        _usedConnections.remove(connection);
        _activeConnections--;

        // 检查连接是否健康
        if (await _isConnectionHealthy(connection)) {
          _availableConnections.add(connection);
          LoggerUtils.debug('连接已释放到池中: ${_activeConnections}/${_totalConnections}');
        } else {
          _totalConnections--;
          LoggerUtils.warning('连接不健康，已移除: ${_activeConnections}/${_totalConnections}');
        }

        // 处理等待队列
        _processWaitingQueue();
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('释放连接失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 执行查询（自动管理连接）
  Future<T> executeWithConnection<T>(
    Future<T> Function(Connection connection) operation,
  ) async {
    Connection? connection;
    try {
      connection = await getConnection();
      return await operation(connection);
    } finally {
      if (connection != null) {
        await releaseConnection(connection);
      }
    }
  }

  /// 检查连接池健康状态
  Future<bool> isHealthy() async {
    try {
      if (_totalConnections == 0) return false;

      // 检查是否有可用连接
      if (_availableConnections.isEmpty && _totalConnections >= _maxConnections) {
        return false;
      }

      // 测试一个连接
      final connection = await getConnection();
      try {
        await connection.execute('SELECT 1');
        return true;
      } finally {
        await releaseConnection(connection);
      }
    } catch (error) {
      LoggerUtils.error('连接池健康检查失败', error: error);
      return false;
    }
  }

  /// 获取连接池统计信息
  Map<String, dynamic> getStats() {
    return {
      'total_connections': _totalConnections,
      'active_connections': _activeConnections,
      'available_connections': _availableConnections.length,
      'waiting_requests': _waitingQueue.length,
      'pool_hits': _poolHits,
      'pool_misses': _poolMisses,
      'hit_rate':
          _poolHits + _poolMisses > 0 ? (_poolHits / (_poolHits + _poolMisses) * 100).toStringAsFixed(2) + '%' : '0%',
      'connection_errors': _connectionErrors,
      'utilization':
          _totalConnections > 0 ? (_activeConnections / _totalConnections * 100).toStringAsFixed(2) + '%' : '0%',
    };
  }

  /// 关闭连接池
  Future<void> close() async {
    try {
      // final logger = LoggerFactory.getLogger('DatabaseConnectionPool');
      LoggerUtils.info('开始关闭数据库连接池...');

      // 停止定时器
      _healthCheckTimer?.cancel();
      _cleanupTimer?.cancel();

      // 关闭所有连接
      final allConnections = [..._availableConnections, ..._usedConnections];
      await Future.wait(allConnections.map((conn) => conn.close()));

      _availableConnections.clear();
      _usedConnections.clear();
      _totalConnections = 0;
      _activeConnections = 0;

      LoggerUtils.info('数据库连接池已关闭');
    } catch (error, stackTrace) {
      LoggerUtils.error('关闭连接池失败', error: error, stackTrace: stackTrace);
    }
  }

  // 私有方法

  /// 创建初始连接
  Future<void> _createInitialConnections() async {
    final futures = List.generate(_minConnections, (_) => _createConnection());
    final connections = await Future.wait(futures);
    _availableConnections.addAll(connections);
    _totalConnections = connections.length;
  }

  /// 创建新连接
  Future<Connection> _createConnection() async {
    try {
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
        connectTimeout: _connectionTimeout,
        queryTimeout: Duration(seconds: 30),
      );

      final connection = await Connection.open(
        endpoint,
        settings: connectionSettings,
      );

      LoggerUtils.debug('创建数据库连接成功');
      return connection;
    } catch (error, stackTrace) {
      _connectionErrors++;
      LoggerUtils.error('创建数据库连接失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 等待可用连接
  Future<Connection> _waitForConnection() async {
    final completer = Completer<Connection>();
    _waitingQueue.add(completer);

    // final logger = LoggerFactory.getLogger('DatabaseConnectionPool');
    LoggerUtils.debug('等待可用连接: ${_waitingQueue.length}个请求');

    return completer.future.timeout(_connectionTimeout);
  }

  /// 处理等待队列
  void _processWaitingQueue() {
    while (_waitingQueue.isNotEmpty && _availableConnections.isNotEmpty) {
      final completer = _waitingQueue.removeFirst();
      final connection = _availableConnections.removeLast();
      _usedConnections.add(connection);
      _activeConnections++;

      if (!completer.isCompleted) {
        completer.complete(connection);
      }
    }
  }

  /// 检查连接是否健康
  Future<bool> _isConnectionHealthy(Connection connection) async {
    try {
      await connection.execute('SELECT 1');
      return true;
    } catch (error) {
      LoggerUtils.error('连接健康检查失败', error: error);
      return false;
    }
  }

  /// 启动健康检查定时器
  void _startHealthCheckTimer() {
    _healthCheckTimer = Timer.periodic(Duration(minutes: 5), (timer) async {
      try {
        await _performHealthCheck();
      } catch (error) {
        LoggerUtils.error('健康检查定时器错误', error: error);
      }
    });
  }

  /// 启动清理定时器
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(Duration(minutes: 10), (timer) async {
      try {
        await _performCleanup();
      } catch (error) {
        LoggerUtils.error('清理定时器错误', error: error);
      }
    });
  }

  /// 执行健康检查
  Future<void> _performHealthCheck() async {
    final unhealthyConnections = <Connection>[];

    for (final connection in _availableConnections) {
      if (!await _isConnectionHealthy(connection)) {
        unhealthyConnections.add(connection);
      }
    }

    // 移除不健康的连接
    for (final connection in unhealthyConnections) {
      _availableConnections.remove(connection);
      _totalConnections--;
      try {
        await connection.close();
      } catch (e) {
        // 忽略关闭错误
      }
    }

    if (unhealthyConnections.isNotEmpty) {
      LoggerUtils.warning('移除不健康连接: ${unhealthyConnections.length}个');
    }
  }

  /// 执行清理
  Future<void> _performCleanup() async {
    // 如果连接数超过最小值，清理多余连接
    if (_availableConnections.length > _minConnections) {
      final excessCount = _availableConnections.length - _minConnections;
      final connectionsToRemove = _availableConnections.take(excessCount).toList();

      for (final connection in connectionsToRemove) {
        _availableConnections.remove(connection);
        _totalConnections--;
        try {
          await connection.close();
        } catch (e) {
          // 忽略关闭错误
        }
      }

      if (connectionsToRemove.isNotEmpty) {
        LoggerUtils.info('清理多余连接: ${connectionsToRemove.length}个');
      }
    }
  }
}
