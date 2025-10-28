import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/features/features.dart';

/// 项目成员管理页面
class ProjectMembersView extends StatefulWidget {
  const ProjectMembersView({super.key, required this.projectId});
  final String projectId;

  @override
  State<ProjectMembersView> createState() => _ProjectMembersViewState();
}

class _ProjectMembersViewState extends State<ProjectMembersView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectController>(
      tag: widget.projectId,
      builder: (controller) {
        return Obx(
          () {
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

                  // 成员上限进度卡片
                  _buildMemberLimitHeader(context, controller),

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
                            ],
                          ),
                          const SizedBox(height: 16.0),

                          // 项目成员列表
                          ...controller.members.map((member) {
                            final roleColor = _getRoleColor(member.role);
                            final displayName = member.displayName ?? member.username ?? '未知用户';
                            final email = member.email ?? '';

                            return _buildMemberCard(
                              context,
                              controller,
                              displayName,
                              email,
                              member.role.displayName,
                              roleColor,
                              member: member,
                              isOwner: member.role == ProjectRoleEnum.owner,
                            );
                          }),
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
                            '成员',
                            '可以翻译词条、提交翻译、查看项目进度',
                            Colors.green,
                            Icons.translate,
                          ),
                          _buildRoleDescription(
                            context,
                            '查看者',
                            '只能查看项目内容，无法进行编辑或翻译',
                            Colors.blue,
                            Icons.visibility,
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

  /// 根据角色获取颜色
  Color _getRoleColor(ProjectRoleEnum role) {
    switch (role) {
      case ProjectRoleEnum.owner:
        return Colors.purple;
      case ProjectRoleEnum.admin:
        return Colors.orange;
      case ProjectRoleEnum.member:
        return Colors.green;
      case ProjectRoleEnum.viewer:
        return Colors.blue;
    }
  }

  Widget _buildMemberLimitHeader(BuildContext context, ProjectController controller) {
    final projectModel = controller.projectObs.value;
    if (projectModel == null) return const SizedBox.shrink();

    // 从 project 的 raw data 中获取成员数和上限
    final currentCount = controller.members.length;
    final limit = 10; // 默认值，实际应该从 projectModel 中获取
    final percentage = currentCount / limit;
    final remaining = limit - currentCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📊 项目成员 ($currentCount/$limit)',
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: remaining > 0 ? () => _showInviteDialog(context, controller) : null,
                  icon: const Icon(Icons.person_add, size: 18.0),
                  label: const Text('邀请成员'),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: percentage,
                minHeight: 8.0,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 1.0 ? Colors.red : Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              percentage >= 1.0 ? '⚠️ 项目成员已达上限，请先移除部分成员或在设置中提升上限' : '💡 还可以邀请 $remaining 人',
              style: TextStyle(
                color: percentage >= 1.0 ? Colors.red : Colors.grey[600],
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context, ProjectController controller) {
    final projectIdInt = int.tryParse(widget.projectId);
    if (projectIdInt == null) return;

    // 创建邀请控制器
    Get.put(ProjectMemberInviteController(projectId: projectIdInt));

    Get.dialog(
      _InviteDialogContent(
        memberCount: controller.members.length,
      ),
      barrierDismissible: false,
    ).then((_) {
      // 对话框关闭后刷新项目数据
      controller.refreshProject();

      // 延迟删除控制器，确保所有 widget 完全销毁
      Future.delayed(const Duration(milliseconds: 300), () {
        try {
          if (Get.isRegistered<ProjectMemberInviteController>()) {
            Get.delete<ProjectMemberInviteController>(force: true);
          }
        } catch (error, stackTrace) {
          log('[_showInviteDialog] 删除控制器失败', error: error, stackTrace: stackTrace, name: 'ProjectMembersView');
        }
      });
    });
  }

  Widget _buildMemberCard(
    BuildContext context,
    ProjectController controller,
    String name,
    String email,
    String role,
    Color roleColor, {
    required ProjectMemberModel member,
    bool isOwner = false,
  }) {
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
                    _showEditMemberDialog(context, controller, member);
                    break;
                  case 'remove':
                    _showRemoveMemberDialog(context, controller, member);
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

  void _showEditMemberDialog(BuildContext context, ProjectController controller, ProjectMemberModel member) {
    final projectIdInt = int.tryParse(widget.projectId);
    if (projectIdInt == null) return;

    ProjectRoleEnum selectedRole = member.role;

    Get.dialog(
      AlertDialog(
        title: const Text('编辑成员权限'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('成员: ${member.displayName ?? member.username ?? "未知"}'),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<ProjectRoleEnum>(
                  value: selectedRole,
                  decoration: const InputDecoration(
                    labelText: '角色权限',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: ProjectRoleEnum.viewer, child: Text('查看者')),
                    DropdownMenuItem(value: ProjectRoleEnum.member, child: Text('成员')),
                    DropdownMenuItem(value: ProjectRoleEnum.admin, child: Text('管理员')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedRole = value);
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final projectApi = Get.find<ProjectApi>();
                await projectApi.updateMemberRole(
                  projectId: projectIdInt,
                  userId: member.userId ?? '',
                  role: selectedRole.name,
                );
                Get.back();
                Get.snackbar('成功', '成员权限已更新');
                controller.refreshProject();
              } catch (error) {
                Get.snackbar('失败', '更新成员权限失败');
              }
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _showRemoveMemberDialog(BuildContext context, ProjectController controller, ProjectMemberModel member) {
    final projectIdInt = int.tryParse(widget.projectId);
    if (projectIdInt == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text('移除成员'),
        content: Text('确定要移除成员 ${member.displayName ?? member.username ?? "未知"} 吗？\n此操作无法撤销。'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('取消'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              try {
                final projectApi = Get.find<ProjectApi>();
                await projectApi.removeProjectMember(
                  projectId: projectIdInt,
                  userId: member.userId ?? '',
                );
                Get.back();
                Get.snackbar('成功', '成员已移除');
                controller.refreshProject();
              } catch (error) {
                Get.snackbar('失败', '移除成员失败');
              }
            },
            child: const Text('移除'),
          ),
        ],
      ),
    );
  }
}

// 邀请对话框内容
class _InviteDialogContent extends StatefulWidget {
  const _InviteDialogContent({required this.memberCount});

  final int memberCount;

  @override
  State<_InviteDialogContent> createState() => _InviteDialogContentState();
}

class _InviteDialogContentState extends State<_InviteDialogContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectMemberInviteController>(
      builder: (controller) {
        return Dialog(
          child: SizedBox(
            width: 600.0,
            height: 700.0,
            child: Column(
              children: [
                // 对话框标题
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        '邀请成员到项目',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1.0),

                // 成员信息提示
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '📊 当前成员: ${widget.memberCount}/10  |  💡 还可以邀请 ${10 - widget.memberCount} 人',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // Tab 栏
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: '邀请链接'),
                    Tab(text: '直接添加'),
                  ],
                ),

                // Tab 内容
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      InviteLinkTab(),
                      AddMemberTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
