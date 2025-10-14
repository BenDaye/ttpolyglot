import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/config/config.dart';
import 'package:ttpolyglot/src/common/network/interceptors/error_interceptor.dart';
import 'package:ttpolyglot/src/common/network/interceptors/loading_interceptor.dart';
import 'package:ttpolyglot/src/common/network/interceptors/response_interceptor.dart';
import 'package:ttpolyglot/src/common/network/interceptors/token_interceptor.dart';
import 'package:ttpolyglot/src/common/network/models/network_models.dart';
import 'package:ttpolyglot_core/core.dart';

/// HTTP 客户端（单例）
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final Dio _dio;

  factory HttpClient() => _instance;

  HttpClient._internal() {
    // 初始化 Dio
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    // 注册拦截器（顺序很重要！）
    _dio.interceptors.add(LoadingInterceptor()); // Loading 状态
    _dio.interceptors.add(TokenInterceptor()); // Token 注入
    _dio.interceptors.add(Logger.talkerDioLogger); // 日志记录
    _dio.interceptors.add(ResponseInterceptor()); // 响应处理
    _dio.interceptors.add(ErrorInterceptor()); // 错误处理
  }

  /// 获取 Dio 实例
  static Dio get dio => _instance._dio;

  /// 修改 BaseUrl
  static void changeBaseUrl(String url) {
    _instance._dio.options.baseUrl = url;
  }

  /// 重置 BaseUrl
  static void resetBaseUrl() {
    _instance._dio.options.baseUrl = AppConfig.apiBaseUrl;
  }

  /// GET 请求
  static Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Duration? delay,
  }) {
    return _fetch<T>(
      delay,
      RequestExtra.fromJson(options?.extra ?? {}),
      dio.get<dynamic>(
        path,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// POST 请求
  static Future<ApiResponse<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Duration? delay,
  }) {
    return _fetch<T>(
      delay,
      RequestExtra.fromJson(options?.extra ?? {}),
      dio.post<dynamic>(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// PUT 请求
  static Future<ApiResponse<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Duration? delay,
  }) {
    return _fetch<T>(
      delay,
      RequestExtra.fromJson(options?.extra ?? {}),
      dio.put<dynamic>(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      ),
    );
  }

  /// DELETE 请求
  static Future<ApiResponse<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
    CancelToken? cancelToken,
    Duration? delay,
  }) {
    return _fetch<T>(
      delay,
      RequestExtra.fromJson(options?.extra ?? {}),
      dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: query,
        options: options,
        cancelToken: cancelToken,
      ),
    );
  }

  /// 统一请求处理
  static Future<ApiResponse<T>> _fetch<T>(
    Duration? delay,
    RequestExtra extra,
    Future<Response<dynamic>> future,
  ) {
    final start = DateTime.now().millisecondsSinceEpoch;

    return future.then<ApiResponse<T>>((response) async {
      final current = DateTime.now().millisecondsSinceEpoch - start;

      // 如果设置了延时，并且当前请求时间小于阈值，则等待剩余时间
      if (delay != null && current < AppConfig.requestTimeThreshold) {
        await Future.delayed(
          Duration(milliseconds: AppConfig.requestTimeThreshold - current),
        );
      }

      return response.data as ApiResponse<T>;
    }).catchError((err) {
      throw err;
    });
  }
}
