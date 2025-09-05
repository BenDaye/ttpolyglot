/// TTPolyglot 核心包
///
/// 提供翻译管理平台的核心数据模型、业务逻辑和接口定义
library;

export 'src/enums/sync_status.dart';
export 'src/enums/translation_key.dart';
// 常量和枚举
export 'src/enums/translation_status.dart';
export 'src/enums/user_role.dart';
export 'src/models/export.dart';
// 数据模型
export 'src/models/language.dart';
export 'src/models/project.dart';
export 'src/models/translation_entry.dart';
export 'src/models/user.dart';
export 'src/models/workspace_config.dart';
// 服务接口
export 'src/services/export_service.dart';
export 'src/services/project_service.dart';
export 'src/services/storage_service.dart';
export 'src/services/sync_service.dart';
export 'src/services/translation_service.dart';
export 'src/services/workspace_service.dart';
export 'src/utils/data_migration_validator.dart';
export 'src/utils/source_language_validator.dart';
// 工具类
export 'src/utils/translation_utils.dart';
