import 'dart:developer';

import '../lib/src/services/feature/ip_location_service.dart';
import '../lib/src/services/infrastructure/redis_service.dart';

/// IP地理位置服务使用示例
void main() async {
  log('IP地理位置服务示例', name: 'IpLocationExample');

  try {
    // 初始化Redis服务
    final redisService = RedisService();
    await redisService.initialize();

    // 创建IP地理位置服务
    final ipLocationService = IpLocationService(
      redisService: redisService,
    );

    // 示例1: 查询单个IP地址
    log('=== 示例1: 查询单个IP地址 ===', name: 'IpLocationExample');
    final ip1 = '114.114.114.114'; // 中国DNS服务器
    final location1 = await ipLocationService.getLocation(ip1);
    log('IP: $ip1', name: 'IpLocationExample');
    log('国家: ${location1['country']}', name: 'IpLocationExample');
    log('城市: ${location1['city']}', name: 'IpLocationExample');
    log('地区: ${location1['region']}', name: 'IpLocationExample');
    log('国家代码: ${location1['countryCode']}', name: 'IpLocationExample');
    log('时区: ${location1['timezone']}', name: 'IpLocationExample');
    log('ISP: ${location1['isp']}', name: 'IpLocationExample');

    // 示例2: 获取格式化的位置字符串
    log('\n=== 示例2: 格式化位置字符串 ===', name: 'IpLocationExample');
    final locationString1 = await ipLocationService.getLocationString(ip1);
    log('位置字符串: $locationString1', name: 'IpLocationExample');

    // 示例3: 查询国外IP
    log('\n=== 示例3: 查询国外IP ===', name: 'IpLocationExample');
    final ip2 = '8.8.8.8'; // Google DNS
    final location2 = await ipLocationService.getLocation(ip2);
    final locationString2 = await ipLocationService.getLocationString(ip2);
    log('IP: $ip2 -> $locationString2', name: 'IpLocationExample');
    log('详情: ${location2['country']} - ${location2['city']}', name: 'IpLocationExample');

    // 示例4: 本地IP处理
    log('\n=== 示例4: 本地IP处理 ===', name: 'IpLocationExample');
    final localIps = ['127.0.0.1', '192.168.1.1', '10.0.0.1'];
    for (final ip in localIps) {
      final location = await ipLocationService.getLocation(ip);
      log('IP: $ip -> ${location['country']}/${location['city']}', name: 'IpLocationExample');
    }

    // 示例5: 批量查询（受API限流限制）
    log('\n=== 示例5: 批量查询 ===', name: 'IpLocationExample');
    final ips = [
      '114.114.114.114', // 中国
      '8.8.8.8', // 美国
      '1.1.1.1', // 美国
    ];

    log('开始批量查询 ${ips.length} 个IP地址...', name: 'IpLocationExample');
    final locations = await ipLocationService.getLocations(ips);

    for (final entry in locations.entries) {
      log('${entry.key} -> ${entry.value['country']}/${entry.value['city']}', name: 'IpLocationExample');
    }

    // 示例6: 缓存测试
    log('\n=== 示例6: 缓存测试 ===', name: 'IpLocationExample');
    final testIp = '114.114.114.114';

    // 第一次查询（调用API）
    final startTime1 = DateTime.now();
    await ipLocationService.getLocation(testIp);
    final duration1 = DateTime.now().difference(startTime1);
    log('首次查询耗时: ${duration1.inMilliseconds}ms', name: 'IpLocationExample');

    // 第二次查询（使用缓存）
    final startTime2 = DateTime.now();
    await ipLocationService.getLocation(testIp);
    final duration2 = DateTime.now().difference(startTime2);
    log('缓存查询耗时: ${duration2.inMilliseconds}ms', name: 'IpLocationExample');

    // 示例7: 清除缓存
    log('\n=== 示例7: 清除缓存 ===', name: 'IpLocationExample');
    await ipLocationService.clearCache(testIp);
    log('缓存已清除: $testIp', name: 'IpLocationExample');

    // 清理
    await redisService.close();
    log('\n示例运行完成', name: 'IpLocationExample');
  } catch (error, stackTrace) {
    log('运行示例时出错', error: error, stackTrace: stackTrace, name: 'IpLocationExample');
  }
}
