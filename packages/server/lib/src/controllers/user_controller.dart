import 'dart:convert';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

/// 用户管理控制器
class UserController {
  final UserService _userService;
  final FileUploadService _fileUploadService;

  UserController({
    required UserService userService,
    required FileUploadService fileUploadService,
  })  : _userService = userService,
        _fileUploadService = fileUploadService;

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

  // 公共方法用于路由配置
  Future<Response> Function(Request) get getUsers => _getUsers;
  Future<Response> Function(Request, String) get getUser => _getUserById;
  Future<Response> Function(Request, String) get updateUser => _updateUser;
  Future<Response> Function(Request, String) get deleteUser => _deleteUser;
  Future<Response> Function(Request) get me => _getCurrentUser;
  Future<Response> Function(Request) get getCurrentUser => _getCurrentUser;
  Future<Response> Function(Request) get updateCurrentUser => _updateCurrentUser;
  Future<Response> Function(Request) get changePassword => _changePassword;
  Future<Response> Function(Request) get uploadAvatar => _uploadAvatar;
  Future<Response> Function(Request) get deleteAvatar => _deleteAvatar;
  Future<Response> Function(Request) get getUserSessions => _getUserSessions;
  Future<Response> Function(Request, String) get deleteSession => _deleteSession;
  Future<Response> Function(Request) get stats => _getUserStats;

  /// 获取用户列表
  Future<Response> _getUsers(Request request) async {
    try {
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = int.tryParse(params['limit'] ?? '20') ?? 20;

      if (page < 1 || limit < 1 || limit > 100) {
        return ResponseUtils.error(
          code: ApiResponseCode.validationError,
          message: '分页参数无效',
        );
      }

      final result = await _userService.getUsers(
        page: page,
        limit: limit,
        search: params['search'],
        status: params['status'],
        role: params['role'],
      );

      return ResponseUtils.paginated(
        data: result['users'],
        page: page,
        limit: limit,
        total: result['pagination']['total'],
        message: '获取用户列表成功',
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取用户列表失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '获取用户列表失败',
      );
    }
  }

