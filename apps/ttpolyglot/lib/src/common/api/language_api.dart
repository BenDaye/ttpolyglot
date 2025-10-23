import 'dart:developer';

import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_model/model.dart';

/// 语言 API
class LanguageApi {
  /// 获取所有语言列表
  ///
  /// 从API获取语言列表，如果失败则返回默认语言列表
  Future<List<LanguageModel>> getLanguages({bool includeInactive = false}) async {
    try {
      log('[getLanguages] 暂时返回默认语言列表', name: 'LanguageApi');
      final response = await HttpClient.get('/languages');
      final data = response.data as List<dynamic>;
      final languages = data.map((item) => LanguageModel.fromJson(item as Map<String, dynamic>)).toList();
      if (languages.isNotEmpty) {
        return languages;
      }
      return LanguageEnum.toArray();
    } catch (error, stackTrace) {
      log('[getLanguages]', error: error, stackTrace: stackTrace, name: 'LanguageApi');
      return LanguageEnum.toArray();
    }
  }

  /// 根据代码获取语言
  Future<LanguageModel?> getLanguageByCode(LanguageEnum code) async {
    try {
      return LanguageEnum.toArray().firstWhere((lang) => lang.code == code);
    } catch (error, stackTrace) {
      log('[getLanguageByCode]', error: error, stackTrace: stackTrace, name: 'LanguageApi');
      return null;
    }
  }
}
