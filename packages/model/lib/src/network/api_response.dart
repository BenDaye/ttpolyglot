import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/enums/enums.dart';

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
    @Default("") String message,
    @JsonKey(
      fromJson: apiResponseTipsTypeFromJson,
      toJson: apiResponseTipsTypeToJson,
    )
    @Default(ApiResponseTipsType.showToast)
    ApiResponseTipsType type,
    T? data,
  }) = _ApiResponse<T>;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  factory ApiResponse.of(ApiResponseCode code, {ApiResponseTipsType? type, String? message}) {
    return ApiResponse(
      code: code,
      type: type ?? ApiResponseTipsType.showToast,
      message: message ?? code.message,
      data: null,
    );
  }
}
