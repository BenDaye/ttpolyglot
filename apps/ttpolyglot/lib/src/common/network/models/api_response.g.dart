// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseImpl<T> _$$ApiResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$ApiResponseImpl<T>(
      code: $enumDecode(_$ApiResponseCodeEnumMap, json['code']),
      message: json['message'] as String,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$$ApiResponseImplToJson<T>(
  _$ApiResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': _$ApiResponseCodeEnumMap[instance.code]!,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

const _$ApiResponseCodeEnumMap = {
  ApiResponseCode.created: 'created',
  ApiResponseCode.noContent: 'noContent',
  ApiResponseCode.badRequest: 'badRequest',
  ApiResponseCode.unauthorized: 'unauthorized',
  ApiResponseCode.forbidden: 'forbidden',
  ApiResponseCode.notFound: 'notFound',
  ApiResponseCode.methodNotAllowed: 'methodNotAllowed',
  ApiResponseCode.conflict: 'conflict',
  ApiResponseCode.unprocessableEntity: 'unprocessableEntity',
  ApiResponseCode.tooManyRequests: 'tooManyRequests',
  ApiResponseCode.internalServerError: 'internalServerError',
  ApiResponseCode.badGateway: 'badGateway',
  ApiResponseCode.serviceUnavailable: 'serviceUnavailable',
  ApiResponseCode.gatewayTimeout: 'gatewayTimeout',
  ApiResponseCode.businessError: 'businessError',
  ApiResponseCode.validationError: 'validationError',
  ApiResponseCode.dataNotFound: 'dataNotFound',
  ApiResponseCode.duplicateData: 'duplicateData',
  ApiResponseCode.unknown: 'unknown',
  ApiResponseCode.success: 'success',
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
