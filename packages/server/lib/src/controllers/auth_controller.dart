import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../middleware/auth_middleware.dart';
import '../middleware/error_handler_middleware.dart';
import '../services/auth_service.dart';
import '../utils/response_builder.dart';
import '../utils/structured_logger.dart';
import '../utils/validator.dart';

/// 认证控制器
class AuthController {
  final AuthService _authService;

  AuthController({
    required AuthService authService,
  }) : _authService = authService;

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
      final username = Validator.validateString(data['username'], 'username', minLength: 3, maxLength: 50);
      final email = Validator.validateEmail(data['email'], 'email');
      final password = Validator.validateString(data['password'], 'password', minLength: 8);

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

      if (result.success) {
        return ResponseBuilder.created(
          message: result.message,
          data: result.data,
        );
      } else {
        return ResponseBuilder.error(
          code: result.code,
          message: result.message,
          statusCode: 400,
        );
      }
    } catch (error, stackTrace) {
      final logger = LoggerFactory.getLogger('AuthController');
      logger.error('用户注册失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseBuilder.validationError(
          message: '用户注册参数验证失败',
          fieldErrors: error.fieldErrors,
        );
      }

      return ResponseBuilder.error(
        code: 'REGISTRATION_FAILED',
        message: '注册失败，请稍后重试',
        statusCode: 500,
      );
    }
  }

  /// 用户登录
  Future<Response> _login(Request request) async {
    try {
      // 解析请求体
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      // 验证必需字段
      final emailOrUsername = Validator.validateString(data['email_or_username'], 'email_or_username');
      final password = Validator.validateString(data['password'], 'password');

      // 可选字段
      final deviceId = data['device_id'] as String?;
      final deviceName = data['device_name'] as String?;
      final deviceType = data['device_type'] as String?;

      // 获取客户端信息
      final ipAddress = _getClientIp(request);
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

      if (result.success) {
        return ResponseBuilder.success(
          message: result.message,
          data: result.data,
        );
      } else {
        return ResponseBuilder.error(
          code: result.code,
          message: result.message,
          statusCode: 401,
        );
      }
    } catch (error, stackTrace) {
      logger.error('用户登录失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseBuilder.validationError(
          message: '用户登录参数验证失败',
          fieldErrors: error.fieldErrors,
        );
      }

      return ResponseBuilder.error(
        code: 'LOGIN_FAILED',
        message: '登录失败，请稍后重试',
        statusCode: 500,
      );
    }
  }

  /// 用户登出
  Future<Response> _logout(Request request) async {
    try {
      // 获取访问令牌
      final token = getAuthToken(request);
      if (token == null) {
        return ResponseBuilder.error(
          code: 'AUTH_TOKEN_MISSING',
          message: '认证令牌缺失',
          statusCode: 401,
        );
      }

      // 调用认证服务
      final result = await _authService.logout(token);

      if (result.success) {
        return ResponseBuilder.success(message: result.message);
      } else {
        return ResponseBuilder.error(
          code: result.code,
          message: result.message,
          statusCode: 400,
        );
      }
    } catch (error, stackTrace) {
      logger.error('用户登出失败', error: error, stackTrace: stackTrace);

      return ResponseBuilder.error(
        code: 'LOGOUT_FAILED',
        message: '登出失败，请稍后重试',
        statusCode: 500,
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
      final refreshToken = Validator.validateString(data['refresh_token'], 'refresh_token');

      // 调用认证服务
      final result = await _authService.refreshToken(refreshToken);

      if (result.success) {
        return ResponseBuilder.success(
          message: result.message,
          data: result.data,
        );
      } else {
        return ResponseBuilder.error(
          code: result.code,
          message: result.message,
          statusCode: 401,
        );
      }
    } catch (error, stackTrace) {
      logger.error('刷新令牌失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseBuilder.validationError(
          message: '令牌刷新参数验证失败',
          fieldErrors: error.fieldErrors,
        );
      }

      return ResponseBuilder.error(
        code: 'REFRESH_FAILED',
        message: '令牌刷新失败',
        statusCode: 500,
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
      final email = Validator.validateEmail(data['email'], 'email');

      // 调用认证服务
      final result = await _authService.forgotPassword(email);

      if (result.success) {
        return ResponseBuilder.success(message: result.message);
      } else {
        return ResponseBuilder.error(
          code: result.code,
          message: result.message,
          statusCode: 400,
        );
      }
    } catch (error, stackTrace) {
      logger.error('忘记密码失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseBuilder.validationError(
          message: '忘记密码参数验证失败',
          fieldErrors: error.fieldErrors,
        );
      }

      return ResponseBuilder.error(
        code: 'FORGOT_PASSWORD_FAILED',
        message: '请求失败，请稍后重试',
        statusCode: 500,
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
      final token = Validator.validateString(data['token'], 'token');
      final newPassword = Validator.validateString(data['new_password'], 'new_password', minLength: 8);

      // 调用认证服务
      final result = await _authService.resetPassword(token, newPassword);

      if (result.success) {
        return ResponseBuilder.success(message: result.message);
      } else {
        return ResponseBuilder.error(
          code: result.code,
          message: result.message,
          statusCode: 400,
        );
      }
    } catch (error, stackTrace) {
      logger.error('重置密码失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseBuilder.validationError(
          message: '重置密码参数验证失败',
          fieldErrors: error.fieldErrors,
        );
      }

      return ResponseBuilder.error(
        code: 'RESET_PASSWORD_FAILED',
        message: '重置失败，请稍后重试',
        statusCode: 500,
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
      final token = Validator.validateString(data['token'], 'token');

      // 调用认证服务
      final result = await _authService.verifyEmail(token);

      if (result.success) {
        return ResponseBuilder.success(message: result.message);
      } else {
        return ResponseBuilder.error(
          code: result.code,
          message: result.message,
          statusCode: 400,
        );
      }
    } catch (error, stackTrace) {
      logger.error('邮箱验证失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseBuilder.validationError(
          message: '邮箱验证参数验证失败',
          fieldErrors: error.fieldErrors,
        );
      }

      return ResponseBuilder.error(
        code: 'EMAIL_VERIFICATION_FAILED',
        message: '验证失败，请稍后重试',
        statusCode: 500,
      );
    }
  }

  /// 获取当前用户信息
  Future<Response> _getCurrentUser(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseBuilder.error(
          code: 'AUTH_USER_NOT_FOUND',
          message: '用户信息不存在',
          statusCode: 401,
        );
      }

      // 从数据库获取完整的用户信息
      final user = await _authService.getUserById(userId);

      if (user == null) {
        return ResponseBuilder.error(
          code: 'AUTH_USER_NOT_FOUND',
          message: '用户不存在',
          statusCode: 404,
        );
      }

      return ResponseBuilder.success(
        message: '获取用户信息成功',
        data: user,
      );
    } catch (error, stackTrace) {
      logger.error('获取当前用户信息失败', error: error, stackTrace: stackTrace);

      return ResponseBuilder.error(
        code: 'GET_USER_INFO_FAILED',
        message: '获取用户信息失败',
        statusCode: 500,
      );
    }
  }

  /// 获取客户端IP地址
  String? _getClientIp(Request request) {
    // 尝试从X-Forwarded-For头获取真实IP
    final forwardedFor = request.headers['x-forwarded-for'];
    if (forwardedFor != null && forwardedFor.isNotEmpty) {
      return forwardedFor.split(',').first.trim();
    }

    // 尝试从X-Real-IP头获取
    final realIp = request.headers['x-real-ip'];
    if (realIp != null && realIp.isNotEmpty) {
      return realIp;
    }

    // 从连接信息获取
    final connectionInfo = request.context['shelf.io.connection_info'];
    if (connectionInfo != null) {
      return connectionInfo.toString();
    }

    return null;
  }

  /// 重发验证邮件
  Future<Response> _resendVerification(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final email = data['email'] as String?;
      if (email == null || email.isEmpty) {
        return ResponseBuilder.error(
          code: 'VALIDATION_MISSING_EMAIL',
          message: '邮箱地址不能为空',
          statusCode: 400,
        );
      }

      final result = await _authService.resendVerification(email);

      if (result.success) {
        return ResponseBuilder.success(message: result.message);
      } else {
        return ResponseBuilder.error(
          code: result.code,
          message: result.message,
          statusCode: 400,
        );
      }
    } catch (error, stackTrace) {
      logger.error('重发验证邮件失败', error: error, stackTrace: stackTrace);

      return ResponseBuilder.error(
        code: 'RESEND_VERIFICATION_FAILED',
        message: '重发验证邮件失败，请稍后重试',
        statusCode: 500,
      );
    }
  }
}
