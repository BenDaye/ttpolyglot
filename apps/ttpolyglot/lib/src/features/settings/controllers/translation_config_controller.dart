import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/translation_provider.dart';

/// 翻译配置控制器
class TranslationConfigController extends GetxController {
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
          isEnabled: isEnabled,
        );
      }
      return p;
    }).toList();

    _config.value = config.copyWith(providers: updatedProviders);
    _saveConfig();
  }

  /// 切换提供商启用状态
  void toggleProvider(TranslationProvider provider) {
    final providerConfig = config.getProviderConfig(provider);
    if (providerConfig != null) {
      updateProviderConfig(
        provider,
        isEnabled: !providerConfig.isEnabled,
      );
    }
  }

  /// 设置最大重试次数
  void setMaxRetries(int retries) {
    if (retries < 0 || retries > 10) return;
    _config.value = config.copyWith(maxRetries: retries);
    _saveConfig();
  }

  /// 设置超时时间
  void setTimeout(int seconds) {
    if (seconds < 5 || seconds > 300) return;
    _config.value = config.copyWith(timeoutSeconds: seconds);
    _saveConfig();
  }

  /// 验证配置
  bool validateConfig() {
    for (final provider in config.providers) {
      if (provider.isEnabled && !provider.isValid) {
        return false;
      }
    }
    return true;
  }

  /// 获取配置验证错误
  List<String> getValidationErrors() {
    final errors = <String>[];
    for (final provider in config.providers) {
      if (provider.isEnabled) {
        errors.addAll(provider.getValidationErrors());
      }
    }
    return errors;
  }

  /// 保存配置到本地存储
  Future<void> _saveConfig() async {
    try {
      _isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final configMap = config.toMap();
      final configJson = jsonEncode(configMap);
      await prefs.setString('translation_config', configJson);
    } catch (error, stackTrace) {
      log('保存翻译配置失败', error: error, stackTrace: stackTrace, name: 'TranslationConfigController');
    } finally {
      _isLoading.value = false;
    }
  }

  /// 从本地存储加载配置
  Future<void> _loadConfig() async {
    try {
      _isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final configString = prefs.getString('translation_config');
      if (configString != null && configString.isNotEmpty) {
        final configMap = jsonDecode(configString) as Map<String, dynamic>;
        final loadedConfig = TranslationConfig.fromMap(configMap);
        _config.value = loadedConfig;
      } else {
        // 没有保存的配置，使用默认配置
        // 不需要重新赋值，因为 _config 已经初始化为默认值
      }
    } catch (error, stackTrace) {
      log('加载翻译配置失败', error: error, stackTrace: stackTrace, name: 'TranslationConfigController');
      // 加载失败时使用默认配置
      // 不需要重新赋值，因为 _config 已经初始化为默认值
    } finally {
      _isLoading.value = false;
    }
  }

  /// 重置为默认配置
  void resetToDefault() {
    _config.value = TranslationConfig(
      providers: [],
    );
    _saveConfig();
  }

  /// 生成唯一ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// 添加翻译接口
  void addTranslationProvider({
    required TranslationProvider provider,
    required String name,
    String? appId,
    String? appKey,
    String? apiUrl,
    bool isDefault = false,
  }) {
    // 如果设置为默认，先取消其他默认设置
    var updatedProviders = config.providers;
    if (isDefault) {
      updatedProviders = config.providers.map((p) => p.copyWith(isDefault: false)).toList();
    }

    final newConfig = TranslationProviderConfig(
      id: _generateId(),
      provider: provider,
      name: name,
      appId: appId ?? '',
      appKey: appKey ?? '',
      apiUrl: apiUrl,
      isEnabled: false,
      isDefault: isDefault,
    );

    updatedProviders = [...updatedProviders, newConfig];
    _config.value = config.copyWith(providers: updatedProviders);
    _saveConfig();
  }

  /// 删除翻译接口
  void removeTranslationProvider(String id) {
    final updatedProviders = config.providers.where((p) => p.id != id).toList();
    _config.value = config.copyWith(providers: updatedProviders);
    _saveConfig();
  }

  /// 启用/禁用翻译接口
  void toggleProviderById(String id) {
    final updatedProviders = config.providers.map((p) {
      if (p.id == id) {
        return p.copyWith(isEnabled: !p.isEnabled);
      }
      return p;
    }).toList();

    _config.value = config.copyWith(providers: updatedProviders);
    _saveConfig();
  }

  /// 更新翻译接口配置
  void updateProviderConfigById(
    String id, {
    String? name,
    String? appId,
    String? appKey,
    String? apiUrl,
    bool? isEnabled,
    bool? isDefault,
  }) {
    var updatedProviders = config.providers;
    if (isDefault == true) {
      // 如果设置为默认，先取消其他默认设置
      updatedProviders = config.providers.map((p) => p.copyWith(isDefault: false)).toList();
    }

    updatedProviders = updatedProviders.map((p) {
      if (p.id == id) {
        return p.copyWith(
          name: name,
          appId: appId,
          appKey: appKey,
          apiUrl: apiUrl,
          isEnabled: isEnabled,
          isDefault: isDefault,
        );
      }
      return p;
    }).toList();

    _config.value = config.copyWith(providers: updatedProviders);
    _saveConfig();
  }

  /// 获取翻译接口配置
  TranslationProviderConfig? getProviderConfigById(String id) {
    return config.getProviderConfigById(id);
  }

  @override
  void onInit() {
    super.onInit();
    _loadConfig();
  }

  @override
  void onClose() {
    _saveConfig();
    super.onClose();
  }
}
