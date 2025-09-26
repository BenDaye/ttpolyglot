/// 缓存工具类
class CacheUtils {
  /// 生成缓存键
  static String generateKey(String prefix, [List<String>? parts]) {
    final keyParts = [prefix];
    if (parts != null && parts.isNotEmpty) {
      keyParts.addAll(parts.where((part) => part.isNotEmpty));
    }
    return keyParts.join(':');
  }

  /// 生成用户缓存键
  static String userKey(String userId) => generateKey('user', [userId]);

  /// 生成项目缓存键
  static String projectKey(String projectId) => generateKey('project', [projectId]);

  /// 生成翻译条目缓存键
  static String translationKey(String entryId) => generateKey('translation', [entryId]);

  /// 生成权限缓存键
  static String permissionKey(String userId, String resource) => generateKey('permission', [userId, resource]);

  /// 生成API响应缓存键
  static String apiResponseKey(String endpoint, String hash) => generateKey('api:response', [endpoint, hash]);

  /// 生成会话缓存键
  static String sessionKey(String userId) => generateKey('user:session', [userId]);

  /// 生成系统配置缓存键
  static String systemConfigKey(String configKey) => generateKey('config:system', [configKey]);

  /// 生成临时数据缓存键
  static String tempDataKey(String key) => generateKey('temp', [key]);

  /// 清理用户相关缓存
  static List<String> getUserCacheKeys(String userId) {
    return [
      userKey(userId),
      sessionKey(userId),
      permissionKey(userId, '*'),
    ];
  }

  /// 清理项目相关缓存
  static List<String> getProjectCacheKeys(String projectId) {
    return [
      projectKey(projectId),
      generateKey('project:members', [projectId]),
      generateKey('project:languages', [projectId]),
    ];
  }

  /// 计算缓存过期时间（秒）
  static int calculateTTL({
    int? minutes,
    int? hours,
    int? days,
  }) {
    int ttl = 0;
    if (minutes != null) ttl += minutes * 60;
    if (hours != null) ttl += hours * 3600;
    if (days != null) ttl += days * 86400;
    return ttl;
  }
}
