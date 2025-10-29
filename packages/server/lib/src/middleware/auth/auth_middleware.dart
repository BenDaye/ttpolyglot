import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

/// 认证中间件
class AuthMiddleware {
  final AuthService _authService;
  final JwtUtils _jwtUtils;
  final RedisService _redisService;

  // 令牌缓存，避免重复验证
  final Map<String, Map<String, dynamic>> _tokenCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheExpiry = Duration(minutes: 5);

  AuthMiddleware({
    required AuthService authService,
    required JwtUtils jwtUtils,
    required RedisService redisService,
  })  : _authService = authService,
        _jwtUtils = jwtUtils,
        _redisService = redisService;

  /// 创建认证中间件
  Middleware call() {
    return (Handler handler) {
      return (Request request) async {
        try {
          // 获取Authorization头
          final authHeader = request.headers['authorization'];
          if (authHeader == null) {
            return ResponseUtils.error(message: '认证令牌缺失', code: DataCodeEnum.unauthorized);
          }

          // 提取Bearer令牌
          final token = _jwtUtils.extractBearerToken(authHeader);
          if (token == null) {
            return ResponseUtils.error(message: '无效的认证令牌格式', code: DataCodeEnum.unauthorized);
          }

          // 检查令牌黑名单
          if (await _isTokenBlacklisted(token)) {
            return ResponseUtils.error(message: '令牌已被撤销', code: DataCodeEnum.unauthorized);
          }

          // 验证令牌（带缓存优化）
          final payload = await _verifyTokenWithCache(token);
          if (payload == null) {
            return ResponseUtils.error(message: '令牌验证失败', code: DataCodeEnum.unauthorized);
          }

          // 将用户信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'user_id': payload['user_id'],
            'username': payload['username'],
            'email': payload['email'],
            'is_authenticated': true,
            'auth_token': token,
            'token_verified_at': DateTime.now().toIso8601String(),
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          ServerLogger.error('认证中间件错误', error: error, stackTrace: stackTrace);

          return ResponseUtils.error(message: '认证失败', code: DataCodeEnum.unauthorized);
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

          // 检查令牌黑名单
          if (await _isTokenBlacklisted(token)) {
            // 令牌被撤销，继续处理但标记为未认证
            final updatedRequest = request.change(context: {
              ...request.context,
              'is_authenticated': false,
            });
            return await handler(updatedRequest);
          }

          // 验证令牌（带缓存优化）
          final payload = await _verifyTokenWithCache(token);
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
            'token_verified_at': DateTime.now().toIso8601String(),
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          ServerLogger.error('可选认证中间件错误', error: error, stackTrace: stackTrace);

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

        // 检查用户是否为管理员
        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '用户信息缺失', code: DataCodeEnum.unauthorized);
        }

        final isAdmin = await _checkUserIsAdmin(userId);
        if (!isAdmin) {
          return ResponseUtils.error(message: '需要管理员权限', code: DataCodeEnum.unauthorized);
        }

        return authResult;
      };
    };
  }

  /// 权限检查中间件
  Middleware requirePermission(String permission, {String? projectId}) {
    return (Handler handler) {
      return (Request request) async {
        // 先进行普通认证
        final authResult = await call()(handler)(request);

        // 如果认证失败，直接返回
        if (authResult.statusCode != 200) {
          return authResult;
        }

        // 检查用户权限
        final userId = getCurrentUserId(request);
        if (userId == null) {
          return ResponseUtils.error(message: '用户信息缺失', code: DataCodeEnum.unauthorized);
        }

        // 这里需要注入PermissionService，暂时简化处理
        // final hasPermission = await _permissionService.checkUserPermission(
        //   userId: userId,
        //   permission: permission,
        //   projectId: projectId,
        // );

        // if (!hasPermission) {
        //   return ResponseUtils.error(message: '权限不足', code: DataCodeEnum.unauthorized);
        // }

        return authResult;
      };
    };
  }

  /// 检查令牌是否在黑名单中
  Future<bool> _isTokenBlacklisted(String token) async {
    try {
      final tokenHash = _jwtUtils.generateTokenHash(token);
      final blacklistKey = 'token_blacklist:$tokenHash';
      final isBlacklisted = await _redisService.get(blacklistKey);
      return isBlacklisted != null;
    } catch (error) {
      ServerLogger.error('检查令牌黑名单失败', error: error);
      return false; // 出错时允许通过，避免误杀
    }
  }

  /// 带缓存的令牌验证
  Future<Map<String, dynamic>?> _verifyTokenWithCache(String token) async {
    try {
      final tokenHash = _jwtUtils.generateTokenHash(token);
      final now = DateTime.now();

      // 检查内存缓存
      if (_tokenCache.containsKey(tokenHash)) {
        final cacheTime = _cacheTimestamps[tokenHash];
        if (cacheTime != null && now.difference(cacheTime) < _cacheExpiry) {
          return _tokenCache[tokenHash];
        } else {
          // 缓存过期，清理
          _tokenCache.remove(tokenHash);
          _cacheTimestamps.remove(tokenHash);
        }
      }

      // 验证令牌
      final payload = await _authService.verifyAccessToken(token);
      if (payload != null) {
        // 缓存结果
        _tokenCache[tokenHash] = payload;
        _cacheTimestamps[tokenHash] = now;

        // 清理过期缓存
        _cleanExpiredCache();
      }

      return payload;
    } catch (error) {
      ServerLogger.error('令牌验证失败', error: error);
      return null;
    }
  }

  /// 检查用户是否为管理员
  Future<bool> _checkUserIsAdmin(String userId) async {
    try {
      // 这里需要注入PermissionService，暂时简化处理
      // return await _permissionService.isSuperAdmin(userId);
      return false; // 暂时返回false，需要后续实现
    } catch (error) {
      ServerLogger.error('检查管理员权限失败', error: error);
      return false;
    }
  }

  /// 清理过期缓存
  void _cleanExpiredCache() {
    final now = DateTime.now();
    final expiredKeys = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) >= _cacheExpiry) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      _tokenCache.remove(key);
      _cacheTimestamps.remove(key);
    }
  }

  /// 撤销令牌（添加到黑名单）
  Future<void> revokeToken(String token) async {
    try {
      final tokenHash = _jwtUtils.generateTokenHash(token);
      final blacklistKey = 'token_blacklist:$tokenHash';

      // 添加到Redis黑名单，24小时过期
      await _redisService.set(blacklistKey, 'true', 86400); // 24小时 = 86400秒

      // 从本地缓存中移除
      _tokenCache.remove(tokenHash);
      _cacheTimestamps.remove(tokenHash);

      ServerLogger.info('令牌已撤销: $tokenHash');
    } catch (error) {
      ServerLogger.error('撤销令牌失败', error: error);
    }
  }

  /// 清理所有缓存
  void clearCache() {
    _tokenCache.clear();
    _cacheTimestamps.clear();
    ServerLogger.info('认证缓存已清理');
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
