import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_pager_model.freezed.dart';
part 'api_response_pager_model.g.dart';

/// 分页响应模型
@Freezed(genericArgumentFactories: true)
class ApiResponsePagerModel<T> with _$ApiResponsePagerModel<T> {
  const factory ApiResponsePagerModel({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'page_size') required int pageSize,
    @JsonKey(name: 'total_size') required int totalSize,
    @JsonKey(name: 'total_page') required int totalPage,
    @JsonKey(name: 'items') List<T>? items,
  }) = _ApiResponsePagerModel<T>;

  factory ApiResponsePagerModel.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ApiResponsePagerModelFromJson(json, fromJsonT);
}
