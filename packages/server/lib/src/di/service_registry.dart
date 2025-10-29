import 'package:ttpolyglot_model/model.dart';

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
    ServerLogger.info('开始注册所有服务...');

    try {
      // 1. 注册配置服务
      await _registerConfigServices();

      // 2. 注册基础设施服务
      await _registerInfrastructureServices();

      // 3. 注册业务服务
      await _registerBusinessServices();

      // 4. 注册中间件服务
      await _registerMiddlewareServices();

      ServerLogger.info('所有服务注册完成');
      _logRegisteredServices();
    } catch (error, stackTrace) {
      ServerLogger.error('服务注册失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 注册配置服务
  Future<void> _registerConfigServices() async {
    ServerLogger.info('注册配置服务...');

    // 加载配置
    await ServerConfig.load();

    // 验证配置
    if (!ServerConfig.validate()) {
      throw Exception('配置验证失败');
    }

    ServerLogger.info('配置服务注册完成');
  }

  /// 注册基础设施服务
  Future<void> _registerInfrastructureServices() async {
    ServerLogger.info('注册基础设施服务...');

    // 注册数据库连接池
    _container.registerSingleton<DatabaseConnectionPool>(
      DatabaseConnectionPool(),
    );

    // 注册数据库服务
    _container.registerSingleton<DatabaseService>(
      DatabaseService(),
    );

    // 注册Redis服务
    _container.registerSingleton<RedisService>(
      RedisService(),
    );

    // 注册多级缓存服务
    _container.register<MultiLevelCacheService>(
      () => MultiLevelCacheService(redisService: _container.get<RedisService>()),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册指标服务
    _container.registerSingleton<MetricsService>(
      MetricsService(),
    );

    ServerLogger.info('基础设施服务注册完成');
  }

  /// 注册业务服务
  Future<void> _registerBusinessServices() async {
    ServerLogger.info('注册业务服务...');

    // 注册邮件服务
    _container.register<EmailService>(
      () => EmailService(),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册文件上传服务
    _container.register<FileUploadService>(
      () => FileUploadService(),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册IP地理位置服务
    _container.register<IpLocationService>(
      () => IpLocationService(
        redisService: _container.get<RedisService>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册权限服务
    _container.register<PermissionService>(
      () => PermissionService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册用户服务（必须先注册，因为 AuthService 依赖它）
    _container.register<UserService>(
      () => UserService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
        ipLocationService: _container.get<IpLocationService>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册用户设置服务
    _container.register<UserSettingsService>(
      () => UserSettingsService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册认证服务（依赖 UserService）
    _container.register<AuthService>(
      () => AuthService(
        emailService: _container.get<EmailService>(),
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
        userService: _container.get<UserService>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册项目服务
    _container.register<ProjectService>(
      () => ProjectService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
      ),
      lifetime: ServiceLifetime.singleton,
    );

    // 注册项目成员服务
    _container.register<ProjectMemberService>(
      () => ProjectMemberService(
        databaseService: _container.get<DatabaseService>(),
        redisService: _container.get<RedisService>(),
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

    ServerLogger.info('业务服务注册完成');
  }

  /// 注册中间件服务
  Future<void> _registerMiddlewareServices() async {
    ServerLogger.info('注册中间件服务...');

    // 这里可以注册中间件相关的服务
    // 例如：认证中间件、CORS中间件等

    ServerLogger.info('中间件服务注册完成');
  }

  /// 初始化所有服务
  Future<void> initializeAllServices() async {
    ServerLogger.info('开始初始化所有服务...');

    try {
      // 初始化基础设施服务
      await _initializeInfrastructureServices();

      // 初始化业务服务
      await _initializeBusinessServices();

      ServerLogger.info('所有服务初始化完成');
    } catch (error, stackTrace) {
      ServerLogger.error('服务初始化失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 初始化基础设施服务
  Future<void> _initializeInfrastructureServices() async {
    ServerLogger.info('初始化基础设施服务...');

    // 并行初始化基础设施服务
    await Future.wait([
      _container.get<DatabaseConnectionPool>().initialize(),
      _container.get<DatabaseService>().initialize(),
      _container.get<RedisService>().initialize(),
    ]);

    // 暂时跳过数据库迁移（开发阶段）
    // await _container.get<MigrationService>().runMigrations();
    // await _container.get<MigrationService>().runSeeds();

    ServerLogger.info('基础设施服务初始化完成');
  }

  /// 初始化业务服务
  Future<void> _initializeBusinessServices() async {
    ServerLogger.info('初始化业务服务...');

    // 业务服务通常不需要特殊的初始化
    // 但可以在这里添加预热逻辑

    // 预热缓存服务
    _container.get<MultiLevelCacheService>();
    ServerLogger.info('缓存服务预热完成');

    ServerLogger.info('业务服务初始化完成');
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
    ServerLogger.info('已注册服务统计: $stats');
  }

  /// 清理所有服务
  Future<void> dispose() async {
    ServerLogger.info('开始清理所有服务...');

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

      ServerLogger.info('所有服务清理完成');
    } catch (error, stackTrace) {
      ServerLogger.error('服务清理失败', error: error, stackTrace: stackTrace);
    }
  }
}

/// 全局服务注册器实例
final ServiceRegistry serviceRegistry = ServiceRegistry();
