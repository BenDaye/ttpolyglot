import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 公开访问控制器
///
/// 提供无需认证的翻译数据访问接口，
/// 通过项目 slug 标识项目，返回和导出 JSON 相同格式的翻译数据。
/// 仅允许访问可见性为 public 且状态为 active 的项目。
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
  /// `GET /public/projects/{slug}/translations?page=1&limit=1000`
  ///
  /// 查询参数:
  /// - `page`: 页码，默认 1
  /// - `limit`: 每页条目数，默认/最大 1000
  Future<Response> getTranslations(Request request, String slug) async {
    return execute(
      () async {
        // 通过 slug 查找项目
        final projectResult = await _databaseService.query(
          'SELECT id, status, visibility FROM {projects} WHERE slug = @slug AND is_active = true',
          {'slug': slug},
        );

        // 项目不存在时统一返回 404，避免泄露私有项目的存在
        if (projectResult.isEmpty) {
          throw NotFoundException(message: '项目不存在');
        }

        final projectData = projectResult.first.toColumnMap();
        final visibility = projectData['visibility'] as String?;
        final status = projectData['status'] as String?;

        // 仅允许访问公开且活跃的项目
        if (visibility != 'public' || status != 'active') {
          throw NotFoundException(message: '项目不存在');
        }

        final projectId = projectData['id'] as int;

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

        // 公开接口使用 ResponseUtils 返回标准 PagerModel 格式，
        // 与项目内部翻译列表接口保持一致
        return ResponseUtils.success<PagerModel<TranslationEntryModel>>(
          message: '获取翻译数据成功',
          data: result,
        );
      },
      operationName: 'getTranslations',
    );
  }
}
