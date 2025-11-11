import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

class RoleController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;

  RoleController({
    required this.databaseService,
    required this.redisService,
  }) : super('RoleController');

  Future<Response> getRoles(Request request) async {
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
          SELECT * FROM {roles}
          ${conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : ''}
          ORDER BY name ASC
        ''';

        final result = await databaseService.query(sql, parameters);
        final roles = result.map((row) => row.toColumnMap()).toList();

        return ResponseUtils.success(
          message: '获取角色列表成功',
          data: roles,
        );
      },
      operationName: 'getRoles',
    );
  }

  Future<Response> createRole(Request request) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final name = ValidatorUtils.validateString(data['name'], 'name', minLength: 2, maxLength: 50);
        final description = data['description']?.toString();
        final isActive = data['is_active'] as bool? ?? true;

        // 检查角色名是否已存在
        final existing = await databaseService.query(
          'SELECT 1 FROM {roles} WHERE name = @name',
          {'name': name},
        );

        if (existing.isNotEmpty) {
          throw BusinessException(message: '角色名已存在');
        }

        final result = await databaseService.query(
          '''
          INSERT INTO {roles} (name, description, is_active, created_at, updated_at)
          VALUES (@name, @description, @is_active, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
          RETURNING *
          ''',
          {
            'name': name,
            'description': description,
            'is_active': isActive,
          },
        );

        return ResponseUtils.success(
          message: '创建角色成功',
          data: result.first.toColumnMap(),
        );
      },
      operationName: 'createRole',
    );
  }

  Future<Response> getRole(Request request, String id) async {
    return execute(
      () async {
        final result = await databaseService.query(
          'SELECT * FROM {roles} WHERE id = @id',
          {'id': id},
        );

        if (result.isEmpty) {
          throw NotFoundException(message: '角色不存在');
        }

        return ResponseUtils.success(
          message: '获取角色详情成功',
          data: result.first.toColumnMap(),
        );
      },
      operationName: 'getRole',
    );
  }

  Future<Response> updateRole(Request request, String id) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final updates = <String>[];
        final parameters = <String, dynamic>{'id': id};

        if (data.containsKey('name')) {
          final name = ValidatorUtils.validateString(data['name'], 'name', minLength: 2, maxLength: 50);
          // 检查角色名是否已被其他角色使用
          final existing = await databaseService.query(
            'SELECT 1 FROM {roles} WHERE name = @name AND id != @id',
            {'name': name, 'id': id},
          );
          if (existing.isNotEmpty) {
            throw BusinessException(message: '角色名已被使用');
          }
          updates.add('name = @name');
          parameters['name'] = name;
        }

        if (data.containsKey('description')) {
          updates.add('description = @description');
          parameters['description'] = data['description']?.toString();
        }

        if (data.containsKey('is_active')) {
          updates.add('is_active = @is_active');
          parameters['is_active'] = data['is_active'] as bool;
        }

        if (updates.isEmpty) {
          throw ValidationException(message: '没有可更新的字段');
        }

        updates.add('updated_at = CURRENT_TIMESTAMP');

        final result = await databaseService.query(
          '''
          UPDATE {roles}
          SET ${updates.join(', ')}
          WHERE id = @id
          RETURNING *
          ''',
          parameters,
        );

        return ResponseUtils.success(
          message: '更新角色成功',
          data: result.first.toColumnMap(),
        );
      },
      operationName: 'updateRole',
    );
  }

  Future<Response> deleteRole(Request request, String id) async {
    return execute(
      () async {
        // 检查角色是否被使用
        final userRoles = await databaseService.query(
          'SELECT 1 FROM {user_roles} WHERE role_id = @role_id LIMIT 1',
          {'role_id': id},
        );

        if (userRoles.isNotEmpty) {
          throw BusinessException(message: '角色正在被使用，无法删除');
        }

        await databaseService.query(
          'DELETE FROM {roles} WHERE id = @id',
          {'id': id},
        );

        return ResponseUtils.success(message: '删除角色成功');
      },
      operationName: 'deleteRole',
    );
  }

  Future<Response> getRolePermissions(Request request, String id) async {
    return execute(
      () async {
        final result = await databaseService.query(
          '''
          SELECT p.*, rp.is_granted
          FROM {role_permissions} rp
          JOIN {permissions} p ON rp.permission_id = p.id
          WHERE rp.role_id = @role_id
          ORDER BY p.name ASC
          ''',
          {'role_id': id},
        );

        final permissions = result.map((row) => row.toColumnMap()).toList();

        return ResponseUtils.success(
          message: '获取角色权限成功',
          data: permissions,
        );
      },
      operationName: 'getRolePermissions',
    );
  }

  Future<Response> assignPermissions(Request request, String id) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final permissionIds = (data['permission_ids'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        final isGranted = data['is_granted'] as bool? ?? true;

        if (permissionIds.isEmpty) {
          throw ValidationException(message: '权限ID列表不能为空');
        }

        await databaseService.transaction(() async {
          for (final permissionId in permissionIds) {
            // 检查是否已存在
            final existing = await databaseService.query(
              'SELECT 1 FROM {role_permissions} WHERE role_id = @role_id AND permission_id = @permission_id',
              {'role_id': id, 'permission_id': permissionId},
            );

            if (existing.isNotEmpty) {
              // 更新
              await databaseService.query(
                '''
                UPDATE {role_permissions}
                SET is_granted = @is_granted
                WHERE role_id = @role_id AND permission_id = @permission_id
                ''',
                {
                  'role_id': id,
                  'permission_id': permissionId,
                  'is_granted': isGranted,
                },
              );
            } else {
              // 插入
              await databaseService.query(
                '''
                INSERT INTO {role_permissions} (role_id, permission_id, is_granted)
                VALUES (@role_id, @permission_id, @is_granted)
                ''',
                {
                  'role_id': id,
                  'permission_id': permissionId,
                  'is_granted': isGranted,
                },
              );
            }
          }
        });

        return ResponseUtils.success(message: '分配权限成功');
      },
      operationName: 'assignPermissions',
    );
  }

  Future<Response> revokePermission(Request request, String id, String permissionId) async {
    return execute(
      () async {
        await databaseService.query(
          'DELETE FROM {role_permissions} WHERE role_id = @role_id AND permission_id = @permission_id',
          {'role_id': id, 'permission_id': permissionId},
        );

        return ResponseUtils.success(message: '撤销权限成功');
      },
      operationName: 'revokePermission',
    );
  }

  Future<Response> getUserRoles(Request request, String userId) async {
    return execute(
      () async {
        final params = request.url.queryParameters;
        final projectId = params['project_id'];

        final conditions = <String>['ur.user_id = @user_id', 'ur.is_active = true'];
        final parameters = <String, dynamic>{'user_id': userId};

        if (projectId != null) {
          conditions.add('ur.project_id = @project_id');
          parameters['project_id'] = projectId;
        } else {
          conditions.add('ur.project_id IS NULL');
        }

        final sql = '''
          SELECT r.*, ur.project_id, ur.expires_at
          FROM {user_roles} ur
          JOIN {roles} r ON ur.role_id = r.id
          WHERE ${conditions.join(' AND ')}
          ORDER BY r.name ASC
        ''';

        final result = await databaseService.query(sql, parameters);
        final roles = result.map((row) => row.toColumnMap()).toList();

        return ResponseUtils.success(
          message: '获取用户角色成功',
          data: roles,
        );
      },
      operationName: 'getUserRoles',
    );
  }

  Future<Response> assignUserRole(Request request, String userId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final roleId = ValidatorUtils.validateString(data['role_id'], 'role_id');
        final projectId = data['project_id']?.toString();
        final expiresAt = data['expires_at']?.toString();

        // 检查是否已存在
        final conditions = <String>['user_id = @user_id', 'role_id = @role_id'];
        final checkParams = <String, dynamic>{
          'user_id': userId,
          'role_id': roleId,
        };

        if (projectId != null) {
          conditions.add('project_id = @project_id');
          checkParams['project_id'] = projectId;
        } else {
          conditions.add('project_id IS NULL');
        }

        final existing = await databaseService.query(
          'SELECT 1 FROM {user_roles} WHERE ${conditions.join(' AND ')}',
          checkParams,
        );

        if (existing.isNotEmpty) {
          throw BusinessException(message: '用户已拥有该角色');
        }

        final insertParams = <String, dynamic>{
          'user_id': userId,
          'role_id': roleId,
          'project_id': projectId,
          'expires_at': expiresAt != null ? DateTime.tryParse(expiresAt) : null,
        };

        final result = await databaseService.query(
          '''
          INSERT INTO {user_roles} (user_id, role_id, project_id, expires_at, is_active, created_at)
          VALUES (@user_id, @role_id, @project_id, @expires_at, true, CURRENT_TIMESTAMP)
          RETURNING *
          ''',
          insertParams,
        );

        return ResponseUtils.success(
          message: '分配用户角色成功',
          data: result.first.toColumnMap(),
        );
      },
      operationName: 'assignUserRole',
    );
  }

  Future<Response> revokeUserRole(Request request, String userId, String roleId) async {
    return execute(
      () async {
        final params = request.url.queryParameters;
        final projectId = params['project_id'];

        final conditions = <String>['user_id = @user_id', 'role_id = @role_id'];
        final parameters = <String, dynamic>{
          'user_id': userId,
          'role_id': roleId,
        };

        if (projectId != null) {
          conditions.add('project_id = @project_id');
          parameters['project_id'] = projectId;
        } else {
          conditions.add('project_id IS NULL');
        }

        await databaseService.query(
          'DELETE FROM {user_roles} WHERE ${conditions.join(' AND ')}',
          parameters,
        );

        return ResponseUtils.success(message: '撤销用户角色成功');
      },
      operationName: 'revokeUserRole',
    );
  }
}
