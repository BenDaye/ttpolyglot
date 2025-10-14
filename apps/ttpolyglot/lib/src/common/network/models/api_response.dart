import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// 将 int 转换为 ApiResponseCode
ApiResponseCode _codeFromJson(int value) => ApiResponseCode.fromValue(value);

/// 将 ApiResponseCode 转换为 int
int _codeToJson(ApiResponseCode code) => code.value;

/// 统一 API 响应模型
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const ApiResponse._();

  const factory ApiResponse({
    @JsonKey(
      fromJson: _codeFromJson,
      toJson: _codeToJson,
    )
    required ApiResponseCode code,
    required String message,
    T? data,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

enum ApiResponseCode {
  // 2xx 成功
  created(201, '创建成功'),
  noContent(204, '无内容'),

  // 4xx 客户端错误
  badRequest(400, '请求参数错误'),
  unauthorized(401, '未授权'),
  forbidden(403, '禁止访问'),
  notFound(404, '未找到'),
  methodNotAllowed(405, '方法不允许'),
  conflict(409, '冲突'),
  unprocessableEntity(422, '请求参数验证失败'),
  tooManyRequests(429, '请求过于频繁'),

  // 5xx 服务器错误
  internalServerError(500, '服务器错误'),
  badGateway(502, '网关错误'),
  serviceUnavailable(503, '服务不可用'),
  gatewayTimeout(504, '网关超时'),

  // 业务自定义错误码
  businessError(-1000, '业务错误'),
  validationError(-1001, '验证失败'),
  dataNotFound(-1002, '数据不存在'),
  duplicateData(-1003, '数据重复'),
  unknown(-1, '未知错误'),
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
