import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/api/api.dart';
import 'package:ttpolyglot/src/common/services/token_storage_service.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 认证服务
class AuthService extends GetxService {
  final AuthApi _authApi;
  final TokenStorageService _tokenStorage;

  // 当前用户
  final Rx<UserInfoModel?> _currentUser = Rx<UserInfoModel?>(null);
  UserInfoModel? get currentUser => _currentUser.value;
  Rx<UserInfoModel?> get currentUserObs => _currentUser;

  // 是否已登录
  bool get isLoggedIn => _tokenStorage.isLoggedIn && _currentUser.value != null;

  AuthService({
    required AuthApi authApi,
    required TokenStorageService tokenStorage,
  })  : _authApi = authApi,
        _tokenStorage = tokenStorage;

  /// 初始化（检查登录状态）
  Future<void> init() async {
    try {
      if (_tokenStorage.isLoggedIn) {
        // 尝试从本地存储加载用户信息
        final savedUser = _tokenStorage.getUserInfo();
        if (savedUser != null) {
          _currentUser.value = savedUser;
          LoggerUtils.info('从本地加载用户信息: ${savedUser.username}');

          // 后台刷新用户信息
          _refreshUserInfo();
        } else {
          // 本地没有用户信息，从服务器获取
          await _refreshUserInfo();
        }
      }
    } catch (error, stackTrace) {
      LoggerUtils.error('初始化认证服务失败', error: error, stackTrace: stackTrace);
      // 初始化失败，清除登录状态
      await logout();
    }
  }

  /// 登录
  Future<void> login({
    required String emailOrUsername,
    required String password,
    String? deviceId,
    String? deviceName,
    String? deviceType,
  }) async {
    try {
      final request = LoginRequestModel(
        emailOrUsername: emailOrUsername,
        password: password,
      );

      final response = await _authApi.login(request);

      if (response == null) {
        throw Exception('登录响应数据为空');
      }

      // 保存 Token
      await _tokenStorage.saveTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      );

      // 保存用户信息
      await _tokenStorage.saveUserInfo(response.user);
      _currentUser.value = response.user;
    } catch (error) {
      rethrow;
    }
  }

  /// 登出
  Future<void> logout() async {
    try {
      // 调用服务端登出接口（忽略失败）
      try {
        await _authApi.logout();
      } catch (error, stackTrace) {
        LoggerUtils.error('服务端登出失败（忽略）', error: error, stackTrace: stackTrace);
      }
    } finally {
      // 无论如何都清除本地数据
      await _tokenStorage.clearTokens();
      await _tokenStorage.clearUserInfo();
      _currentUser.value = null;
      LoggerUtils.info('登出成功');
    }
  }

  /// 刷新 Token
  Future<void> refreshToken() async {
    try {
      final oldRefreshToken = _tokenStorage.getRefreshToken();
      if (oldRefreshToken == null || oldRefreshToken.isEmpty) {
        throw Exception('Refresh token not found');
      }

      final newTokens = await _authApi.refreshToken(oldRefreshToken);

      if (newTokens == null) {
        throw Exception('刷新 Token 响应数据为空');
      }

      await _tokenStorage.saveTokens(
        accessToken: newTokens.accessToken,
        refreshToken: newTokens.refreshToken,
      );

      LoggerUtils.info('Token 刷新成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('Token 刷新失败', error: error, stackTrace: stackTrace);
      // Token 刷新失败，清除登录状态
      await logout();
      rethrow;
    }
  }

  /// 刷新用户信息
  Future<void> _refreshUserInfo() async {
    try {
      final user = await _authApi.getCurrentUser();

      if (user == null) {
        throw Exception('获取当前用户响应数据为空');
      }

      _currentUser.value = user;
      await _tokenStorage.saveUserInfo(user);
      LoggerUtils.info('用户信息刷新成功: ${user.username}');
    } catch (error, stackTrace) {
      LoggerUtils.error('用户信息刷新失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 获取当前用户（强制刷新）
  Future<UserInfoModel> getCurrentUser({bool forceRefresh = false}) async {
    if (forceRefresh || _currentUser.value == null) {
      await _refreshUserInfo();
    }
    return _currentUser.value!;
  }

  /// 注册
  Future<UserInfoModel> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
    String? languageCode,
  }) async {
    try {
      final request = RegisterRequestModel(
        username: username,
        email: email,
        password: password,
        displayName: displayName,
        languageCode: languageCode,
      );

      final userInfo = await _authApi.register(request);

      if (userInfo == null) {
        throw Exception('注册响应数据为空');
      }

      LoggerUtils.info('用户注册成功: ${userInfo.username}');
      return userInfo;
    } catch (error, stackTrace) {
      LoggerUtils.error('注册失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 忘记密码
  Future<bool> forgotPassword({required String email}) async {
    try {
      final request = ForgotPasswordRequestModel(email: email);
      final success = await _authApi.forgotPassword(request);

      if (success) {
        LoggerUtils.info('忘记密码邮件发送成功: $email');
      }

      return success;
    } catch (error, stackTrace) {
      LoggerUtils.error('忘记密码失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 重置密码
  Future<bool> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final request = ResetPasswordRequestModel(
        token: token,
        newPassword: newPassword,
      );
      final success = await _authApi.resetPassword(request);

      if (success) {
        LoggerUtils.info('密码重置成功');
      }

      return success;
    } catch (error, stackTrace) {
      LoggerUtils.error('重置密码失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 验证邮箱
  Future<bool> verifyEmail({required String token}) async {
    try {
      final request = VerifyEmailRequestModel(token: token);
      final success = await _authApi.verifyEmail(request);

      if (success) {
        LoggerUtils.info('邮箱验证成功');
      }

      return success;
    } catch (error, stackTrace) {
      LoggerUtils.error('验证邮箱失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 重发验证邮件
  Future<bool> resendVerification({required String email}) async {
    try {
      final request = ResendVerificationRequestModel(email: email);
      final success = await _authApi.resendVerification(request);

      if (success) {
        LoggerUtils.info('重发验证邮件成功: $email');
      }

      return success;
    } catch (error, stackTrace) {
      LoggerUtils.error('重发验证邮件失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
