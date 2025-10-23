import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/projects/controllers/project_members_controller.dart';
import 'package:ttpolyglot_model/model.dart';

/// 项目成员管理页面
class ProjectMembersView extends StatelessWidget {
  const ProjectMembersView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectMembersController>(
      init: ProjectMembersController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: const Text('项目成员管理'),
          actions: [
            // 邀请成员按钮
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: controller.showInviteMemberDialog,
              tooltip: '邀请成员',
            ),
            const SizedBox(width: 8.0),
          ],
        ),
        body: Column(
          children: [
            // 过滤器
            _buildFilters(context, controller),
            const Divider(height: 1.0),
            // 成员列表
            Expanded(
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.members.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildMembersList(context, controller);
              }),
            ),
            // 分页器
            _buildPagination(context, controller),
          ],
        ),
      ),
    );
  }

  /// 构建过滤器
  Widget _buildFilters(BuildContext context, ProjectMembersController controller) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 角色过滤
          SizedBox(
            width: 150.0,
            child: Obx(() => DropdownButtonFormField<String?>(
                  value: controller.roleFilter,
                  decoration: const InputDecoration(
                    labelText: '角色',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('全部')),
                    DropdownMenuItem(value: 'owner', child: Text('所有者')),
                    DropdownMenuItem(value: 'admin', child: Text('管理员')),
                    DropdownMenuItem(value: 'member', child: Text('成员')),
                    DropdownMenuItem(value: 'viewer', child: Text('查看者')),
                  ],
                  onChanged: controller.updateRoleFilter,
                )),
          ),
          const SizedBox(width: 16.0),
          // 状态过滤
          SizedBox(
            width: 150.0,
            child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.statusFilter,
                  decoration: const InputDecoration(
                    labelText: '状态',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'active', child: Text('活跃')),
                    DropdownMenuItem(value: 'pending', child: Text('待接受')),
                    DropdownMenuItem(value: 'inactive', child: Text('已停用')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateStatusFilter(value);
                    }
                  },
                )),
          ),
          const Spacer(),
          // 刷新按钮
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadMembers(),
            tooltip: '刷新',
          ),
        ],
      ),
    );
  }

  /// 构建成员列表
  Widget _buildMembersList(BuildContext context, ProjectMembersController controller) {
    return Obx(() => ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.members.length,
          itemBuilder: (context, index) {
            final member = controller.members[index];
            return _buildMemberCard(context, controller, member);
          },
        ));
  }

  /// 构建成员卡片
  Widget _buildMemberCard(
    BuildContext context,
    ProjectMembersController controller,
    ProjectMemberModel member,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          radius: 24.0,
          backgroundImage: member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
          child: member.avatarUrl == null
              ? Text(
                  (member.displayName ?? member.username ?? 'U').substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                )
              : null,
        ),
        title: Row(
          children: [
            Text(
              member.displayName ?? member.username ?? member.userId,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8.0),
            _buildRoleBadge(controller, member.role),
            const SizedBox(width: 8.0),
            _buildStatusBadge(controller, member.status),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            if (member.username != null)
              Text(
                '@${member.username}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14.0,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4.0),
                Text(
                  '加入时间: ${_formatDate(member.joinedAt ?? member.createdAt)}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: member.role != ProjectRoleEnum.owner.value
            ? PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      controller.showEditRoleDialog(member);
                      break;
                    case 'remove':
                      controller.removeMember(member.userId);
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
                        Text('编辑角色'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.remove_circle, color: Colors.red),
                        SizedBox(width: 8.0),
                        Text('移除成员', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  /// 构建角色徽章
  Widget _buildRoleBadge(ProjectMembersController controller, ProjectRoleEnum? role) {
    if (role == null) {
      return const SizedBox.shrink();
    }

    Color badgeColor;
    switch (role) {
      case ProjectRoleEnum.owner:
        badgeColor = Colors.purple;
        break;
      case ProjectRoleEnum.admin:
        badgeColor = Colors.blue;
        break;
      case ProjectRoleEnum.member:
        badgeColor = Colors.green;
        break;
      case ProjectRoleEnum.viewer:
        badgeColor = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        role.displayName,
        style: TextStyle(
          fontSize: 12.0,
          color: badgeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 构建状态徽章
  Widget _buildStatusBadge(ProjectMembersController controller, MemberStatusEnum? status) {
    if (status == null) {
      return const SizedBox.shrink();
    }

    Color badgeColor;
    switch (status) {
      case MemberStatusEnum.active:
        badgeColor = Colors.green;
        break;
      case MemberStatusEnum.pending:
        badgeColor = Colors.orange;
        break;
      case MemberStatusEnum.inactive:
        badgeColor = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 12.0,
          color: badgeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64.0,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16.0),
          Text(
            '暂无成员',
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '点击右上角按钮邀请成员',
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建分页器
  Widget _buildPagination(BuildContext context, ProjectMembersController controller) {
    return Obx(() {
      if (controller.totalPages <= 1) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.currentPage > 1 ? controller.previousPage : null,
            ),
            const SizedBox(width: 16.0),
            Text(
              '第 ${controller.currentPage} / ${controller.totalPages} 页',
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(width: 16.0),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: controller.currentPage < controller.totalPages ? controller.nextPage : null,
            ),
          ],
        ),
      );
    });
  }

  /// 格式化日期
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
