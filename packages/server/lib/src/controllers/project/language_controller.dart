import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

class LanguageController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;
  late final ProjectService _projectService;

  LanguageController({
    required this.databaseService,
    required this.redisService,
  })  : _projectService = ProjectService(
          databaseService: databaseService,
          redisService: redisService,
        ),
        super('LanguageController');

  /// 获取项目的语言列表
  Future<Response> getLanguages(Request request, String projectId) async {
    return execute(
      () async {
        final languages = await _projectService.getProjectLanguages(projectId);

        return ResponseUtils.success(
          message: '获取项目语言列表成功',
          data: languages.map((lang) => lang.toJson()).toList(),
        );
      },
      operationName: 'getLanguages',
    );
  }

  /// 向项目添加语言
  Future<Response> createLanguage(Request request, String projectId) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;

        final languageId = data['language_id'];
        if (languageId == null) {
          throw ValidationException(message: 'language_id 不能为空');
        }

        final languageIdInt = languageId is int ? languageId : int.parse(languageId.toString());

        await _projectService.addProjectLanguage(projectId, languageIdInt);

        return ResponseUtils.success(message: '添加项目语言成功');
      },
      operationName: 'createLanguage',
    );
  }

  /// 获取项目语言详情
  Future<Response> getLanguage(Request request, String projectId, String languageId) async {
    return execute(
      () async {
        final langId = int.tryParse(languageId);
        if (langId == null) {
          throw ValidationException(message: '语言ID格式无效');
        }

        final languages = await _projectService.getProjectLanguages(projectId);
        final language = languages.firstWhere(
          (lang) => lang.id == langId,
          orElse: () => throw NotFoundException(message: '项目语言不存在'),
        );

        return ResponseUtils.success(
          message: '获取项目语言详情成功',
          data: language.toJson(),
        );
      },
      operationName: 'getLanguage',
    );
  }

  /// 更新项目语言设置
  Future<Response> updateLanguage(Request request, String projectId, String languageId) async {
    return execute(
      () async {
        final langId = int.tryParse(languageId);
        if (langId == null) {
          throw ValidationException(message: '语言ID格式无效');
        }

        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final settings = data['settings'] as Map<String, dynamic>? ?? {};

        await _projectService.updateLanguageSettings(projectId, langId, settings);

        return ResponseUtils.success(message: '更新项目语言设置成功');
      },
      operationName: 'updateLanguage',
    );
  }

  /// 从项目删除语言
  Future<Response> deleteLanguage(Request request, String projectId, String languageId) async {
    return execute(
      () async {
        final langId = int.tryParse(languageId);
        if (langId == null) {
          throw ValidationException(message: '语言ID格式无效');
        }

        await _projectService.removeProjectLanguage(projectId, langId);

        return ResponseUtils.success(message: '删除项目语言成功');
      },
      operationName: 'deleteLanguage',
    );
  }
}
