import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 用户设置 API
class UserSettingsApi {
  /// 获取用户完整设置
  Future<UserSettingsModel> getUserSettings() async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>(
        '/users/me/settings',
        options: Options(
          extra: const RequestExtraModel(
            showLoading: false,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return UserSettingsModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('获取用户设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新用户完整设置
  Future<UserSettingsModel> updateUserSettings(Map<String, dynamic> settings) async {
    try {
      final response = await HttpClient.put<Map<String, dynamic>>(
        '/users/me/settings',
        data: settings,
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return UserSettingsModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('更新用户设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新语言设置
  Future<LanguageSettingsModel> updateLanguageSettings(String languageCode) async {
    try {
      final response = await HttpClient.put<Map<String, dynamic>>(
        '/users/me/settings/language',
        data: {'language_code': languageCode},
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return LanguageSettingsModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('更新语言设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新通用设置
  Future<GeneralSettingsModel> updateGeneralSettings({
    bool? autoSave,
    bool? notifications,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (autoSave != null) data['auto_save'] = autoSave;
      if (notifications != null) data['notifications'] = notifications;

      final response = await HttpClient.put<Map<String, dynamic>>(
        '/users/me/settings/general',
        data: data,
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      final responseData = response.data as Map<String, dynamic>;
      return GeneralSettingsModel.fromJson(responseData);
    } catch (error, stackTrace) {
      Logger.error('更新通用设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新翻译设置
  Future<TranslationSettingsModel> updateTranslationSettings(
    TranslationSettingsModel settings,
  ) async {
    try {
      final response = await HttpClient.put<Map<String, dynamic>>(
        '/users/me/settings/translation',
        data: settings.toJson(),
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return TranslationSettingsModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('更新翻译设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 添加翻译接口
  Future<TranslationProviderConfigModel> addTranslationProvider(
    TranslationProviderConfigModel provider,
  ) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/users/me/settings/translation/providers',
        data: provider.toJson(),
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return TranslationProviderConfigModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('添加翻译接口失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新翻译接口
  Future<TranslationProviderConfigModel> updateTranslationProvider(
    String providerId,
    TranslationProviderConfigModel provider,
  ) async {
    try {
      final response = await HttpClient.put<Map<String, dynamic>>(
        '/users/me/settings/translation/providers/$providerId',
        data: provider.toJson(),
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return TranslationProviderConfigModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('更新翻译接口失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 删除翻译接口
  Future<void> deleteTranslationProvider(String providerId) async {
    try {
      await HttpClient.delete(
        '/users/me/settings/translation/providers/$providerId',
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );
    } catch (error, stackTrace) {
      Logger.error('删除翻译接口失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 重置用户设置
  Future<UserSettingsModel> resetUserSettings() async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/users/me/settings/reset',
        options: Options(
          extra: const RequestExtraModel(
            showSuccessToast: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      final data = response.data as Map<String, dynamic>;
      return UserSettingsModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('重置用户设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
