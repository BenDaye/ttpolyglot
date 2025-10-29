import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';
import 'package:ttpolyglot_utils/utils.dart';

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
            return ResponseUtils.error(message: '用户未认证', code: DataCodeEnum.unauthorized);
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return ResponseUtils.error(message: '无效的用户信息', code: DataCodeEnum.unauthorized);
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
            LoggerUtils.warning('权限检查失败: $userId 缺少权限 $permission (项目: $actualProjectId)');
            return ResponseUtils.error(message: '权限不足', code: DataCodeEnum.unauthorized);
          }

          // 将权限信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'checked_permission': permission,
            'project_id': actualProjectId,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          LoggerUtils.error(
            '权限中间件错误',
            error: error,
            stackTrace: stackTrace,
          );

          return ResponseUtils.error(message: '权限检查失败', code: DataCodeEnum.unauthorized);
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
            return ResponseUtils.error(message: '用户未认证', code: DataCodeEnum.unauthorized);
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return ResponseUtils.error(message: '无效的用户信息', code: DataCodeEnum.unauthorized);
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
              LoggerUtils.warning('权限检查失败: $userId 缺少权限 $permission (项目: $actualProjectId)');
              return ResponseUtils.error(message: '权限不足', code: DataCodeEnum.unauthorized);
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
          LoggerUtils.error(
            '权限中间件错误',
            error: error,
            stackTrace: stackTrace,
          );

          return ResponseUtils.error(message: '权限检查失败', code: DataCodeEnum.unauthorized);
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
            return ResponseUtils.error(message: '用户未认证', code: DataCodeEnum.unauthorized);
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return ResponseUtils.error(message: '无效的用户信息', code: DataCodeEnum.unauthorized);
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
            LoggerUtils.warning('权限检查失败: $userId 缺少权限 ${permissions.join(' 或 ')} (项目: $actualProjectId)');
            return ResponseUtils.error(message: '权限不足', code: DataCodeEnum.unauthorized);
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
          LoggerUtils.error(
            '权限中间件错误',
            error: error,
            stackTrace: stackTrace,
          );

          return ResponseUtils.error(message: '权限检查失败', code: DataCodeEnum.unauthorized);
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
            return ResponseUtils.error(message: '用户未认证', code: DataCodeEnum.unauthorized);
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return ResponseUtils.error(message: '无效的用户信息', code: DataCodeEnum.internalServerError);
          }

          // 注意：项目ID应该在路由级别处理
          // 此方法需要重新设计为接受projectId参数
          return ResponseUtils.error(message: '项目所有者检查需要projectId参数', code: DataCodeEnum.internalServerError);
        } catch (error, stackTrace) {
          LoggerUtils.error(
            '项目所有者中间件错误',
            error: error,
            stackTrace: stackTrace,
          );

          return ResponseUtils.error(message: '权限检查失败', code: DataCodeEnum.internalServerError);
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
            return ResponseUtils.error(message: '用户未认证', code: DataCodeEnum.internalServerError);
          }

          final userId = getCurrentUserId(request);
          if (userId == null) {
            return ResponseUtils.error(message: '无效的用户信息', code: DataCodeEnum.internalServerError);
          }

          // 检查是否为超级管理员
          final isSuperAdmin = await _permissionService.isSuperAdmin(userId);

          if (!isSuperAdmin) {
            LoggerUtils.warning('超级管理员检查失败: $userId 不是超级管理员');
            return ResponseUtils.error(message: '只有超级管理员可以执行此操作', code: DataCodeEnum.internalServerError);
          }

          // 将超级管理员信息添加到请求上下文
          final updatedRequest = request.change(context: {
            ...request.context,
            'is_super_admin': true,
          });

          return await handler(updatedRequest);
        } catch (error, stackTrace) {
          LoggerUtils.error(
            '超级管理员中间件错误',
            error: error,
            stackTrace: stackTrace,
          );

          return ResponseUtils.error(message: '权限检查失败', code: DataCodeEnum.internalServerError);
        }
      };
    };
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
