import 'dart:convert';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 用户管理控制器
class UserController extends BaseController {
  final UserService _userService;
  final FileUploadService _fileUploadService;

  UserController({
    required UserService userService,
    required FileUploadService fileUploadService,
  })  : _userService = userService,
        _fileUploadService = fileUploadService,
        super('UserController');

  Router get router {
    final router = Router();

    // 需要认证的路由
    // 注意：具体路由必须在参数化路由之前定义
    router.get('/', _getUsers);
    router.get('/search', _searchUsers);
    router.get('/me', _getCurrentUser);
    router.put('/me', _updateCurrentUser);
    router.post('/me/change-password', _changePassword);

    return router;
  }

  // 公共方法用于路由配置
  Future<Response> Function(Request) get getUsers => _getUsers;
  Future<Response> Function(Request) get searchUsers => _searchUsers;
  Future<Response> Function(Request) get me => _getCurrentUser;
  Future<Response> Function(Request) get getCurrentUser => _getCurrentUser;
  Future<Response> Function(Request) get updateCurrentUser => _updateCurrentUser;
  Future<Response> Function(Request) get changePassword => _changePassword;
  Future<Response> Function(Request) get uploadAvatar => _uploadAvatar;
  Future<Response> Function(Request) get deleteAvatar => _deleteAvatar;

  /// 获取用户列表
  Future<Response> _getUsers(Request request) async {
    try {
      final params = request.url.queryParameters;
      final page = int.tryParse(params['page'] ?? '1') ?? 1;
      final limit = int.tryParse(params['limit'] ?? '20') ?? 20;

      if (page < 1 || limit < 1 || limit > 100) {
        return ResponseUtils.error(
          message: '分页参数无效',
        );
      }

      final users = await _userService.getUsers(
        page: page,
        limit: limit,
        search: params['search'],
        status: params['status'],
        role: params['role'],
      );

      return ResponseUtils.success<PagerModel<UserInfoModel>>(
        data: users,
        message: '获取用户列表成功',
      );
    } catch (error, stackTrace) {
      ServerLogger.error('获取用户列表失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '获取用户列表失败',
      );
    }
  }

  /// 获取当前用户信息
  Future<Response> _getCurrentUser(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '用户信息不存在');
      }

      final user = await _userService.getUserById(userId);

      if (user == null) {
        return ResponseUtils.error(message: '用户不存在');
      }

      return ResponseUtils.success(
        message: '获取当前用户信息成功',
        data: user,
      );
    } catch (error, stackTrace) {
      ServerLogger.error('获取当前用户信息失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(message: error is ServerException ? error.message : '获取用户信息失败');
    }
  }

  /// 更新当前用户信息
  Future<Response> _updateCurrentUser(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '用户信息不存在');
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

      final updatedUser = await _userService.updateUser(userId, updateData, updatedBy: userId);

      return ResponseUtils.success(
        message: '个人信息更新成功',
        data: updatedUser,
      );
    } catch (error, stackTrace) {
      ServerLogger.error('更新当前用户信息失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '更新个人信息失败',
      );
    }
  }

  /// 搜索用户
  Future<Response> _searchUsers(Request request) async {
    try {
      final params = request.url.queryParameters;
      final query = params['q'] ?? params['query'] ?? '';
      final limitParam = params['limit'] ?? '10';
      final limit = int.tryParse(limitParam) ?? 10;
      final includeSelf = params['include_self'] == 'true';

      if (query.trim().isEmpty) {
        return ResponseUtils.success<List<UserSearchResultModel>>(
          data: [],
          message: '请输入搜索关键词',
        );
      }

      if (limit < 1 || limit > 50) {
        return ResponseUtils.error(message: '限制参数无效（1-50）');
      }

      final userId = getCurrentUserId(request);
      final users = await _userService.searchUsers(
        query: query,
        limit: limit,
        excludeUserId: includeSelf ? null : userId,
      );

      return ResponseUtils.success<List<UserSearchResultModel>>(
        data: users,
        message: '搜索用户成功',
      );
    } catch (error, stackTrace) {
      ServerLogger.error(
        '搜索用户失败',
        error: error,
        stackTrace: stackTrace,
      );

      return ResponseUtils.error(message: error is ServerException ? error.message : '搜索用户失败');
    }
  }

  /// 修改密码
  Future<Response> _changePassword(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(
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
      ServerLogger.error('修改密码失败', error: error, stackTrace: stackTrace);

      return ResponseUtils.error(
        message: error is ServerException ? error.message : '修改密码失败',
      );
    }
  }

  /// 上传头像
  Future<Response> _uploadAvatar(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '用户信息不存在');
      }

      // 解析multipart请求
      final contentType = request.headers['content-type'];
      if (contentType == null || !contentType.startsWith('multipart/form-data')) {
        return ResponseUtils.error(
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

      if (uploadResult == null) {
        return ResponseUtils.error(
          message: '上传头像失败',
        );
      }

      // 更新用户头像URL
      await _userService.updateUser(userId, {
        'avatar_url': uploadResult.path,
      });

      return ResponseUtils.success<FileModel>(
        message: '头像上传成功',
        data: uploadResult,
      );
    } catch (error, stackTrace) {
      ServerLogger.error('上传头像失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(
        message: error is ServerException ? error.message : '上传头像失败',
      );
    }
  }

  /// 删除头像
  Future<Response> _deleteAvatar(Request request) async {
    try {
      final userId = getCurrentUserId(request);
      if (userId == null) {
        return ResponseUtils.error(message: '用户信息不存在');
      }

      await _userService.updateUser(userId, {'avatar_url': null});
      return ResponseUtils.success(message: '头像删除成功');
    } catch (error, stackTrace) {
      ServerLogger.error('删除头像失败', error: error, stackTrace: stackTrace);
      return ResponseUtils.error(
        message: error is ServerException ? error.message : '删除头像失败',
      );
    }
  }
}
