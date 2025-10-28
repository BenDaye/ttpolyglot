import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/common/serializable.dart';

part 'pager_model.freezed.dart';
part 'pager_model.g.dart';

/// 分页响应模型
@Freezed(genericArgumentFactories: true)
class PagerModel<T> with _$PagerModel<T> {
  const PagerModel._();

  const factory PagerModel({
    /// 当前页数
    @JsonKey(name: 'page') required int page,

    /// 每页大小
    @JsonKey(name: 'page_size') required int pageSize,

    /// 总大小
    @JsonKey(name: 'total_size') required int totalSize,

    /// 总页数
    @JsonKey(name: 'total_page') required int totalPage,

    /// 数据
    @JsonKey(name: 'items') List<T>? items,
  }) = _PagerModel<T>;

  factory PagerModel.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PagerModelFromJson(json, fromJsonT);

  bool get isArray => !isEmpty && items is Iterable;

  bool get isEmpty => items == null;

  R toModel<R>(Converter<R> converter) => converter(items as Map<String, dynamic>);

  List<R> toArray<R>(Converter<R> converter) {
    if (isEmpty) return <R>[];
    if (isArray) {
      final list = items as Iterable?;
      return list?.map<R>((e) => converter(e as Map<String, dynamic>)).toList() ?? <R>[];
    }
    return <R>[converter(items as Map<String, dynamic>)];
  }
}
