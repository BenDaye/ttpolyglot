import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 用户设置 API
class UserSettingsApi {
  /// 获取用户完整设置
  Future<UserSettingsModel?> getUserSettings() async {
    try {
      final response = await HttpClient.get(
        '/users/me/settings',
      );
      return ModelUtils.toModel(
        response.data,
        (json) => UserSettingsModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取用户设置失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 更新用户完整设置
  Future<UserSettingsModel?> updateUserSettings(Map<String, dynamic> settings) async {
    try {
      final response = await HttpClient.put(
        '/users/me/settings',
        data: settings,
      );

      return ModelUtils.toModel(
        response.data,
        (json) => UserSettingsModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新用户设置失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 更新语言设置
  Future<LanguageSettingsModel?> updateLanguageSettings(String languageCode) async {
    try {
      final response = await HttpClient.put(
        '/users/me/settings/language',
        data: {'language_code': languageCode},
      );

      return ModelUtils.toModel(
        response.data,
        (json) => LanguageSettingsModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新语言设置失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 更新通用设置
  Future<GeneralSettingsModel?> updateGeneralSettings({
    bool? autoSave,
    bool? notifications,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (autoSave != null) data['auto_save'] = autoSave;
      if (notifications != null) data['notifications'] = notifications;

      final response = await HttpClient.put(
        '/users/me/settings/general',
        data: data,
      );

      return ModelUtils.toModel(
        response.data,
        (json) => GeneralSettingsModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新通用设置失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 更新翻译设置
  Future<TranslationSettingsModel?> updateTranslationSettings(
    TranslationSettingsModel settings,
  ) async {
    try {
      final response = await HttpClient.put(
        '/users/me/settings/translation',
        data: settings.toJson(),
      );

      return ModelUtils.toModel(
        response.data,
        (json) => TranslationSettingsModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新翻译设置失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 添加翻译接口
  Future<TranslationProviderConfigModel?> addTranslationProvider(
    TranslationProviderConfigModel provider,
  ) async {
    try {
      final response = await HttpClient.post(
        '/users/me/settings/translation/providers',
        data: provider.toJson(),
      );

      return ModelUtils.toModel(
        response.data,
        (json) => TranslationProviderConfigModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('添加翻译接口失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 更新翻译接口
  Future<TranslationProviderConfigModel?> updateTranslationProvider(
    String providerId,
    TranslationProviderConfigModel provider,
  ) async {
    try {
      final response = await HttpClient.put(
        '/users/me/settings/translation/providers/$providerId',
        data: provider.toJson(),
      );

      return ModelUtils.toModel(
        response.data,
        (json) => TranslationProviderConfigModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新翻译接口失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 删除翻译接口
  Future<bool> deleteTranslationProvider(String providerId) async {
    try {
      final response = await HttpClient.delete(
        '/users/me/settings/translation/providers/$providerId',
      );
      return response.success;
    } catch (error, stackTrace) {
      LoggerUtils.error('删除翻译接口失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 重置用户设置
  Future<UserSettingsModel?> resetUserSettings() async {
    try {
      final response = await HttpClient.post(
        '/users/me/settings/reset',
      );

      return ModelUtils.toModel(
        response.data,
        (json) => UserSettingsModel.fromJson(json),
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('重置用户设置失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
