import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';

import '../services/auth_service.dart';
import '../utils/jwt_utils.dart';

/// 认证中间件
class AuthMiddleware {
  final AuthService _authService;
  final JwtUtils _jwtUtils;

  AuthMiddleware({
    required AuthService authService,
    required JwtUtils jwtUtils,
  })  : _authService = authService,
        _jwtUtils = jwtUtils;

  /// 创建认证中间件
  Middleware call() {
    return (Handler handler) {
      return (Request request) async {
        try {
          // 获取Authorization头
          final authHeader = request.headers['authorization'];
          if (authHeader == null) {
            return _unauthorized('认证令牌缺失');
          }

          // 提取Bearer令牌
          final token = _jwtUtils.extractBearerToken(authHeader);
          if (token == null) {
            return _unauthorized('无效的认证令牌格式');
          }

          // 验证令牌
          final payload = await _authService.verifyAccessToken(token);
          if (payload == null) {
            return _unauthorized('令牌验证失败');
          }

          // 将用户信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'user_id': payload['user_id'],
            'username': payload['username'],
            'email': payload['email'],
            'is_authenticated': true,
            'auth_token': token,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          log('认证中间件错误', error: error, stackTrace: stackTrace, name: 'AuthMiddleware');

          return _unauthorized('认证失败');
        }
      };
    };
  }

  /// 可选认证中间件（不强制要求认证）
  Middleware optional() {
    return (Handler handler) {
      return (Request request) async {
        try {
          // 获取Authorization头
          final authHeader = request.headers['authorization'];
          if (authHeader == null) {
            // 没有认证头，继续处理但标记为未认证
            final updatedRequest = request.change(context: {
              ...request.context,
              'is_authenticated': false,
            });
            return await handler(updatedRequest);
          }

          // 提取Bearer令牌
          final token = _jwtUtils.extractBearerToken(authHeader);
          if (token == null) {
            // 无效格式，继续处理但标记为未认证
            final updatedRequest = request.change(context: {
              ...request.context,
              'is_authenticated': false,
            });
            return await handler(updatedRequest);
          }

          // 验证令牌
          final payload = await _authService.verifyAccessToken(token);
          if (payload == null) {
            // 验证失败，继续处理但标记为未认证
            final updatedRequest = request.change(context: {
              ...request.context,
              'is_authenticated': false,
            });
            return await handler(updatedRequest);
          }

          // 验证成功，添加用户信息到上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'user_id': payload['user_id'],
            'username': payload['username'],
            'email': payload['email'],
            'is_authenticated': true,
            'auth_token': token,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          log('可选认证中间件错误', error: error, stackTrace: stackTrace, name: 'AuthMiddleware');

          // 出错时标记为未认证，继续处理
          final updatedRequest = request.change(context: {
            ...request.context,
            'is_authenticated': false,
          });
          return await handler(updatedRequest);
        }
      };
    };
  }

  /// 管理员认证中间件
  Middleware admin() {
    return (Handler handler) {
      return (Request request) async {
        // 先进行普通认证
        final authResult = await call()(handler)(request);

        // 如果认证失败，直接返回
        if (authResult.statusCode != 200) {
          return authResult;
        }

        // TODO: 检查用户是否为管理员
        // 这里需要查询用户角色，暂时简化处理

        return authResult;
      };
    };
  }

  /// 返回未授权响应
  Response _unauthorized(String message) {
    final errorResponse = {
      'error': {
        'code': 'AUTH_TOKEN_INVALID',
        'message': message,
        'metadata': {
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
      },
    };

    return Response(
      401,
      headers: {
        'Content-Type': 'application/json',
        'WWW-Authenticate': 'Bearer realm="TTPolyglot API"',
      },
      body: jsonEncode(errorResponse),
    );
  }
}

/// 从请求上下文中获取当前用户ID
String? getCurrentUserId(Request request) {
  return request.context['user_id'] as String?;
}

/// 从请求上下文中获取当前用户名
String? getCurrentUsername(Request request) {
  return request.context['username'] as String?;
}

/// 从请求上下文中获取当前用户邮箱
String? getCurrentUserEmail(Request request) {
  return request.context['email'] as String?;
}

/// 检查用户是否已认证
bool isAuthenticated(Request request) {
  return request.context['is_authenticated'] == true;
}

/// 获取认证令牌
String? getAuthToken(Request request) {
  return request.context['auth_token'] as String?;
}
