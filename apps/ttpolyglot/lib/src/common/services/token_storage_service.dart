import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttpolyglot/src/common/config/config.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// Token 存储服务
class TokenStorageService {
  final SharedPreferences _prefs;

  TokenStorageService(this._prefs);

  /// 保存 Tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await _prefs.setString(AppConfig.accessTokenKey, accessToken);
      await _prefs.setString(AppConfig.refreshTokenKey, refreshToken);
      Logger.info('Token 保存成功');
    } catch (error, stackTrace) {
      Logger.error('Token 保存失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取 Access Token
  String? getAccessToken() {
    try {
      return _prefs.getString(AppConfig.accessTokenKey);
    } catch (error, stackTrace) {
      Logger.error('获取 Access Token 失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 获取 Refresh Token
  String? getRefreshToken() {
    try {
      return _prefs.getString(AppConfig.refreshTokenKey);
    } catch (error, stackTrace) {
      Logger.error('获取 Refresh Token 失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 删除 Tokens
  Future<void> clearTokens() async {
    try {
      await _prefs.remove(AppConfig.accessTokenKey);
      await _prefs.remove(AppConfig.refreshTokenKey);
      Logger.info('Token 清除成功');
    } catch (error, stackTrace) {
      Logger.error('Token 清除失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 保存用户信息
  Future<void> saveUserInfo(UserInfo userInfo) async {
    try {
      final jsonString = jsonEncode(userInfo.toJson());
      await _prefs.setString(AppConfig.userInfoKey, jsonString);
      Logger.info('用户信息保存成功');
    } catch (error, stackTrace) {
      Logger.error('用户信息保存失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取用户信息
  UserInfo? getUserInfo() {
    try {
      final jsonString = _prefs.getString(AppConfig.userInfoKey);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserInfo.fromJson(json);
    } catch (error, stackTrace) {
      Logger.error('获取用户信息失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 清除用户信息
  Future<void> clearUserInfo() async {
    try {
      await _prefs.remove(AppConfig.userInfoKey);
      Logger.info('用户信息清除成功');
    } catch (error, stackTrace) {
      Logger.error('用户信息清除失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 是否已登录
  bool get isLoggedIn {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
