import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_info_model.freezed.dart';
part 'token_info_model.g.dart';

/// Token 信息模型
@freezed
class TokenInfo with _$TokenInfo {
  const factory TokenInfo({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'expires_in') required int expiresIn,
  }) = _TokenInfo;

  factory TokenInfo.fromJson(Map<String, dynamic> json) => _$TokenInfoFromJson(json);
}
