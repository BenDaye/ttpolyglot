// 数据库迁移导出文件
// 创建时间: 2024-12-26
// 描述: 统一导出所有数据库迁移

// 核心表迁移
export '001_users_table.dart';
export '002_roles_table.dart';
export '003_permissions_table.dart';
export '004_role_permissions_table.dart';
export '005_languages_table.dart';
export '006_projects_table.dart';
export '007_user_roles_table.dart';
// 翻译相关表迁移
export '008_project_languages_table.dart';
export '009_user_translation_providers_table.dart';
export '010_translation_entries_table.dart';
export '011_translation_history_table.dart';
// 系统管理表迁移
export '012_system_configs_table.dart';
export '013_user_sessions_table.dart';
export '014_file_uploads_table.dart';
export '015_notifications_table.dart';
export '016_audit_logs_table.dart';
// 基础类
export 'base_migration.dart';
// 迁移管理器
export 'migration_manager.dart';
