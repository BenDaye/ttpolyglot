import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';

import '../services/permission_service.dart';
import 'auth_middleware.dart';

/// 权限中间件
class PermissionMiddleware {
  final PermissionService _permissionService;

  PermissionMiddleware({required PermissionService permissionService}) : _permissionService = permissionService;

  /// 创建权限检查中间件
  Middleware requirePermission(String permission, {String? projectId}) {
    return (Handler handler) {
      return (Request request) async {
        try {
          // 检查用户是否已认证
          if (!isAuthenticated(request)) {
            return _forbidden('用户未认证');
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return _forbidden('无效的用户信息');
          }

          // 从路径参数中获取项目ID（如果未明确指定）
          final actualProjectId = projectId;

          // 检查权限
          final hasPermission = await _permissionService.checkUserPermission(
            userId: userId,
            permission: permission,
            projectId: actualProjectId,
          );

          if (!hasPermission) {
            log('权限检查失败: $userId 缺少权限 $permission (项目: $actualProjectId)', name: 'PermissionMiddleware');
            return _forbidden('权限不足');
          }

          // 将权限信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'checked_permission': permission,
            'project_id': actualProjectId,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          log('权限中间件错误', error: error, stackTrace: stackTrace, name: 'PermissionMiddleware');

          return _forbidden('权限检查失败');
        }
      };
    };
  }

  /// 检查多个权限（需要全部满足）
  Middleware requireAllPermissions(List<String> permissions, {String? projectId}) {
    return (Handler handler) {
      return (Request request) async {
        try {
          // 检查用户是否已认证
          if (!isAuthenticated(request)) {
            return _forbidden('用户未认证');
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return _forbidden('无效的用户信息');
          }

          // 从路径参数中获取项目ID（如果未明确指定）
          final actualProjectId = projectId;

          // 检查所有权限
          for (final permission in permissions) {
            final hasPermission = await _permissionService.checkUserPermission(
              userId: userId,
              permission: permission,
              projectId: actualProjectId,
            );

            if (!hasPermission) {
              log('权限检查失败: $userId 缺少权限 $permission (项目: $actualProjectId)', name: 'PermissionMiddleware');
              return _forbidden('权限不足');
            }
          }

          // 将权限信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'checked_permissions': permissions,
            'project_id': actualProjectId,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          log('权限中间件错误', error: error, stackTrace: stackTrace, name: 'PermissionMiddleware');

          return _forbidden('权限检查失败');
        }
      };
    };
  }

  /// 检查多个权限（满足任一即可）
  Middleware requireAnyPermission(List<String> permissions, {String? projectId}) {
    return (Handler handler) {
      return (Request request) async {
        try {
          // 检查用户是否已认证
          if (!isAuthenticated(request)) {
            return _forbidden('用户未认证');
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return _forbidden('无效的用户信息');
          }

          // 从路径参数中获取项目ID（如果未明确指定）
          final actualProjectId = projectId;

          // 检查是否满足任一权限
          bool hasAnyPermission = false;
          String? grantedPermission;

          for (final permission in permissions) {
            final hasPermission = await _permissionService.checkUserPermission(
              userId: userId,
              permission: permission,
              projectId: actualProjectId,
            );

            if (hasPermission) {
              hasAnyPermission = true;
              grantedPermission = permission;
              break;
            }
          }

          if (!hasAnyPermission) {
            log('权限检查失败: $userId 缺少权限 ${permissions.join(' 或 ')} (项目: $actualProjectId)', name: 'PermissionMiddleware');
            return _forbidden('权限不足');
          }

          // 将权限信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'granted_permission': grantedPermission,
            'checked_permissions': permissions,
            'project_id': actualProjectId,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          log('权限中间件错误', error: error, stackTrace: stackTrace, name: 'PermissionMiddleware');

          return _forbidden('权限检查失败');
        }
      };
    };
  }

  /// 项目所有者中间件
  Middleware requireProjectOwnership() {
    return (Handler handler) {
      return (Request request) async {
        try {
          // 检查用户是否已认证
          if (!isAuthenticated(request)) {
            return _forbidden('用户未认证');
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return _forbidden('无效的用户信息');
          }

          // 注意：项目ID应该通过其他方式传递给中间件
          // 这里需要重新设计API路由以传递项目ID
          return _internalError('项目所有者检查需要重新设计API路由');

          // 检查是否为项目所有者
          final isOwner = await _permissionService.isProjectOwner(
            userId: userId,
            projectId: projectId,
          );

          if (!isOwner) {
            log('项目所有者检查失败: $userId 不是项目 $projectId 的所有者', name: 'PermissionMiddleware');
            return _forbidden('只有项目所有者可以执行此操作');
          }

          // 将项目所有者信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'is_project_owner': true,
            'project_id': projectId,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          log('项目所有者中间件错误', error: error, stackTrace: stackTrace, name: 'PermissionMiddleware');

          return _forbidden('权限检查失败');
        }
      };
    };
  }

  /// 超级管理员中间件
  Middleware requireSuperAdmin() {
    return (Handler handler) {
      return (Request request) async {
        try {
          // 检查用户是否已认证
          if (!isAuthenticated(request)) {
            return _forbidden('用户未认证');
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return _forbidden('无效的用户信息');
          }

          // 检查是否为超级管理员
          final isSuperAdmin = await _permissionService.isSuperAdmin(userId);

          if (!isSuperAdmin) {
            log('超级管理员检查失败: $userId 不是超级管理员', name: 'PermissionMiddleware');
            return _forbidden('只有超级管理员可以执行此操作');
          }

          // 将超级管理员信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'is_super_admin': true,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          log('超级管理员中间件错误', error: error, stackTrace: stackTrace, name: 'PermissionMiddleware');

          return _forbidden('权限检查失败');
        }
      };
    };
  }

  /// 返回权限不足响应
  Response _forbidden(String message) {
    final errorResponse = {
      'error': {
        'code': 'AUTH_PERMISSION_DENIED',
        'message': message,
        'metadata': {
          'timestamp': DateTime.now().toUtc().toIso8601String(),
        },
      },
    };

    return Response(
      403,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(errorResponse),
    );
  }
}

/// 从请求上下文中获取检查的权限
String? getCheckedPermission(Request request) {
  return request.context['checked_permission'] as String?;
}

/// 从请求上下文中获取检查的权限列表
List<String>? getCheckedPermissions(Request request) {
  return request.context['checked_permissions'] as List<String>?;
}

/// 从请求上下文中获取授予的权限
String? getGrantedPermission(Request request) {
  return request.context['granted_permission'] as String?;
}

/// 从请求上下文中获取项目ID
String? getProjectId(Request request) {
  return request.context['project_id'] as String?;
}

/// 检查是否为项目所有者
bool isProjectOwner(Request request) {
  return request.context['is_project_owner'] == true;
}

/// 检查是否为超级管理员
bool isSuperAdmin(Request request) {
  return request.context['is_super_admin'] == true;
}
