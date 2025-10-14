import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/models/models.dart';
import 'package:ttpolyglot/src/common/network/network.dart';

/// 认证 API
class AuthApi {
  /// 登录
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/auth/login',
        data: request.toJson(),
        options: Options(
          extra: const RequestExtra(
            showLoading: true,
            showErrorToast: true,
          ).toJson(),
        ),
      );

      // response 已经被 ResponseInterceptor 处理，直接获取 data 字段
      final data = response['data'] as Map<String, dynamic>;
      return LoginResponse.fromJson(data);
    } catch (error, stackTrace) {
      log('登录请求失败', error: error, stackTrace: stackTrace, name: 'AuthApi');
      rethrow;
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      await HttpClient.post(
        '/auth/logout',
        options: Options(
          extra: const RequestExtra(
            showSuccessToast: true,
          ).toJson(),
        ),
      );
    } catch (error, stackTrace) {
      log('登出请求失败', error: error, stackTrace: stackTrace, name: 'AuthApi');
      rethrow;
    }
  }

  /// 刷新 Token
  Future<TokenInfo> refreshToken(String refreshToken) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response['data'] as Map<String, dynamic>;
      return TokenInfo.fromJson(data);
    } catch (error, stackTrace) {
      log('刷新 Token 失败', error: error, stackTrace: stackTrace, name: 'AuthApi');
      rethrow;
    }
  }

  /// 获取当前用户
  Future<UserInfo> getCurrentUser() async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>('/auth/me');

      final data = response['data'] as Map<String, dynamic>;
      return UserInfo.fromJson(data);
    } catch (error, stackTrace) {
      log('获取当前用户失败', error: error, stackTrace: stackTrace, name: 'AuthApi');
      rethrow;
    }
  }
}
