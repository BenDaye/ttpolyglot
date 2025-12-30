import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 项目数据初始化器
class ProjectDataInitializer {
  /// 创建预设的语言列表
  static List<LanguageEnum> getPresetLanguages() {
    return LanguageEnum.toArray().map((lang) => lang.code).toList();
  }

  /// 根据语言代码获取语言对象
  static LanguageEnum? getLanguageByCode(String code) {
    try {
      return getPresetLanguages().firstWhere((lang) => lang.code == code);
    } catch (error, stackTrace) {
      LoggerUtils.error('getLanguageByCode', error: error, stackTrace: stackTrace);
      return null;
    }
  }
}
