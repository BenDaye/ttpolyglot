import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/platform/platform_adapter.dart';
import '../../core/storage/storage_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _platformAdapter = PlatformAdapter();
  late final StorageProvider _storageProvider;

  @override
  void initState() {
    super.initState();
    _storageProvider = StorageProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TTPolyglot'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 16),
            _buildPlatformInfoCard(),
            const SizedBox(height: 16),
            _buildFeaturesCard(),
            const SizedBox(height: 16),
            _buildActionsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.translate, size: 32),
                const SizedBox(width: 12),
                Text(
                  '欢迎使用 TTPolyglot',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '让每个开发者都成为多语言专家',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'TTPolyglot 是一个跨平台的翻译管理工具，支持桌面、Web 和移动端。'
              '它提供了统一的界面来管理多语言项目，支持多种文件格式，'
              '并且可以在不同平台间同步数据。',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getPlatformIcon()),
                const SizedBox(width: 12),
                Text(
                  '平台信息',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('当前平台', _platformAdapter.platformName),
            _buildInfoRow('平台类型', _platformAdapter.currentPlatform.name),
            _buildInfoRow('存储类型', _storageProvider.currentPlatform.name),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final features = _platformAdapter.features;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.featured_play_list),
                const SizedBox(width: 12),
                Text(
                  '平台功能',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeatureChip('文件系统', features.supportsFileSystem),
                _buildFeatureChip('系统托盘', features.supportsSystemTray),
                _buildFeatureChip('全局热键', features.supportsHotkeys),
                _buildFeatureChip('文件监控', features.supportsFileWatcher),
                _buildFeatureChip('窗口管理', features.supportsWindowManagement),
                _buildFeatureChip('多窗口', features.supportsMultiWindow),
                _buildFeatureChip('菜单栏', features.supportsMenuBar),
                _buildFeatureChip('通知', features.supportsNotifications),
                _buildFeatureChip('剪贴板', features.supportsClipboard),
                _buildFeatureChip('开机自启', features.supportsAutoStart),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.dashboard),
                const SizedBox(width: 12),
                Text(
                  '快速操作',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/projects'),
                    icon: const Icon(Icons.folder),
                    label: const Text('项目管理'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.settings),
                    label: const Text('设置'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, bool supported) {
    return Chip(
      label: Text(label),
      backgroundColor:
          supported ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceVariant,
      labelStyle: TextStyle(
        color: supported
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      avatar: Icon(
        supported ? Icons.check_circle : Icons.cancel,
        size: 16,
        color: supported
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }

  IconData _getPlatformIcon() {
    if (_platformAdapter.isDesktop) {
      if (_platformAdapter.isMacOS) return Icons.laptop_mac;
      if (_platformAdapter.isWindows) return Icons.laptop_windows;
      if (_platformAdapter.isLinux) return Icons.laptop;
    }
    if (_platformAdapter.isWeb) return Icons.web;
    if (_platformAdapter.isMobile) {
      if (_platformAdapter.isIOS) return Icons.phone_iphone;
      if (_platformAdapter.isAndroid) return Icons.phone_android;
    }
    return Icons.device_unknown;
  }
}
