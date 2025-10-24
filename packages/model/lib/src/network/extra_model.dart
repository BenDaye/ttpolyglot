import 'package:freezed_annotation/freezed_annotation.dart';

part 'extra_model.freezed.dart';
part 'extra_model.g.dart';

/// 请求额外配置类
@freezed
class ExtraModel with _$ExtraModel {
  const factory ExtraModel({
    @JsonKey(name: 'show_loading') @Default(false) bool showLoading,
    @JsonKey(name: 'show_lazy_loading') @Default(false) bool showLazyLoading,
    @JsonKey(name: 'show_success_toast') @Default(false) bool showSuccessToast,
    @JsonKey(name: 'show_error_toast') @Default(false) bool showErrorToast,
  }) = _ExtraModel;

  factory ExtraModel.fromJson(Map<String, dynamic> json) => _$ExtraModelFromJson(json);
}
