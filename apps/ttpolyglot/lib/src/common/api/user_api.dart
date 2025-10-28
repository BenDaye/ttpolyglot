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
          // 'include_self': true,
        },
      );

      final result = Utils.toModel(
        response.data,
        (json) {
          final items = json as List;
          return items.map((item) => UserSearchResultModel.fromJson(item as Map<String, dynamic>)).toList();
        },
      );
      if (result == null) {
        Logger.error('搜索用户响应数据为空');
        return null;
      }
      return result;
    } catch (error, stackTrace) {
      Logger.error('[searchUsers] 搜索用户失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
