import 'dart:convert';
import 'dart:developer';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../middleware/auth_middleware.dart';
import '../middleware/error_handler_middleware.dart';
import '../services/user_service.dart';
import '../utils/response_builder.dart';
import '../utils/validator.dart';

/// 用户管理控制器
class UserController {
  final UserService _userService;

  UserController(this._userService);

  Router get router {
    final router = Router();

    // 需要认证的路由
    router.get('/', _getUsers);
    router.get('/<id>', _getUserById);
    router.put('/<id>', _updateUser);
    router.delete('/<id>', _deleteUser);
    router.get('/me', _getCurrentUser);
    router.put('/me', _updateCurrentUser);
    router.post('/me/change-password', _changePassword);
    router.get('/stats', _getUserStats);

    return router;
  }

  /// 获取用户列表
  Future<Response> _getUsers(Request request) async {
    try {
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = int.tryParse(params['limit'] ?? '20') ?? 20;

      if (page < 1 || limit < 1 || limit > 100) {
        return ResponseBuilder.error(
          code: 'VALIDATION_INVALID_PAGINATION',
          message: '分页参数无效',
          statusCode: 400,
        );
      }

      final result = await _userService.getUsers(
        page: page,
        limit: limit,
        search: params['search'],
        status: params['status'],
        role: params['role'],
      );

      return ResponseBuilder.paginated(
        data: result['users'],
        page: page,
        limit: limit,
        total: result['pagination']['total'],
        message: '获取用户列表成功',
      );
    } catch (error, stackTrace) {
      log('获取用户列表失败', error: error, stackTrace: stackTrace, name: 'UserController');

      return ResponseBuilder.errorFromRequest(
        request: request,
        code: 'GET_USERS_FAILED',
        message: '获取用户列表失败',
        statusCode: 500,
      );
    }
  }

  /// 根据ID获取用户详情
  Future<Response> _getUserById(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'user_id');

      final user = await _userService.getUserById(id);

      if (user == null) {
        return ResponseBuilder.notFound(message: '用户不存在');
      }

