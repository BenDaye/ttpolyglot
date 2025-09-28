import 'dart:convert';
import 'dart:developer';

import 'redis_service.dart';

/// 多级缓存服务
/// 实现 L1(内存) + L2(Redis) 的两级缓存策略
class MultiLevelCacheService {
  final RedisService _redisService;

  // L1 缓存：内存缓存
  final Map<String, _CacheEntry> _l1Cache = {};
  final Map<String, DateTime> _l1Timestamps = {};

  // 缓存统计
  int _l1Hits = 0;
  int _l1Misses = 0;
  int _l2Hits = 0;
  int _l2Misses = 0;

  // 配置
  static const Duration _l2DefaultTtl = Duration(hours: 1);
  static const int _maxL1Size = 1000; // 最大L1缓存条目数

  MultiLevelCacheService({
    required RedisService redisService,
  }) : _redisService = redisService;

  /// 获取缓存值（多级查找）
  Future<T?> get<T>(String key, {T Function(String)? fromJson}) async {
    try {
      // L1 缓存查找
      final l1Result = _getFromL1<T>(key, fromJson);
      if (l1Result != null) {
        _l1Hits++;
        log('L1缓存命中: $key', name: 'MultiLevelCache');
        return l1Result;
      }
      _l1Misses++;

      // L2 缓存查找
      final l2Result = await _getFromL2<T>(key, fromJson);
      if (l2Result != null) {
        _l2Hits++;
        log('L2缓存命中: $key', name: 'MultiLevelCache');

        // 回填L1缓存
        _setToL1(key, l2Result);
        return l2Result;
      }
      _l2Misses++;

      log('缓存未命中: $key', name: 'MultiLevelCache');
      return null;
    } catch (error, stackTrace) {
      log('获取缓存失败: $key', error: error, stackTrace: stackTrace, name: 'MultiLevelCache');
      return null;
    }
  }

  /// 设置缓存值（多级存储）
  Future<void> set<T>(
    String key,
    T value, {
    Duration? l1Ttl,
    Duration? l2Ttl,
    String Function(T)? toJson,
  }) async {
    try {
      // 设置L1缓存
      _setToL1(key, value, l1Ttl);

      // 设置L2缓存
      await _setToL2(key, value, l2Ttl, toJson);

      log('缓存设置成功: $key', name: 'MultiLevelCache');
    } catch (error, stackTrace) {
      log('设置缓存失败: $key', error: error, stackTrace: stackTrace, name: 'MultiLevelCache');
    }
  }

  /// 删除缓存值（多级删除）
  Future<void> delete(String key) async {
    try {
      // 删除L1缓存
      _deleteFromL1(key);

      // 删除L2缓存
      await _deleteFromL2(key);

      log('缓存删除成功: $key', name: 'MultiLevelCache');
    } catch (error, stackTrace) {
      log('删除缓存失败: $key', error: error, stackTrace: stackTrace, name: 'MultiLevelCache');
    }
  }

  /// 批量获取缓存值
  Future<Map<String, T?>> getBatch<T>(
    List<String> keys, {
    T Function(String)? fromJson,
  }) async {
    final results = <String, T?>{};

    try {
      // 并行处理所有键
      final futures = keys.map((key) async {
        final value = await get<T>(key, fromJson: fromJson);
        return MapEntry(key, value);
      });

      final entries = await Future.wait(futures);
      for (final entry in entries) {
        results[entry.key] = entry.value;
      }

      log('批量获取缓存完成: ${keys.length}个键', name: 'MultiLevelCache');
    } catch (error, stackTrace) {
      log('批量获取缓存失败', error: error, stackTrace: stackTrace, name: 'MultiLevelCache');
    }

    return results;
  }

  /// 批量设置缓存值
  Future<void> setBatch<T>(
    Map<String, T> values, {
    Duration? l1Ttl,
    Duration? l2Ttl,
    String Function(T)? toJson,
  }) async {
    try {
      // 并行设置所有值
      final futures = values.entries.map((entry) async {
        await set<T>(
          entry.key,
          entry.value,
          l1Ttl: l1Ttl,
          l2Ttl: l2Ttl,
          toJson: toJson,
        );
      });

      await Future.wait(futures);
      log('批量设置缓存完成: ${values.length}个键', name: 'MultiLevelCache');
    } catch (error, stackTrace) {
      log('批量设置缓存失败', error: error, stackTrace: stackTrace, name: 'MultiLevelCache');
    }
  }

  /// 清空所有缓存
  Future<void> clear() async {
    try {
      // 清空L1缓存
      _l1Cache.clear();
      _l1Timestamps.clear();

      // 清空L2缓存（需要实现Redis清空逻辑）
      // await _redisService.clearAll();

      log('所有缓存已清空', name: 'MultiLevelCache');
    } catch (error, stackTrace) {
      log('清空缓存失败', error: error, stackTrace: stackTrace, name: 'MultiLevelCache');
    }
  }

