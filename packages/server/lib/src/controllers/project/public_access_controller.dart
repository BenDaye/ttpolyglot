import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

/// 公开访问控制器
///
/// 提供无需认证的翻译数据访问接口，
/// 通过项目 UUID 标识项目，仅返回 `entry_key`、`source_language`、
/// `source_text`、`target_languages` 四个字段。
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
  /// `GET /public/projects/{uuid}/translations?page=1&limit=1000`
  ///
  /// 查询参数:
  /// - `page`: 页码，默认 1
  /// - `limit`: 每页条目数，默认/最大 1000
  Future<Response> getTranslations(Request request, String uuid) async {
    return execute(
      () async {
        // 通过 UUID 查找项目
        final projectResult = await _databaseService.query(
          'SELECT id FROM {projects} WHERE uuid = @uuid::uuid AND is_active = true',
          {'uuid': uuid},
        );

        if (projectResult.isEmpty) {
          throw NotFoundException(message: '项目不存在');
        }

        final projectId = int.tryParse(projectResult.first.toColumnMap()['id'].toString()) ?? 0;

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

        // 过滤字段：仅返回 entry_key, source_language, source_text, target_languages
        final filteredItems = result.items?.map((entry) => {
              'entry_key': entry.entryKey,
              'source_language': entry.sourceLanguage.code,
              'target_languages': entry.targetLanguages.map((t) => t.toJson()).toList(),
              'source_text': entry.sourceText,
            }).toList();

        final filteredResult = {
          'page': result.page,
          'page_size': result.pageSize,
          'total_size': result.totalSize,
          'total_page': result.totalPage,
          'items': filteredItems,
        };

        return ResponseUtils.success<Map<String, dynamic>>(
          message: '获取翻译数据成功',
          data: filteredResult,
        );
      },
      operationName: 'getTranslations',
    );
  }
}
