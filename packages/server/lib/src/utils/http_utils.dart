import 'dart:io';

/// HTTP工具类
class HttpUtils {
  /// 获取客户端IP地址
  static String getClientIp(HttpRequest request) {
    // 尝试从各种代理头获取真实IP
    final forwarded = request.headers.value('X-Forwarded-For');
    if (forwarded != null && forwarded.isNotEmpty) {
      return forwarded.split(',').first.trim();
    }

    final realIp = request.headers.value('X-Real-IP');
    if (realIp != null && realIp.isNotEmpty) {
      return realIp;
    }

    final cfConnectingIp = request.headers.value('CF-Connecting-IP');
    if (cfConnectingIp != null && cfConnectingIp.isNotEmpty) {
      return cfConnectingIp;
    }

    // 默认使用远程地址
    return request.connectionInfo?.remoteAddress.address ?? 'unknown';
  }

  /// 获取用户代理字符串
  static String getUserAgent(HttpRequest request) {
    return request.headers.value('User-Agent') ?? 'unknown';
  }

  /// 获取请求ID
  static String getRequestId(HttpRequest request) {
    return request.headers.value('X-Request-ID') ?? 'unknown';
  }

  /// 检查是否是移动设备
  static bool isMobile(String userAgent) {
    if (userAgent.isEmpty) return false;

    final mobileKeywords = [
      'Mobile',
      'Android',
      'iPhone',
      'iPad',
      'iPod',
      'BlackBerry',
      'Windows Phone',
      'Opera Mini',
      'IEMobile',
    ];

    return mobileKeywords.any((keyword) => userAgent.toLowerCase().contains(keyword.toLowerCase()));
  }

  /// 检查是否是API请求
  static bool isApiRequest(HttpRequest request) {
    return request.uri.path.startsWith('/api/');
  }

  /// 检查是否是健康检查请求
  static bool isHealthCheck(HttpRequest request) {
    final path = request.uri.path;
    return path == '/health' || path == '/health/db' || path == '/health/ready' || path == '/health/live';
  }

  /// 获取请求内容类型
  static String getContentType(HttpRequest request) {
    return request.headers.contentType?.mimeType ?? 'unknown';
  }

  /// 检查是否是JSON请求
  static bool isJsonRequest(HttpRequest request) {
    final contentType = getContentType(request);
    return contentType.contains('application/json');
  }

  /// 检查是否是表单请求
  static bool isFormRequest(HttpRequest request) {
    final contentType = getContentType(request);
    return contentType.contains('application/x-www-form-urlencoded') || contentType.contains('multipart/form-data');
  }

  /// 获取请求方法
  static String getMethod(HttpRequest request) {
    return request.method;
  }

  /// 获取请求路径
  static String getPath(HttpRequest request) {
    return request.uri.path;
  }

  /// 获取查询参数
  static String? getQueryParam(HttpRequest request, String key) {
    return request.uri.queryParameters[key];
  }

  /// 获取所有查询参数
  static Map<String, String> getQueryParameters(HttpRequest request) {
    return request.uri.queryParameters;
  }

  /// 获取请求头
  static String? getHeader(HttpRequest request, String key) {
    return request.headers.value(key);
  }

  /// 检查请求头是否存在
  static bool hasHeader(HttpRequest request, String key) {
    return request.headers[key] != null;
  }

  /// 获取请求大小
  static int getContentLength(HttpRequest request) {
    return request.headers.contentLength ?? 0;
  }

  /// 格式化HTTP状态码描述
  static String getStatusMessage(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'OK';
      case 201:
        return 'Created';
      case 204:
        return 'No Content';
      case 400:
        return 'Bad Request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not Found';
      case 405:
        return 'Method Not Allowed';
      case 409:
        return 'Conflict';
      case 422:
        return 'Unprocessable Entity';
      case 429:
        return 'Too Many Requests';
      case 500:
        return 'Internal Server Error';
      case 502:
        return 'Bad Gateway';
      case 503:
        return 'Service Unavailable';
      case 504:
        return 'Gateway Timeout';
      default:
        return 'Unknown Status';
    }
  }

  /// 检查是否是成功的状态码
  static bool isSuccessStatus(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  /// 检查是否是客户端错误状态码
  static bool isClientErrorStatus(int statusCode) {
    return statusCode >= 400 && statusCode < 500;
  }

  /// 检查是否是服务器错误状态码
  static bool isServerErrorStatus(int statusCode) {
    return statusCode >= 500 && statusCode < 600;
  }

  /// 构建完整的URL
  static String buildUrl(String baseUrl, String path, Map<String, String>? queryParams) {
    var url = baseUrl;
    if (!url.endsWith('/')) url += '/';
    if (path.startsWith('/')) path = path.substring(1);
    url += path;

    if (queryParams != null && queryParams.isNotEmpty) {
      final queryString = queryParams.entries
          .map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
          .join('&');
      url += '?$queryString';
    }

    return url;
  }

  /// 解析Accept-Language头
  static List<String> parseAcceptLanguage(String? acceptLanguage) {
    if (acceptLanguage == null || acceptLanguage.isEmpty) {
      return ['en'];
    }

    return acceptLanguage
        .split(',')
        .map((lang) => lang.split(';').first.trim().split('-').first)
        .where((lang) => lang.isNotEmpty)
        .toList();
  }

  /// 获取客户端语言偏好
  static String getPreferredLanguage(HttpRequest request) {
    final acceptLanguage = request.headers.value('Accept-Language');
    final languages = parseAcceptLanguage(acceptLanguage);
    return languages.isNotEmpty ? languages.first : 'en';
  }

  /// 检查是否是预检请求（OPTIONS）
  static bool isPreflightRequest(HttpRequest request) {
    return request.method == 'OPTIONS';
  }

  /// 检查是否是CORS请求
  static bool isCorsRequest(HttpRequest request) {
    return hasHeader(request, 'Origin');
  }

  /// 获取CORS Origin
  static String? getCorsOrigin(HttpRequest request) {
    return getHeader(request, 'Origin');
  }
}
