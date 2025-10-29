import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/core/layout/layout_controller.dart';
import 'package:ttpolyglot/src/core/routing/app_pages.dart';
import 'package:ttpolyglot/src/features/profile/controllers/profile_controller.dart';

/// 个人信息页面
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    // 更新布局控制器
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<LayoutController>()) {
        final controller = Get.find<LayoutController>();
        controller.updateLayoutForRoute(Routes.profile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ProfileViewContent();
  }
}

/// 个人信息页面内容组件
class ProfileViewContent extends GetView<ProfileController> {
  const ProfileViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = controller.userInfo.value;
          if (user == null) {
            return const Center(
              child: Text('无法加载用户信息'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 页面标题
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        '个人信息',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    // 用户头像和基本信息
                    _buildUserHeader(context, user),

                    const SizedBox(height: 32.0),

                    // 基本信息卡片
                    _buildInfoCard(
                      context,
                      title: '基本信息',
                      items: [
                        _InfoItem(
                          icon: Icons.badge_outlined,
                          label: '用户名',
                          value: user.username,
                        ),
                        _InfoItem(
                          icon: Icons.email_outlined,
                          label: '邮箱',
                          value: user.email,
                        ),
                        if (user.displayName != null)
                          _InfoItem(
                            icon: Icons.person_outline,
                            label: '显示名称',
                            value: user.displayName!,
                          ),
                        if (user.phone != null)
                          _InfoItem(
                            icon: Icons.phone_outlined,
                            label: '手机号码',
                            value: user.phone!,
                          ),
                      ],
                    ),

                    const SizedBox(height: 16.0),

                    // 账户状态卡片
                    _buildInfoCard(
                      context,
                      title: '账户状态',
                      items: [
                        _InfoItem(
                          icon: Icons.verified_user_outlined,
                          label: '账户状态',
                          value: (user.isActive ?? false) ? '已激活' : '未激活',
                          valueColor: (user.isActive ?? false)
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        ),
                        _InfoItem(
                          icon: Icons.mark_email_read_outlined,
                          label: '邮箱验证',
                          value: (user.isEmailVerified ?? false) ? '已验证' : '未验证',
                          valueColor: (user.isEmailVerified ?? false)
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        ),
                        if (user.lastLoginAt != null)
                          _InfoItem(
                            icon: Icons.login_outlined,
                            label: '最后登录时间',
                            value: _formatDateTime(user.lastLoginAt!),
                          ),
                        if (user.lastLoginIp != null)
                          _InfoItem(
                            icon: Icons.location_on_outlined,
                            label: '最后登录IP',
                            value: user.lastLoginIp!,
                          ),
                        if (user.lastLoginLocation?.locationString != null)
                          _InfoItem(
                            icon: Icons.public_outlined,
                            label: '最后登录地址',
                            value: user.lastLoginLocation!.locationString,
                          ),
                      ],
                    ),

                    const SizedBox(height: 16.0),

                    // 账户信息卡片
                    _buildInfoCard(
                      context,
                      title: '账户信息',
                      items: [
                        if (user.createdAt != null)
                          _InfoItem(
                            icon: Icons.calendar_today_outlined,
                            label: '创建时间',
                            value: _formatDateTime(user.createdAt!),
                          ),
                        if (user.updatedAt != null)
                          _InfoItem(
                            icon: Icons.update_outlined,
                            label: '更新时间',
                            value: _formatDateTime(user.updatedAt!),
                          ),
                        if (user.passwordChangedAt != null)
                          _InfoItem(
                            icon: Icons.lock_outline,
                            label: '密码修改时间',
                            value: _formatDateTime(user.passwordChangedAt!),
                          ),
                      ],
                    ),

                    const SizedBox(height: 32.0),

                    // 操作按钮
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 构建用户头像和基本信息
  Widget _buildUserHeader(BuildContext context, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // 头像
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                width: 2.0,
              ),
            ),
            child: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      user.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.person_rounded,
                          size: 50.0,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.person_rounded,
                    size: 50.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
          ),

          const SizedBox(height: 16.0),

          // 用户名
          Text(
            user.displayName ?? user.username,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 8.0),

          // 用户邮箱
          Text(
            user.email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
        ],
      ),
    );
  }

  /// 构建信息卡片
  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<_InfoItem> items,
  }) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),
            ...items.map((item) => _buildInfoRow(context, item)),
          ],
        ),
      ),
    );
  }

  /// 构建信息行
  Widget _buildInfoRow(BuildContext context, _InfoItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.icon,
            size: 20.0,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            flex: 2,
            child: Text(
              item.label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            flex: 3,
            child: Text(
              item.value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: item.valueColor,
                  ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              controller.logout();
            },
            icon: const Icon(Icons.logout_outlined),
            label: const Text('退出登录'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              foregroundColor: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  /// 格式化日期时间
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}

/// 信息项
class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });
}
