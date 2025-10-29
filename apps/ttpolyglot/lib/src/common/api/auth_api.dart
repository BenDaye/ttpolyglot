import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 认证 API
class AuthApi {
  /// 登录
  /// 注意：登录不使用拦截器的 loading，由 Controller 控制
  Future<LoginResponseModel?> login(LoginRequestModel request) async {
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
      final loginResponse = ModelUtils.toModel(
        response.data,
        (json) => LoginResponseModel.fromJson(json),
      );
      if (loginResponse == null) {
        LoggerUtils.error('登录响应数据为空');
        return null;
      }
      return loginResponse;
    } catch (error, stackTrace) {
      LoggerUtils.error('登录请求失败', error: error, stackTrace: stackTrace);
      return null;
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
      LoggerUtils.error('登出请求失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 刷新 Token
  Future<TokenInfoModel?> refreshToken(String refreshToken) async {
    try {
      final response = await HttpClient.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final tokenInfo = ModelUtils.toModel(
        response.data,
        (json) => TokenInfoModel.fromJson(json),
      );
      if (tokenInfo == null) {
        LoggerUtils.error('刷新 Token 响应数据为空');
        return null;
      }
      return tokenInfo;
    } catch (error, stackTrace) {
      LoggerUtils.error('刷新 Token 失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 获取当前用户
  Future<UserInfoModel?> getCurrentUser() async {
    try {
      final response = await HttpClient.get<Map<String, dynamic>>('/users/me');
      final userInfo = ModelUtils.toModel(
        response.data,
        (json) => UserInfoModel.fromJson(json),
      );
      if (userInfo == null) {
        LoggerUtils.error('获取当前用户响应数据为空');
        return null;
      }
      return userInfo;
    } catch (error, stackTrace) {
      LoggerUtils.error('获取当前用户失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
