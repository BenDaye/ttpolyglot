import 'package:ttpolyglot_core/core.dart';

void main() {
  print('TTPolyglot Core 多项目管理示例');
  print('=' * 40);

  // 创建语言实例
  final english = Language(
    code: 'en',
    name: 'English',
    nativeName: 'English',
  );

  final chinese = Language(
    code: 'zh-CN',
    name: 'Chinese',
    nativeName: '中文',
  );

  print('\n1. 语言管理:');
  print('- $english');
  print('- $chinese');

  // 创建用户实例
  final user = User(
    id: 'user-1',
    email: 'admin@example.com',
    name: 'Admin User',
    role: UserRole.admin,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  print('\n2. 用户管理:');
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
    defaultLanguage: english,
    targetLanguages: [chinese],
    owner: user,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    settings: projectSettings,
  );

  print('\n3. 项目管理:');
  print('Project: ${project.name}');
  print('Languages: ${project.allLanguages.map((l) => l.code).join(', ')}');
  print('Settings: Auto-sync: ${project.settings?.autoSync}, Max key length: ${project.settings?.maxKeyLength}');

  // 创建项目成员
  final projectMember = ProjectMember(
    user: user,
    role: ProjectRole.owner,
    joinedAt: DateTime.now(),
  );

  print('\n4. 项目成员管理:');
  print('Member: ${projectMember.user.name} (${projectMember.role.displayName})');
  print('Permissions: Read: ${projectMember.role.canRead}, Write: ${projectMember.role.canWrite}');

  // 创建工作空间配置
  final workspacePreferences = WorkspacePreferences(
    defaultLanguage: 'en',
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

  print('\n5. 工作空间管理:');
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

  print('\n6. 项目引用:');
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

  print('\n7. 翻译条目管理:');
  print('Entry: ${entry.key}');
  print('Status: ${entry.status.displayName}');
  print('Is editable: ${entry.status.isEditable}');

  // 使用工具类
  final (namespace, key) = TranslationUtils.parseKey('hello.world');
  print('\n8. 工具类功能:');
  print('Parsed key:');
  print('- Namespace: $namespace');
  print('- Key: $key');

  final placeholders = TranslationUtils.extractPlaceholders('Hello, {name}!');
  print('- Placeholders: $placeholders');

  // 项目统计示例
  final projectStats = ProjectStats(
    totalEntries: 100,
    completedEntries: 80,
    pendingEntries: 15,
    reviewingEntries: 5,
    completionRate: 0.8,
    languageCount: 2,
    memberCount: 3,
    lastUpdated: DateTime.now(),
  );

  print('\n9. 项目统计:');
  print('Total entries: ${projectStats.totalEntries}');
  print('Completion rate: ${(projectStats.completionRate * 100).toStringAsFixed(1)}%');
  print('Languages: ${projectStats.languageCount}');
  print('Members: ${projectStats.memberCount}');

  print('\n✅ 多项目管理功能演示完成！');
}
