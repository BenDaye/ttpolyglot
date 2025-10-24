// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseModelImpl<T> _$$BaseModelImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$BaseModelImpl<T>(
      code:
          const DataCodeEnumConverter().fromJson((json['code'] as num).toInt()),
      message: json['message'] as String? ?? "",
      type: json['type'] == null
          ? DataMessageTipsEnum.showToast
          : const DataMessageTipsEnumConverter()
              .fromJson(json['type'] as String),
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$$BaseModelImplToJson<T>(
  _$BaseModelImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': const DataCodeEnumConverter().toJson(instance.code),
      'message': instance.message,
      'type': const DataMessageTipsEnumConverter().toJson(instance.type),
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
