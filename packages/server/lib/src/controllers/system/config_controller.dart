import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:ttpolyglot_server/server.dart';

import '../base_controller.dart';

class ConfigController extends BaseController {
  final DatabaseService databaseService;
  final RedisService redisService;
  late final ConfigService _configService;

  ConfigController({
    required this.databaseService,
    required this.redisService,
  })  : _configService = ConfigService(
          databaseService: databaseService,
          redisService: redisService,
        ),
        super('ConfigController');

  Future<Response> getConfigs(Request request) async {
    return execute(
      () async {
        final params = request.url.queryParameters;
        final category = params['category'];
        final isPublic = params['is_public'] == 'true' ? true : (params['is_public'] == 'false' ? false : null);
        final isEditable = params['is_editable'] == 'true' ? true : (params['is_editable'] == 'false' ? false : null);
        final page = int.tryParse(params['page'] ?? '1') ?? 1;
        final limit = int.tryParse(params['limit'] ?? '50') ?? 50;

        final configs = await _configService.getConfigs(
          category: category,
          isPublic: isPublic,
          isEditable: isEditable,
          page: page,
          limit: limit,
        );

        return ResponseUtils.success(
          message: '获取配置列表成功',
          data: configs.map((c) => c.toJson()).toList(),
        );
      },
      operationName: 'getConfigs',
    );
  }

  Future<Response> getPublicConfigs(Request request) async {
    return execute(
      () async {
        final configs = await _configService.getPublicConfigs();

        return ResponseUtils.success(
          message: '获取公开配置成功',
          data: configs,
        );
      },
      operationName: 'getPublicConfigs',
    );
  }

  Future<Response> getConfig(Request request, String key) async {
    return execute(
      () async {
        final config = await _configService.getConfigByKey(key);
        if (config == null) {
          throw NotFoundException(message: '配置不存在');
        }

        return ResponseUtils.success(
          message: '获取配置详情成功',
          data: config.toJson(),
        );
      },
      operationName: 'getConfig',
    );
  }

  Future<Response> updateConfig(Request request, String key) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final value = data['value']?.toString();

        if (value == null) {
          throw ValidationException(message: '配置值不能为空');
        }

        final updatedBy = getCurrentUserId(request);
        final reason = data['reason']?.toString();

        final config = await _configService.updateConfig(
          key: key,
          value: value,
          updatedBy: updatedBy,
          reason: reason,
        );

        return ResponseUtils.success(
          message: '更新配置成功',
          data: config.toJson(),
        );
      },
      operationName: 'updateConfig',
    );
  }

  Future<Response> createConfig(Request request) async {
    return execute(
      () async {
        // 创建配置通常需要管理员权限，这里简化处理
        // 实际应该调用 ConfigService 的创建方法，但 ConfigService 中没有创建方法
        // 所以这里返回错误提示
        throw BusinessException(message: '配置创建功能需要数据库直接操作，请使用数据库管理工具');
      },
      operationName: 'createConfig',
    );
  }

  Future<Response> deleteConfig(Request request, String key) async {
    return execute(
      () async {
        // 删除配置通常需要管理员权限，这里简化处理
        // 实际应该调用 ConfigService 的删除方法，但 ConfigService 中没有删除方法
        // 所以这里返回错误提示
        throw BusinessException(message: '配置删除功能需要数据库直接操作，请使用数据库管理工具');
      },
      operationName: 'deleteConfig',
    );
  }

  Future<Response> getConfigCategories(Request request) async {
    return execute(
      () async {
        final categories = await _configService.getConfigCategories();

        return ResponseUtils.success(
          message: '获取配置分类成功',
          data: categories,
        );
      },
      operationName: 'getConfigCategories',
    );
  }

  Future<Response> batchUpdateConfigs(Request request) async {
    return execute(
      () async {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final updates = data['updates'] as Map<String, dynamic>?;

        if (updates == null || updates.isEmpty) {
          throw ValidationException(message: '更新列表不能为空');
        }

        final updatesMap = <String, String>{};
        for (final entry in updates.entries) {
          updatesMap[entry.key] = entry.value.toString();
        }

        final updatedBy = getCurrentUserId(request);
        final reason = data['reason']?.toString();

        final configs = await _configService.updateConfigs(
          updates: updatesMap,
          updatedBy: updatedBy,
          reason: reason,
        );

        return ResponseUtils.success(
          message: '批量更新配置成功',
          data: configs.map((c) => c.toJson()).toList(),
        );
      },
      operationName: 'batchUpdateConfigs',
    );
  }

  Future<Response> resetConfig(Request request, String key) async {
    return execute(
      () async {
        final updatedBy = getCurrentUserId(request);
        final config = await _configService.resetConfigToDefault(key, updatedBy: updatedBy);

        return ResponseUtils.success(
          message: '重置配置成功',
          data: config.toJson(),
        );
      },
      operationName: 'resetConfig',
    );
  }
}
