import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

import '../../exceptions/exceptions.dart';
import '../../services/business/language_service.dart';
import '../../utils/http/response_utils.dart';

/// 语言控制器
class LanguageController {
  final LanguageService _languageService;

  LanguageController({required LanguageService languageService}) : _languageService = languageService;

  /// 配置路由
  Router get router {
    final router = Router();

    // 获取所有语言列表（公开接口，无需认证）
    router.get('/languages', _getLanguages);

    // 获取单个语言详情（公开接口，无需认证）
    router.get('/languages/<code>', _getLanguageByCode);

    // 刷新语言缓存（需要管理员权限）
    router.post('/languages/refresh-cache', _refreshCache);

    return router;
  }

  /// 获取所有语言列表
  Future<Response> _getLanguages(Request request) async {
    try {
      LoggerUtils.info('获取语言列表');

      // 解析查询参数
      final queryParams = request.url.queryParameters;
      final includeInactive = queryParams['include_inactive'] == 'true';

      final languages = await _languageService.getLanguages(includeInactive: includeInactive);

      return ResponseUtils.success<List<LanguageModel>>(
        message: '获取语言列表成功',
        data: languages,
      );
    } catch (error) {
      LoggerUtils.error('获取语言列表失败: error=$error');
      return ResponseUtils.error(message: error is ServerException ? error.message : '获取语言列表失败');
    }
  }

  /// 获取单个语言详情
  Future<Response> _getLanguageByCode(Request request, String code) async {
    try {
      LoggerUtils.info('获取语言详情: code=$code');

      final language = await _languageService.getLanguageByCode(code);

      if (language == null) {
        return ResponseUtils.error(
          message: '语言不存在',
        );
      }

      return ResponseUtils.success<LanguageModel>(
        message: '获取语言详情成功',
        data: language,
      );
    } catch (error) {
      LoggerUtils.error('获取语言详情失败: code=$code, error=$error');
      return ResponseUtils.error(message: error is ServerException ? error.message : '获取语言详情失败');
    }
  }

  /// 刷新语言缓存
  Future<Response> _refreshCache(Request request) async {
    try {
      // 这里应该检查用户权限（需要管理员权限）
      // final userId = getCurrentUserId(request);
      // if (!await _userService.isAdmin(userId)) {
      //   return ResponseUtils.error(code: DataCodeEnum.forbidden, data: '需要管理员权限');
      // }

      LoggerUtils.info('刷新语言缓存');

      await _languageService.refreshCache();

      return ResponseUtils.success(message: '刷新语言缓存成功');
    } catch (error) {
      LoggerUtils.error('刷新语言缓存失败: error=$error');
      return ResponseUtils.error(message: error is ServerException ? error.message : '刷新语言缓存失败');
    }
  }
}
