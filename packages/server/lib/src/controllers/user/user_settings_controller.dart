import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 用户设置控制器
class UserSettingsController extends BaseController {
  final UserSettingsService _userSettingsService;

  UserSettingsController({
    required UserSettingsService userSettingsService,
  })  : _userSettingsService = userSettingsService,
        super('UserSettingsController');

  Router get router {
    final router = Router();

    // 完整设置接口
    router.get('/settings', _getUserSettings);
    router.put('/settings', _updateUserSettings);

    // 语言设置接口
    router.get('/settings/language', _getLanguageSettings);
    router.put('/settings/language', _updateLanguageSettings);

    // 通用设置接口
    router.get('/settings/general', _getGeneralSettings);
    router.put('/settings/general', _updateGeneralSettings);

    // 翻译设置接口
    router.get('/settings/translation', _getTranslationSettings);
    router.put('/settings/translation', _updateTranslationSettings);

    // 翻译接口管理
    router.post('/settings/translation/providers', _addTranslationProvider);
    router.put('/settings/translation/providers/<id>', _updateTranslationProvider);
    router.delete('/settings/translation/providers/<id>', _deleteTranslationProvider);

    // 重置设置
    router.post('/settings/reset', _resetUserSettings);

    return router;
  }

  /// 获取用户完整设置
  Future<Response> _getUserSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final settings = await _userSettingsService.getUserSettings(userId);

      return ResponseUtils.success<UserSettingsModel>(
        message: '获取用户设置成功',
        data: settings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取用户设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '获取用户设置失败');
    }
  }

  /// 更新用户完整设置
  Future<Response> _updateUserSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final body = await request.readAsString();
      final settingsData = jsonDecode(body) as Map<String, dynamic>;

      final updatedSettings = await _userSettingsService.updateUserSettings(userId, settingsData);

      return ResponseUtils.success(
        message: '更新用户设置成功',
        data: updatedSettings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新用户设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '更新用户设置失败');
    }
  }

  /// 获取语言设置
  Future<Response> _getLanguageSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final settings = await _userSettingsService.getUserSettings(userId);

      return ResponseUtils.success<LanguageSettingsModel>(
        message: '获取语言设置成功',
        data: settings.languageSettings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取语言设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '获取语言设置失败');
    }
  }

  /// 更新语言设置
  Future<Response> _updateLanguageSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final languageCode = data['language_code'] as String?;
      if (languageCode == null || languageCode.isEmpty) {
        return ResponseUtils.error(message: '语言代码不能为空');
      }

      final languageSettings = await _userSettingsService.updateLanguageSettings(userId, languageCode);

      return ResponseUtils.success(
        message: '更新语言设置成功',
        data: languageSettings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新语言设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '更新语言设置失败');
    }
  }

  /// 获取通用设置
  Future<Response> _getGeneralSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final settings = await _userSettingsService.getUserSettings(userId);

      return ResponseUtils.success<GeneralSettingsModel>(
        message: '获取通用设置成功',
        data: settings.generalSettings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取通用设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '获取通用设置失败');
    }
  }

  /// 更新通用设置
  Future<Response> _updateGeneralSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final autoSave = data['auto_save'] as bool?;
      final notifications = data['notifications'] as bool?;

      final generalSettings = await _userSettingsService.updateGeneralSettings(
        userId,
        autoSave: autoSave,
        notifications: notifications,
      );

      return ResponseUtils.success<GeneralSettingsModel>(
        message: '更新通用设置成功',
        data: generalSettings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新通用设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '更新通用设置失败');
    }
  }

  /// 获取翻译设置
  Future<Response> _getTranslationSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final settings = await _userSettingsService.getUserSettings(userId);

      return ResponseUtils.success<TranslationSettingsModel>(
        message: '获取翻译设置成功',
        data: settings.translationSettings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取翻译设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '获取翻译设置失败');
    }
  }

  /// 更新翻译设置
  Future<Response> _updateTranslationSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final translationSettings = TranslationSettingsModel.fromJson(data);

      final updatedSettings = await _userSettingsService.updateTranslationSettings(userId, translationSettings);

      return ResponseUtils.success(
        message: '更新翻译设置成功',
        data: updatedSettings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新翻译设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '更新翻译设置失败');
    }
  }

  /// 添加翻译接口
  Future<Response> _addTranslationProvider(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final provider = TranslationProviderConfigModel.fromJson(data);

      final addedProvider = await _userSettingsService.addTranslationProvider(userId, provider);

      return ResponseUtils.success<TranslationProviderConfigModel>(
        message: '添加翻译接口成功',
        data: addedProvider,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('添加翻译接口失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '添加翻译接口失败');
    }
  }

  /// 更新翻译接口
  Future<Response> _updateTranslationProvider(Request request, String providerId) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final provider = TranslationProviderConfigModel.fromJson(data);

      final updatedProvider = await _userSettingsService.updateTranslationProvider(userId, providerId, provider);

      return ResponseUtils.success<TranslationProviderConfigModel>(
        message: '更新翻译接口成功',
        data: updatedProvider,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新翻译接口失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '更新翻译接口失败');
    }
  }

  /// 删除翻译接口
  Future<Response> _deleteTranslationProvider(Request request, String providerId) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      await _userSettingsService.deleteTranslationProvider(userId, providerId);

      return ResponseUtils.success(
        message: '删除翻译接口成功',
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('删除翻译接口失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '删除翻译接口失败');
    }
  }

  /// 重置用户设置
  Future<Response> _resetUserSettings(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: DataCodeEnum.authenticationError, message: '未授权访问');
      }

      final defaultSettings = await _userSettingsService.resetUserSettings(userId);

      return ResponseUtils.success<UserSettingsModel>(
        message: '重置用户设置成功',
        data: defaultSettings,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('重置用户设置失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '重置用户设置失败');
    }
  }
}
