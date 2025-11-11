import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

class PermissionController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;

  PermissionController({
    required this.databaseService,
    required this.redisService,
  }) : super('PermissionController');

  Future<Response> getPermissions(Request request) async {
    return execute(
      () async {
        final params = request.url.queryParameters;
        final isActive = params['is_active'] == 'true' ? true : (params['is_active'] == 'false' ? false : null);

        final conditions = <String>[];
        final parameters = <String, dynamic>{};

        if (isActive != null) {
          conditions.add('is_active = @is_active');
          parameters['is_active'] = isActive;
        }

        final sql = '''
          SELECT * FROM {permissions}
          ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
          ORDER BY name ASC
        ''';

        final result = await databaseService.query(sql, parameters);
        final permissions = result.map((row) => row.toColumnMap()).toList();

        return ResponseUtils.success(
          message: '获取权限列表成功',
          data: permissions,
        );
      },
      operationName: 'getPermissions',
    );
  }

  Future<Response> getPermission(Request request, String id) async {
    return execute(
      () async {
        final result = await databaseService.query(
          'SELECT * FROM {permissions} WHERE id = @id',
          {'id': id},
        );

        if (result.isEmpty) {
          throw NotFoundException(message: '权限不存在');
        }

        return ResponseUtils.success(
          message: '获取权限详情成功',
          data: result.first.toColumnMap(),
        );
      },
      operationName: 'getPermission',
    );
  }
}
