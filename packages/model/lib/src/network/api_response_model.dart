import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ttpolyglot_model/src/common/model.dart';
import 'package:ttpolyglot_model/src/enums/enums.dart';

part 'api_response_model.freezed.dart';
part 'api_response_model.g.dart';

/// 统一 API 响应模型
@Freezed(genericArgumentFactories: true)
class ApiResponseModel<T> with _$ApiResponseModel<T> {
  const ApiResponseModel._();

  const factory ApiResponseModel({
    @JsonKey(name: 'code') @DataCodeEnumConverter() required DataCodeEnum code,
    @Default("") String message,
    @JsonKey(name: 'type')
    @DataMessageTipsEnumConverter()
    @Default(DataMessageTipsEnum.showToast)
    DataMessageTipsEnum type,
    T? data,
  }) = _ApiResponseModel<T>;

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseModelFromJson(json, fromJsonT);

  factory ApiResponseModel.of(DataCodeEnum code, {DataMessageTipsEnum? type, String? message}) {
    return ApiResponseModel(
      code: code,
      type: type ?? DataMessageTipsEnum.showToast,
      message: message ?? code.message,
      data: null,
    );
  }

  // 成功
  bool get success => code == DataCodeEnum.success;

  bool get isArray => !isEmpty && data is Iterable;

  //
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
