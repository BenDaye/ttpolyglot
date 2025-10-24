// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pager_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PagerModelImpl<T> _$$PagerModelImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    _$PagerModelImpl<T>(
      page: (json['page'] as num).toInt(),
      pageSize: (json['page_size'] as num).toInt(),
      totalSize: (json['total_size'] as num).toInt(),
      totalPage: (json['total_page'] as num).toInt(),
      items: (json['items'] as List<dynamic>?)?.map(fromJsonT).toList(),
    );

Map<String, dynamic> _$$PagerModelImplToJson<T>(
  _$PagerModelImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'page': instance.page,
      'page_size': instance.pageSize,
      'total_size': instance.totalSize,
      'total_page': instance.totalPage,
      'items': instance.items?.map(toJsonT).toList(),
    };
