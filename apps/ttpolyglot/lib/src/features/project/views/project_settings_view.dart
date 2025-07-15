import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

/// 项目设置页面
class ProjectSettingsView extends StatelessWidget {
  const ProjectSettingsView({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: projectId,
      builder: (controller) {
        return Obx(
          () {
            if (controller.isLoading) return const Center(child: CircularProgressIndicator());
            final project = controller.project;
            if (project == null) return const Center(child: Text('项目不存在'));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 页面标题
                  Row(
                    children: [
                      const Icon(Icons.settings, size: 28.0),
                      const SizedBox(width: 12.0),
                      Text(
                        '项目设置',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // 基本设置卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '基本设置',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          _buildSettingItem(
                            context,
                            '项目名称',
                            project.name,
                            Icons.title,
                            () {},
                          ),
                          _buildSettingItem(
                            context,
                            '项目描述',
                            project.description,
                            Icons.description,
                            () {},
                          ),
                          _buildSettingItem(
                            context,
                            '项目状态',
                            project.isActive ? '激活' : '停用',
                            Icons.toggle_on,
                            () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 权限设置卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '权限设置',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          _buildSwitchItem(
                            context,
                            '公开项目',
                            '允许其他用户查看项目信息',
                            false,
                            (value) {},
                          ),
                          _buildSwitchItem(
                            context,
                            '允许申请加入',
                            '用户可以申请加入项目',
                            true,
                            (value) {},
                          ),
                          _buildSwitchItem(
                            context,
                            '自动批准翻译',
                            '新翻译无需审核自动生效',
                            false,
                            (value) {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 通知设置卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '通知设置',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          _buildSwitchItem(
                            context,
                            '邮件通知',
                            '重要事件发生时发送邮件通知',
                            true,
                            (value) {},
                          ),
                          _buildSwitchItem(
                            context,
                            '翻译完成通知',
                            '翻译完成时通知项目成员',
                            true,
                            (value) {},
                          ),
                          _buildSwitchItem(
                            context,
                            '新成员加入通知',
                            '新成员加入时通知管理员',
                            true,
                            (value) {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 危险操作卡片
                  Card(
                    color: Colors.red.withValues(alpha: 0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '危险操作',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.red,
                                ),
                          ),
                          const SizedBox(height: 16.0),
                          _buildDangerItem(
                            context,
                            '删除项目',
                            '永久删除项目及其所有数据',
                            Icons.delete_forever,
                            () {},
                          ),
                          _buildDangerItem(
                            context,
                            '转移所有权',
                            '将项目所有权转移给其他成员',
                            Icons.transfer_within_a_station,
                            () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 为悬浮导航留出空间
                  const SizedBox(height: 100.0),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDangerItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(
          title,
          style: const TextStyle(color: Colors.red),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red),
        onTap: onTap,
      ),
    );
  }
}
