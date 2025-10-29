import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';

/// 结构化日志中间件
Middleware structuredLoggingMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      // 构建请求数据信息
      final requestData = <String, dynamic>{
        'method': request.method,
        // 'path': request.url.path,
        'query_params': request.url.queryParameters,
        'request_id': request.context['request_id'],
      };

      // 只对POST/PUT/PATCH请求读取请求体（避免消耗GET请求的性能）
      if (['POST', 'PUT', 'PATCH'].contains(request.method)) {
        try {
          // 读取请求体
          final body = await request.readAsString();

          // 尝试解析为JSON（如果失败则记录原始字符串）
          try {
            requestData['body'] = jsonDecode(body);
          } catch (_) {
            requestData['body'] = body;
          }

          // 重要：由于请求体只能读取一次，需要创建新的请求对象传递给下一个处理器
          request = request.change(body: body);
        } catch (error) {
          ServerLogger.warning('读取请求体失败', error: {'error': error.toString()}, name: 'structuredLoggingMiddleware');
        }
      }

      // 记录请求开始
      ServerLogger.info(
        '收到请求 path: ${request.url.path}',
        error: requestData,
        name: 'structuredLoggingMiddleware',
      );

      try {
        // 处理请求
        final response = await handler(request);

        // // 读取响应体用于日志记录
        // dynamic responseData;
        // String? responseBody;

        // try {
        //   // 读取响应体
        //   responseBody = await response.readAsString();

        //   // 尝试解析为JSON
        //   try {
        //     responseData = jsonDecode(responseBody);
        //   } catch (_) {
        //     responseData = responseBody;
        //   }
        // } catch (error) {
        //   ServerLogger.warning(
        //     '读取响应体失败',
        //     error: {'error': error.toString()},
        //     name: 'structuredLoggingMiddleware',
        //   );
        // }

        ServerLogger.info(
          '请求完成 path: ${request.url.path}',
          error: {
            'http_status': response.statusCode,
            'request_id': request.context['request_id'],
            // 'response_data': responseData,
            // 'response_headers': response.headers,
          },
          name: 'structuredLoggingMiddleware',
        );

        // 重要：由于响应体只能读取一次，需要创建新的响应对象返回
        // return response.change(body: responseBody ?? '');

        return response;
      } catch (error, stackTrace) {
        ServerLogger.error(
          '请求失败',
          error: error,
          stackTrace: stackTrace,
          name: 'structuredLoggingMiddleware',
        );
        rethrow;
      }
    };
  };
}
