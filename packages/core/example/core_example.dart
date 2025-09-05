import 'package:ttpolyglot_core/core.dart';

void main() {
  print('TTPolyglot Core 多项目管理示例');
  print('=' * 40);

  // 创建语言实例
  final english = Language(
    code: 'en-US',
    name: 'English (United States)',
    nativeName: 'English (United States)',
  );

  final chinese = Language(
    code: 'zh-CN',
    name: 'Chinese (Simplified)',
    nativeName: '中文（简体）',
  );

  print('\n1. 语言管理:');
  print('- $english');
  print('- $chinese');

  // 展示支持的语言列表功能
  print('\n2. 支持的语言列表:');
  print('总共支持 ${Language.supportedLanguages.length} 种语言');

  // 显示前 10 种支持的语言
  print('前 10 种支持的语言:');
  for (int i = 0; i < 10 && i < Language.supportedLanguages.length; i++) {
    final lang = Language.supportedLanguages[i];
    print('  ${i + 1}. ${lang.code} - ${lang.name} (${lang.nativeName})');
  }

  // 测试语言代码验证
  print('\n3. 语言代码验证:');
  final testCodes = ['en-US', 'zh-CN', 'en', 'zh', 'fr-FR', 'invalid'];
  for (final code in testCodes) {
    final isValid = Language.isValidLanguageCode(code);
    final isSupported = Language.isLanguageSupported(code);
    print('  $code: 格式${isValid ? '正确' : '错误'}, ${isSupported ? '支持' : '不支持'}');
  }

  // 测试语言搜索
  print('\n4. 语言搜索:');
  final searchResults = Language.searchSupportedLanguages('Chinese');
  print('搜索 "Chinese" 的结果:');
  for (final lang in searchResults) {
    print('  - ${lang.code}: ${lang.name}');
  }

  // 测试按语言分组
  print('\n5. 按语言分组:');
  final groupedLanguages = Language.supportedLanguagesByGroup;
  print('支持的语言组数量: ${groupedLanguages.length}');

  // 显示中文和英文的变体
  if (groupedLanguages.containsKey('zh')) {
    print('中文变体:');
    for (final lang in groupedLanguages['zh']!) {
      print('  - ${lang.code}: ${lang.nativeName}');
    }
  }

  if (groupedLanguages.containsKey('en')) {
    print('英文变体:');
    for (final lang in groupedLanguages['en']!) {
      print('  - ${lang.code}: ${lang.name}');
    }
  }

  // 创建用户实例
  final user = User(
    id: 'user-1',
    email: 'admin@example.com',
    name: 'Admin User',
    role: UserRole.admin,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('\n6. 用户管理:');
  print('User: $user');
  print('Can manage project: ${user.role.canManageProject}');
  print('Can translate: ${user.role.canTranslate}');

  // 创建项目设置
  final projectSettings = ProjectSettings(
    autoSync: true,
    allowEmptyTranslations: false,
    requireReview: true,
    maxKeyLength: 50,
    keyPattern: r'^[a-zA-Z][a-zA-Z0-9._-]*$',
  );

  // 创建项目实例
  final project = Project(
    id: 'project-1',
    name: 'Web App',
    description: '主要的 Web 应用项目',
    primaryLanguage: english,
    targetLanguages: [chinese],
    owner: user,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    settings: projectSettings,
  );

  print('\n7. 项目管理:');
  print('Project: ${project.name}');
  print('Languages: ${project.allLanguages.map((l) => l.code).join(', ')}');
  print('Settings: Auto-sync: ${project.settings?.autoSync}, Max key length: ${project.settings?.maxKeyLength}');

  // 创建项目成员
  final projectMember = ProjectMember(
    user: user,
    role: ProjectRole.owner,
    joinedAt: DateTime.now(),
  );

  print('\n8. 项目成员管理:');
  print('Member: ${projectMember.user.name} (${projectMember.role.displayName})');
  print('Permissions: Read: ${projectMember.role.canRead}, Write: ${projectMember.role.canWrite}');

  // 创建工作空间配置
  final workspacePreferences = WorkspacePreferences(
    defaultLanguage: 'en-US',
    theme: 'auto',
    autoSync: true,
    maxRecentProjects: 5,
  );

  final workspaceConfig = WorkspaceConfig(
    version: '1.0.0',
    user: user,
    currentProjectId: project.id,
    preferences: workspacePreferences,
    recentProjects: [project.id],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('\n9. 工作空间管理:');
  print('Version: ${workspaceConfig.version}');
  print('Current project: ${workspaceConfig.currentProjectId}');
  print('Recent projects: ${workspaceConfig.recentProjects.length}');
  print('Preferences: Theme: ${workspaceConfig.preferences.theme}, Auto-sync: ${workspaceConfig.preferences.autoSync}');

  // 创建项目引用
  final projectReference = ProjectReference(
    id: project.id,
    name: project.name,
    path: '/path/to/web-app',
    lastAccessed: DateTime.now(),
  );

  print('\n10. 项目引用:');
  print('Reference: ${projectReference.name} at ${projectReference.path}');

  // 创建翻译条目
  final entry = TranslationEntry(
    id: 'entry-1',
    key: 'hello.world',
    projectId: project.id,
    sourceLanguage: english,
    targetLanguage: chinese,
    sourceText: 'Hello, World!',
    targetText: '你好，世界！',
    status: TranslationStatus.completed,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('\n11. 翻译条目管理:');
  print('Entry: ${entry.key}');
  print('Status: ${entry.status.displayName}');
  print('Is editable: ${entry.status.isEditable}');

  // 使用工具类
  final (namespace, key) = TranslationUtils.parseKey('hello.world');
  print('\n12. 工具类功能:');
  print('Parsed key:');
  print('- Namespace: $namespace');
  print('- Key: $key');

  final placeholders = TranslationUtils.extractPlaceholders('Hello, {name}!');
  print('- Placeholders: $placeholders');

  // 项目统计示例
  print('\n13. 项目统计:');
  final stats = TranslationUtils.generateStatistics([entry]);
  print('Total entries: ${stats['total']}');
  print('Completed: ${stats['completed']}');
  print('Completion rate: ${(stats['completionRate'] * 100).toStringAsFixed(1)}%');
}
