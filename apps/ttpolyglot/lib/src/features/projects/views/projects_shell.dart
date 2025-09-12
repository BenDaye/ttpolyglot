import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ttpolyglot/src/core/layout/layout.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/core/theme/app_theme.dart' as app_theme;
import 'package:ttpolyglot/src/features/features.dart';

class ProjectsShell extends StatefulWidget {
  const ProjectsShell({super.key});

  @override
  State<ProjectsShell> createState() => _ProjectsShellState();
}

class _ProjectsShellState extends State<ProjectsShell> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<LayoutController>()) {
        final controller = Get.find<LayoutController>();
        controller.updateLayoutForRoute(Routes.projects);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final shouldShowPersistentSidebar = ResponsiveUtils.shouldShowPersistentSidebar(context);

        if (shouldShowPersistentSidebar) {
          return _buildDesktopLayout(context);
        } else {
          // TODO: 移动端布局
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        const ProjectsSidebar(),
        Expanded(
          child: GetBuilder<ProjectsController>(
            builder: (controller) => Obx(
              () {
                if (controller.selectedProjectId.isEmpty) {
                  return Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: _buildEmptyState(context),
                    ),
                  );
                }

                return GetRouterOutlet(
                  initialRoute: Routes.project(controller.selectedProjectId),
                  anchorRoute: Routes.projects,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 400.0),
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图标
          Icon(
            Symbols.folder_open,
            size: 64.0,
            color: app_theme.AppThemeController.primaryColor.withValues(alpha: 0.9),
          ),
          const SizedBox(height: 24.0),
          // 标题
          Text(
            '暂无选择的项目',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey : const Color(0xFF191919),
                ),
          ),
        ],
      ),
    );
  }
}
