import 'package:test/test.dart';
import 'package:ttpolyglot_model/model.dart';

void main() {
  test('model package exports are available', () {
    // 验证认证模型可以导入
    expect(LoginRequest, isNotNull);
    expect(LoginResponse, isNotNull);
    expect(TokenInfo, isNotNull);
    expect(UserInfo, isNotNull);

    // 验证网络模型可以导入
    expect(ApiResponse, isNotNull);
    expect(RequestExtra, isNotNull);

    // 验证枚举可以导入
    expect(ApiResponseCode, isNotNull);

    // 验证项目模型可以导入
    expect(ImportRecord, isNotNull);
  });
}
