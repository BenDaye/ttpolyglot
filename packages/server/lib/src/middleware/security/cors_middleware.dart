import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

/// CORS中间件
Middleware corsMiddleware({
  required List<String> allowedOrigins,
  List<String> allowedMethods = const ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  List<String> allowedHeaders = const [
    'Content-Type',
    'Authorization',
    'X-Requested-With',
    'Accept',
    'Origin',
  ],
  bool allowCredentials = true,
  int maxAge = 86400, // 24 hours
}) {
  return (Handler handler) {
    return (Request request) async {
      // 如果是OPTIONS预检请求，直接处理CORS
      if (request.method == 'OPTIONS') {
        final origin = request.headers['origin'];
        final isAllowedOrigin =
            origin == null || origin == '*' || allowedOrigins.contains('*') || allowedOrigins.contains(origin);

        if (isAllowedOrigin) {
          return Response(200, headers: {
            'Access-Control-Allow-Origin': origin ?? '*',
            'Access-Control-Allow-Methods': allowedMethods.join(', '),
            'Access-Control-Allow-Headers': allowedHeaders.join(', '),
            'Access-Control-Max-Age': maxAge.toString(),
            if (allowCredentials) 'Access-Control-Allow-Credentials': 'true',
          });
        }
      }

      // 处理实际请求
      final response = await handler(request);

      // 添加CORS头
      final origin = request.headers['origin'];
      final isAllowedOrigin =
          origin == null || origin == '*' || allowedOrigins.contains('*') || allowedOrigins.contains(origin);

      if (isAllowedOrigin) {
        final headers = <String, String>{
          ...response.headers,
          'Access-Control-Allow-Origin': origin ?? '*',
          'Access-Control-Allow-Methods': allowedMethods.join(', '),
          'Access-Control-Allow-Headers': allowedHeaders.join(', '),
          if (allowCredentials) 'Access-Control-Allow-Credentials': 'true',
        };

        return response.change(headers: headers);
      }

      return response;
    };
  };
}

/// 简单的CORS中间件（使用shelf_cors_headers包）
Middleware simpleCorsMiddleware({
  required List<String> origins,
  bool allowCredentials = true,
}) {
  return corsHeaders(
    headers: {
      ACCESS_CONTROL_ALLOW_ORIGIN: origins.join(','),
      ACCESS_CONTROL_ALLOW_METHODS: 'GET, POST, PUT, DELETE, OPTIONS',
      ACCESS_CONTROL_ALLOW_HEADERS: 'Origin, Content-Type, Authorization, X-Request-ID',
      ACCESS_CONTROL_ALLOW_CREDENTIALS: allowCredentials.toString(),
      ACCESS_CONTROL_MAX_AGE: '86400',
    },
  );
}
