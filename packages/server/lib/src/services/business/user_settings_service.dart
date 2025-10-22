import 'dart:convert';

import 'package:ttpolyglot_model/model.dart';

import '../../config/server_config.dart';
import '../base_service.dart';
import '../infrastructure/database_service.dart';
import '../infrastructure/redis_service.dart';

/// 用户设置服务
class UserSettingsService extends BaseService {
  final DatabaseService _databaseService;
  final RedisService _redisService;

  UserSettingsService({
    required DatabaseService databaseService,
    required RedisService redisService,
  })  : _databaseService = databaseService,
        _redisService = redisService,
        super('UserSettingsService');

  /// 获取用户完整设置
  Future<UserSettingsModel> getUserSettings(String userId) async {
    return execute(() async {
      logInfo('获取用户设置', context: {'userId': userId});

      // 先检查缓存
      final cacheKey = 'user:settings:$userId';
      final cachedSettings = await _redisService.getJson(cacheKey);
      if (cachedSettings != null) {
        logInfo('从缓存获取用户设置');
        return UserSettingsModel.fromJson(cachedSettings);
      }

      // 从数据库获取语言设置和通用设置
      final settingsResult = await _databaseService.query(
        '''
        SELECT language_code, auto_save, notifications, created_at, updated_at
        FROM {user_settings}
        WHERE user_id = @user_id
        ''',
        {'user_id': userId},
      );

      // 从数据库获取翻译配置
      final translationConfigResult = await _databaseService.query(
        '''
        SELECT providers, max_retries, timeout_seconds
        FROM {user_translation_configs}
        WHERE user_id = @user_id
        ''',
        {'user_id': userId},
      );

      // 构建设置对象
      final languageSettings = settingsResult.isNotEmpty
          ? LanguageSettingsModel(
              languageCode: settingsResult.first.toColumnMap()['language_code'] as String? ?? 'zh_CN',
            )
          : const LanguageSettingsModel();

      final generalSettings = settingsResult.isNotEmpty
          ? GeneralSettingsModel(
              autoSave: settingsResult.first.toColumnMap()['auto_save'] as bool? ?? true,
              notifications: settingsResult.first.toColumnMap()['notifications'] as bool? ?? true,
            )
          : const GeneralSettingsModel();

      // 解析翻译配置
      TranslationSettingsModel translationSettings;
      if (translationConfigResult.isNotEmpty) {
        final configData = translationConfigResult.first.toColumnMap();
        final providersJson = configData['providers'];

        List<TranslationProviderConfigModel> providers = [];
        if (providersJson != null) {
          try {
            final providersList =
                providersJson is String ? jsonDecode(providersJson) as List<dynamic> : providersJson as List<dynamic>;

            providers =
                providersList.map((p) => TranslationProviderConfigModel.fromJson(p as Map<String, dynamic>)).toList();
          } catch (error, stackTrace) {
            logError(
              '解析翻译配置失败',
              error: error,
              stackTrace: stackTrace,
            );
          }
        }

        translationSettings = TranslationSettingsModel(
          providers: providers,
          maxRetries: configData['max_retries'] as int? ?? 3,
          timeoutSeconds: configData['timeout_seconds'] as int? ?? 30,
        );
      } else {
        translationSettings = const TranslationSettingsModel();
      }

      final userSettings = UserSettingsModel(
        languageSettings: languageSettings,
        generalSettings: generalSettings,
        translationSettings: translationSettings,
        createdAt: settingsResult.isNotEmpty ? settingsResult.first.toColumnMap()['created_at'] as DateTime? : null,
        updatedAt: settingsResult.isNotEmpty ? settingsResult.first.toColumnMap()['updated_at'] as DateTime? : null,
      );

      // 缓存设置（1小时）
      await _redisService.setJson(cacheKey, userSettings.toJson(), ServerConfig.cacheApiResponseTtl);

      return userSettings;
    }, operationName: 'getUserSettings');
  }

