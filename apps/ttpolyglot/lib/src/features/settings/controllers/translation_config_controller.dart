import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttpolyglot/src/common/api/api.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 翻译配置控制器
class TranslationConfigController extends GetxController {
  static TranslationConfigController get instance => Get.isRegistered<TranslationConfigController>()
      ? Get.find<TranslationConfigController>()
      : Get.put(TranslationConfigController());

  final UserSettingsApi _userSettingsApi = Get.find<UserSettingsApi>();

  // 响应式变量
  final _config = TranslationSettingsModel(
    providers: [],
  ).obs;

  final _isLoading = false.obs;
  final _isInitialized = false.obs;

  // Getters
  TranslationSettingsModel get config => _config.value;
  bool get isLoading => _isLoading.value;
  bool get isInitialized => _isInitialized.value;

  /// 更新提供商配置
  void updateProviderConfig(
    TranslationProviderConfigModel provider, {
    String? appId,
    String? appKey,
    String? apiUrl,
    bool? isEnabled,
  }) {
    final updatedProviders = config.providers.map((p) {
      if (p.id == provider.id) {
        return p.copyWith(
          appId: appId ?? '',
          appKey: appKey ?? '',
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

  /// 从服务器加载配置
  Future<void> loadConfigFromServer() async {
    try {
      _isLoading.value = true;
      final settings = await _userSettingsApi.getUserSettings();

      _config.value = TranslationSettingsModel(
        providers: settings.translationSettings.providers,
        maxRetries: settings.translationSettings.maxRetries,
        timeoutSeconds: settings.translationSettings.timeoutSeconds,
      );

      // 同时保存到本地缓存
      await _saveConfigLocal();

      LoggerUtils.info('从服务器加载翻译配置成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('从服务器加载翻译配置失败', error: error, stackTrace: stackTrace);
      // 加载失败时从本地加载
      await _loadConfigLocal();
    } finally {
      _isLoading.value = false;
    }
  }

  /// 保存配置到服务器
  Future<void> _saveConfigToServer() async {
    try {
      final translationSettings = TranslationSettingsModel(
        providers: config.providers,
        maxRetries: config.maxRetries,
        timeoutSeconds: config.timeoutSeconds,
      );

      await _userSettingsApi.updateTranslationSettings(translationSettings);
      await _saveConfigLocal();

      LoggerUtils.info('保存翻译配置到服务器成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('保存翻译配置到服务器失败', error: error, stackTrace: stackTrace);
      // 保存失败时仅保存到本地
      await _saveConfigLocal();
    }
  }

  /// 保存配置到本地存储（作为缓存）
  Future<void> _saveConfigLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configMap = config.toJson();
      final configJson = jsonEncode(configMap);
      await prefs.setString('translation_config', configJson);
    } catch (error, stackTrace) {
      LoggerUtils.error('保存翻译配置到本地失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 从本地存储加载配置
  Future<void> _loadConfigLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configString = prefs.getString('translation_config');
      if (configString != null && configString.isNotEmpty) {
        final configMap = jsonDecode(configString) as Map<String, dynamic>;
        final loadedConfig = TranslationSettingsModel.fromJson(configMap);
        _config.value = loadedConfig;
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('从本地加载翻译配置失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 重置为默认配置
  Future<void> resetToDefault() async {
    try {
      // 只重置最大重试次数和超时时间，保留翻译接口列表
      _config.value = config.copyWith(
        maxRetries: 3,
        timeoutSeconds: 30,
      );

      await _saveConfigToServer();
      LoggerUtils.info('重置翻译配置成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('重置翻译配置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 添加翻译接口
  Future<void> addTranslationProvider({
    required TranslationProviderConfigModel provider,
    required String name,
    String? appId,
    String? appKey,
    String? apiUrl,
    bool isDefault = false,
  }) async {
    try {
      final addedProvider = await _userSettingsApi.addTranslationProvider(provider);

      // 如果设置为默认，先取消其他默认设置
      var updatedProviders = config.providers;
      if (isDefault) {
        updatedProviders = config.providers.map((p) => p.copyWith(isDefault: false)).toList();
      }

      // 添加新接口
      final newConfig = TranslationProviderConfigModel(
        id: addedProvider.id,
        provider: provider.provider,
        name: name,
        appId: appId ?? '',
        appKey: appKey ?? '',
        apiUrl: apiUrl ?? '',
        isDefault: isDefault,
      );

      updatedProviders = [...updatedProviders, newConfig];
      _config.value = config.copyWith(providers: updatedProviders);
      await _saveConfigLocal();

      LoggerUtils.info('添加翻译接口成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('添加翻译接口失败', error: error, stackTrace: stackTrace);
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

      LoggerUtils.info('删除翻译接口成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('删除翻译接口失败', error: error, stackTrace: stackTrace);
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
      final existingProvider = config.providers.firstWhereOrNull((p) => p.id == id);
      if (existingProvider == null) {
        LoggerUtils.warning('翻译接口不存在: $id');
        return;
      }

      // 构建更新后的配置
      final updatedProviderConfig = TranslationProviderConfigModel(
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
        provider: updatedProviderConfig.provider,
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

      LoggerUtils.info('更新翻译接口成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('更新翻译接口失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取翻译接口配置
  TranslationProviderConfigModel? getProviderConfigById(String id) {
    return config.providers.firstWhereOrNull((p) => p.id == id);
  }

  /// 加载设置（优先从服务器，失败则从本地）
  Future<void> loadSettings() async {
    try {
      // 先从本地快速加载
      await _loadConfigLocal();
      // 然后从服务器加载最新数据
      await loadConfigFromServer();
    } finally {
      _isInitialized.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // 确保配置加载完成后再继续
    loadSettings();
  }

  @override
  void onClose() {
    _saveConfigLocal();
    super.onClose();
  }
}
