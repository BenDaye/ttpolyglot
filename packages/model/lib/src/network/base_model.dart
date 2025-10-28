import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/common/serializable.dart';
import 'package:ttpolyglot_model/src/enums/enums.dart';

part 'base_model.freezed.dart';
part 'base_model.g.dart';

/// 统一 API 响应模型
@Freezed(genericArgumentFactories: true)
class BaseModel<T> with _$BaseModel<T> {
  const BaseModel._();

  const factory BaseModel({
    /// 响应码
    @JsonKey(name: 'code') @DataCodeEnumConverter() required DataCodeEnum code,

    /// 提示信息
    @JsonKey(name: 'message') @Default("") String message,

    /// 提示类型
    @JsonKey(name: 'type')
    @DataMessageTipsEnumConverter()
    @Default(DataMessageTipsEnum.showToast)
    DataMessageTipsEnum type,

    /// 数据
    @JsonKey(name: 'data') T? data,
  }) = _BaseModel<T>;

  factory BaseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$BaseModelFromJson(json, fromJsonT);

  factory BaseModel.of(DataCodeEnum code, {DataMessageTipsEnum? type, String? message}) {
    return BaseModel(
      code: code,
      type: type ?? DataMessageTipsEnum.showToast,
      message: message ?? code.message,
      data: null,
    );
  }

  bool get success => code == DataCodeEnum.success;

  bool get isArray => !isEmpty && data is Iterable;

  bool get isEmpty => data == null;

  int get size => isEmpty ? 0 : (isArray ? (data as Iterable?)?.length ?? 0 : 1);

  R toModel<R>(Converter<R> converter) => converter(data as Map<String, dynamic>);

  List<R> toArray<R>(Converter<R> converter) {
    if (isEmpty) return <R>[];
    if (isArray) {
      final list = data as Iterable?;
      return list?.map<R>((e) => converter(e as Map<String, dynamic>)).toList() ?? <R>[];
    }
    return <R>[converter(data as Map<String, dynamic>)];
  }
}
