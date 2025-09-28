import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../config/server_config.dart';
import 'structured_logger.dart';

/// JWT 工具类
class JwtUtils {
  static final _logger = LoggerFactory.getLogger('JwtUtils');
  final ServerConfig _config;

  JwtUtils(this._config);

  /// 生成访问令牌
  String generateAccessToken(Map<String, dynamic> payload) {
    try {
      final jwt = JWT({
        ...payload,
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'exp': DateTime.now().add(Duration(hours: _config.jwtExpireHours)).millisecondsSinceEpoch ~/ 1000,
        'iss': 'ttpolyglot-server',
        'aud': 'ttpolyglot-client',
        'type': 'access',
      });

      return jwt.sign(SecretKey(_config.jwtSecret));
    } catch (error, stackTrace) {
      _logger.error('生成访问令牌失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 生成刷新令牌
  String generateRefreshToken(Map<String, dynamic> payload) {
    try {
      final jwt = JWT({
        ...payload,
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'exp': DateTime.now().add(Duration(days: _config.jwtRefreshExpireDays)).millisecondsSinceEpoch ~/ 1000,
        'iss': 'ttpolyglot-server',
        'aud': 'ttpolyglot-client',
        'type': 'refresh',
      });

      return jwt.sign(SecretKey(_config.jwtSecret));
    } catch (error, stackTrace) {
      _logger.error('生成刷新令牌失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 验证JWT令牌
  Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_config.jwtSecret));

      // 检查令牌类型
      final payload = jwt.payload as Map<String, dynamic>;

      // 检查必要字段
      if (!payload.containsKey('user_id') || !payload.containsKey('exp')) {
        _logger.warn('JWT令牌缺少必要字段');
        return null;
      }

      // 检查过期时间
      final exp = payload['exp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (exp <= now) {
        _logger.warn('JWT令牌已过期');
        return null;
      }

      return payload;
    } on JWTExpiredException {
      _logger.warn('JWT令牌已过期');
      return null;
    } on JWTException catch (error) {
      _logger.warn('JWT验证失败', error: error);
      return null;
    } catch (error, stackTrace) {
      _logger.error('JWT验证出错', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 从令牌中提取用户ID
  String? extractUserId(String token) {
    final payload = verifyToken(token);
    return payload?['user_id'] as String?;
  }

  /// 检查令牌是否为访问令牌
  bool isAccessToken(String token) {
    final payload = verifyToken(token);
    return payload?['type'] == 'access';
  }

  /// 检查令牌是否为刷新令牌
  bool isRefreshToken(String token) {
    final payload = verifyToken(token);
    return payload?['type'] == 'refresh';
  }

  /// 生成令牌哈希值（用于存储和撤销）
  String generateTokenHash(String token) {
    final bytes = utf8.encode(token);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// 从Authorization头中提取Bearer令牌
  String? extractBearerToken(String? authHeader) {
    if (authHeader == null || !authHeader.startsWith('Bearer ')) {
      return null;
    }

    return authHeader.substring('Bearer '.length).trim();
  }

  /// 生成用于密码重置的临时令牌
  String generatePasswordResetToken(String userId, String email) {
    try {
      final jwt = JWT({
        'user_id': userId,
        'email': email,
        'purpose': 'password_reset',
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'exp': DateTime.now().add(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
        'iss': 'ttpolyglot-server',
      });

      return jwt.sign(SecretKey(_config.jwtSecret));
    } catch (error, stackTrace) {
      _logger.error('生成密码重置令牌失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 验证密码重置令牌
  Map<String, dynamic>? verifyPasswordResetToken(String token) {
    try {
      final payload = verifyToken(token);

      if (payload == null) {
        return null;
      }

      // 检查令牌用途
      if (payload['purpose'] != 'password_reset') {
        _logger.warn('无效的密码重置令牌用途');
        return null;
      }

      return payload;
    } catch (error, stackTrace) {
      _logger.error('验证密码重置令牌失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 生成邮箱验证令牌
  String generateEmailVerificationToken(String userId, String email) {
    try {
      final jwt = JWT({
        'user_id': userId,
        'email': email,
        'purpose': 'email_verification',
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
        'iss': 'ttpolyglot-server',
      });

      return jwt.sign(SecretKey(_config.jwtSecret));
    } catch (error, stackTrace) {
      _logger.error('生成邮箱验证令牌失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 验证邮箱验证令牌
  Map<String, dynamic>? verifyEmailVerificationToken(String token) {
    try {
      final payload = verifyToken(token);

      if (payload == null) {
        return null;
      }

      // 检查令牌用途
      if (payload['purpose'] != 'email_verification') {
        _logger.warn('无效的邮箱验证令牌用途');
        return null;
      }

      return payload;
    } catch (error, stackTrace) {
      _logger.error('验证邮箱验证令牌失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }

  /// 获取令牌的剩余有效时间（秒）
  int? getTokenRemainingTime(String token) {
    final payload = verifyToken(token);
    if (payload == null) {
      return null;
    }

    final exp = payload['exp'] as int;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final remaining = exp - now;

    return remaining > 0 ? remaining : 0;
  }
}
