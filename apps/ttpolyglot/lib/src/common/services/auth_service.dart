import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/api/api.dart';
import 'package:ttpolyglot/src/common/services/token_storage_service.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

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
          Logger.info('从本地加载用户信息: ${savedUser.username}');

          // 后台刷新用户信息
          _refreshUserInfo();
        } else {
          // 本地没有用户信息，从服务器获取
          await _refreshUserInfo();
        }
      }
    } catch (error, stackTrace) {
      Logger.error('初始化认证服务失败', error: error, stackTrace: stackTrace);
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
        Logger.error('服务端登出失败（忽略）', error: error, stackTrace: stackTrace);
      }
    } finally {
      // 无论如何都清除本地数据
      await _tokenStorage.clearTokens();
      await _tokenStorage.clearUserInfo();
      _currentUser.value = null;
      Logger.info('登出成功');
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

      Logger.info('Token 刷新成功');
    } catch (error, stackTrace) {
      Logger.error('Token 刷新失败', error: error, stackTrace: stackTrace);
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
      Logger.info('用户信息刷新成功: ${user.username}');
    } catch (error, stackTrace) {
      Logger.error('用户信息刷新失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 获取当前用户（强制刷新）
  Future<UserInfoModel> getCurrentUser({bool forceRefresh = false}) async {
    if (forceRefresh || _currentUser.value == null) {
      await _refreshUserInfo();
    }
    return _currentUser.value!;
  }
}
