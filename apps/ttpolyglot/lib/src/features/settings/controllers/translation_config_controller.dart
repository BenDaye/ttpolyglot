import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttpolyglot/src/common/api/api.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 翻译配置控制器
class TranslationConfigController extends GetxController {
  static TranslationConfigController get instance => Get.isRegistered<TranslationConfigController>()
      ? Get.find<TranslationConfigController>()
      : Get.put(TranslationConfigController());

  final UserSettingsApi _userSettingsApi = Get.find<UserSettingsApi>();

  // 响应式变量
  final _config = TranslationConfig(
    providers: [],
  ).obs;

  final _isLoading = false.obs;

  // Getters
  TranslationConfig get config => _config.value;
  bool get isLoading => _isLoading.value;

  /// 获取所有提供商选项
  List<Map<String, String>> get providerOptions => TranslationProvider.getAllProviders();

  /// 获取启用的提供商
  List<TranslationProviderConfig> get enabledProviders => config.enabledProviders;

  /// 更新提供商配置
  void updateProviderConfig(
    TranslationProvider provider, {
    String? appId,
    String? appKey,
    String? apiUrl,
    bool? isEnabled,
  }) {
    final updatedProviders = config.providers.map((p) {
      if (p.provider == provider) {
        return p.copyWith(
          appId: appId,
          appKey: appKey,
          apiUrl: apiUrl,
        );
      }
      return p;
    }).toList();

    _config.value = config.copyWith(providers: updatedProviders);
    _saveConfigToServer();
  }

  /// 设置最大重试次数
  Future<void> setMaxRetries(int retries) async {
    if (retries < 0 || retries > 10) return;
    _config.value = config.copyWith(maxRetries: retries);
    await _saveConfigToServer();
  }

  /// 设置超时时间
  Future<void> setTimeout(int seconds) async {
    if (seconds < 5 || seconds > 300) return;
    _config.value = config.copyWith(timeoutSeconds: seconds);
    await _saveConfigToServer();
  }

  /// 验证配置
  bool validateConfig() {
    for (final provider in config.providers) {
      if (!provider.isValid) {
        return false;
      }
    }
    return true;
  }

  /// 获取配置验证错误
  List<String> getValidationErrors() {
    final errors = <String>[];
    for (final provider in config.providers) {
      if (provider.isValid) {
        errors.addAll(provider.getValidationErrors());
      }
    }
    return errors;
  }

  /// 从服务器加载配置
  Future<void> loadConfigFromServer() async {
    try {
      _isLoading.value = true;
      final settings = await _userSettingsApi.getUserSettings();

      // 转换 Model 到 Core 类型
      final providers = settings.translationSettings.providers
          .map((p) => TranslationProviderConfig(
                id: p.id,
                provider: TranslationProvider.fromCode(p.provider) ?? TranslationProvider.google,
                name: p.name,
                appId: p.appId,
                appKey: p.appKey,
                apiUrl: p.apiUrl,
                isDefault: p.isDefault,
              ))
          .toList();

      _config.value = TranslationConfig(
        providers: providers,
        maxRetries: settings.translationSettings.maxRetries,
        timeoutSeconds: settings.translationSettings.timeoutSeconds,
      );

      // 同时保存到本地缓存
      await _saveConfigLocal();

      Logger.info('从服务器加载翻译配置成功');
    } catch (error, stackTrace) {
      Logger.error('从服务器加载翻译配置失败', error: error, stackTrace: stackTrace);
      // 加载失败时从本地加载
      await _loadConfigLocal();
    } finally {
      _isLoading.value = false;
    }
  }

  /// 保存配置到服务器
  Future<void> _saveConfigToServer() async {
    try {
      // 转换 Core 类型到 Model
      final providers = config.providers
          .map((p) => TranslationProviderConfigModel(
                id: p.id,
                provider: p.provider.code,
                name: p.name,
                appId: p.appId,
                appKey: p.appKey,
                apiUrl: p.apiUrl,
                isDefault: p.isDefault,
              ))
          .toList();

      final translationSettings = TranslationSettingsModel(
        providers: providers,
        maxRetries: config.maxRetries,
        timeoutSeconds: config.timeoutSeconds,
      );

      await _userSettingsApi.updateTranslationSettings(translationSettings);
      await _saveConfigLocal();

      Logger.info('保存翻译配置到服务器成功');
    } catch (error, stackTrace) {
      Logger.error('保存翻译配置到服务器失败', error: error, stackTrace: stackTrace);
      // 保存失败时仅保存到本地
      await _saveConfigLocal();
    }
  }

