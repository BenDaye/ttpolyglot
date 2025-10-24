import 'dart:convert';

import 'package:redis/redis.dart';

import '../../config/server_config.dart';
import '../../utils/logging/logger_utils.dart';

/// Redis服务类
class RedisService {
  RedisConnection? _connection;
  Command? _command;

  /// 初始化Redis连接
  Future<void> initialize() async {
    try {
      // 解析Redis URL
      final uri = Uri.parse(ServerConfig.redisUrl);

      _connection = RedisConnection();
      _command = await _connection!.connect(
        uri.host,
        uri.port,
      );

      // 如果有密码，进行认证
      if (ServerConfig.redisPassword.isNotEmpty) {
        await _command!.send_object(['AUTH', ServerConfig.redisPassword]);
      }

      // 测试连接
      final result = await _command!.send_object(['PING']);
      if (result != 'PONG') {
        throw Exception('Redis连接测试失败');
      }

      LoggerUtils.info('Redis连接成功: ${uri.host}:${uri.port}');
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis连接失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取Redis命令对象
  Command get command {
    if (_command == null) {
      throw Exception('Redis连接未初始化');
    }
    return _command!;
  }

  /// 检查Redis健康状态
  Future<bool> isHealthy() async {
    try {
      if (_command == null) return false;

      final result = await _command!.send_object(['PING']);
      return result == 'PONG';
    } catch (error) {
      LoggerUtils.error('Redis健康检查失败', error: error);
      return false;
    }
  }

  /// 设置字符串值
  Future<void> set(String key, String value, [int? ttlSeconds]) async {
    try {
      if (ttlSeconds != null) {
        await command.send_object(['SETEX', key, ttlSeconds, value]);
      } else {
        await command.send_object(['SET', key, value]);
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis SET操作失败: $key', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取字符串值
  Future<String?> get(String key) async {
    try {
      final result = await command.send_object(['GET', key]);
      return result?.toString();
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis GET操作失败: $key', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 设置JSON对象
  Future<void> setJson(String key, Map<String, dynamic> value, [int? ttlSeconds]) async {
    await set(key, jsonEncode(value, toEncodable: _toEncodable), ttlSeconds);
  }

  /// JSON 编码转换器，处理特殊类型
  static Object? _toEncodable(dynamic value) {
    if (value is DateTime) {
      return value.toUtc().toIso8601String();
    }
    return value;
  }

  /// 获取JSON对象
  Future<Map<String, dynamic>?> getJson(String key) async {
    final result = await get(key);
    if (result == null) return null;

    try {
      return jsonDecode(result) as Map<String, dynamic>;
    } catch (error) {
      LoggerUtils.error('JSON解析失败: $key', error: error);
      return null;
    }
  }

  /// 删除键
  Future<int> delete(String key) async {
    try {
      final result = await command.send_object(['DEL', key]);
      return result as int;
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis DELETE操作失败: $key', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 批量删除键（支持模式）
  Future<int> deleteByPattern(String pattern) async {
    try {
      final keys = await command.send_object(['KEYS', pattern]);
      if (keys is List && keys.isNotEmpty) {
        final result = await command.send_object(['DEL', ...keys]);
        return result as int;
      }
      return 0;
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis批量删除失败: $pattern', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 检查键是否存在
  Future<bool> exists(String key) async {
    try {
      final result = await command.send_object(['EXISTS', key]);
      return (result as int) > 0;
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis EXISTS操作失败: $key', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 设置键的过期时间
  Future<bool> expire(String key, int seconds) async {
    try {
      final result = await command.send_object(['EXPIRE', key, seconds]);
      return (result as int) == 1;
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis EXPIRE操作失败: $key', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取键的剩余生存时间
  Future<int> ttl(String key) async {
    try {
      final result = await command.send_object(['TTL', key]);
      return result as int;
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis TTL操作失败: $key', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 递增计数器
  Future<int> increment(String key, [int? by]) async {
    try {
      final result =
          by != null ? await command.send_object(['INCRBY', key, by]) : await command.send_object(['INCR', key]);
      return result as int;
    } catch (error, stackTrace) {
      LoggerUtils.error('Redis INCREMENT操作失败: $key', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 用户会话缓存相关方法

  /// 设置用户会话
  Future<void> setUserSession(String userId, Map<String, dynamic> sessionData) async {
    await setJson('user:session:$userId', sessionData, ServerConfig.cacheSessionTtl);
  }

  /// 获取用户会话
  Future<Map<String, dynamic>?> getUserSession(String userId) async {
    return await getJson('user:session:$userId');
  }

  /// 删除用户会话
  Future<void> deleteUserSession(String userId) async {
    await delete('user:session:$userId');
  }

  /// 缓存用户权限
  Future<void> setUserPermissions(String userId, List<String> permissions) async {
    await setJson('user:permissions:$userId', {'permissions': permissions}, ServerConfig.cachePermissionTtl);
  }

  /// 获取用户权限
  Future<List<String>?> getUserPermissions(String userId) async {
    final result = await getJson('user:permissions:$userId');
    if (result == null) return null;

    final permissions = result['permissions'] as List<dynamic>?;
    return permissions?.cast<String>();
  }

  /// 设置权限缓存
  Future<void> setPermissionCache(String key, dynamic value) async {
    final fullKey = 'permission:$key';
    final valueStr = value is bool ? (value ? 'true' : 'false') : value.toString();
    await set(fullKey, valueStr, ServerConfig.cachePermissionTtl);
  }

  /// 设置API响应缓存
  Future<void> setApiResponseCache(String cacheKey, Map<String, dynamic> responseData) async {
    await setJson('api:response:$cacheKey', responseData, ServerConfig.cacheApiResponseTtl);
  }

  /// 获取API响应缓存
  Future<Map<String, dynamic>?> getApiResponseCache(String cacheKey) async {
    return await getJson('api:response:$cacheKey');
  }

  /// 设置系统配置缓存
  Future<void> setSystemConfig(String configKey, dynamic configValue) async {
    await set('config:system:$configKey', configValue.toString(), ServerConfig.cacheConfigTtl);
  }

  /// 获取系统配置缓存
  Future<String?> getSystemConfig(String configKey) async {
    return await get('config:system:$configKey');
  }

  /// 设置临时数据（如验证码、重置token等）
  Future<void> setTempData(String key, String value) async {
    await set('temp:$key', value, ServerConfig.cacheTempDataTtl);
  }

  /// 获取临时数据
  Future<String?> getTempData(String key) async {
    return await get('temp:$key');
  }

  /// 删除匹配模式的键（用于权限缓存清理）
  Future<void> deletePattern(String pattern) async {
    try {
      await deleteByPattern(pattern);
    } catch (error, stackTrace) {
      LoggerUtils.error('删除匹配模式的键失败: $pattern', error: error, stackTrace: stackTrace);
    }
  }

  /// 关闭Redis连接
  Future<void> close() async {
    try {
      if (_connection != null) {
        await _connection!.close();
        _connection = null;
        _command = null;
        LoggerUtils.info('Redis连接已关闭');
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('关闭Redis连接时出错', error: error, stackTrace: stackTrace);
    }
  }
}
