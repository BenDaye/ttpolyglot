import 'dart:developer';

import 'package:ttpolyglot/src/common/network/network.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 语言 API
class LanguageApi {
  /// 获取所有语言列表
  ///
  /// 从API获取语言列表，如果失败则返回默认语言列表
  Future<List<LanguageModel>> getLanguages({bool includeInactive = false}) async {
    try {
      final response = await HttpClient.get('/languages');
      final languages = ModelUtils.toModelArray(
        response.data,
        (json) => LanguageModel.fromJson(json),
      );
      if (languages == null) {
        LoggerUtils.error('获取语言列表响应数据为空');
        return LanguageEnum.toArray();
      }
      log('[getLanguages] 从API获取到 ${languages.length} 个语言', name: 'LanguageApi');
      return languages.toList();
    } catch (error, stackTrace) {
      log('[getLanguages] API请求失败，返回默认语言列表', error: error, stackTrace: stackTrace, name: 'LanguageApi');
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
