// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtraModelImpl _$$ExtraModelImplFromJson(Map<String, dynamic> json) =>
    _$ExtraModelImpl(
      showLoading: json['show_loading'] as bool? ?? false,
      showLazyLoading: json['show_lazy_loading'] as bool? ?? false,
      showSuccessToast: json['show_success_toast'] as bool? ?? false,
      showErrorToast: json['show_error_toast'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExtraModelImplToJson(_$ExtraModelImpl instance) =>
    <String, dynamic>{
      'show_loading': instance.showLoading,
      'show_lazy_loading': instance.showLazyLoading,
      'show_success_toast': instance.showSuccessToast,
      'show_error_toast': instance.showErrorToast,
    };
