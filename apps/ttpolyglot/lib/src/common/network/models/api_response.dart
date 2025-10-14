import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot/src/common/enums/enums.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// 统一 API 响应模型
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const ApiResponse._();

  const factory ApiResponse({
    @JsonKey(
      fromJson: apiResponseCodeFromJson,
      toJson: apiResponseCodeToJson,
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

  factory ApiResponse.of(ApiResponseCode code, {String? message}) {
    return ApiResponse(
      code: code,
      message: message ?? code.message,
      data: null,
    );
  }
}
