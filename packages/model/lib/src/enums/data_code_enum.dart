import 'package:freezed_annotation/freezed_annotation.dart';

enum DataCodeEnum {
  // 业务自定义错误码 < 10000
  unknown(-10001, '未知错误'),
  validationError(-10002, '验证失败'),
  authenticationError(-10003, '认证失败'),
  authorizationError(-10004, '授权失败'),
  dataNotFound(-10005, '数据不存在'),
  businessError(-10006, '业务错误'),
  databaseError(-10007, '数据库错误'),
  cacheError(-10008, '缓存错误'),
  externalServiceError(-10009, '外部服务错误'),
  rateLimitError(-10010, '速率限制错误'),
  conflictError(-10011, '冲突错误'),
  fileUploadError(-10012, '文件上传错误'),
  internalServerError(-10013, '服务器内部错误'),
  serviceUnavailable(-10014, '服务不可用'),
  noContent(-10015, '无内容'),
  notFound(-10016, '资源不存在'),

  // 通用错误码
  error(-1, '错误'),
  success(0, '成功'),

  // dio默认错误码 < 1000
  cancelRequest(-1001, '取消请求'),
  domainError(-1002, '域名错误'),
  networkError(-1003, '网络错误'),
  sendTimeout(-1004, '发送超时'),
  connectionTimeout(-1005, '连接超时'),
  receiveTimeout(-1006, '证书过期'),
  badCertificate(-1007, '接收超时');

  final int value;
  final String message;

  const DataCodeEnum(this.value, this.message);

  /// 是否成功
  bool get isSuccess => value == 0;

  /// 根据值获取对应的枚举
  static DataCodeEnum fromValue(int value) {
    return DataCodeEnum.values.firstWhere(
      (code) => code.value == value,
      orElse: () => DataCodeEnum.unknown,
    );
  }
}

/// DataCodeEnum 的 JSON 转换器
class DataCodeEnumConverter implements JsonConverter<DataCodeEnum, int> {
  const DataCodeEnumConverter();

  @override
  DataCodeEnum fromJson(int json) {
    return DataCodeEnum.fromValue(json);
  }

  @override
  int toJson(DataCodeEnum object) => object.value;
}
