import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:ttpolyglot/src/common/config/app_config.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

final class LoadingInterceptor extends Interceptor {
  CancelFunc? _loadingHideFunc; // 改为私有变量
  Timer? _loadingTimer; // 新增：延迟显示Loading的定时器

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final extra = RequestExtraModel.fromJson(options.extra);
    _cancelLoading();
    //
    if (extra.showLoading == true) {
      _loadingHideFunc = Toast.showLoading();
    } else if (extra.showLazyLoading == true) {
      // 设置5秒延迟的定时器
      _loadingTimer = Timer(AppConfig.requestLazyTimeout, () {
        // 如果5秒后请求仍未完成，显示Loading
        _loadingHideFunc = Toast.showLoading();
      });
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cancelLoading(); // 请求完成时清理Loading和定时器
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _cancelLoading(); // 请求失败时清理Loading和定时器
    super.onError(err, handler);
  }

  // 私有方法：取消定时器和Loading
  void _cancelLoading() {
    _loadingTimer?.cancel(); // 取消定时器（如果存在）
    _loadingTimer = null;
    _loadingHideFunc?.call(); // 隐藏Loading（如果已显示）
    _loadingHideFunc = null;
  }
}
