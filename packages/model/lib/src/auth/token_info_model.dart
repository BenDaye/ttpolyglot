import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_info_model.freezed.dart';
part 'token_info_model.g.dart';

/// Token 信息模型
@freezed
class TokenInfoModel with _$TokenInfoModel {
  const factory TokenInfoModel({
    /// 访问令牌
    @JsonKey(name: 'access_token') required String accessToken,

    /// 刷新令牌
    @JsonKey(name: 'refresh_token') required String refreshToken,

    /// 令牌类型
    @JsonKey(name: 'token_type') required String tokenType,

    /// 过期时间
    @JsonKey(name: 'expires_in') required int expiresIn,
  }) = _TokenInfoModel;

  factory TokenInfoModel.fromJson(Map<String, dynamic> json) => _$TokenInfoModelFromJson(json);
}
