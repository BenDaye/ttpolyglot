import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

class LanguageController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;

  LanguageController({
    required this.databaseService,
    required this.redisService,
  }) : super('LanguageController');

  Future<Response> getLanguages(Request request) async {
    return ResponseUtils.success(message: '获取语言列表功能待实现');
  }

  Future<Response> createLanguage(Request request) async {
    return ResponseUtils.success(message: '创建语言功能待实现');
  }

  Future<Response> getLanguage(Request request) async {
    return ResponseUtils.success(message: '获取语言详情功能待实现');
  }

  Future<Response> updateLanguage(Request request) async {
    return ResponseUtils.success(message: '更新语言功能待实现');
  }

  Future<Response> deleteLanguage(Request request) async {
    return ResponseUtils.success(message: '删除语言功能待实现');
  }
}
