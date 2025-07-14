import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/layout/layout_controller.dart';
import '../../core/platform/platform_adapter.dart';
import '../../core/routing/app_router.dart';
import '../../core/storage/storage_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<LayoutController>();
      controller.updateLayoutForRoute(AppRouter.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const HomePageContent();
  }
}

/// 导出的首页内容组件，用于嵌套路由
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
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
                    onPressed: () => Get.toNamed(AppRouter.projects),
                    icon: const Icon(Icons.folder),
                    label: const Text('项目管理'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRouter.settings),
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
      backgroundColor: supported
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      labelStyle: TextStyle(
        color: supported ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
      ),
      avatar: Icon(
        supported ? Icons.check_circle : Icons.cancel,
        size: 16,
        color: supported ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  IconData _getPlatformIcon() {
    switch (_platformAdapter.currentPlatform) {
      case PlatformType.desktop:
        if (_platformAdapter.isMacOS) return Icons.desktop_mac;
        if (_platformAdapter.isWindows) return Icons.desktop_windows;
        if (_platformAdapter.isLinux) return Icons.computer;
        return Icons.desktop_windows;
      case PlatformType.mobile:
        if (_platformAdapter.isIOS) return Icons.phone_iphone;
        if (_platformAdapter.isAndroid) return Icons.android;
        return Icons.phone_android;
      case PlatformType.web:
        return Icons.web;
      case PlatformType.unknown:
        return Icons.device_unknown;
    }
  }
}
