/// 请求额外配置类
class RequestExtra {
  /// 是否显示 loading
  final bool showLoading;

  /// 是否延迟显示 loading（避免闪烁）
  final bool showLazyLoading;

  /// 是否显示成功提示
  final bool showSuccessToast;

  /// 是否显示失败提示
  final bool showErrorToast;

  const RequestExtra({
    this.showLoading = false,
    this.showLazyLoading = true,
    this.showSuccessToast = false,
    this.showErrorToast = true,
  });

  /// 转换为 JSON（用于 Dio Options.extra）
  Map<String, dynamic> toJson() {
    return {
      'showLoading': showLoading,
      'showLazyLoading': showLazyLoading,
      'showSuccessToast': showSuccessToast,
      'showErrorToast': showErrorToast,
    };
  }

  /// 从 JSON 创建
  factory RequestExtra.fromJson(Map<String, dynamic> json) {
    return RequestExtra(
      showLoading: json['showLoading'] as bool? ?? false,
      showLazyLoading: json['showLazyLoading'] as bool? ?? true,
      showSuccessToast: json['showSuccessToast'] as bool? ?? false,
      showErrorToast: json['showErrorToast'] as bool? ?? true,
    );
  }
}
