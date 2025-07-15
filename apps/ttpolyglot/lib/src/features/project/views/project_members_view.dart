import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/project/project.dart';

/// 项目成员管理页面
class ProjectMembersView extends StatelessWidget {
  const ProjectMembersView({super.key, required this.projectId});
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
                      const Icon(Icons.people, size: 28.0),
                      const SizedBox(width: 12.0),
                      Text(
                        '成员管理',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),

                  // 成员统计卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '成员统计',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  '总成员',
                                  '8',
                                  Icons.people,
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  '管理员',
                                  '2',
                                  Icons.admin_panel_settings,
                                  Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  '翻译者',
                                  '6',
                                  Icons.translate,
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 成员列表卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '项目成员',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // TODO: 邀请成员功能
                                },
                                icon: const Icon(Icons.person_add),
                                label: const Text('邀请成员'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          // 项目所有者
                          _buildMemberCard(
                            context,
                            project.owner.name,
                            project.owner.email,
                            '所有者',
                            Colors.purple,
                            isOwner: true,
                          ),

                          // 示例成员
                          _buildMemberCard(
                            context,
                            '张三',
                            'zhangsan@example.com',
                            '管理员',
                            Colors.orange,
                          ),
                          _buildMemberCard(
                            context,
                            '李四',
                            'lisi@example.com',
                            '翻译者',
                            Colors.green,
                          ),
                          _buildMemberCard(
                            context,
                            '王五',
                            'wangwu@example.com',
                            '翻译者',
                            Colors.green,
                          ),
                          _buildMemberCard(
                            context,
                            '赵六',
                            'zhaoliu@example.com',
                            '翻译者',
                            Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // 角色说明卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '角色权限说明',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16.0),
                          _buildRoleDescription(
                            context,
                            '所有者',
                            '拥有项目的完全控制权，可以管理所有设置和成员',
                            Colors.purple,
                            Icons.star,
                          ),
                          _buildRoleDescription(
                            context,
                            '管理员',
                            '可以管理项目设置、邀请成员、审核翻译',
                            Colors.orange,
                            Icons.admin_panel_settings,
                          ),
                          _buildRoleDescription(
                            context,
                            '翻译者',
                            '可以翻译词条、提交翻译、查看项目进度',
                            Colors.green,
                            Icons.translate,
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

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32.0, color: color),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4.0),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, String name, String email, String role, Color roleColor,
      {bool isOwner = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          // 头像
          CircleAvatar(
            radius: 24.0,
            backgroundColor: roleColor.withValues(alpha: 0.2),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: roleColor,
              ),
            ),
          ),
          const SizedBox(width: 16.0),

          // 成员信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                          fontSize: 10.0,
                          color: roleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),

          // 操作按钮
          if (!isOwner) ...[
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    // TODO: 编辑成员权限
                    break;
                  case 'remove':
                    // TODO: 移除成员
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8.0),
                      Text('编辑权限'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'remove',
                  child: Row(
                    children: [
                      Icon(Icons.remove_circle),
                      SizedBox(width: 8.0),
                      Text('移除成员'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoleDescription(
    BuildContext context,
    String role,
    String description,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              size: 20.0,
              color: color,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