      return ResponseBuilder.success(
        message: '获取用户详情成功',
        data: user,
      );
    } catch (error, stackTrace) {
      log('获取用户详情失败: $id', error: error, stackTrace: stackTrace, name: 'UserController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(
          request: request,
          fieldErrors: error.fieldErrors,
        );
      }

      return ResponseBuilder.errorFromRequest(
        request: request,
        code: 'GET_USER_FAILED',
        message: '获取用户详情失败',
        statusCode: 500,
      );
    }
  }

  /// 更新用户信息
  Future<Response> _updateUser(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'user_id');

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final updateData = <String, dynamic>{};

      if (data.containsKey('display_name')) {
        updateData['display_name'] =
            Validator.validateString(data['display_name'], 'display_name', maxLength: 100, required: false);
      }

      if (data.containsKey('phone')) {
        updateData['phone'] = Validator.validateString(data['phone'], 'phone', maxLength: 20, required: false);
      }

      if (data.containsKey('timezone')) {
        updateData['timezone'] = Validator.validateString(data['timezone'], 'timezone', maxLength: 50, required: false);
      }

      if (data.containsKey('locale')) {
        updateData['locale'] = Validator.validateString(data['locale'], 'locale', maxLength: 10, required: false);
      }

      if (data.containsKey('avatar_url')) {
        updateData['avatar_url'] = Validator.validateUrl(data['avatar_url'], 'avatar_url', required: false);
      }

      if (data.containsKey('is_active')) {
        updateData['is_active'] = Validator.validateBool(data['is_active'], 'is_active', required: false);
      }

      final updatedUser = await _userService.updateUser(id, updateData, updatedBy: getCurrentUserId(request));

      return ResponseBuilder.success(
        message: '用户信息更新成功',
        data: updatedUser,
      );
    } catch (error, stackTrace) {
      log('更新用户信息失败: $id', error: error, stackTrace: stackTrace, name: 'UserController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }

      if (error is BusinessException) {
        return ResponseBuilder.errorFromRequest(
            request: request, code: error.code, message: error.message, statusCode: 400);
      }

      return ResponseBuilder.errorFromRequest(
        request: request,
        code: 'UPDATE_USER_FAILED',
        message: '更新用户信息失败',
        statusCode: 500,
      );
    }
  }

  /// 删除用户
  Future<Response> _deleteUser(Request request, String id) async {
    try {
      Validator.validateUuid(id, 'user_id');

      final currentUserId = getCurrentUserId(request);
      if (id == currentUserId) {
        return ResponseBuilder.error(
          code: 'BUSINESS_CANNOT_DELETE_SELF',
          message: '不能删除自己的账户',
          statusCode: 400,
        );
      }

      await _userService.deleteUser(id, deletedBy: currentUserId);

      return ResponseBuilder.noContent();
    } catch (error, stackTrace) {
      log('删除用户失败: $id', error: error, stackTrace: stackTrace, name: 'UserController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }

      if (error is NotFoundException) {
        return ResponseBuilder.notFound(message: '用户不存在');
      }

      return ResponseBuilder.errorFromRequest(
        request: request,
        code: 'DELETE_USER_FAILED',
        message: '删除用户失败',
        statusCode: 500,
      );
    }
  }

  /// 获取当前用户信息
  Future<Response> _getCurrentUser(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseBuilder.authError(
          code: 'AUTH_USER_NOT_FOUND',
          message: '用户信息不存在',
        );
      }

      final user = await _userService.getUserById(userId);

      if (user == null) {
        return ResponseBuilder.authError(
          code: 'AUTH_USER_NOT_FOUND',
          message: '用户不存在',
        );
      }

      return ResponseBuilder.success(
        message: '获取当前用户信息成功',
        data: user,
      );
    } catch (error, stackTrace) {
      log('获取当前用户信息失败', error: error, stackTrace: stackTrace, name: 'UserController');

      return ResponseBuilder.errorFromRequest(
        request: request,
        code: 'GET_CURRENT_USER_FAILED',
        message: '获取用户信息失败',
        statusCode: 500,
      );
    }
  }

  /// 更新当前用户信息
  Future<Response> _updateCurrentUser(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseBuilder.authError(
          code: 'AUTH_USER_NOT_FOUND',
          message: '用户信息不存在',
        );
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final updateData = <String, dynamic>{};

      if (data.containsKey('display_name')) {
        updateData['display_name'] =
            Validator.validateString(data['display_name'], 'display_name', maxLength: 100, required: false);
      }

      if (data.containsKey('phone')) {
        updateData['phone'] = Validator.validateString(data['phone'], 'phone', maxLength: 20, required: false);
      }

      if (data.containsKey('timezone')) {
        updateData['timezone'] = Validator.validateString(data['timezone'], 'timezone', maxLength: 50, required: false);
      }

      if (data.containsKey('locale')) {
        updateData['locale'] = Validator.validateString(data['locale'], 'locale', maxLength: 10, required: false);
      }

      if (data.containsKey('avatar_url')) {
        updateData['avatar_url'] = Validator.validateUrl(data['avatar_url'], 'avatar_url', required: false);
      }

      final updatedUser = await _userService.updateUser(userId, updateData, updatedBy: userId);

      return ResponseBuilder.success(
        message: '个人信息更新成功',
        data: updatedUser,
      );
    } catch (error, stackTrace) {
      log('更新当前用户信息失败', error: error, stackTrace: stackTrace, name: 'UserController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }

      if (error is BusinessException) {
        return ResponseBuilder.errorFromRequest(
            request: request, code: error.code, message: error.message, statusCode: 400);
      }

      return ResponseBuilder.errorFromRequest(
        request: request,
        code: 'UPDATE_CURRENT_USER_FAILED',
        message: '更新个人信息失败',
        statusCode: 500,
      );
    }
  }

  /// 修改密码
  Future<Response> _changePassword(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseBuilder.authError(
          code: 'AUTH_USER_NOT_FOUND',
          message: '用户信息不存在',
        );
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final currentPassword = Validator.validateString(data['current_password'], 'current_password');
      final newPassword = Validator.validateString(data['new_password'], 'new_password', minLength: 8);

      await _userService.changePassword(userId, currentPassword, newPassword);

      return ResponseBuilder.success(message: '密码修改成功，请重新登录');
    } catch (error, stackTrace) {
      log('修改密码失败', error: error, stackTrace: stackTrace, name: 'UserController');

      if (error is ValidationException) {
        return ResponseBuilder.validationErrorFromRequest(request: request, fieldErrors: error.fieldErrors);
      }

      if (error is BusinessException) {
        return ResponseBuilder.errorFromRequest(
            request: request, code: error.code, message: error.message, statusCode: 400);
      }

      return ResponseBuilder.errorFromRequest(
        request: request,
        code: 'CHANGE_PASSWORD_FAILED',
        message: '修改密码失败',
        statusCode: 500,
      );
    }
  }

  /// 获取用户统计信息
  Future<Response> _getUserStats(Request request) async {
    try {
      final stats = await _userService.getUserStats();

      return ResponseBuilder.success(
        message: '获取用户统计信息成功',
        data: stats,
      );
    } catch (error, stackTrace) {
      log('获取用户统计信息失败', error: error, stackTrace: stackTrace, name: 'UserController');

      return ResponseBuilder.errorFromRequest(
        request: request,
        code: 'GET_USER_STATS_FAILED',
        message: '获取统计信息失败',
        statusCode: 500,
      );
    }
  }
}
