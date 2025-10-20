enum ApiResponseCode {
  // dio默认错误码
  cancelRequest(3, '取消请求'),
  domainError(4, '域名错误'),
  networkError(5, '网络错误'),
  sendTimeout(6, '发送超时'),
  connectionTimeout(7, '连接超时'),
  receiveTimeout(8, '证书过期'),
  badCertificate(9, '接收超时'),

  // 业务自定义错误码
  unknown(-10000, '未知错误'),
  validationError(-10001, '验证失败'),
  authenticationError(-10002, '认证失败'),
  authorizationError(-10003, '授权失败'),
  dataNotFound(-10004, '数据不存在'),
  businessError(-10005, '业务错误'),
  databaseError(-10006, '数据库错误'),
  cacheError(-10007, '缓存错误'),
  externalServiceError(-10008, '外部服务错误'),
  rateLimitError(-10009, '速率限制错误'),
  conflictError(-10010, '冲突错误'),
  fileUploadError(-10011, '文件上传错误'),
  internalServerError(-10012, '服务器内部错误'),
  serviceUnavailable(-10013, '服务不可用'),
  notFound(-10014, '资源不存在'),
  noContent(-10015, '无内容'),
  error(-1, '错误'),
  success(0, '成功');

  final int value;
  final String message;

  const ApiResponseCode(this.value, this.message);

  /// 是否成功
  bool get isSuccess => value == 0;

  /// 根据值获取对应的枚举
  static ApiResponseCode fromValue(int value) {
    return ApiResponseCode.values.firstWhere(
      (code) => code.value == value,
      orElse: () => ApiResponseCode.unknown,
    );
  }
}

/// 将 int 转换为 ApiResponseCode
ApiResponseCode apiResponseCodeFromJson(int value) => ApiResponseCode.fromValue(value);

/// 将 ApiResponseCode 转换为 int
int apiResponseCodeToJson(ApiResponseCode code) => code.value;
