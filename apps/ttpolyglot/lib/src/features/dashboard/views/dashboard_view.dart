import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/platform/platform_adapter.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/core/storage/storage_provider.dart';
import 'package:ttpolyglot/src/core/theme/app_theme.dart';

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                const SizedBox(height: 40.0),
                _buildPlatformInfoSection(),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppThemeController.primaryColor.withValues(alpha: 0.1),
            AppThemeController.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppThemeController.primaryColor.withValues(alpha: 0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 4.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppThemeController.primaryColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Icon(
                  Icons.translate,
                  color: AppThemeController.primaryColor,
                  size: 32.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '欢迎使用 TTPolyglot',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '让每个开发者都成为多语言专家',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              'TTPolyglot 是一个跨平台的翻译管理工具，支持桌面、Web 和移动端。'
              '它提供了统一的界面来管理多语言项目，支持多种文件格式，'
              '并且可以在不同平台间同步数据。',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformInfoSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: AppThemeController.cardDecoration.copyWith(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppThemeController.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Icon(
                  _getPlatformIcon(),
                  color: AppThemeController.primaryColor,
                  size: 24.0,
                ),
              ),
              const SizedBox(width: 16.0),
              Text(
                '平台信息',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          _buildInfoRow('当前平台', _platformAdapter.platformName),
          const SizedBox(height: 16.0),
          _buildInfoRow('平台类型', _platformAdapter.currentPlatform.name),
          const SizedBox(height: 16.0),
          _buildInfoRow('存储类型', _storageProvider.currentPlatform.name),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100.0,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
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