  /// 获取缓存统计信息
  Map<String, dynamic> getStats() {
    final totalRequests = _l1Hits + _l1Misses + _l2Hits + _l2Misses;
    final l1HitRate = totalRequests > 0 ? (_l1Hits / totalRequests * 100).toStringAsFixed(2) : '0.00';
    final l2HitRate = totalRequests > 0 ? (_l2Hits / totalRequests * 100).toStringAsFixed(2) : '0.00';
    final overallHitRate = totalRequests > 0 ? ((_l1Hits + _l2Hits) / totalRequests * 100).toStringAsFixed(2) : '0.00';

    return {
      'l1_cache': {
        'hits': _l1Hits,
        'misses': _l1Misses,
        'hit_rate': '$l1HitRate%',
        'size': _l1Cache.length,
        'max_size': _maxL1Size,
      },
      'l2_cache': {
        'hits': _l2Hits,
        'misses': _l2Misses,
        'hit_rate': '$l2HitRate%',
      },
      'overall': {
        'total_requests': totalRequests,
        'hit_rate': '$overallHitRate%',
        'l1_hit_rate': '$l1HitRate%',
        'l2_hit_rate': '$l2HitRate%',
      },
    };
  }

  /// 预热缓存
  Future<void> warmup<T>(
    List<String> keys,
    T Function(String) valueFactory, {
    Duration? l1Ttl,
    Duration? l2Ttl,
    String Function(T)? toJson,
  }) async {
    try {
      log('开始缓存预热: ${keys.length}个键', name: 'MultiLevelCache');

      // 并行预热所有键
      final futures = keys.map((key) async {
        final value = valueFactory(key);
        await set<T>(key, value, l1Ttl: l1Ttl, l2Ttl: l2Ttl, toJson: toJson);
      });

      await Future.wait(futures);
      log('缓存预热完成', name: 'MultiLevelCache');
    } catch (error, stackTrace) {
      log('缓存预热失败', error: error, stackTrace: stackTrace, name: 'MultiLevelCache');
    }
  }

  // 私有方法：L1缓存操作

  /// 从L1缓存获取值
  T? _getFromL1<T>(String key, T Function(String)? fromJson) {
    final entry = _l1Cache[key];
    if (entry == null) return null;

    // 检查是否过期
    if (entry.expiresAt != null && DateTime.now().isAfter(entry.expiresAt!)) {
      _deleteFromL1(key);
      return null;
    }

    // 更新访问时间
    _l1Timestamps[key] = DateTime.now();

    // 转换类型
    if (entry.value is T) {
      return entry.value as T;
    }

    if (fromJson != null && entry.value is String) {
      return fromJson(entry.value as String);
    }

    return null;
  }

  /// 设置L1缓存
  void _setToL1<T>(String key, T value, [Duration? ttl]) {
    // 检查缓存大小限制
    if (_l1Cache.length >= _maxL1Size) {
      _evictL1Cache();
    }

    final expiresAt = ttl != null ? DateTime.now().add(ttl) : null;
    _l1Cache[key] = _CacheEntry(value, expiresAt);
    _l1Timestamps[key] = DateTime.now();
  }

  /// 从L1缓存删除
  void _deleteFromL1(String key) {
    _l1Cache.remove(key);
    _l1Timestamps.remove(key);
  }

  /// L1缓存淘汰策略（LRU）
  void _evictL1Cache() {
    if (_l1Cache.isEmpty) return;

    // 找到最久未访问的键
    String? oldestKey;
    DateTime? oldestTime;

    for (final entry in _l1Timestamps.entries) {
      if (oldestTime == null || entry.value.isBefore(oldestTime)) {
        oldestTime = entry.value;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _deleteFromL1(oldestKey);
      log('L1缓存淘汰: $oldestKey', name: 'MultiLevelCache');
    }
  }

  // 私有方法：L2缓存操作

  /// 从L2缓存获取值
  Future<T?> _getFromL2<T>(String key, T Function(String)? fromJson) async {
    try {
      final value = await _redisService.get(key);
      if (value == null) return null;

      // 转换类型
      if (value is T) {
        return value as T;
      }

      if (fromJson != null) {
        return fromJson(value);
      }

      return null;
    } catch (error) {
      log('L2缓存获取失败: $key', error: error, name: 'MultiLevelCache');
      return null;
    }
  }

  /// 设置L2缓存
  Future<void> _setToL2<T>(String key, T value, Duration? ttl, String Function(T)? toJson) async {
    try {
      String jsonValue;
      if (toJson != null) {
        jsonValue = toJson(value);
      } else if (value is String) {
        jsonValue = value;
      } else {
        jsonValue = jsonEncode(value);
      }

      final ttlSeconds = ttl?.inSeconds ?? _l2DefaultTtl.inSeconds;
      await _redisService.set(key, jsonValue, ttlSeconds);
    } catch (error) {
      log('L2缓存设置失败: $key', error: error, name: 'MultiLevelCache');
    }
  }

  /// 从L2缓存删除
  Future<void> _deleteFromL2(String key) async {
    try {
      await _redisService.delete(key);
    } catch (error) {
      log('L2缓存删除失败: $key', error: error, name: 'MultiLevelCache');
    }
  }
}

/// 缓存条目
class _CacheEntry {
  final dynamic value;
  final DateTime? expiresAt;

  _CacheEntry(this.value, this.expiresAt);
}
