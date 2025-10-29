import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

import 'base_seed.dart';

/// 种子: 004 - 插入默认语言
/// 创建时间: 2024-12-26
/// 描述: 插入常用的默认语言数据
class Seed004InsertLanguages extends BaseSeed {
  @override
  String get name => '004_insert_languages';

  @override
  String get description => '插入默认语言';

  @override
  String get createdAt => '2024-12-26';

  @override
  Future<void> run() async {
    try {
      LoggerUtils.info('开始插入默认语言数据');

      // 定义默认语言列表
      final languages = LanguageEnum.toArray()
          .map(
            (item) => {
              'code': item.code.code,
              'name': item.name,
              'native_name': item.nativeName,
              'flag_emoji': item.flagEmoji,
              'is_active': item.isActive,
              'is_rtl': item.isRtl,
              'sort_order': item.sortOrder,
            },
          )
          .toList();

      // 插入语言数据
      await insertData('languages', languages);

      LoggerUtils.info('默认语言数据插入完成，共 ${languages.length} 种语言');
    } catch (error, stackTrace) {
      LoggerUtils.error('插入默认语言数据失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
