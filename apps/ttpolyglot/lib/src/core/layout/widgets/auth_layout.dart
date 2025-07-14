import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/core/layout/layout.dart';

/// 认证布局（登录、注册等页面）
class AuthLayout extends StatelessWidget {
  final LayoutConfig config;
  final Widget child;

  const AuthLayout({
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

  /// 构建 AppBar
  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    // 如果有自定义 AppBar，使用自定义的
    if (config.customAppBar != null) {
      return config.customAppBar;
    }

    // 如果标题为空且没有操作按钮且不显示返回按钮，不显示 AppBar
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
      scrolledUnderElevation: 1,
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
          // 如果无法返回，跳转到首页
          Get.offAllNamed('/');
        }
      },
    );
  }
}

/// 带有装饰背景的认证布局
class AuthLayoutWithDecoration extends StatelessWidget {
  final LayoutConfig config;
  final Widget child;
  final Widget? backgroundDecoration;

  const AuthLayoutWithDecoration({
    super.key,
    required this.config,
    required this.child,
    this.backgroundDecoration,
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

    // 添加背景装饰
    if (backgroundDecoration != null) {
      body = Stack(
        children: [
          Positioned.fill(child: backgroundDecoration!),
          body,
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

    // 如果标题为空且没有操作按钮且不显示返回按钮，不显示 AppBar
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
      scrolledUnderElevation: 1,
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

/// 居中卡片认证布局
class AuthLayoutWithCard extends StatelessWidget {
  final LayoutConfig config;
  final Widget child;
  final double? cardMaxWidth;
  final EdgeInsets? cardPadding;

  const AuthLayoutWithCard({
    super.key,
    required this.config,
    required this.child,
    this.cardMaxWidth = 400,
    this.cardPadding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    Widget body = Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: cardMaxWidth ?? 400,
        ),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: cardPadding ?? const EdgeInsets.all(24),
            child: child,
          ),
        ),
      ),
    );

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

  /// 构建 AppBar
  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    // 如果有自定义 AppBar，使用自定义的
    if (config.customAppBar != null) {
      return config.customAppBar;
    }

    // 如果标题为空且没有操作按钮且不显示返回按钮，不显示 AppBar
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
      scrolledUnderElevation: 1,
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
