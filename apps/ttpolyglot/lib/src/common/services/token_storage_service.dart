import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttpolyglot/src/common/config/config.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

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
      LoggerUtils.info('Token 保存成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('Token 保存失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取 Access Token
  String? getAccessToken() {
    try {
      return _prefs.getString(AppConfig.accessTokenKey);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取 Access Token 失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 获取 Refresh Token
  String? getRefreshToken() {
    try {
      return _prefs.getString(AppConfig.refreshTokenKey);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取 Refresh Token 失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 删除 Tokens
  Future<void> clearTokens() async {
    try {
      await _prefs.remove(AppConfig.accessTokenKey);
      await _prefs.remove(AppConfig.refreshTokenKey);
      LoggerUtils.info('Token 清除成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('Token 清除失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 保存用户信息
  Future<void> saveUserInfo(UserInfoModel userInfo) async {
    try {
      final jsonString = jsonEncode(userInfo.toJson());
      await _prefs.setString(AppConfig.userInfoKey, jsonString);
      LoggerUtils.info('用户信息保存成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('用户信息保存失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取用户信息
  UserInfoModel? getUserInfo() {
    try {
      final jsonString = _prefs.getString(AppConfig.userInfoKey);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserInfoModel.fromJson(json);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取用户信息失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 清除用户信息
  Future<void> clearUserInfo() async {
    try {
      await _prefs.remove(AppConfig.userInfoKey);
      LoggerUtils.info('用户信息清除成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('用户信息清除失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 是否已登录
  bool get isLoggedIn {
    final token = getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
