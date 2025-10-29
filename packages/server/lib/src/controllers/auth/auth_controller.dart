import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 认证控制器
class AuthController extends BaseController {
  final AuthService _authService;

  AuthController({
    required AuthService authService,
  })  : _authService = authService,
        super('AuthController');

  Router get router {
    final router = Router();

    // 公开路由（无需认证）
    router.post('/register', _register);
    router.post('/login', _login);
    router.post('/refresh', _refreshToken);
    router.post('/forgot-password', _forgotPassword);
    router.post('/reset-password', _resetPassword);
    router.post('/verify-email', _verifyEmail);

    // 需要认证的路由
    router.post('/logout', _logout);
    router.get('/me', _getCurrentUser);

    return router;
  }

  // 公共方法用于路由配置
  Future<Response> Function(Request) get login => _login;
  Future<Response> Function(Request) get logout => _logout;
  Future<Response> Function(Request) get refresh => _refreshToken;
  Future<Response> Function(Request) get register => _register;
  Future<Response> Function(Request) get forgotPassword => _forgotPassword;
  Future<Response> Function(Request) get resetPassword => _resetPassword;
  Future<Response> Function(Request) get verifyEmail => _verifyEmail;
  Future<Response> Function(Request) get resendVerification => _resendVerification;
  Future<Response> Function(Request) get me => _getCurrentUser;

