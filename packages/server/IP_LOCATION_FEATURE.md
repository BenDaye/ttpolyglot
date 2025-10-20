# IP 地理位置功能说明

## 功能概述

本功能为系统添加了 IP 地址到国家/城市的转换能力，使用免费的 ip-api.com API 服务。

## 主要特性

1. **IP 地址查询**：将 IP 地址转换为国家、城市等地理位置信息
2. **智能缓存**：使用 Redis 缓存查询结果（7天有效期），减少 API 调用
3. **本地 IP 识别**：自动识别并处理本地/私有 IP 地址
4. **批量查询**：支持批量查询多个 IP 地址
5. **API 限流保护**：自动添加延迟以避免触发 API 限流（45请求/分钟）

## API 返回数据格式

### 用户详情接口
```json
{
  "username": "testuser",
  "email": "test@example.com",
  "last_login_ip": "114.114.114.114",
  "last_login_location": {
    "country": "中国",
    "city": "北京",
    "region": "北京市",
    "country_code": "CN"
  },
  "last_login_location_string": "中国/北京"
}
```

### 用户列表接口
```json
{
  "users": [
    {
      "username": "testuser",
      "last_login_ip": "114.114.114.114",
      "last_login_location": {
        "country": "中国",
        "city": "北京",
        "region": "北京市",
        "country_code": "CN"
      },
      "last_login_location_string": "中国/北京"
    }
  ],
  "pagination": {...}
}
```

### 用户会话接口
```json
[
  {
    "id": "session-id",
    "ip_address": "114.114.114.114",
    "ip_location": {
      "country": "中国",
      "city": "北京",
      "region": "北京市",
      "country_code": "CN"
    },
    "ip_location_string": "中国/北京",
    "device_name": "Chrome on macOS",
    "last_activity_at": "2025-10-20T10:00:00Z"
  }
]
```

## 服务使用示例

### 基本使用

```dart
import 'package:ttpolyglot_server/src/services/feature/ip_location_service.dart';

// 获取服务实例
final ipLocationService = serviceRegistry.get<IpLocationService>();

// 查询单个IP地址
final location = await ipLocationService.getLocation('114.114.114.114');
print('国家: ${location['country']}');
print('城市: ${location['city']}');
print('地区: ${location['region']}');
print('国家代码: ${location['countryCode']}');
print('时区: ${location['timezone']}');
print('ISP: ${location['isp']}');

// 获取格式化的位置字符串
final locationString = await ipLocationService.getLocationString('114.114.114.114');
print('位置: $locationString'); // 输出：中国/北京
```

### 批量查询

```dart
final ips = ['114.114.114.114', '8.8.8.8', '1.1.1.1'];
final locations = await ipLocationService.getLocations(ips);

for (final entry in locations.entries) {
  print('${entry.key} -> ${entry.value['country']}/${entry.value['city']}');
}
```

### 清除缓存

```dart
// 清除单个IP的缓存
await ipLocationService.clearCache('114.114.114.114');

// 清除所有IP位置缓存（需要手动实现）
await ipLocationService.clearAllCache();
```

## 性能优化

### 缓存策略
- **缓存时长**：7天（604800秒）
- **缓存键格式**：`ip_location:{ip_address}`
- **首次查询**：调用 API，约 0.5-2 秒
- **缓存命中**：从 Redis 读取，约 1-10 毫秒

### API 限流处理
- ip-api.com 免费 API 限制：45请求/分钟
- 批量查询时每次请求间隔 1.5 秒
- 用户列表最多查询 10 个唯一 IP
- 超时时间：5 秒

## 特殊 IP 处理

以下情况返回默认位置（未知）：

1. **空值或未知**：`""`, `"未知"`, `"unknown"`
2. **本地回环地址**：`127.0.0.1`, `localhost`, `::1`
3. **私有 IP 地址段**：
   - 10.0.0.0/8
   - 172.16.0.0/12
   - 192.168.0.0/16
   - 169.254.0.0/16 (APIPA)
   - fc00::/7 (IPv6 私有)
   - fe80::/10 (IPv6 链路本地)

## 错误处理

### API 调用失败
- 超时：5 秒后返回默认位置
- 网络错误：捕获异常，返回默认位置
- API 错误：记录日志，返回默认位置

### 日志记录
```
INFO: 查询IP地理位置: 114.114.114.114
INFO: IP地理位置查询成功: 114.114.114.114 -> 中国/北京
INFO: 从缓存获取IP位置: 114.114.114.114
WARNING: IP地理位置查询超时: 1.2.3.4
WARNING: IP地理位置查询失败: 1.2.3.4, 原因: invalid query
```

## 依赖项

- **http**: ^1.1.2 - HTTP 客户端
- **redis**: ^3.1.0 - Redis 缓存
- ip-api.com - 免费 IP 地理位置 API

## 技术实现

### 文件结构
```
packages/server/lib/src/services/
├── feature/
│   ├── ip_location_service.dart  # IP地理位置服务（新增）
│   └── feature_services.dart     # 功能服务导出（已更新）
└── business/
    └── user_service.dart          # 用户服务（已更新）
```

### 依赖注入
```dart
// 在 service_registry.dart 中注册
_container.register<IpLocationService>(
  () => IpLocationService(
    redisService: _container.get<RedisService>(),
  ),
  lifetime: ServiceLifetime.singleton,
);
```

## 注意事项

1. **API 限流**：请勿频繁调用，建议依赖缓存
2. **隐私保护**：IP 地址属于敏感信息，注意权限控制
3. **API 可用性**：ip-api.com 是第三方服务，可能出现宕机
4. **网络延迟**：首次查询可能需要 0.5-2 秒，建议异步处理
5. **缓存清理**：定期清理过期缓存，避免 Redis 占用过多内存

## 未来优化方向

1. 支持多个 IP 地理位置 API 提供商（备用）
2. 使用本地 IP 数据库（如 MaxMind GeoIP2）
3. 实现缓存预热策略
4. 添加 IP 地理位置变更监控
5. 支持 IPv6 地址查询
6. 添加 IP 地理位置统计分析

## 相关资源

- [ip-api.com 官方文档](http://ip-api.com/docs/)
- [ip-api.com 限流说明](http://ip-api.com/docs/api:json)
- [MaxMind GeoIP2](https://www.maxmind.com/en/geoip2-services-and-databases)

