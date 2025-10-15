import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_pager.freezed.dart';
part 'api_response_pager.g.dart';

/// 分页响应模型
@Freezed(genericArgumentFactories: true)
class ApiResponsePager<T> with _$ApiResponsePager<T> {
  const factory ApiResponsePager({
    @JsonKey(name: 'page') required int page,
    @JsonKey(name: 'page_size') required int pageSize,
    @JsonKey(name: 'total_size') required int totalSize,
    @JsonKey(name: 'total_page') required int totalPage,
    @JsonKey(name: 'items') List<T>? items,
  }) = _ApiResponsePager<T>;

  factory ApiResponsePager.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ApiResponsePagerFromJson(json, fromJsonT);
}
