import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

class LanguageController {
  final DatabaseService databaseService;
  final RedisService redisService;

  LanguageController({
    required this.databaseService,
    required this.redisService,
  });

  Future<Response> getLanguages(Request request) async {
    return ResponseBuilder.success(message: '获取语言列表功能待实现');
  }

  Future<Response> createLanguage(Request request) async {
    return ResponseBuilder.success(message: '创建语言功能待实现');
  }

  Future<Response> getLanguage(Request request) async {
    return ResponseBuilder.success(message: '获取语言详情功能待实现');
  }

  Future<Response> updateLanguage(Request request) async {
    return ResponseBuilder.success(message: '更新语言功能待实现');
  }

  Future<Response> deleteLanguage(Request request) async {
    return ResponseBuilder.success(message: '删除语言功能待实现');
  }
}
