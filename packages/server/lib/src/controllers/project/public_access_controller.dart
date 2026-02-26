import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 公开访问控制器
///
/// 提供无需认证的翻译数据访问接口，
/// 通过项目 ID 标识项目，返回和导出 JSON 相同格式的翻译数据。
class PublicAccessController extends BaseController {
  final DatabaseService _databaseService;
  late final TranslationService _translationService;

  /// 默认每页条目数
  static const int _defaultLimit = 1000;

  PublicAccessController({
    required DatabaseService databaseService,
  })  : _databaseService = databaseService,
        _translationService = TranslationService(databaseService: databaseService),
        super('PublicAccessController');

  /// 公开获取项目翻译数据（分页）
  ///
  /// `GET /public/projects/{id}/translations?page=1&limit=1000`
  ///
  /// 查询参数:
  /// - `page`: 页码，默认 1
  /// - `limit`: 每页条目数，默认/最大 1000
  Future<Response> getTranslations(Request request, String id) async {
    return execute(
      () async {
        final projectId = int.tryParse(id);
        if (projectId == null) {
          throw ValidationException(message: '项目ID格式无效');
        }

        // 验证项目存在且处于活跃状态
        final projectResult = await _databaseService.query(
          'SELECT id FROM {projects} WHERE id = @id AND is_active = true',
          {'id': projectId},
        );

        if (projectResult.isEmpty) {
          throw NotFoundException(message: '项目不存在');
        }

        // 读取查询参数
        final params = request.url.queryParameters;
        final page = (int.tryParse(params['page'] ?? '') ?? 1).clamp(1, 9999);
        final limit = (int.tryParse(params['limit'] ?? '') ?? _defaultLimit).clamp(1, _defaultLimit);

        // 使用 PagerModel 分页获取翻译数据
        final result = await _translationService.getTranslationEntries(
          projectId: projectId,
          page: page,
          limit: limit,
        );

        return ResponseUtils.success<PagerModel<TranslationEntryModel>>(
          message: '获取翻译数据成功',
          data: result,
        );
      },
      operationName: 'getTranslations',
    );
  }
}
