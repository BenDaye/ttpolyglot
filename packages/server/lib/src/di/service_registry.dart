import 'dart:developer';

import '../config/server_config.dart';
import '../services/services.dart';
import 'dependency_injection.dart';

/// 服务注册器
class ServiceRegistry {
  static final ServiceRegistry _instance = ServiceRegistry._internal();
  factory ServiceRegistry() => _instance;
  ServiceRegistry._internal();

  final DIContainer _container = DIContainer();

  /// 注册所有服务
  Future<void> registerAllServices() async {
    log('开始注册所有服务...', name: 'ServiceRegistry');

    try {
      // 1. 注册配置服务
      await _registerConfigServices();

      // 2. 注册基础设施服务
      await _registerInfrastructureServices();

      // 3. 注册业务服务
      await _registerBusinessServices();

      // 4. 注册中间件服务
      await _registerMiddlewareServices();

      log('所有服务注册完成', name: 'ServiceRegistry');
      _logRegisteredServices();
    } catch (error, stackTrace) {
      log('服务注册失败', error: error, stackTrace: stackTrace, name: 'ServiceRegistry');
      rethrow;
    }
  }

  /// 注册配置服务
  Future<void> _registerConfigServices() async {
    log('注册配置服务...', name: 'ServiceRegistry');

    // 注册服务器配置
    _container.registerSingleton<ServerConfig>(ServerConfig());

    // 加载配置
    final config = _container.get<ServerConfig>();
    await config.load();

    log('配置服务注册完成', name: 'ServiceRegistry');
  }

  /// 注册基础设施服务
  Future<void> _registerInfrastructureServices() async {
    log('注册基础设施服务...', name: 'ServiceRegistry');

    final config = _container.get<ServerConfig>();

    // 注册数据库连接池
    _container.registerSingleton<DatabaseConnectionPool>(
      DatabaseConnectionPool(config),
    );

    // 注册数据库服务
    _container.registerSingleton<DatabaseService>(
      DatabaseService(config),
    );

    // 注册Redis服务
    _container.registerSingleton<RedisService>(
      RedisService(config),
    );

    // 注册多级缓存服务
    _container.register<MultiLevelCacheService>(
      () => MultiLevelCacheService(redisService: _container.get<RedisService>()),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册迁移服务
    _container.register<MigrationService>(
      () => MigrationService(
        _container.get<DatabaseService>(),
        _container.get<ServerConfig>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    log('基础设施服务注册完成', name: 'ServiceRegistry');
  }

  /// 注册业务服务
  Future<void> _registerBusinessServices() async {
    log('注册业务服务...', name: 'ServiceRegistry');

    // 注册权限服务
    _container.register<PermissionService>(
      () => PermissionService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册认证服务
    _container.register<AuthService>(
      () => AuthService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
        config: _container.get<ServerConfig>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册用户服务
    _container.register<UserService>(
      () => UserService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
        config: _container.get<ServerConfig>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册项目服务
    _container.register<ProjectService>(
      () => ProjectService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
        config: _container.get<ServerConfig>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册翻译服务
    _container.register<TranslationService>(
      () => TranslationService(
        databaseService: _container.get<DatabaseService>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册翻译提供商服务
    _container.register<TranslationProviderService>(
      () => TranslationProviderService(
        databaseService: _container.get<DatabaseService>(),
        config: _container.get<ServerConfig>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册邮件服务
    _container.register<EmailService>(
      () => EmailService(_container.get<ServerConfig>()),
      lifetime: ServiceLifetime.singleton,
    );

    log('业务服务注册完成', name: 'ServiceRegistry');
  }

  /// 注册中间件服务
  Future<void> _registerMiddlewareServices() async {
    log('注册中间件服务...', name: 'ServiceRegistry');

    // 这里可以注册中间件相关的服务
    // 例如：认证中间件、CORS中间件等

    log('中间件服务注册完成', name: 'ServiceRegistry');
  }

  /// 初始化所有服务
  Future<void> initializeAllServices() async {
    log('开始初始化所有服务...', name: 'ServiceRegistry');

    try {
      // 初始化基础设施服务
      await _initializeInfrastructureServices();

      // 初始化业务服务
      await _initializeBusinessServices();

      log('所有服务初始化完成', name: 'ServiceRegistry');
    } catch (error, stackTrace) {
      log('服务初始化失败', error: error, stackTrace: stackTrace, name: 'ServiceRegistry');
      rethrow;
    }
  }

  /// 初始化基础设施服务
  Future<void> _initializeInfrastructureServices() async {
    log('初始化基础设施服务...', name: 'ServiceRegistry');

    // 并行初始化基础设施服务
    await Future.wait([
      _container.get<DatabaseConnectionPool>().initialize(),
      _container.get<DatabaseService>().initialize(),
      _container.get<RedisService>().initialize(),
    ]);

    // 运行数据库迁移
    await _container.get<MigrationService>().runMigrations();
    await _container.get<MigrationService>().runSeeds();

    log('基础设施服务初始化完成', name: 'ServiceRegistry');
  }

  /// 初始化业务服务
  Future<void> _initializeBusinessServices() async {
    log('初始化业务服务...', name: 'ServiceRegistry');

    // 业务服务通常不需要特殊的初始化
    // 但可以在这里添加预热逻辑

    // 预热缓存服务
    _container.get<MultiLevelCacheService>();
    log('缓存服务预热完成', name: 'ServiceRegistry');

    log('业务服务初始化完成', name: 'ServiceRegistry');
  }

  /// 获取服务实例
  T get<T>() => _container.get<T>();

  /// 尝试获取服务实例
  T? tryGet<T>() => _container.tryGet<T>();

  /// 检查服务是否已注册
  bool isRegistered<T>() => _container.isRegistered<T>();

  /// 获取容器统计信息
  Map<String, dynamic> getContainerStats() => _container.getStats();

  /// 记录已注册的服务
  void _logRegisteredServices() {
    final stats = _container.getStats();
    log('已注册服务统计: $stats', name: 'ServiceRegistry');
  }

  /// 清理所有服务
  Future<void> dispose() async {
    log('开始清理所有服务...', name: 'ServiceRegistry');

    try {
      // 清理数据库连接池
      if (_container.isRegistered<DatabaseConnectionPool>()) {
        await _container.get<DatabaseConnectionPool>().close();
      }

      // 清理数据库连接
      if (_container.isRegistered<DatabaseService>()) {
        await _container.get<DatabaseService>().close();
      }

      // 清理Redis连接
      if (_container.isRegistered<RedisService>()) {
        await _container.get<RedisService>().close();
      }

      // 清理缓存
      if (_container.isRegistered<MultiLevelCacheService>()) {
        await _container.get<MultiLevelCacheService>().clear();
      }

      // 清理容器
      _container.clear();

      log('所有服务清理完成', name: 'ServiceRegistry');
    } catch (error, stackTrace) {
      log('服务清理失败', error: error, stackTrace: stackTrace, name: 'ServiceRegistry');
    }
  }
}

/// 全局服务注册器实例
final ServiceRegistry serviceRegistry = ServiceRegistry();