  /// 保存配置到本地存储（作为缓存）
  Future<void> _saveConfigLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configMap = config.toMap();
      final configJson = jsonEncode(configMap);
      await prefs.setString('translation_config', configJson);
    } catch (error, stackTrace) {
      Logger.error('保存翻译配置到本地失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 从本地存储加载配置
  Future<void> _loadConfigLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configString = prefs.getString('translation_config');
      if (configString != null && configString.isNotEmpty) {
        final configMap = jsonDecode(configString) as Map<String, dynamic>;
        final loadedConfig = TranslationConfig.fromMap(configMap);
        _config.value = loadedConfig;
      }
    } catch (error, stackTrace) {
      Logger.error('从本地加载翻译配置失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 重置为默认配置
  Future<void> resetToDefault() async {
    try {
      final defaultSettings = await _userSettingsApi.resetUserSettings();

      // 转换 Model 到 Core 类型
      final providers = defaultSettings.translationSettings.providers
          .map((p) => TranslationProviderConfig(
                id: p.id,
                provider: TranslationProvider.fromCode(p.provider) ?? TranslationProvider.google,
                name: p.name,
                appId: p.appId,
                appKey: p.appKey,
                apiUrl: p.apiUrl,
                isDefault: p.isDefault,
              ))
          .toList();

      _config.value = TranslationConfig(
        providers: providers,
        maxRetries: defaultSettings.translationSettings.maxRetries,
        timeoutSeconds: defaultSettings.translationSettings.timeoutSeconds,
      );

      await _saveConfigLocal();
    } catch (error, stackTrace) {
      Logger.error('重置翻译配置失败', error: error, stackTrace: stackTrace);
      _config.value = TranslationConfig(providers: []);
      await _saveConfigLocal();
    }
  }

  /// 生成唯一ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// 添加翻译接口
  Future<void> addTranslationProvider({
    required TranslationProvider provider,
    required String name,
    String? appId,
    String? appKey,
    String? apiUrl,
    bool isDefault = false,
  }) async {
    try {
      // 转换 Core 类型到 Model
      final providerModel = TranslationProviderConfigModel(
        id: _generateId(),
        provider: provider.code,
        name: name,
        appId: appId ?? '',
        appKey: appKey ?? '',
        apiUrl: apiUrl,
        isDefault: isDefault,
      );

      final addedProvider = await _userSettingsApi.addTranslationProvider(providerModel);

      // 如果设置为默认，先取消其他默认设置
      var updatedProviders = config.providers;
      if (isDefault) {
        updatedProviders = config.providers.map((p) => p.copyWith(isDefault: false)).toList();
      }

      // 添加新接口
      final newConfig = TranslationProviderConfig(
        id: addedProvider.id,
        provider: provider,
        name: name,
        appId: appId ?? '',
        appKey: appKey ?? '',
        apiUrl: apiUrl,
        isDefault: isDefault,
      );

      updatedProviders = [...updatedProviders, newConfig];
      _config.value = config.copyWith(providers: updatedProviders);
      await _saveConfigLocal();

      Logger.info('添加翻译接口成功');
    } catch (error, stackTrace) {
      Logger.error('添加翻译接口失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除翻译接口
  Future<void> removeTranslationProvider(String id) async {
    try {
      await _userSettingsApi.deleteTranslationProvider(id);

      final updatedProviders = config.providers.where((p) => p.id != id).toList();
      _config.value = config.copyWith(providers: updatedProviders);
      await _saveConfigLocal();

      Logger.info('删除翻译接口成功');
    } catch (error, stackTrace) {
      Logger.error('删除翻译接口失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新翻译接口配置
  Future<void> updateProviderConfigById(
    String id, {
    String? name,
    String? appId,
    String? appKey,
    String? apiUrl,
    bool? isEnabled,
    bool? isDefault,
  }) async {
    try {
      // 获取现有配置
      final existingProvider = config.getProviderConfigById(id);
      if (existingProvider == null) {
        Logger.warning('翻译接口不存在: $id');
        return;
      }

      // 构建更新后的配置
      final updatedProviderConfig = TranslationProviderConfig(
        id: id,
        provider: existingProvider.provider,
        name: name ?? existingProvider.name,
        appId: appId ?? existingProvider.appId,
        appKey: appKey ?? existingProvider.appKey,
        apiUrl: apiUrl ?? existingProvider.apiUrl,
        isDefault: isDefault ?? existingProvider.isDefault,
      );

      // 转换为 Model
      final providerModel = TranslationProviderConfigModel(
        id: updatedProviderConfig.id,
        provider: updatedProviderConfig.provider.code,
        name: updatedProviderConfig.name,
        appId: updatedProviderConfig.appId,
        appKey: updatedProviderConfig.appKey,
        apiUrl: updatedProviderConfig.apiUrl,
        isDefault: updatedProviderConfig.isDefault,
      );

      await _userSettingsApi.updateTranslationProvider(id, providerModel);

      // 更新本地状态
      var updatedProviders = config.providers;
      if (isDefault == true) {
        // 如果设置为默认，先取消其他默认设置
        updatedProviders = config.providers.map((p) => p.copyWith(isDefault: false)).toList();
      }

      updatedProviders = updatedProviders.map((p) {
        if (p.id == id) {
          return updatedProviderConfig;
        }
        return p;
      }).toList();

      _config.value = config.copyWith(providers: updatedProviders);
      await _saveConfigLocal();

      Logger.info('更新翻译接口成功');
    } catch (error, stackTrace) {
      Logger.error('更新翻译接口失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取翻译接口配置
  TranslationProviderConfig? getProviderConfigById(String id) {
    return config.getProviderConfigById(id);
  }

  /// 加载设置（优先从服务器，失败则从本地）
  Future<void> loadSettings() async {
    // 先从本地快速加载
    await _loadConfigLocal();
    // 然后从服务器加载最新数据
    await loadConfigFromServer();
  }

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  @override
  void onClose() {
    _saveConfigLocal();
    super.onClose();
  }
}
