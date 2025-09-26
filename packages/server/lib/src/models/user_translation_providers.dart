/// 用户翻译接口配置模型
class UserTranslationProvider {
  final String id;
  final String userId;
  final String providerType; // 'baidu', 'youdao', 'google', 'deepl', 'openai', 'custom'
  final String displayName;
  final String? appId;
  final String? appKeyEncrypted;
  final String? apiUrl;
  final bool isEnabled;
  final bool isDefault;
  final Map<String, dynamic>? settings;
  final int usageCount;
  final int totalCharacters;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserTranslationProvider({
    required this.id,
    required this.userId,
    required this.providerType,
    required this.displayName,
    this.appId,
    this.appKeyEncrypted,
    this.apiUrl,
    this.isEnabled = true,
    this.isDefault = false,
    this.settings,
    this.usageCount = 0,
    this.totalCharacters = 0,
    this.lastUsedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserTranslationProvider.fromJson(Map<String, dynamic> json) {
    return UserTranslationProvider(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      providerType: json['provider_type'] as String,
      displayName: json['display_name'] as String,
      appId: json['app_id'] as String?,
      appKeyEncrypted: json['app_key_encrypted'] as String?,
      apiUrl: json['api_url'] as String?,
      isEnabled: json['is_enabled'] as bool? ?? true,
      isDefault: json['is_default'] as bool? ?? false,
      settings: json['settings'] as Map<String, dynamic>?,
      usageCount: json['usage_count'] as int? ?? 0,
      totalCharacters: json['total_characters'] as int? ?? 0,
      lastUsedAt: json['last_used_at'] != null ? DateTime.parse(json['last_used_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'provider_type': providerType,
      'display_name': displayName,
      'app_id': appId,
      'app_key_encrypted': appKeyEncrypted,
      'api_url': apiUrl,
      'is_enabled': isEnabled,
      'is_default': isDefault,
      'settings': settings,
      'usage_count': usageCount,
      'total_characters': totalCharacters,
      'last_used_at': lastUsedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserTranslationProvider.fromMap(Map<String, dynamic> map) {
    return UserTranslationProvider(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      providerType: map['provider_type'] as String,
      displayName: map['display_name'] as String,
      appId: map['app_id'] as String?,
      appKeyEncrypted: map['app_key_encrypted'] as String?,
      apiUrl: map['api_url'] as String?,
      isEnabled: map['is_enabled'] as bool,
      isDefault: map['is_default'] as bool,
      settings: map['settings'] as Map<String, dynamic>?,
      usageCount: map['usage_count'] as int,
      totalCharacters: map['total_characters'] as int,
      lastUsedAt: map['last_used_at'] as DateTime?,
      createdAt: map['created_at'] as DateTime,
      updatedAt: map['updated_at'] as DateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'provider_type': providerType,
      'display_name': displayName,
      'app_id': appId,
      'app_key_encrypted': appKeyEncrypted,
      'api_url': apiUrl,
      'is_enabled': isEnabled,
      'is_default': isDefault,
      'settings': settings,
      'usage_count': usageCount,
      'total_characters': totalCharacters,
      'last_used_at': lastUsedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// 获取提供商显示信息（不包含敏感信息）
  Map<String, dynamic> toSafeMap() {
    return {
      'id': id,
      'provider_type': providerType,
      'display_name': displayName,
      'app_id': appId,
      'api_url': apiUrl,
      'is_enabled': isEnabled,
      'is_default': isDefault,
      'settings': settings,
      'usage_count': usageCount,
      'total_characters': totalCharacters,
      'last_used_at': lastUsedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// 检查是否支持指定的语言对
  bool supportsLanguagePair(String fromLanguage, String toLanguage) {
    // 这里应该根据提供商的实际支持情况来判断
    // 暂时返回true，后续可以根据settings中的配置来判断
    return true;
  }

  /// 获取提供商的配额限制
  Map<String, dynamic> getQuotaLimits() {
    return settings?['quota_limits'] as Map<String, dynamic>? ??
        {
          'monthly_requests': 1000000,
          'monthly_characters': 2000000,
          'daily_requests': 50000,
          'daily_characters': 100000,
        };
  }

  /// 检查是否超过配额
  bool isOverQuota({required int monthlyRequests, required int monthlyCharacters}) {
    final limits = getQuotaLimits();
    return monthlyRequests >= limits['monthly_requests'] || monthlyCharacters >= limits['monthly_characters'];
  }
}
