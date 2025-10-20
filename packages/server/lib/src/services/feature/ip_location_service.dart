import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../base_service.dart';
import '../infrastructure/redis_service.dart';

/// IP地理位置服务
/// 使用免费的 ip-api.com API 查询IP地理位置信息
class IpLocationService extends BaseService {
  final RedisService _redisService;

  // ip-api.com 免费API端点
  static const String _apiEndpoint = 'http://ip-api.com/json';

  // 缓存过期时间（7天）
  static const int _cacheTtl = 604800;

  IpLocationService({
    required RedisService redisService,
  })  : _redisService = redisService,
        super('IpLocationService');

  /// 查询IP地理位置信息
  ///
  /// 返回格式：
  /// ```dart
  /// {
  ///   'country': '中国',
  ///   'city': '北京',
  ///   'region': '北京市',
  ///   'countryCode': 'CN',
  ///   'timezone': 'Asia/Shanghai',
  ///   'isp': 'China Telecom',
  /// }
  /// ```
  Future<Map<String, String>> getLocation(String ipAddress) async {
    return execute(() async {
      // 处理特殊IP地址
      if (ipAddress.isEmpty || ipAddress == '未知' || ipAddress == 'unknown' || _isLocalIp(ipAddress)) {
        return _getDefaultLocation();
      }

      // 先检查缓存
      final cacheKey = 'ip_location:$ipAddress';
      final cachedData = await _redisService.getJson(cacheKey);

      if (cachedData != null) {
        logInfo('从缓存获取IP位置: $ipAddress');
        return Map<String, String>.from(cachedData);
      }

      // 调用API查询
      try {
        final url =
            '$_apiEndpoint/$ipAddress?lang=zh-CN&fields=status,message,country,countryCode,region,regionName,city,timezone,isp';
        logInfo('查询IP地理位置: $ipAddress');

        final response = await http.get(
          Uri.parse(url),
          headers: {'Accept': 'application/json'},
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            logWarning('IP地理位置查询超时: $ipAddress');
            return http.Response('{"status":"fail","message":"timeout"}', 408);
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;

          // 检查API返回状态
          if (data['status'] == 'success') {
            final locationData = {
              'country': data['country']?.toString() ?? '未知',
              'countryCode': data['countryCode']?.toString() ?? '',
              'region': data['regionName']?.toString() ?? '',
              'city': data['city']?.toString() ?? '未知',
              'timezone': data['timezone']?.toString() ?? '',
              'isp': data['isp']?.toString() ?? '',
            };

            // 缓存结果
            await _redisService.setJson(cacheKey, locationData, _cacheTtl);

            logInfo('IP地理位置查询成功: $ipAddress -> ${locationData['country']}/${locationData['city']}');
            return locationData;
          } else {
            logWarning('IP地理位置查询失败: $ipAddress, 原因: ${data['message']}');
            return _getDefaultLocation();
          }
        } else {
          logWarning('IP地理位置API请求失败: ${response.statusCode}');
          return _getDefaultLocation();
        }
      } catch (error, stackTrace) {
        log('getLocation', error: error, stackTrace: stackTrace, name: 'IpLocationService');
        logWarning('IP地理位置查询异常: $ipAddress');
        return _getDefaultLocation();
      }
    }, operationName: 'getLocation');
  }

  /// 获取格式化的位置字符串
  ///
  /// 返回格式：中国/北京
  Future<String> getLocationString(String ipAddress) async {
    final location = await getLocation(ipAddress);
    final country = location['country'] ?? '未知';
    final city = location['city'] ?? '未知';

    if (country == '未知' && city == '未知') {
      return '未知';
    }

    if (country == city) {
      return country;
    }

    return '$country/$city';
  }

  /// 批量查询IP地理位置
  ///
  /// 注意：为了避免API限流，会在每次请求之间添加延迟
  Future<Map<String, Map<String, String>>> getLocations(List<String> ipAddresses) async {
    final results = <String, Map<String, String>>{};

    for (final ip in ipAddresses) {
      results[ip] = await getLocation(ip);

      // 添加延迟以避免API限流（ip-api.com 限制：45请求/分钟）
      if (ipAddresses.length > 1) {
        await Future.delayed(const Duration(milliseconds: 1500));
      }
    }

    return results;
  }

  /// 检查是否为本地IP
  bool _isLocalIp(String ip) {
    // 检查本地回环地址
    if (ip.startsWith('127.') || ip == 'localhost' || ip == '::1') {
      return true;
    }

    // 检查私有IP地址段
    final patterns = [
      RegExp(r'^10\.'), // 10.0.0.0/8
      RegExp(r'^172\.(1[6-9]|2[0-9]|3[0-1])\.'), // 172.16.0.0/12
      RegExp(r'^192\.168\.'), // 192.168.0.0/16
      RegExp(r'^169\.254\.'), // 169.254.0.0/16 (APIPA)
      RegExp(r'^fc00:'), // IPv6 私有地址
      RegExp(r'^fe80:'), // IPv6 链路本地地址
    ];

    return patterns.any((pattern) => pattern.hasMatch(ip));
  }

  /// 获取默认位置信息
  Map<String, String> _getDefaultLocation() {
    return {
      'country': '未知',
      'countryCode': '',
      'region': '',
      'city': '未知',
      'timezone': '',
      'isp': '',
    };
  }

  /// 清除IP位置缓存
  Future<void> clearCache(String ipAddress) async {
    final cacheKey = 'ip_location:$ipAddress';
    await _redisService.delete(cacheKey);
    logInfo('清除IP位置缓存: $ipAddress');
  }

  /// 清除所有IP位置缓存
  Future<void> clearAllCache() async {
    // 注意：这需要Redis SCAN命令支持
    logWarning('清除所有IP位置缓存功能需要手动实现SCAN命令');
  }
}
