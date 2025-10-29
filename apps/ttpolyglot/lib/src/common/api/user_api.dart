import 'package:ttpolyglot/src/common/network/http_client.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 用户 API
class UserApi {
  /// 搜索用户
  Future<List<UserSearchResultModel>?> searchUsers({
    required String query,
    int limit = 10,
  }) async {
    try {
      final response = await HttpClient.get<List<dynamic>>(
        '/users/search',
        query: {
          'q': query,
          'limit': limit,
        },
      );

      final result = Utils.toModelArray<UserSearchResultModel>(
        response.data,
        (json) => UserSearchResultModel.fromJson(json),
      );
      return result;
    } catch (error, stackTrace) {
      Logger.error('[searchUsers] 搜索用户失败', error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
