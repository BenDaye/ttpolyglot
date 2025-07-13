import 'dart:convert';

import 'package:ttpolyglot_core/core.dart';

void main() async {
  print('TTPolyglot 跨平台存储策略演示');
  print('=' * 50);

  // 演示不同平台的存储策略
  await demonstrateStorageStrategies();

  // 演示数据导入导出
  await demonstrateDataPortability();

  // 演示存储配额管理
  await demonstrateStorageQuota();

  print('\n✅ 跨平台存储策略演示完成！');
}

/// 演示不同平台的存储策略
Future<void> demonstrateStorageStrategies() async {
  print('\n1. 不同平台存储策略:');

  // 内存存储 (测试用)
  final memoryStorage = MemoryStorageService();

  print('\n📱 内存存储 (测试/开发用):');
  await memoryStorage.write(StorageKeys.workspaceConfig, '{"version": "1.0.0"}');
  await memoryStorage.write(StorageKeys.projectList, '["project-1", "project-2"]');

  final workspaceConfig = await memoryStorage.read(StorageKeys.workspaceConfig);
  print('- 工作空间配置: $workspaceConfig');

  final projectList = await memoryStorage.read(StorageKeys.projectList);
  print('- 项目列表: $projectList');

  final allKeys = await memoryStorage.listKeys('');
  print('- 所有键: $allKeys');

  // 演示不同平台的键值规范
  print('\n🔑 存储键值规范:');
  print('- 工作空间配置: ${StorageKeys.workspaceConfig}');
  print('- 用户偏好: ${StorageKeys.userPreferences}');
  print('- 项目列表: ${StorageKeys.projectList}');
  print('- 项目配置: ${StorageKeys.projectConfig("project-1")}');
  print('- 项目数据库: ${StorageKeys.projectDatabase("project-1")}');
  print('- 项目缓存: ${StorageKeys.projectCache("project-1")}');

  // 演示平台特定的存储路径
  print('\n📁 平台特定存储路径:');
  print('桌面端 (文件系统):');
  print('  ~/.ttpolyglot/workspace.config.json');
  print('  ~/.ttpolyglot/projects/project-1/config.json');
  print('  ~/.ttpolyglot/projects/project-1/database.json');

  print('\nWeb 端 (LocalStorage):');
  print('  localStorage["ttpolyglot.workspace.config"]');
  print('  localStorage["ttpolyglot.project.project-1.config"]');
  print('  localStorage["ttpolyglot.project.project-1.database"]');

  print('\n移动端 (应用沙盒):');
  print('  /Documents/ttpolyglot/workspace.config.json');
  print('  /Documents/ttpolyglot/projects/project-1/config.json');
  print('  /Documents/ttpolyglot/projects/project-1/database.json');
}

