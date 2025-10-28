import 'package:freezed_annotation/freezed_annotation.dart';

part 'extra_model.freezed.dart';
part 'extra_model.g.dart';

/// 请求额外配置类
@freezed
class ExtraModel with _$ExtraModel {
  const factory ExtraModel({
    /// 是否显示加载中
    @JsonKey(name: 'show_loading') @Default(false) bool showLoading,

    /// 是否显示懒加载
    @JsonKey(name: 'show_lazy_loading') @Default(true) bool showLazyLoading,

    /// 是否显示成功提示
    @JsonKey(name: 'show_success_toast') @Default(false) bool showSuccessToast,

    /// 是否显示错误提示
    @JsonKey(name: 'show_error_toast') @Default(true) bool showErrorToast,
  }) = _ExtraModel;

  factory ExtraModel.fromJson(Map<String, dynamic> json) => _$ExtraModelFromJson(json);
}
