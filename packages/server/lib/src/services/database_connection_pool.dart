import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:postgres/postgres.dart';

import '../config/server_config.dart';

/// 数据库连接池
class DatabaseConnectionPool {
  final ServerConfig _config;
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

  DatabaseConnectionPool(this._config) {
    _minConnections = _config.dbPoolSize;
    _maxConnections = _config.dbPoolSize * 2;
    _connectionTimeout = Duration(seconds: _config.dbConnectionTimeout);
  }

  /// 初始化连接池
  Future<void> initialize() async {
    try {
      log('初始化数据库连接池...', name: 'DatabaseConnectionPool');

      // 创建最小连接数
      await _createInitialConnections();

      // 启动健康检查定时器
      _startHealthCheckTimer();

      // 启动清理定时器
      _startCleanupTimer();

      log('数据库连接池初始化完成: ${_availableConnections.length}/${_maxConnections}', name: 'DatabaseConnectionPool');
    } catch (error, stackTrace) {
      log('数据库连接池初始化失败', error: error, stackTrace: stackTrace, name: 'DatabaseConnectionPool');
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

        log('从连接池获取连接: ${_activeConnections}/${_totalConnections}', name: 'DatabaseConnectionPool');
        return connection;
      }

      _poolMisses++;

      // 如果未达到最大连接数，创建新连接
      if (_totalConnections < _maxConnections) {
        final connection = await _createConnection();
        _usedConnections.add(connection);
        _activeConnections++;
        _totalConnections++;

        log('创建新连接: ${_activeConnections}/${_totalConnections}', name: 'DatabaseConnectionPool');
        return connection;
      }

      // 等待可用连接
      return await _waitForConnection();
    } catch (error, stackTrace) {
      _connectionErrors++;
      log('获取连接失败', error: error, stackTrace: stackTrace, name: 'DatabaseConnectionPool');
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
          log('连接已释放到池中: ${_activeConnections}/${_totalConnections}', name: 'DatabaseConnectionPool');
        } else {
          _totalConnections--;
          log('连接不健康，已移除: ${_activeConnections}/${_totalConnections}', name: 'DatabaseConnectionPool');
        }

        // 处理等待队列
        _processWaitingQueue();
      }
    } catch (error, stackTrace) {
      log('释放连接失败', error: error, stackTrace: stackTrace, name: 'DatabaseConnectionPool');
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
      log('连接池健康检查失败', error: error, name: 'DatabaseConnectionPool');
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
      log('开始关闭数据库连接池...', name: 'DatabaseConnectionPool');

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

      log('数据库连接池已关闭', name: 'DatabaseConnectionPool');
    } catch (error, stackTrace) {
      log('关闭连接池失败', error: error, stackTrace: stackTrace, name: 'DatabaseConnectionPool');
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
        connectTimeout: _connectionTimeout,
        queryTimeout: Duration(seconds: 30),
      );

      final connection = await Connection.open(
        endpoint,
        settings: connectionSettings,
      );

      log('创建数据库连接成功', name: 'DatabaseConnectionPool');
      return connection;
    } catch (error, stackTrace) {
      _connectionErrors++;
      log('创建数据库连接失败', error: error, stackTrace: stackTrace, name: 'DatabaseConnectionPool');
      rethrow;
    }
  }

  /// 等待可用连接
  Future<Connection> _waitForConnection() async {
    final completer = Completer<Connection>();
    _waitingQueue.add(completer);

    log('等待可用连接: ${_waitingQueue.length}个请求', name: 'DatabaseConnectionPool');

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
      log('连接健康检查失败', error: error, name: 'DatabaseConnectionPool');
      return false;
    }
  }

  /// 启动健康检查定时器
  void _startHealthCheckTimer() {
    _healthCheckTimer = Timer.periodic(Duration(minutes: 5), (timer) async {
      try {
        await _performHealthCheck();
      } catch (error) {
        log('健康检查定时器错误', error: error, name: 'DatabaseConnectionPool');
      }
    });
  }

  /// 启动清理定时器
  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(Duration(minutes: 10), (timer) async {
      try {
        await _performCleanup();
      } catch (error) {
        log('清理定时器错误', error: error, name: 'DatabaseConnectionPool');
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
      log('移除不健康连接: ${unhealthyConnections.length}个', name: 'DatabaseConnectionPool');
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
        log('清理多余连接: ${connectionsToRemove.length}个', name: 'DatabaseConnectionPool');
      }
    }
  }
}
