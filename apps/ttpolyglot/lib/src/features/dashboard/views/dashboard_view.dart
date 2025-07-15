import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/platform/platform_adapter.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/core/storage/storage_provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<LayoutController>()) {
        final controller = Get.find<LayoutController>();
        controller.updateLayoutForRoute(Routes.dashboard);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const DashboardViewContent();
  }
}

/// 导出的首页内容组件，用于嵌套路由
class DashboardViewContent extends StatefulWidget {
  const DashboardViewContent({super.key});

  @override
  State<DashboardViewContent> createState() => _DashboardViewContentState();
}

class _DashboardViewContentState extends State<DashboardViewContent> {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 16),
            _buildPlatformInfoCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
        padding: const EdgeInsets.all(16.0),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