  /// 根据ID获取用户详情
  Future<Response> _getUserById(Request request, String id) async {
    try {
      ValidatorUtils.validateUuid(id, 'user_id');

      final user = await _userService.getUserById(id);

      if (user == null) {
        return ResponseUtils.error(message: '用户不存在');
      }

      return ResponseUtils.success(
        message: '获取用户详情成功',
        data: user,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取用户详情失败: $id', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(
          code: ApiResponseCode.validationError,
          message: error.message,
        );
      }

      return ResponseUtils.error(
        message: '获取用户详情失败',
      );
    }
  }

  /// 更新用户信息
  Future<Response> _updateUser(Request request, String id) async {
    try {
      ValidatorUtils.validateUuid(id, 'user_id');

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final updateData = <String, dynamic>{};

      if (data.containsKey('display_name')) {
        updateData['display_name'] =
            ValidatorUtils.validateString(data['display_name'], 'display_name', maxLength: 100, required: false);
      }

      if (data.containsKey('phone')) {
        updateData['phone'] = ValidatorUtils.validateString(data['phone'], 'phone', maxLength: 20, required: false);
      }

      if (data.containsKey('avatar_url')) {
        updateData['avatar_url'] = ValidatorUtils.validateUrl(data['avatar_url'], 'avatar_url', required: false);
      }

      if (data.containsKey('timezone')) {
        updateData['timezone'] =
            ValidatorUtils.validateString(data['timezone'], 'timezone', maxLength: 50, required: false);
      }

      if (data.containsKey('locale')) {
        updateData['locale'] = ValidatorUtils.validateString(data['locale'], 'locale', maxLength: 10, required: false);
      }

      if (data.containsKey('is_active')) {
        updateData['is_active'] = ValidatorUtils.validateBool(data['is_active'], 'is_active', required: false);
      }

      final updatedUser = await _userService.updateUser(id, updateData, updatedBy: getCurrentUserId(request));

      return ResponseUtils.success(
        message: '用户信息更新成功',
        data: updatedUser,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新用户信息失败: $id', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(code: ApiResponseCode.validationError, message: error.message);
      }

      if (error is BusinessException) {
        return ResponseUtils.error(code: ApiResponseCode.businessError, message: error.message);
      }

      return ResponseUtils.error(code: ApiResponseCode.internalServerError, message: '更新用户信息失败');
    }
  }

  /// 删除用户
  Future<Response> _deleteUser(Request request, String id) async {
    try {
      ValidatorUtils.validateUuid(id, 'user_id');

      final currentUserId = getCurrentUserId(request);
      if (id == currentUserId) {
        return ResponseUtils.error(
          code: ApiResponseCode.businessError,
          message: '不能删除自己的账户',
        );
      }

      await _userService.deleteUser(id, deletedBy: currentUserId);

      return ResponseUtils.success(message: '用户删除成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('删除用户失败: $id', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(code: ApiResponseCode.validationError, message: error.message);
      }

      if (error is NotFoundException) {
        return ResponseUtils.error(code: ApiResponseCode.notFound, message: '用户不存在');
      }

      return ResponseUtils.error(code: ApiResponseCode.internalServerError, message: '删除用户失败');
    }
  }

  /// 获取当前用户信息
  Future<Response> _getCurrentUser(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: ApiResponseCode.unauthorized, message: '用户信息不存在');
      }

      final user = await _userService.getUserById(userId);

      if (user == null) {
        return ResponseUtils.error(code: ApiResponseCode.notFound, message: '用户不存在');
      }

      return ResponseUtils.success(
        message: '获取当前用户信息成功',
        data: user,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取当前用户信息失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(code: ApiResponseCode.internalServerError, message: '获取用户信息失败');
    }
  }

  /// 更新当前用户信息
  Future<Response> _updateCurrentUser(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: ApiResponseCode.unauthorized, message: '用户信息不存在');
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final updateData = <String, dynamic>{};

      if (data.containsKey('display_name')) {
        updateData['display_name'] =
            ValidatorUtils.validateString(data['display_name'], 'display_name', maxLength: 100, required: false);
      }

      if (data.containsKey('phone')) {
        updateData['phone'] = ValidatorUtils.validateString(data['phone'], 'phone', maxLength: 20, required: false);
      }

      if (data.containsKey('avatar_url')) {
        updateData['avatar_url'] = ValidatorUtils.validateUrl(data['avatar_url'], 'avatar_url', required: false);
      }

      if (data.containsKey('timezone')) {
        updateData['timezone'] =
            ValidatorUtils.validateString(data['timezone'], 'timezone', maxLength: 50, required: false);
      }

      if (data.containsKey('locale')) {
        updateData['locale'] = ValidatorUtils.validateString(data['locale'], 'locale', maxLength: 10, required: false);
      }

      final updatedUser = await _userService.updateUser(userId, updateData, updatedBy: userId);

      return ResponseUtils.success(
        message: '个人信息更新成功',
        data: updatedUser,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('更新当前用户信息失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(code: ApiResponseCode.validationError, message: error.message);
      }

      if (error is BusinessException) {
        return ResponseUtils.error(code: ApiResponseCode.businessError, message: error.message);
      }

      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '更新个人信息失败',
      );
    }
  }

  /// 修改密码
  Future<Response> _changePassword(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(
          code: ApiResponseCode.unauthorized,
          message: '用户信息不存在',
        );
      }

      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final currentPassword = ValidatorUtils.validateString(data['current_password'], 'current_password');
      final newPassword = ValidatorUtils.validateString(data['new_password'], 'new_password', minLength: 8);

      await _userService.changePassword(userId, currentPassword, newPassword);

      return ResponseUtils.success(message: '密码修改成功，请重新登录');
    } catch (error, stackTrace) {
      LoggerUtils.error('修改密码失败', error: error, stackTrace: stackTrace);

      if (error is ValidationException) {
        return ResponseUtils.error(code: ApiResponseCode.validationError, message: error.message);
      }

      if (error is BusinessException) {
        return ResponseUtils.error(code: ApiResponseCode.businessError, message: error.message);
      }

      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '修改密码失败',
      );
    }
  }

  /// 获取用户统计信息
  Future<Response> _getUserStats(Request request) async {
    try {
      final stats = await _userService.getUserStats();

      return ResponseUtils.success(
        message: '获取用户统计信息成功',
        data: stats,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('获取用户统计信息失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '获取统计信息失败',
      );
    }
  }

  /// 上传头像
  Future<Response> _uploadAvatar(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: ApiResponseCode.unauthorized, message: '用户信息不存在');
      }

      // 解析multipart请求
      final contentType = request.headers['content-type'];
      if (contentType == null || !contentType.startsWith('multipart/form-data')) {
        return ResponseUtils.error(
          code: ApiResponseCode.validationError,
          message: '请使用multipart/form-data格式上传文件',
        );
      }

      // 简化实现：从请求体读取文件数据
      final bodyBytes = await request.read().expand((chunk) => chunk).toList();
      final body = Uint8List.fromList(bodyBytes);
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final fileContentType = 'image/jpeg';

      if (body.isEmpty) {
        return ResponseUtils.error(
          code: ApiResponseCode.validationError,
          message: '请选择要上传的头像文件',
        );
      }

      // 清理旧头像
      await _fileUploadService.cleanupOldAvatars(userId);

      // 上传新头像
      final uploadResult = await _fileUploadService.uploadAvatar(
        userId: userId,
        fileData: body,
        fileName: fileName,
        contentType: fileContentType,
      );

      if (!uploadResult.success) {
        return ResponseUtils.error(
          code: ApiResponseCode.businessError,
          message: uploadResult.message ?? '上传头像失败',
        );
      }

      // 更新用户头像URL
      await _userService.updateUser(userId, {
        'avatar_url': uploadResult.url,
      });

      return ResponseUtils.success(
        message: '头像上传成功',
        data: {
          'avatar_url': uploadResult.url,
          'file_name': uploadResult.fileName,
          'file_size': uploadResult.fileSize,
        },
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('上传头像失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '上传头像失败',
      );
    }
  }

  /// 删除头像
  Future<Response> _deleteAvatar(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: ApiResponseCode.unauthorized, message: '用户信息不存在');
      }

      await _userService.updateUser(userId, {'avatar_url': null});
      return ResponseUtils.success(message: '头像删除成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('删除头像失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '删除头像失败',
      );
    }
  }

  /// 获取用户会话
  Future<Response> _getUserSessions(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(
          message: '用户信息不存在',
        );
      }

      final sessions = await _userService.getUserSessions(userId);
      return ResponseUtils.success(message: '获取用户会话成功', data: sessions);
    } catch (error, stackTrace) {
      LoggerUtils.error('获取用户会话失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '获取用户会话失败',
      );
    }
  }

  /// 删除用户会话
  Future<Response> _deleteSession(Request request, String sessionId) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(code: ApiResponseCode.unauthorized, message: '用户信息不存在');
      }

      await _userService.deleteUserSession(userId, sessionId);
      return ResponseUtils.success(message: '会话删除成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('删除用户会话失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(
        code: ApiResponseCode.internalServerError,
        message: '删除会话失败',
      );
    }
  }
}
