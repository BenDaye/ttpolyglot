import 'dart:developer';

/// 迁移: 002 - 创建翻译相关表
/// 创建时间: 2024-12-26
/// 描述: 创建翻译条目、项目语言关联、翻译接口配置等表
class Migration002CreateTranslationTables {
  static const String name = '002_create_translation_tables';
  static const String description = '创建翻译条目、项目语言关联、翻译接口配置等表';
  static const String createdAt = '2024-12-26';

  /// 执行迁移
  static Future<void> up() async {
    try {
      log('开始执行迁移: $name', name: 'Migration002CreateTranslationTables');

      // 1. 项目语言关联表
      await _createProjectLanguagesTable();

      // 2. 用户翻译接口配置表
      await _createUserTranslationProvidersTable();

      // 3. 翻译条目表
      await _createTranslationEntriesTable();

      // 4. 翻译历史表
      await _createTranslationHistoryTable();

      log('迁移完成: $name', name: 'Migration002CreateTranslationTables');
    } catch (error, stackTrace) {
      log('迁移失败: $name', error: error, stackTrace: stackTrace, name: 'Migration002CreateTranslationTables');
      rethrow;
    }
  }

  /// 回滚迁移
  static Future<void> down() async {
    try {
      log('开始回滚迁移: $name', name: 'Migration002CreateTranslationTables');

      // 按相反顺序删除表
      await _dropTranslationHistoryTable();
      await _dropTranslationEntriesTable();
      await _dropUserTranslationProvidersTable();
      await _dropProjectLanguagesTable();

      log('回滚完成: $name', name: 'Migration002CreateTranslationTables');
    } catch (error, stackTrace) {
      log('回滚失败: $name', error: error, stackTrace: stackTrace, name: 'Migration002CreateTranslationTables');
      rethrow;
    }
  }

  /// 创建项目语言关联表
  static Future<void> _createProjectLanguagesTable() async {
    log('创建项目语言关联表', name: 'Migration002CreateTranslationTables');
  }

  /// 创建用户翻译接口配置表
  static Future<void> _createUserTranslationProvidersTable() async {
    log('创建用户翻译接口配置表', name: 'Migration002CreateTranslationTables');
  }

  /// 创建翻译条目表
  static Future<void> _createTranslationEntriesTable() async {
    log('创建翻译条目表', name: 'Migration002CreateTranslationTables');
  }

  /// 创建翻译历史表
  static Future<void> _createTranslationHistoryTable() async {
    log('创建翻译历史表', name: 'Migration002CreateTranslationTables');
  }

  /// 删除翻译历史表
  static Future<void> _dropTranslationHistoryTable() async {
    log('删除翻译历史表', name: 'Migration002CreateTranslationTables');
  }

  /// 删除翻译条目表
  static Future<void> _dropTranslationEntriesTable() async {
    log('删除翻译条目表', name: 'Migration002CreateTranslationTables');
  }

  /// 删除用户翻译接口配置表
  static Future<void> _dropUserTranslationProvidersTable() async {
    log('删除用户翻译接口配置表', name: 'Migration002CreateTranslationTables');
  }

  /// 删除项目语言关联表
  static Future<void> _dropProjectLanguagesTable() async {
    log('删除项目语言关联表', name: 'Migration002CreateTranslationTables');
  }
}
