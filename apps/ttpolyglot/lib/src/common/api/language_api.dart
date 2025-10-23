import 'dart:developer';

import 'package:ttpolyglot_model/model.dart';

/// 语言 API
class LanguageApi {
  /// 获取所有语言列表
  ///
  /// 从API获取语言列表，如果失败则返回默认语言列表
  Future<List<LanguageModel>> getLanguages({bool includeInactive = false}) async {
    try {
      // TODO: 实现实际的API调用
      // 暂时返回默认语言列表
      log('[getLanguages] 暂时返回默认语言列表', name: 'LanguageApi');
      return getDefaultLanguages();

      // 未来实现：
      // final response = await dio.get('/api/languages', queryParameters: {...});
      // return parse response...
    } catch (error, stackTrace) {
      log('[getLanguages]', error: error, stackTrace: stackTrace, name: 'LanguageApi');
      // API 失败时返回默认语言列表
      return getDefaultLanguages();
    }
  }

  /// 根据代码获取语言
  Future<LanguageModel?> getLanguageByCode(String code) async {
    try {
      // TODO: 实现实际的API调用
      // 暂时从默认列表查找
      final languages = getDefaultLanguages();
      return languages.firstWhere(
        (lang) => lang.code.code == code,
        orElse: () => languages.first,
      );
    } catch (error, stackTrace) {
      log('[getLanguageByCode]', error: error, stackTrace: stackTrace, name: 'LanguageApi');
      return null;
    }
  }

  /// 获取默认语言列表（降级方案）
  static List<LanguageModel> getDefaultLanguages() {
    return LanguageEnum.values.asMap().entries.map((entry) {
      final index = entry.key;
      final lang = entry.value;

      return LanguageModel(
        id: index + 1,
        code: lang,
        name: lang.name,
        nativeName: lang.nativeName,
        flagEmoji: lang.flagEmoji,
        isActive: true,
        isRtl: false,
        sortOrder: index + 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }).toList();
  }
}
