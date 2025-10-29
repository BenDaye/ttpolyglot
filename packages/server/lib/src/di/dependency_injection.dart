import 'package:ttpolyglot_utils/utils.dart';

/// 依赖注入容器
class DIContainer {
  static final DIContainer _instance = DIContainer._internal();
  factory DIContainer() => _instance;
  DIContainer._internal();

  final Map<Type, dynamic> _services = {};
  final Map<Type, ServiceFactory> _factories = {};
  final Map<Type, ServiceLifetime> _lifetimes = {};

  /// 注册单例服务
  void registerSingleton<T>(T instance) {
    _services[T] = instance;
    _lifetimes[T] = ServiceLifetime.singleton;
    LoggerUtils.info('注册单例服务: ${T.toString()}');
  }

  /// 注册瞬态服务工厂
  void registerTransient<T>(T Function() factory) {
    _factories[T] = ServiceFactory(factory);
    _lifetimes[T] = ServiceLifetime.transient;
    LoggerUtils.info('注册瞬态服务: ${T.toString()}');
  }

  /// 注册作用域服务工厂
  void registerScoped<T>(T Function() factory) {
    _factories[T] = ServiceFactory(factory);
    _lifetimes[T] = ServiceLifetime.scoped;
    LoggerUtils.info('注册作用域服务: ${T.toString()}');
  }

  /// 注册服务（带生命周期）
  void register<T>(T Function() factory, {ServiceLifetime lifetime = ServiceLifetime.transient}) {
    switch (lifetime) {
      case ServiceLifetime.singleton:
        // 立即创建单例实例
        final instance = factory();
        registerSingleton<T>(instance);
        break;
      case ServiceLifetime.transient:
        registerTransient<T>(factory);
        break;
      case ServiceLifetime.scoped:
        registerScoped<T>(factory);
        break;
    }
  }

  /// 获取服务实例
  T get<T>() {
    final type = T;

    // 检查是否已注册
    if (!_services.containsKey(type) && !_factories.containsKey(type)) {
      throw ServiceNotFoundException('服务未注册: ${T.toString()}');
    }

    // 检查单例服务
    if (_lifetimes[type] == ServiceLifetime.singleton) {
      if (_services.containsKey(type)) {
        return _services[type];
      }
    }

    // 检查工厂服务
    if (_factories.containsKey(type)) {
      final factory = _factories[type]!;
      final instance = factory.create() as T;

      // 如果是单例，缓存实例
      if (_lifetimes[type] == ServiceLifetime.singleton) {
        _services[type] = instance;
      }

      return instance;
    }

    throw ServiceNotFoundException('无法创建服务实例: ${T.toString()}');
  }

  /// 尝试获取服务实例（不抛异常）
  T? tryGet<T>() {
    try {
      return get<T>();
    } catch (e) {
      return null;
    }
  }

  /// 检查服务是否已注册
  bool isRegistered<T>() {
    return _services.containsKey(T) || _factories.containsKey(T);
  }

  /// 获取所有已注册的服务类型
  List<Type> getRegisteredServices() {
    return [..._services.keys, ..._factories.keys];
  }

  /// 清除所有服务
  void clear() {
    _services.clear();
    _factories.clear();
    _lifetimes.clear();
    LoggerUtils.info('依赖注入容器已清空');
  }

  /// 移除特定服务
  void remove<T>() {
    _services.remove(T);
    _factories.remove(T);
    _lifetimes.remove(T);
    LoggerUtils.info('移除服务: ${T.toString()}');
  }

  /// 获取服务统计信息
  Map<String, dynamic> getStats() {
    return {
      'total_services': _services.length + _factories.length,
      'singleton_services': _services.length,
      'factory_services': _factories.length,
      'registered_types': getRegisteredServices().map((t) => t.toString()).toList(),
    };
  }
}

/// 服务工厂
class ServiceFactory {
  final Function _factory;

  ServiceFactory(this._factory);

  dynamic create() => _factory();
}

/// 服务生命周期
enum ServiceLifetime {
  singleton, // 单例
  transient, // 瞬态
  scoped, // 作用域
}

/// 服务未找到异常
class ServiceNotFoundException implements Exception {
  final String message;

  ServiceNotFoundException(this.message);

  @override
  String toString() => 'ServiceNotFoundException: $message';
}

/// 依赖注入扩展方法
extension DIExtensions on DIContainer {
  /// 批量注册服务
  void registerBatch(Map<Type, dynamic> services) {
    services.forEach((type, service) {
      if (service is Function) {
        registerTransient(() => service());
      } else {
        registerSingleton(service);
      }
    });
  }

  /// 条件注册服务
  void registerIf<T>(bool condition, T Function() factory, {ServiceLifetime lifetime = ServiceLifetime.transient}) {
    if (condition) {
      register<T>(factory, lifetime: lifetime);
    }
  }

  /// 注册服务别名
  void registerAlias<T, U>() {
    register<T>(() => get<U>() as T);
  }
}

/// 全局依赖注入容器实例
final DIContainer di = DIContainer();