  /// 更新用户完整设置
  Future<UserSettingsModel> updateUserSettings(String userId, Map<String, dynamic> settingsData) async {
    return execute(() async {
      logInfo('更新用户设置', context: {'userId': userId});

      await _databaseService.transaction(() async {
        // 更新或插入语言设置和通用设置
        if (settingsData.containsKey('language_settings') || settingsData.containsKey('general_settings')) {
          final languageSettings = settingsData['language_settings'] as Map<String, dynamic>?;
          final generalSettings = settingsData['general_settings'] as Map<String, dynamic>?;

          final languageCode = languageSettings?['language_code'] as String? ?? 'zh_CN';
          final autoSave = generalSettings?['auto_save'] as bool? ?? true;
          final notifications = generalSettings?['notifications'] as bool? ?? true;

          await _databaseService.query(
            '''
            INSERT INTO {user_settings} (user_id, language_code, auto_save, notifications)
            VALUES (@user_id, @language_code, @auto_save, @notifications)
            ON CONFLICT (user_id) DO UPDATE SET
              language_code = EXCLUDED.language_code,
              auto_save = EXCLUDED.auto_save,
              notifications = EXCLUDED.notifications,
              updated_at = CURRENT_TIMESTAMP
            ''',
            {
              'user_id': userId,
              'language_code': languageCode,
              'auto_save': autoSave,
              'notifications': notifications,
            },
          );
        }

        // 更新或插入翻译配置
        if (settingsData.containsKey('translation_settings')) {
          final translationSettings = settingsData['translation_settings'] as Map<String, dynamic>;

          final providersData = translationSettings['providers'] as List<dynamic>? ?? [];
          final providersJson = jsonEncode(providersData);
          final maxRetries = translationSettings['max_retries'] as int? ?? 3;
          final timeoutSeconds = translationSettings['timeout_seconds'] as int? ?? 30;

          await _databaseService.query(
            '''
            INSERT INTO {user_translation_configs} (user_id, providers, max_retries, timeout_seconds)
            VALUES (@user_id, @providers::jsonb, @max_retries, @timeout_seconds)
            ON CONFLICT (user_id) DO UPDATE SET
              providers = EXCLUDED.providers,
              max_retries = EXCLUDED.max_retries,
              timeout_seconds = EXCLUDED.timeout_seconds,
              updated_at = CURRENT_TIMESTAMP
            ''',
            {
              'user_id': userId,
              'providers': providersJson,
              'max_retries': maxRetries,
              'timeout_seconds': timeoutSeconds,
            },
          );
        }
      });

      // 清除缓存
      final cacheKey = 'user:settings:$userId';
      await _redisService.delete(cacheKey);

      // 返回更新后的设置
      return await getUserSettings(userId);
    }, operationName: 'updateUserSettings');
  }

  /// 更新语言设置
  Future<LanguageSettingsModel> updateLanguageSettings(String userId, String languageCode) async {
    return execute(() async {
      logInfo('更新语言设置', context: {'userId': userId, 'languageCode': languageCode});

      await _databaseService.query(
        '''
        INSERT INTO {user_settings} (user_id, language_code)
        VALUES (@user_id, @language_code)
        ON CONFLICT (user_id) DO UPDATE SET
          language_code = EXCLUDED.language_code,
          updated_at = CURRENT_TIMESTAMP
        ''',
        {'user_id': userId, 'language_code': languageCode},
      );

      // 清除缓存
      await _redisService.delete('user:settings:$userId');

      return LanguageSettingsModel(languageCode: languageCode);
    }, operationName: 'updateLanguageSettings');
  }

  /// 更新通用设置
  Future<GeneralSettingsModel> updateGeneralSettings(
    String userId, {
    bool? autoSave,
    bool? notifications,
  }) async {
    return execute(() async {
      logInfo('更新通用设置', context: {'userId': userId});

      // 先获取现有设置
      final currentSettings = await getUserSettings(userId);

      final newAutoSave = autoSave ?? currentSettings.generalSettings.autoSave;
      final newNotifications = notifications ?? currentSettings.generalSettings.notifications;

      await _databaseService.query(
        '''
        INSERT INTO {user_settings} (user_id, auto_save, notifications)
        VALUES (@user_id, @auto_save, @notifications)
        ON CONFLICT (user_id) DO UPDATE SET
          auto_save = EXCLUDED.auto_save,
          notifications = EXCLUDED.notifications,
          updated_at = CURRENT_TIMESTAMP
        ''',
        {
          'user_id': userId,
          'auto_save': newAutoSave,
          'notifications': newNotifications,
        },
      );

      // 清除缓存
      await _redisService.delete('user:settings:$userId');

      return GeneralSettingsModel(
        autoSave: newAutoSave,
        notifications: newNotifications,
      );
    }, operationName: 'updateGeneralSettings');
  }

  /// 更新翻译配置
  Future<TranslationSettingsModel> updateTranslationSettings(
    String userId,
    TranslationSettingsModel translationSettings,
  ) async {
    return execute(() async {
      logInfo('更新翻译配置', context: {'userId': userId});

      final providersJson = jsonEncode(
        translationSettings.providers
            .map((p) => {
                  'id': p.id,
                  'provider': p.provider,
                  'name': p.name,
                  'app_id': p.appId,
                  'app_key': p.appKey,
                  'api_url': p.apiUrl,
                  'is_default': p.isDefault,
                })
            .toList(),
      );

      await _databaseService.query(
        '''
        INSERT INTO {user_translation_configs} (user_id, providers, max_retries, timeout_seconds)
        VALUES (@user_id, @providers::jsonb, @max_retries, @timeout_seconds)
        ON CONFLICT (user_id) DO UPDATE SET
          providers = EXCLUDED.providers,
          max_retries = EXCLUDED.max_retries,
          timeout_seconds = EXCLUDED.timeout_seconds,
          updated_at = CURRENT_TIMESTAMP
        ''',
        {
          'user_id': userId,
          'providers': providersJson,
          'max_retries': translationSettings.maxRetries,
          'timeout_seconds': translationSettings.timeoutSeconds,
        },
      );

      // 清除缓存
      await _redisService.delete('user:settings:$userId');

      return translationSettings;
    }, operationName: 'updateTranslationSettings');
  }

