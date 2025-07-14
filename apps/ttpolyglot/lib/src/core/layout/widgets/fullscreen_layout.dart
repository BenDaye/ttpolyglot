import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ttpolyglot/src/core/layout/layout.dart';

/// 全屏布局（欢迎页、引导页等）
class FullscreenLayout extends StatelessWidget {
  final LayoutConfig config;
  final Widget child;

  const FullscreenLayout({
    super.key,
    required this.config,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = child;

    // 如果需要滚动，包装 SingleChildScrollView
    if (config.scrollable) {
      body = SingleChildScrollView(
        child: body,
      );
    }

    // 如果有内边距，包装 Padding
    if (config.padding != null) {
      body = Padding(
        padding: config.padding!,
        child: body,
      );
    }

    // 如果需要安全区域，包装 SafeArea
    if (config.safeArea) {
      body = SafeArea(child: body);
    }

    return Scaffold(
      backgroundColor: config.backgroundColor ?? Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: body,
      floatingActionButton: config.floatingActionButton,
      floatingActionButtonLocation: config.floatingActionButtonLocation,
    );
  }

  /// 构建 AppBar（全屏布局通常不需要 AppBar）
  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    // 如果有自定义 AppBar，使用自定义的
    if (config.customAppBar != null) {
      return config.customAppBar;
    }

    // 全屏布局通常不显示 AppBar，除非明确要求
    if (config.title.isEmpty && (config.actions?.isEmpty ?? true) && !config.showBackButton) {
      return null;
    }

    return AppBar(
      title: config.title.isNotEmpty ? Text(config.title) : null,
      centerTitle: true,
      actions: config.actions,
      leading: config.showBackButton ? _buildBackButton(context) : null,
      automaticallyImplyLeading: config.showBackButton,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  /// 构建返回按钮
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Get.back();
        } else {
          Get.offAllNamed('/');
        }
      },
    );
  }
}

/// 带有渐变背景的全屏布局
class FullscreenLayoutWithGradient extends StatelessWidget {
  final LayoutConfig config;
  final Widget child;
  final Gradient? gradient;

  const FullscreenLayoutWithGradient({
    super.key,
    required this.config,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = child;

    // 如果需要滚动，包装 SingleChildScrollView
    if (config.scrollable) {
      body = SingleChildScrollView(
        child: body,
      );
    }

    // 如果有内边距，包装 Padding
    if (config.padding != null) {
      body = Padding(
        padding: config.padding!,
        child: body,
      );
    }

    // 如果需要安全区域，包装 SafeArea
    if (config.safeArea) {
      body = SafeArea(child: body);
    }

    // 添加渐变背景
    body = Container(
      decoration: BoxDecoration(
        gradient: gradient ??
            LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
              ],
            ),
      ),
      child: body,
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(context),
      body: body,
      floatingActionButton: config.floatingActionButton,
      floatingActionButtonLocation: config.floatingActionButtonLocation,
    );
  }

  /// 构建 AppBar
  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    // 如果有自定义 AppBar，使用自定义的
    if (config.customAppBar != null) {
      return config.customAppBar;
    }

    // 全屏布局通常不显示 AppBar，除非明确要求
    if (config.title.isEmpty && (config.actions?.isEmpty ?? true) && !config.showBackButton) {
      return null;
    }

    return AppBar(
      title: config.title.isNotEmpty ? Text(config.title) : null,
      centerTitle: true,
      actions: config.actions,
      leading: config.showBackButton ? _buildBackButton(context) : null,
      automaticallyImplyLeading: config.showBackButton,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  /// 构建返回按钮
  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Get.back();
        } else {
          Get.offAllNamed('/');
        }
      },
    );
  }
}

/// 引导页布局
class OnboardingLayout extends StatelessWidget {
  final LayoutConfig config;
  final Widget child;
  final Widget? skipButton;
  final Widget? nextButton;

  const OnboardingLayout({
    super.key,
    required this.config,
    required this.child,
    this.skipButton,
    this.nextButton,
  });

  @override
  Widget build(BuildContext context) {
    Widget body = child;

    // 如果需要滚动，包装 SingleChildScrollView
    if (config.scrollable) {
      body = SingleChildScrollView(
        child: body,
      );
    }

    // 如果有内边距，包装 Padding
    if (config.padding != null) {
      body = Padding(
        padding: config.padding!,
        child: body,
      );
    }

    // 如果需要安全区域，包装 SafeArea
    if (config.safeArea) {
      body = SafeArea(child: body);
    }

    // 添加底部按钮
    if (skipButton != null || nextButton != null) {
      body = Column(
        children: [
          Expanded(child: body),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                skipButton ?? const SizedBox.shrink(),
                nextButton ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: config.backgroundColor ?? Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: body,
      floatingActionButton: config.floatingActionButton,
      floatingActionButtonLocation: config.floatingActionButtonLocation,
    );
  }

  /// 构建 AppBar
  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    // 如果有自定义 AppBar，使用自定义的
    if (config.customAppBar != null) {
      return config.customAppBar;
    }

    // 引导页通常不显示 AppBar
    return null;
  }
}
