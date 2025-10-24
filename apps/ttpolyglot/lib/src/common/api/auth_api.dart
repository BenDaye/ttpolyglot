import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 认证 API
class AuthApi {
  /// 登录
  /// 注意：登录不使用拦截器的 loading，由 Controller 控制
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await HttpClient.post(
        '/auth/login',
        data: request.toJson(),
        options: Options(
          extra: const ExtraModel(
            showLoading: false, // 关键：登录不使用拦截器 loading
            showErrorToast: true,
          ).toJson(),
        ),
      );
      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('登录响应数据为空');
      }
      return LoginResponseModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('登录请求失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      await HttpClient.post(
        '/auth/logout',
        options: Options(
          extra: const ExtraModel(
            showSuccessToast: true,
          ).toJson(),
        ),
      );
    } catch (error, stackTrace) {
      Logger.error('登出请求失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 刷新 Token
  Future<TokenInfoModel> refreshToken(String refreshToken) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      return TokenInfoModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('刷新 Token 失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 获取当前用户
  Future<UserInfoModel> getCurrentUser() async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>('/users/me');

      final data = response.data as Map<String, dynamic>;
      return UserInfoModel.fromJson(data);
    } catch (error, stackTrace) {
      Logger.error('获取当前用户失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
