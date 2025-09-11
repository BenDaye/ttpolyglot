/// 翻译提供商枚举
enum TranslationProvider {
  /// 百度翻译
  baidu('baidu', '百度翻译'),

  /// 有道翻译
  youdao('youdao', '有道翻译'),

  /// 谷歌翻译
  google('google', '谷歌翻译'),

  /// 自定义翻译
  custom('custom', '自定义翻译');

  const TranslationProvider(this.code, this.name);

  /// 提供商代码
  final String code;

  /// 提供商名称
  final String name;

  /// 根据代码获取提供商
  static TranslationProvider? fromCode(String code) {
    try {
      return values.firstWhere((provider) => provider.code == code);
    } catch (e) {
      return null;
    }
  }

  /// 获取所有提供商选项
  static List<Map<String, String>> getAllProviders() {
    return values
        .map((provider) => {
              'code': provider.code,
              'name': provider.name,
            })
        .toList();
  }
}

/// 翻译提供商配置
class TranslationProviderConfig {
  const TranslationProviderConfig({
    required this.id,
    required this.provider,
    required this.appId,
    required this.appKey,
    this.apiUrl,
    this.isEnabled = false,
    this.name,
  });

  /// 唯一标识符
  final String id;

  /// 翻译提供商
  final TranslationProvider provider;

  /// 显示名称
  final String? name;

  /// 应用ID/App ID
  final String appId;

  /// 应用密钥/App Key
  final String appKey;

  /// API地址（自定义翻译时使用）
  final String? apiUrl;

  /// 是否启用
  final bool isEnabled;

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provider': provider.code,
      'name': name,
      'appId': appId,
      'appKey': appKey,
      'apiUrl': apiUrl,
      'isEnabled': isEnabled,
    };
  }

  /// 从Map创建实例
  factory TranslationProviderConfig.fromMap(Map<String, dynamic> map) {
    return TranslationProviderConfig(
      id: map['id'] as String? ?? _generateId(),
      provider: TranslationProvider.fromCode(map['provider'] as String) ?? TranslationProvider.baidu,
      name: map['name'] as String?,
      appId: map['appId'] as String? ?? '',
      appKey: map['appKey'] as String? ?? '',
      apiUrl: map['apiUrl'] as String?,
      isEnabled: map['isEnabled'] as bool? ?? false,
    );
  }

  /// 生成唯一ID
  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// 创建副本
  TranslationProviderConfig copyWith({
    String? id,
    TranslationProvider? provider,
    String? name,
    String? appId,
    String? appKey,
    String? apiUrl,
    bool? isEnabled,
  }) {
    return TranslationProviderConfig(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      name: name ?? this.name,
      appId: appId ?? this.appId,
      appKey: appKey ?? this.appKey,
      apiUrl: apiUrl ?? this.apiUrl,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  /// 验证配置是否完整
  bool get isValid {
    if (!isEnabled) return true;

    switch (provider) {
      case TranslationProvider.baidu:
      case TranslationProvider.youdao:
      case TranslationProvider.google:
        return appId.isNotEmpty && appKey.isNotEmpty;
      case TranslationProvider.custom:
        return appId.isNotEmpty && apiUrl?.isNotEmpty == true;
    }
  }

  /// 获取显示名称
  String get displayName {
    return name ?? provider.name;
  }

  /// 获取验证错误信息
  List<String> getValidationErrors() {
    final errors = <String>[];

    if (!isEnabled) return errors;

    if (appId.isEmpty) {
      errors.add('${provider.name} 的应用ID不能为空');
    }

    if (appKey.isEmpty) {
      errors.add('${provider.name} 的应用密钥不能为空');
    }

    if (provider == TranslationProvider.custom && (apiUrl?.isEmpty ?? true)) {
      errors.add('自定义翻译的API地址不能为空');
    }

    return errors;
  }
}

/// 翻译配置
class TranslationConfig {
  const TranslationConfig({
    required this.providers,
    this.maxRetries = 3,
    this.timeoutSeconds = 30,
  });

  /// 翻译提供商配置列表
  final List<TranslationProviderConfig> providers;

  /// 最大重试次数
  final int maxRetries;

  /// 超时时间（秒）
  final int timeoutSeconds;

  /// 转换为Map
  Map<String, dynamic> toMap() {
    return {
      'providers': providers.map((p) => p.toMap()).toList(),
      'maxRetries': maxRetries,
      'timeoutSeconds': timeoutSeconds,
    };
  }

  /// 从Map创建实例
  factory TranslationConfig.fromMap(Map<String, dynamic> map) {
    final providersData = map['providers'] as List<dynamic>? ?? [];
    final providers = providersData.map((p) => TranslationProviderConfig.fromMap(p as Map<String, dynamic>)).toList();

    return TranslationConfig(
      providers: providers,
      maxRetries: map['maxRetries'] as int? ?? 3,
      timeoutSeconds: map['timeoutSeconds'] as int? ?? 30,
    );
  }

  /// 获取启用的提供商
  List<TranslationProviderConfig> get enabledProviders {
    return providers.where((p) => p.isEnabled && p.isValid).toList();
  }

  /// 获取指定ID的配置
  TranslationProviderConfig? getProviderConfigById(String id) {
    try {
      return providers.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// 获取指定提供商的配置
  TranslationProviderConfig? getProviderConfig(TranslationProvider provider) {
    try {
      return providers.firstWhere((p) => p.provider == provider);
    } catch (e) {
      return null;
    }
  }

  /// 创建副本
  TranslationConfig copyWith({
    List<TranslationProviderConfig>? providers,
    int? maxRetries,
    int? timeoutSeconds,
  }) {
    return TranslationConfig(
      providers: providers ?? this.providers,
      maxRetries: maxRetries ?? this.maxRetries,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
    );
  }
}
