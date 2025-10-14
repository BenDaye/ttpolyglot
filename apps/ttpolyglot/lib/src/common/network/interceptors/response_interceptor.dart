import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/network/models/network_models.dart';
import 'package:ttpolyglot_core/core.dart';

/// 响应统一处理拦截器
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      final result = ApiResponse.fromJson(response.data, (json) => json);
      if (result.code.isSuccess) {
        response.data = result;
        response.statusMessage = result.message;
        // 业务正常 & 请求正常
        return handler.resolve(response);
      }

      // 业务异常（请求是正常的）
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: result,
          message: result.message,
        ),
      );
    } catch (error, stackTrace) {
      Logger.error(
        'ResponseInterceptor',
        error: error,
        stackTrace: stackTrace,
      );
      // 基础数据解析异常
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: error,
          message: '基础数据解析异常',
        ),
      );
    }
  }
}
