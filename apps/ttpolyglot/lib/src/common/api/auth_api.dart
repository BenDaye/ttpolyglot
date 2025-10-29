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

  /// 注册
  /// 注意：注册不使用拦截器的 loading，由 Controller 控制
  Future<UserInfoModel?> register(RegisterRequestModel request) async {
    try {
      final response = await HttpClient.post(
        '/auth/register',
        data: request.toJson(),
        options: Options(
          extra: const ExtraModel(
            showLoading: false,
            showErrorToast: true,
          ).toJson(),
        ),
      );
      final userInfo = ModelUtils.toModel(
        response.data,
        (json) => UserInfoModel.fromJson(json),
      );
      if (userInfo == null) {
        LoggerUtils.error('注册响应数据为空');
        return null;
      }
      return userInfo;
    } catch (error, stackTrace) {
      LoggerUtils.error('注册请求失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 忘记密码
  Future<bool> forgotPassword(ForgotPasswordRequestModel request) async {
    try {
      await HttpClient.post(
        '/auth/forgot-password',
        data: request.toJson(),
        options: Options(
          extra: const ExtraModel(
            showLoading: true,
            showErrorToast: true,
            showSuccessToast: true,
          ).toJson(),
        ),
      );
      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('忘记密码请求失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 重置密码
  Future<bool> resetPassword(ResetPasswordRequestModel request) async {
    try {
      await HttpClient.post(
        '/auth/reset-password',
        data: request.toJson(),
        options: Options(
          extra: const ExtraModel(
            showLoading: true,
            showErrorToast: true,
            showSuccessToast: true,
          ).toJson(),
        ),
      );
      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('重置密码请求失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 验证邮箱
  Future<bool> verifyEmail(VerifyEmailRequestModel request) async {
    try {
      await HttpClient.post(
        '/auth/verify-email',
        data: request.toJson(),
        options: Options(
          extra: const ExtraModel(
            showLoading: true,
            showErrorToast: true,
            showSuccessToast: true,
          ).toJson(),
        ),
      );
      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('验证邮箱请求失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 重发验证邮件
  Future<bool> resendVerification(ResendVerificationRequestModel request) async {
    try {
      await HttpClient.post(
        '/auth/resend-verification',
        data: request.toJson(),
        options: Options(
          extra: const ExtraModel(
            showLoading: true,
            showErrorToast: true,
            showSuccessToast: true,
          ).toJson(),
        ),
      );
      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('重发验证邮件请求失败', error: error, stackTrace: stackTrace);
      return false;
    }
  }
}
