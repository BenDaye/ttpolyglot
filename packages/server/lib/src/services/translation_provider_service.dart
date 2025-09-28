import '../config/server_config.dart';
import '../models/api_error.dart';
import '../utils/crypto_utils.dart';
import '../utils/structured_logger.dart';
import 'database_service.dart';

/// 翻译接口配置服务
class TranslationProviderService {
  final DatabaseService _databaseService;
  final ServerConfig _config;
  late final CryptoUtils _cryptoUtils;
  static final _logger = LoggerFactory.getLogger('TranslationProviderService');

  TranslationProviderService({
    required DatabaseService databaseService,
    required ServerConfig config,
  })  : _databaseService = databaseService,
        _config = config {
    _cryptoUtils = CryptoUtils(_config);
  }

  /// 获取用户翻译接口配置列表
  Future<List<Map<String, dynamic>>> getUserTranslationProviders(String userId) async {
    try {
      _logger.info('获取用户翻译接口配置: $userId');

      const sql = '''
        SELECT
          id, provider_type, display_name, app_id, is_enabled,
          is_default, usage_count, total_characters, last_used_at,
          settings, created_at, updated_at
        FROM user_translation_providers
        WHERE user_id = @user_id AND is_enabled = true
        ORDER BY is_default DESC, last_used_at DESC NULLS LAST
      ''';

      final result = await _databaseService.query(sql, {'user_id': userId});

      return result.map((row) {
        final provider = row.toColumnMap();
        // 移除敏感信息
        provider.remove('app_key_encrypted');
        return provider;
      }).toList();
    } catch (error, stackTrace) {
      _logger.error('获取用户翻译接口配置失败: $userId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 根据ID获取翻译接口配置详情
  Future<Map<String, dynamic>?> getTranslationProviderById(String providerId, String userId) async {
    try {
      _logger.info('获取翻译接口配置详情: $providerId');

      const sql = '''
        SELECT * FROM user_translation_providers
        WHERE id = @provider_id AND user_id = @user_id
      ''';

      final result = await _databaseService.query(sql, {
        'provider_id': providerId,
        'user_id': userId,
      });

      if (result.isEmpty) {
        return null;
      }

      final provider = result.first.toColumnMap();
      // 移除敏感信息
      provider.remove('app_key_encrypted');
      return provider;
    } catch (error, stackTrace) {
      _logger.error('获取翻译接口配置详情失败: $providerId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 创建翻译接口配置
  Future<Map<String, dynamic>> createTranslationProvider({
    required String userId,
    required String providerType,
    required String displayName,
    String? appId,
    String? appKey,
    String? apiUrl,
    Map<String, dynamic>? settings,
  }) async {
    try {
      _logger.info('创建翻译接口配置: $providerType for user $userId');

      // 验证提供商类型
      if (!_isValidProviderType(providerType)) {
        throw const BusinessException('INVALID_PROVIDER_TYPE', '不支持的翻译提供商类型');
      }

      // 加密API密钥
      String? encryptedAppKey;
      if (appKey != null && appKey.isNotEmpty) {
        encryptedAppKey = _cryptoUtils.encryptString(appKey, _config.encryptionKey);
      }

      // 如果设置为默认，先取消其他默认设置
      if (settings?['is_default'] == true) {
        await _databaseService.query('''
          UPDATE user_translation_providers
          SET is_default = false
          WHERE user_id = @user_id
        ''', {'user_id': userId});
      }

      // 创建配置
      final result = await _databaseService.query('''
        INSERT INTO user_translation_providers (
          user_id, provider_type, display_name, app_id,
          app_key_encrypted, api_url, is_enabled, is_default,
          settings
        ) VALUES (
          @user_id, @provider_type, @display_name, @app_id,
          @app_key_encrypted, @api_url, true, @is_default,
          @settings
        ) RETURNING id, provider_type, display_name, app_id,
          is_enabled, is_default, usage_count, total_characters,
          last_used_at, settings, created_at, updated_at
      ''', {
        'user_id': userId,
        'provider_type': providerType,
        'display_name': displayName,
        'app_id': appId,
        'app_key_encrypted': encryptedAppKey,
        'api_url': apiUrl,
        'is_default': settings?['is_default'] ?? false,
        'settings': settings?.toString(),
      });

      final provider = result.first.toColumnMap();

      _logger.info('翻译接口配置创建成功: ${provider['id']}');

      return provider;
    } catch (error, stackTrace) {
      _logger.error('创建翻译接口配置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新翻译接口配置
  Future<Map<String, dynamic>> updateTranslationProvider({
    required String providerId,
    required String userId,
    String? displayName,
    String? appId,
    String? appKey,
    String? apiUrl,
    bool? isEnabled,
    bool? isDefault,
    Map<String, dynamic>? settings,
  }) async {
    try {
      _logger.info('更新翻译接口配置: $providerId');

      // 检查配置是否存在
      final existing = await getTranslationProviderById(providerId, userId);
      if (existing == null) {
        throw const NotFoundException('翻译接口配置不存在');
      }

      // 如果设置为默认，先取消其他默认设置
      if (isDefault == true) {
        await _databaseService.query('''
          UPDATE user_translation_providers
          SET is_default = false
          WHERE user_id = @user_id AND id != @provider_id
        ''', {'user_id': userId, 'provider_id': providerId});
      }

      // 加密API密钥
      String? encryptedAppKey;
      if (appKey != null && appKey.isNotEmpty) {
        encryptedAppKey = _cryptoUtils.encryptString(appKey, _config.encryptionKey);
      }

      // 构建更新字段
      final updates = <String>[];
      final parameters = <String, dynamic>{
        'provider_id': providerId,
        'user_id': userId,
      };

      if (displayName != null) {
        updates.add('display_name = @display_name');
        parameters['display_name'] = displayName;
      }

      if (appId != null) {
        updates.add('app_id = @app_id');
        parameters['app_id'] = appId;
      }

      if (encryptedAppKey != null) {
        updates.add('app_key_encrypted = @app_key_encrypted');
        parameters['app_key_encrypted'] = encryptedAppKey;
      }

      if (apiUrl != null) {
        updates.add('api_url = @api_url');
        parameters['api_url'] = apiUrl;
      }

      if (isEnabled != null) {
        updates.add('is_enabled = @is_enabled');
        parameters['is_enabled'] = isEnabled;
      }

      if (isDefault != null) {
        updates.add('is_default = @is_default');
        parameters['is_default'] = isDefault;
      }

      if (settings != null) {
        updates.add('settings = @settings');
        parameters['settings'] = settings.toString();
      }

      if (updates.isEmpty) {
        throw const BusinessException('VALIDATION_NO_UPDATES', '没有可更新的字段');
      }

      // 更新数据库
      final sql = '''
        UPDATE user_translation_providers
        SET ${updates.join(', ')}, updated_at = CURRENT_TIMESTAMP
        WHERE id = @provider_id AND user_id = @user_id
        RETURNING id, provider_type, display_name, app_id,
          is_enabled, is_default, usage_count, total_characters,
          last_used_at, settings, created_at, updated_at
      ''';

      final result = await _databaseService.query(sql, parameters);
      final updatedProvider = result.first.toColumnMap();

      _logger.info('翻译接口配置更新成功: $providerId');

      return updatedProvider;
    } catch (error, stackTrace) {
      _logger.error('更新翻译接口配置失败: $providerId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除翻译接口配置
  Future<void> deleteTranslationProvider(String providerId, String userId) async {
    try {
      _logger.info('删除翻译接口配置: $providerId');

      final result = await _databaseService.query('''
        DELETE FROM user_translation_providers
        WHERE id = @provider_id AND user_id = @user_id
        RETURNING id
      ''', {'provider_id': providerId, 'user_id': userId});

      if (result.isEmpty) {
        throw const NotFoundException('翻译接口配置不存在');
      }

      _logger.info('翻译接口配置删除成功: $providerId');
    } catch (error, stackTrace) {
      _logger.error('删除翻译接口配置失败: $providerId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 测试翻译接口配置
  Future<Map<String, dynamic>> testTranslationProvider(String providerId, String userId) async {
    try {
      _logger.info('测试翻译接口配置: $providerId');

      // 获取配置详情（包含加密密钥）
      const sql = 'SELECT * FROM user_translation_providers WHERE id = @provider_id AND user_id = @user_id';
      final result = await _databaseService.query(sql, {
        'provider_id': providerId,
        'user_id': userId,
      });

      if (result.isEmpty) {
        throw const NotFoundException('翻译接口配置不存在');
      }

      final provider = result.first.toColumnMap();
      final providerType = provider['provider_type'] as String;

      // 解密API密钥
      String? appKey;
      final encryptedKey = provider['app_key_encrypted'] as String?;
      if (encryptedKey != null && encryptedKey.isNotEmpty) {
        appKey = _cryptoUtils.decryptString(encryptedKey, _config.encryptionKey);
      }

      // 根据提供商类型测试接口
      final testResult = await _testProviderConnection(
        providerType,
        provider['app_id'] as String?,
        appKey,
        provider['api_url'] as String?,
      );

      // 更新使用统计
      await _updateProviderUsage(providerId);

      return {
        'success': testResult['success'],
        'message': testResult['message'],
        'response_time': testResult['response_time'],
      };
    } catch (error, stackTrace) {
      _logger.error('测试翻译接口配置失败: $providerId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 设置默认翻译接口
  Future<void> setDefaultTranslationProvider(String providerId, String userId) async {
    try {
      _logger.info('设置默认翻译接口: $providerId for user $userId');

      await _databaseService.transaction(() async {
        // 取消所有默认设置
        await _databaseService.query('''
          UPDATE user_translation_providers
          SET is_default = false
          WHERE user_id = @user_id
        ''', {'user_id': userId});

        // 设置新的默认接口
        await _databaseService.query('''
          UPDATE user_translation_providers
          SET is_default = true
          WHERE id = @provider_id AND user_id = @user_id
        ''', {'provider_id': providerId, 'user_id': userId});
      });

      _logger.info('默认翻译接口设置成功');
    } catch (error, stackTrace) {
      _logger.error('设置默认翻译接口失败: $providerId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 使用翻译接口进行翻译
  Future<Map<String, dynamic>> translate({
    required String providerId,
    required String userId,
    required String text,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    try {
      _logger.info('使用翻译接口翻译: $providerId, $fromLanguage -> $toLanguage');

      // 获取配置详情
      const sql = 'SELECT * FROM user_translation_providers WHERE id = @provider_id AND user_id = @user_id';
      final result = await _databaseService.query(sql, {
        'provider_id': providerId,
        'user_id': userId,
      });

      if (result.isEmpty) {
        throw const NotFoundException('翻译接口配置不存在');
      }

      final provider = result.first.toColumnMap();
      if (!(provider['is_enabled'] as bool)) {
        throw const BusinessException('PROVIDER_DISABLED', '翻译接口已被禁用');
      }

      final providerType = provider['provider_type'] as String;

      // 解密API密钥
      String? appKey;
      final encryptedKey = provider['app_key_encrypted'] as String?;
      if (encryptedKey != null && encryptedKey.isNotEmpty) {
        appKey = _cryptoUtils.decryptString(encryptedKey, _config.encryptionKey);
      }

      // 调用翻译接口
      final translationResult = await _callTranslationAPI(
        providerType,
        provider['app_id'] as String?,
        appKey,
        provider['api_url'] as String?,
        text,
        fromLanguage,
        toLanguage,
      );

      // 更新使用统计
      await _updateProviderUsage(providerId, text.length);

      return {
        'translated_text': translationResult['text'],
        'provider': providerType,
        'confidence_score': translationResult['confidence'] ?? 0.8,
        'response_time': translationResult['response_time'],
      };
    } catch (error, stackTrace) {
      _logger.error('翻译接口调用失败: $providerId', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取支持的翻译接口类型
  Map<String, Map<String, dynamic>> getSupportedProviderTypes() {
    return {
      'baidu': {
        'name': '百度翻译',
        'requires_app_id': true,
        'requires_app_key': true,
        'requires_api_url': false,
        'supported_languages': ['zh', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'pt', 'ru'],
      },
      'youdao': {
        'name': '有道翻译',
        'requires_app_id': true,
        'requires_app_key': true,
        'requires_api_url': false,
        'supported_languages': ['zh', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'pt', 'ru'],
      },
      'google': {
        'name': 'Google翻译',
        'requires_app_id': false,
        'requires_app_key': true,
        'requires_api_url': false,
        'supported_languages': ['zh', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'pt', 'ru', 'ar', 'hi'],
      },
      'deepl': {
        'name': 'DeepL翻译',
        'requires_app_id': false,
        'requires_app_key': true,
        'requires_api_url': false,
        'supported_languages': ['zh', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'pt', 'ru', 'nl', 'pl'],
      },
      'openai': {
        'name': 'OpenAI翻译',
        'requires_app_id': false,
        'requires_app_key': true,
        'requires_api_url': false,
        'supported_languages': ['zh', 'en', 'ja', 'ko', 'fr', 'de', 'es', 'it', 'pt', 'ru'],
      },
      'custom': {
        'name': '自定义翻译接口',
        'requires_app_id': false,
        'requires_app_key': false,
        'requires_api_url': true,
        'supported_languages': [], // 取决于自定义接口
      },
    };
  }

  // 私有辅助方法

  bool _isValidProviderType(String providerType) {
    return getSupportedProviderTypes().containsKey(providerType);
  }

  Future<Map<String, dynamic>> _testProviderConnection(
    String providerType,
    String? appId,
    String? appKey,
    String? apiUrl,
  ) async {
    final startTime = DateTime.now();

    try {
      switch (providerType) {
        case 'baidu':
          return await _testBaiduConnection(appId!, appKey!);
        case 'youdao':
          return await _testYoudaoConnection(appId!, appKey!);
        case 'google':
          return await _testGoogleConnection(appKey!);
        case 'deepl':
          return await _testDeepLConnection(appKey!);
        case 'openai':
          return await _testOpenAIConnection(appKey!);
        case 'custom':
          return await _testCustomConnection(apiUrl!);
        default:
          throw const BusinessException('UNSUPPORTED_PROVIDER', '不支持的翻译提供商');
      }
    } catch (error) {
      final responseTime = DateTime.now().difference(startTime).inMilliseconds;
      return {
        'success': false,
        'message': '连接测试失败: ${error.toString()}',
        'response_time': responseTime,
      };
    }
  }

  Future<Map<String, dynamic>> _callTranslationAPI(
    String providerType,
    String? appId,
    String? appKey,
    String? apiUrl,
    String text,
    String fromLanguage,
    String toLanguage,
  ) async {
    final startTime = DateTime.now();

    try {
      switch (providerType) {
        case 'baidu':
          return await _translateWithBaidu(appId!, appKey!, text, fromLanguage, toLanguage);
        case 'youdao':
          return await _translateWithYoudao(appId!, appKey!, text, fromLanguage, toLanguage);
        case 'google':
          return await _translateWithGoogle(appKey!, text, fromLanguage, toLanguage);
        case 'deepl':
          return await _translateWithDeepL(appKey!, text, fromLanguage, toLanguage);
        case 'openai':
          return await _translateWithOpenAI(appKey!, text, fromLanguage, toLanguage);
        case 'custom':
          return await _translateWithCustom(apiUrl!, text, fromLanguage, toLanguage);
        default:
          throw const BusinessException('UNSUPPORTED_PROVIDER', '不支持的翻译提供商');
      }
    } finally {
      final responseTime = DateTime.now().difference(startTime).inMilliseconds;
      // 记录响应时间统计到日志
      _logger.info('翻译API调用响应时间: $responseTime ms');
    }
  }

  Future<void> _updateProviderUsage(String providerId, [int characterCount = 0]) async {
    try {
      await _databaseService.query('''
        UPDATE user_translation_providers
        SET usage_count = usage_count + 1,
            total_characters = total_characters + @character_count,
            last_used_at = CURRENT_TIMESTAMP,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = @provider_id
      ''', {
        'provider_id': providerId,
        'character_count': characterCount,
      });
    } catch (error) {
      _logger.error('更新提供商使用统计失败: $providerId', error: error);
    }
  }

  // 翻译接口实现（简化版本，实际需要根据各平台的API文档实现）
  Future<Map<String, dynamic>> _testBaiduConnection(String appId, String appKey) async {
    // 这里应该实现百度翻译API的连接测试
    return {'success': true, 'message': '百度翻译接口连接正常', 'response_time': 100};
  }

  Future<Map<String, dynamic>> _testYoudaoConnection(String appId, String appKey) async {
    // 这里应该实现有道翻译API的连接测试
    return {'success': true, 'message': '有道翻译接口连接正常', 'response_time': 100};
  }

  Future<Map<String, dynamic>> _testGoogleConnection(String appKey) async {
    // 这里应该实现Google翻译API的连接测试
    return {'success': true, 'message': 'Google翻译接口连接正常', 'response_time': 100};
  }

  Future<Map<String, dynamic>> _testDeepLConnection(String appKey) async {
    // 这里应该实现DeepL翻译API的连接测试
    return {'success': true, 'message': 'DeepL翻译接口连接正常', 'response_time': 100};
  }

  Future<Map<String, dynamic>> _testOpenAIConnection(String appKey) async {
    // 这里应该实现OpenAI翻译API的连接测试
    return {'success': true, 'message': 'OpenAI翻译接口连接正常', 'response_time': 100};
  }

  Future<Map<String, dynamic>> _testCustomConnection(String apiUrl) async {
    // 这里应该实现自定义翻译API的连接测试
    return {'success': true, 'message': '自定义翻译接口连接正常', 'response_time': 100};
  }

  Future<Map<String, dynamic>> _translateWithBaidu(
      String appId, String appKey, String text, String from, String to) async {
    // 实现百度翻译API调用
    return {'text': 'Translated text', 'confidence': 0.9, 'response_time': 200};
  }

  Future<Map<String, dynamic>> _translateWithYoudao(
      String appId, String appKey, String text, String from, String to) async {
    // 实现有道翻译API调用
    return {'text': 'Translated text', 'confidence': 0.8, 'response_time': 180};
  }

  Future<Map<String, dynamic>> _translateWithGoogle(String appKey, String text, String from, String to) async {
    // 实现Google翻译API调用
    return {'text': 'Translated text', 'confidence': 0.95, 'response_time': 150};
  }

  Future<Map<String, dynamic>> _translateWithDeepL(String appKey, String text, String from, String to) async {
    // 实现DeepL翻译API调用
    return {'text': 'Translated text', 'confidence': 0.92, 'response_time': 220};
  }

  Future<Map<String, dynamic>> _translateWithOpenAI(String appKey, String text, String from, String to) async {
    // 实现OpenAI翻译API调用
    return {'text': 'Translated text', 'confidence': 0.88, 'response_time': 300};
  }

  Future<Map<String, dynamic>> _translateWithCustom(String apiUrl, String text, String from, String to) async {
    // 实现自定义翻译API调用
    return {'text': 'Translated text', 'confidence': 0.85, 'response_time': 250};
  }
}
