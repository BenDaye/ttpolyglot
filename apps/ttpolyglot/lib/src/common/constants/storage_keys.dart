/// 存储键常量类
class StorageKeys {
  StorageKeys._();

  // 用户相关
  static const String userToken = 'user_token';
  static const String userId = 'user_id';
  static const String userInfo = 'user_info';
  static const String userSettings = 'user_settings';
  static const String lastLoginTime = 'last_login_time';

  // 项目相关
  static const String currentProjectId = 'current_project_id';
  static const String recentProjects = 'recent_projects';
  static const String projectList = 'project_list';
  
  // 项目相关方法（需要拼接 projectId）
  static String projectCache(String projectId) => 'project_cache_$projectId';
  static String projectSettings(String projectId) => 'project_settings_$projectId';
  static String projectConfig(String projectId) => 'project_config_$projectId';
  static String projectDatabase(String projectId) => 'project_database_$projectId';

  // 翻译相关
  static const String translationCache = 'translation_cache';
  static const String translationHistory = 'translation_history';
  static const String translationDraft = 'translation_draft';

  // 语言相关
  static const String selectedLanguage = 'selected_language';
  static const String languagePreferences = 'language_preferences';

  // UI状态
  static const String themeMode = 'theme_mode';
  static const String sidebarCollapsed = 'sidebar_collapsed';
  static const String lastViewMode = 'last_view_mode';

  // 其他
  static const String appVersion = 'app_version';
  static const String firstLaunch = 'first_launch';
  static const String lastUpdateCheck = 'last_update_check';
}