  /// 添加翻译接口
  Future<TranslationProviderConfigModel> addTranslationProvider(
    String userId,
    TranslationProviderConfigModel provider,
  ) async {
    return execute(() async {
      logInfo('添加翻译接口', context: {'userId': userId, 'provider': provider.provider});

      // 获取当前配置
      final currentSettings = await getUserSettings(userId);
      final providers = List<TranslationProviderConfigModel>.from(currentSettings.translationSettings.providers);

      // 如果设为默认，先取消其他默认设置
      if (provider.isDefault) {
        providers.forEach((p) {
          if (p.isDefault) {
            providers[providers.indexOf(p)] = TranslationProviderConfigModel(
              id: p.id,
              provider: p.provider,
              name: p.name,
              appId: p.appId,
              appKey: p.appKey,
              apiUrl: p.apiUrl,
              isDefault: false,
            );
          }
        });
      }

      // 添加新接口
      providers.add(provider);

      // 更新配置
      final updatedSettings = TranslationSettingsModel(
        providers: providers,
        maxRetries: currentSettings.translationSettings.maxRetries,
        timeoutSeconds: currentSettings.translationSettings.timeoutSeconds,
      );

      await updateTranslationSettings(userId, updatedSettings);

      return provider;
    }, operationName: 'addTranslationProvider');
  }

  /// 更新翻译接口
  Future<TranslationProviderConfigModel> updateTranslationProvider(
    String userId,
    String providerId,
    TranslationProviderConfigModel updatedProvider,
  ) async {
    return execute(() async {
      logInfo('更新翻译接口', context: {'userId': userId, 'providerId': providerId});

      // 获取当前配置
      final currentSettings = await getUserSettings(userId);
      final providers = List<TranslationProviderConfigModel>.from(currentSettings.translationSettings.providers);

      // 查找并更新接口
      final index = providers.indexWhere((p) => p.id == providerId);
      if (index == -1) {
        throw Exception('翻译接口不存在');
      }

      // 如果设为默认，先取消其他默认设置
      if (updatedProvider.isDefault) {
        for (var i = 0; i < providers.length; i++) {
          if (i != index && providers[i].isDefault) {
            providers[i] = TranslationProviderConfigModel(
              id: providers[i].id,
              provider: providers[i].provider,
              name: providers[i].name,
              appId: providers[i].appId,
              appKey: providers[i].appKey,
              apiUrl: providers[i].apiUrl,
              isDefault: false,
            );
          }
        }
      }

      providers[index] = updatedProvider;

      // 更新配置
      final updatedSettings = TranslationSettingsModel(
        providers: providers,
        maxRetries: currentSettings.translationSettings.maxRetries,
        timeoutSeconds: currentSettings.translationSettings.timeoutSeconds,
      );

      await updateTranslationSettings(userId, updatedSettings);

      return updatedProvider;
    }, operationName: 'updateTranslationProvider');
  }

  /// 删除翻译接口
  Future<void> deleteTranslationProvider(String userId, String providerId) async {
    return execute(() async {
      logInfo('删除翻译接口', context: {'userId': userId, 'providerId': providerId});

      // 获取当前配置
      final currentSettings = await getUserSettings(userId);
      final providers = List<TranslationProviderConfigModel>.from(currentSettings.translationSettings.providers);

      // 删除接口
      providers.removeWhere((p) => p.id == providerId);

      // 更新配置
      final updatedSettings = TranslationSettingsModel(
        providers: providers,
        maxRetries: currentSettings.translationSettings.maxRetries,
        timeoutSeconds: currentSettings.translationSettings.timeoutSeconds,
      );

      await updateTranslationSettings(userId, updatedSettings);
    }, operationName: 'deleteTranslationProvider');
  }

  /// 重置用户设置为默认值
  Future<UserSettingsModel> resetUserSettings(String userId) async {
    return execute(() async {
      logInfo('重置用户设置', context: {'userId': userId});

      await _databaseService.transaction(() async {
        // 删除用户设置
        await _databaseService.query(
          'DELETE FROM {user_settings} WHERE user_id = @user_id',
          {'user_id': userId},
        );

        // 删除翻译配置
        await _databaseService.query(
          'DELETE FROM {user_translation_configs} WHERE user_id = @user_id',
          {'user_id': userId},
        );
      });

      // 清除缓存
      await _redisService.delete('user:settings:$userId');

      // 返回默认设置
      return const UserSettingsModel(
        languageSettings: LanguageSettingsModel(),
        generalSettings: GeneralSettingsModel(),
        translationSettings: TranslationSettingsModel(),
      );
    }, operationName: 'resetUserSettings');
  }
}
