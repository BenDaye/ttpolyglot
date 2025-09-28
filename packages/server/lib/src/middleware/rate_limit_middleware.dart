import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

import '../config/server_config.dart';
import '../services/redis_service.dart';
import '../utils/structured_logger.dart';

/// 速率限制中间件
class RateLimitMiddleware {
  static final _logger = LoggerFactory.getLogger('RateLimitMiddleware');
  final RedisService _redisService;
  final ServerConfig _config;

  RateLimitMiddleware(this._redisService, this._config);

  /// 创建中间件处理器
  Middleware get handler => (Handler innerHandler) {
        return (Request request) async {
          // 跳过健康检查端点的速率限制
          if (request.requestedUri.path.startsWith('/health')) {
            return await innerHandler(request);
          }

          try {
            // 获取客户端标识（IP地址或用户ID）
            final clientId = _getClientId(request);

            // 检查速率限制
            final isAllowed = await _checkRateLimit(clientId);

            if (!isAllowed) {
              return _rateLimitExceededResponse(request);
            }

            // 继续处理请求
            final response = await innerHandler(request);

            // 在响应头中添加速率限制信息
            return _addRateLimitHeaders(response, clientId);
          } catch (error, stackTrace) {
            _logger.error('速率限制检查失败', error: error, stackTrace: stackTrace);

            // 如果速率限制检查失败，允许请求通过
            return await innerHandler(request);
          }
        };
      };

  /// 获取客户端标识
  String _getClientId(Request request) {
    // 优先使用用户ID（如果已认证）
    final userId = request.context['user_id'] as String?;
    if (userId != null) {
      return 'user:$userId';
    }

    // 使用IP地址作为标识
    final forwarded = request.headers['x-forwarded-for'];
    final realIp = request.headers['x-real-ip'];
    final connectionInfo = request.context['shelf.io.connection_info'] as HttpConnectionInfo?;
    final remoteAddress = connectionInfo?.remoteAddress.address;

    final clientIp = forwarded?.split(',').first.trim() ?? realIp ?? remoteAddress ?? 'unknown';

    return 'ip:$clientIp';
  }

  /// 检查速率限制
  Future<bool> _checkRateLimit(String clientId) async {
    final now = DateTime.now();
    final windowStart = now.subtract(Duration(minutes: _config.rateLimitWindowMinutes));
    final windowKey =
        'rate_limit:$clientId:${windowStart.millisecondsSinceEpoch ~/ (1000 * 60 * _config.rateLimitWindowMinutes)}';

    try {
      // 获取当前窗口的请求计数
      final currentCount = await _redisService.get(windowKey);
      final count = int.tryParse(currentCount ?? '0') ?? 0;

      // 检查是否超出限制
      if (count >= _config.rateLimitRequests) {
        return false;
      }

      // 增加计数
      await _redisService.increment(windowKey);

      // 设置过期时间
      await _redisService.expire(windowKey, _config.rateLimitWindowMinutes * 60);

      return true;
    } catch (error) {
      _logger.warn('速率限制Redis操作失败',
          error: error, context: LogContext().field('client_id', clientId).field('window_key', windowKey));
      // 如果Redis操作失败，允许请求通过
      return true;
    }
  }

  /// 获取速率限制信息
  Future<Map<String, int>> _getRateLimitInfo(String clientId) async {
    final now = DateTime.now();
    final windowStart = now.subtract(Duration(minutes: _config.rateLimitWindowMinutes));
    final windowKey =
        'rate_limit:$clientId:${windowStart.millisecondsSinceEpoch ~/ (1000 * 60 * _config.rateLimitWindowMinutes)}';

    try {
      final currentCount = await _redisService.get(windowKey);
      final count = int.tryParse(currentCount ?? '0') ?? 0;
      final remaining = (_config.rateLimitRequests - count).clamp(0, _config.rateLimitRequests);
      final resetTime = windowStart.add(Duration(minutes: _config.rateLimitWindowMinutes));

      return {
        'limit': _config.rateLimitRequests,
        'remaining': remaining,
        'resetTime': resetTime.millisecondsSinceEpoch ~/ 1000,
      };
    } catch (error) {
      return {
        'limit': _config.rateLimitRequests,
        'remaining': _config.rateLimitRequests,
        'resetTime': now.add(Duration(minutes: _config.rateLimitWindowMinutes)).millisecondsSinceEpoch ~/ 1000,
      };
    }
  }

  /// 添加速率限制响应头
  Future<Response> _addRateLimitHeaders(Response response, String clientId) async {
    try {
      final rateLimitInfo = await _getRateLimitInfo(clientId);

      return response.change(headers: {
        ...response.headers,
        'X-RateLimit-Limit': rateLimitInfo['limit'].toString(),
        'X-RateLimit-Remaining': rateLimitInfo['remaining'].toString(),
        'X-RateLimit-Reset': rateLimitInfo['resetTime'].toString(),
      });
    } catch (error) {
      return response;
    }
  }

  /// 速率限制超出响应
  Response _rateLimitExceededResponse(Request request) {
    final requestId = request.context['request_id'] ?? 'unknown';

    final errorResponse = {
      'error': {
        'code': 'SYSTEM_RATE_LIMIT_EXCEEDED',
        'message': '请求频率过高',
        'details': '您在${_config.rateLimitWindowMinutes}分钟内的请求次数已达上限，请稍后重试',
        'metadata': {
          'request_id': requestId,
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'limit': _config.rateLimitRequests,
          'window_minutes': _config.rateLimitWindowMinutes,
        }
      }
    };

    return Response(
      429,
      headers: {
        'Content-Type': 'application/json',
        'X-Request-ID': requestId,
        'Retry-After': (_config.rateLimitWindowMinutes * 60).toString(),
      },
      body: jsonEncode(errorResponse),
    );
  }
}