/// 演示数据导入导出
Future<void> demonstrateDataPortability() async {
  print('\n2. 数据导入导出 (跨平台同步):');

  final sourceStorage = MemoryStorageService();
  final targetStorage = MemoryStorageService();

  // 在源存储中创建一些数据
  final user = User(
    id: 'user-1',
    email: 'user@example.com',
    name: 'Test User',
    role: UserRole.admin,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final workspaceConfig = WorkspaceConfig(
    version: '1.0.0',
    user: user,
    currentProjectId: 'project-1',
    preferences: const WorkspacePreferences(
      defaultLanguage: 'en',
      theme: 'dark',
      autoSync: true,
    ),
    recentProjects: ['project-1', 'project-2'],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  await sourceStorage.write(
    StorageKeys.workspaceConfig,
    jsonEncode(workspaceConfig.toJson()),
  );

  await sourceStorage.write(
    StorageKeys.projectList,
    jsonEncode(['project-1', 'project-2']),
  );

  await sourceStorage.write(
    StorageKeys.projectConfig('project-1'),
    jsonEncode({
      'id': 'project-1',
      'name': 'Web App',
      'description': 'Main web application',
    }),
  );

  print('📤 从源存储导出数据...');
  final exportedData = await sourceStorage.exportData();
  print('- 导出了 ${exportedData.length} 个数据项');

  print('📥 导入到目标存储...');
  await targetStorage.importData(exportedData);

  print('✅ 验证导入的数据:');
  final importedConfig = await targetStorage.read(StorageKeys.workspaceConfig);
  final config = WorkspaceConfig.fromJson(jsonDecode(importedConfig!));
  print('- 用户: ${config.user.name}');
  print('- 当前项目: ${config.currentProjectId}');
  print('- 主题: ${config.preferences.theme}');

  final importedProjects = await targetStorage.read(StorageKeys.projectList);
  final projects = List<String>.from(jsonDecode(importedProjects!));
  print('- 项目列表: $projects');
}

/// 演示存储配额管理
Future<void> demonstrateStorageQuota() async {
  print('\n3. 存储配额管理:');

  final storage = MemoryStorageService();

  // 创建一些测试数据
  for (int i = 0; i < 10; i++) {
    await storage.write('test_key_$i', 'test_data_$i' * 100);
  }

  final size = await storage.getSize();
  print('- 当前存储大小: ${size} 字节');

  // 模拟存储配额
  const storageQuota = StorageQuota(
    total: 5 * 1024 * 1024, // 5MB
    used: 1024 * 1024, // 1MB
    available: 4 * 1024 * 1024, // 4MB
  );

  print('- 存储配额: ${storageQuota.total ~/ 1024 ~/ 1024}MB');
  print('- 已使用: ${storageQuota.used ~/ 1024 ~/ 1024}MB');
  print('- 可用: ${storageQuota.available ~/ 1024 ~/ 1024}MB');
  print('- 使用率: ${(storageQuota.used / storageQuota.total * 100).toStringAsFixed(1)}%');

  // 演示存储配置
  const config = StorageConfig(
    maxSize: 50 * 1024 * 1024, // 50MB
    compressionEnabled: true,
    encryptionEnabled: false,
    backupEnabled: true,
    cacheEnabled: true,
  );

  print('\n⚙️ 存储配置:');
  print('- 最大大小: ${config.maxSize ~/ 1024 ~/ 1024}MB');
  print('- 压缩: ${config.compressionEnabled ? "启用" : "禁用"}');
  print('- 加密: ${config.encryptionEnabled ? "启用" : "禁用"}');
  print('- 备份: ${config.backupEnabled ? "启用" : "禁用"}');
  print('- 缓存: ${config.cacheEnabled ? "启用" : "禁用"}');
}

/// 演示不同平台的项目配置
void demonstratePlatformSpecificConfigs() {
  print('\n4. 平台特定的项目配置:');

  print('\n🖥️  桌面端项目配置 (.ttpolyglot):');
  final desktopConfig = {
    'projectId': 'project-1-uuid',
    'storageType': 'filesystem',
    'configPath': '~/.ttpolyglot/projects/project-1-uuid',
    'localePath': './locales',
    'watchEnabled': true,
  };
  print(const JsonEncoder.withIndent('  ').convert(desktopConfig));

  print('\n🌐 Web 端项目配置 (LocalStorage):');
  final webConfig = {
    'projectId': 'project-1-uuid',
    'storageType': 'web',
    'lastSync': DateTime.now().toIso8601String(),
    'offlineMode': true,
    'syncOnReconnect': true,
  };
  print(const JsonEncoder.withIndent('  ').convert(webConfig));

  print('\n📱 移动端项目配置 (应用沙盒):');
  final mobileConfig = {
    'projectId': 'project-1-uuid',
    'storageType': 'mobile',
    'documentsPath': '/Documents/ttpolyglot/project-1-uuid',
    'cacheEnabled': true,
    'backgroundSync': false,
  };
  print(const JsonEncoder.withIndent('  ').convert(mobileConfig));
}