  /// 用户注册
  Future<Response> _register(Request request) async {
    try {
      // 解析请求体
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // 验证必需字段
      final username = ValidatorUtils.validateString(data['username'], 'username', minLength: 3, maxLength: 50);
      final email = ValidatorUtils.validateEmail(data['email'], 'email');
      final password = ValidatorUtils.validateString(data['password'], 'password', minLength: 8);

      // 可选字段
      final displayName = data['display_name'] as String?;
      final timezone = data['timezone'] as String?;
      final locale = data['locale'] as String?;

      // 调用认证服务
      final result = await _authService.register(
        username: username,
        email: email,
        password: password,
        displayName: displayName,
        timezone: timezone,
        locale: locale,
      );

      if (result != null) {
        return ResponseUtils.success<UserInfoModel>(
          message: '用户注册成功',
          data: result,
        );
      } else {
        return ResponseUtils.error(message: '用户注册失败');
      }
    } catch (error, stackTrace) {
      ServerLogger.error('用户注册失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '注册失败，请稍后重试');
    }
  }

  /// 用户登录
  Future<Response> _login(Request request) async {
    try {
      // 解析请求体
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // 验证必需字段
      final emailOrUsername = ValidatorUtils.validateString(data['email_or_username'], 'email_or_username');
      final password = ValidatorUtils.validateString(data['password'], 'password');

      // 可选字段
      final deviceId = data['device_id'] as String?;
      final deviceName = data['device_name'] as String?;
      final deviceType = data['device_type'] as String?;

      // 获取客户端信息
      final ipAddress = getClientIp(request);
      final userAgent = request.headers['user-agent'];

      // 调用认证服务
      final result = await _authService.login(
        emailOrUsername: emailOrUsername,
        password: password,
        deviceId: deviceId,
        deviceName: deviceName,
        deviceType: deviceType,
        ipAddress: ipAddress,
        userAgent: userAgent,
      );

      if (result != null) {
        return ResponseUtils.success<LoginResponseModel>(
          message: '用户登录成功',
          data: result,
        );
      } else {
        return ResponseUtils.error(message: '用户登录失败');
      }
    } catch (error, stackTrace) {
      ServerLogger.error('用户登录失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '登录失败，请稍后重试',
      );
    }
  }

  /// 用户登出
  Future<Response> _logout(Request request) async {
    try {
      // 获取访问令牌
      final token = getAuthToken(request);
      if (token == null) {
        return ResponseUtils.error(
          message: '认证令牌缺失',
        );
      }

      // 调用认证服务
      final result = await _authService.logout(token);

      if (result != null) {
        return ResponseUtils.success(message: '用户登出成功');
      } else {
        return ResponseUtils.error(message: '用户登出失败');
      }
    } catch (error, stackTrace) {
      ServerLogger.error('用户登出失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '登出失败，请稍后重试',
      );
    }
  }

  /// 刷新令牌
  Future<Response> _refreshToken(Request request) async {
    try {
      // 解析请求体
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // 验证刷新令牌
      final refreshToken = ValidatorUtils.validateString(data['refresh_token'], 'refresh_token');

      // 调用认证服务
      final result = await _authService.refreshToken(refreshToken);

      if (result != null) {
        return ResponseUtils.success<TokenInfoModel>(
          message: '刷新令牌成功',
          data: result,
        );
      } else {
        return ResponseUtils.error(message: '刷新令牌失败');
      }
    } catch (error, stackTrace) {
      ServerLogger.error('刷新令牌失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '令牌刷新失败',
      );
    }
  }

  /// 忘记密码
  Future<Response> _forgotPassword(Request request) async {
    try {
      // 解析请求体
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // 验证邮箱
      final email = ValidatorUtils.validateEmail(data['email'], 'email');

      // 调用认证服务
      final result = await _authService.forgotPassword(email);

      if (result != null) {
        return ResponseUtils.success(message: '忘记密码成功');
      } else {
        return ResponseUtils.error(message: '忘记密码失败');
      }
    } catch (error, stackTrace) {
      ServerLogger.error('忘记密码失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '请求失败，请稍后重试',
      );
    }
  }

  /// 重置密码
  Future<Response> _resetPassword(Request request) async {
    try {
      // 解析请求体
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // 验证参数
      final token = ValidatorUtils.validateString(data['token'], 'token');
      final newPassword = ValidatorUtils.validateString(data['new_password'], 'new_password', minLength: 8);

      // 调用认证服务
      final result = await _authService.resetPassword(token, newPassword);

      if (result != null) {
        return ResponseUtils.success(message: '重置密码成功');
      } else {
        return ResponseUtils.error(message: '重置密码失败');
      }
    } catch (error, stackTrace) {
      ServerLogger.error('重置密码失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '重置失败，请稍后重试',
      );
    }
  }

  /// 邮箱验证
  Future<Response> _verifyEmail(Request request) async {
    try {
      // 解析请求体
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // 验证令牌
      final token = ValidatorUtils.validateString(data['token'], 'token');

      // 调用认证服务
      final result = await _authService.verifyEmail(token);

      if (result != null) {
        return ResponseUtils.success(message: '邮箱验证成功');
      } else {
        return ResponseUtils.error(message: '邮箱验证失败');
      }
    } catch (error, stackTrace) {
      ServerLogger.error('邮箱验证失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '验证失败，请稍后重试',
      );
    }
  }

  /// 获取当前用户信息
  Future<Response> _getCurrentUser(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(
          message: '用户信息不存在',
        );
      }

      // 从数据库获取完整的用户信息
      final user = await _authService.getUserById(userId);

      if (user == null) {
        return ResponseUtils.error(
          message: '用户不存在',
        );
      }

      return ResponseUtils.success(
        message: '获取用户信息成功',
        data: user,
      );
    } catch (error, stackTrace) {
      ServerLogger.error('获取当前用户信息失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '获取用户信息失败',
      );
    }
  }

  /// 重发验证邮件
  Future<Response> _resendVerification(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final email = data['email'] as String?;
      if (email == null || email.isEmpty) {
        return ResponseUtils.error(
          message: '邮箱地址不能为空',
        );
      }

      final result = await _authService.resendVerification(email);

      if (result != null) {
        return ResponseUtils.success(message: '重发验证邮件成功');
      } else {
        return ResponseUtils.error(message: '重发验证邮件失败');
      }
    } catch (error, stackTrace) {
      ServerLogger.error('重发验证邮件失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '重发验证邮件失败，请稍后重试',
      );
    }
  }
}
