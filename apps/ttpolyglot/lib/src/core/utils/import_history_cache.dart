import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ttpolyglot_model/model.dart';

/// 导入历史缓存服务
class ImportHistoryCache {
  static const String _cacheKey = 'import_history';
  static const int _maxHistoryPerProject = 5;

  static Future<void> saveImportHistory(String projectId, ImportHistoryItemModel item) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';

    // 获取现有历史记录
    final historyList = await getImportHistory(projectId);

    // 添加新记录到开头
    historyList.insert(0, item);

    // 限制每个项目最多5条记录
    if (historyList.length > _maxHistoryPerProject) {
      historyList.removeRange(_maxHistoryPerProject, historyList.length);
    }

    // 保存到缓存
    final jsonList = historyList.map((item) => item.toJson()).toList();
    await prefs.setString(key, jsonEncode(jsonList));
  }

  static Future<List<ImportHistoryItemModel>> getImportHistory(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';

    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((json) => ImportHistoryItemModel.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<void> clearImportHistory(String projectId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_cacheKey:$projectId';
    await prefs.remove(key);
  }
}
