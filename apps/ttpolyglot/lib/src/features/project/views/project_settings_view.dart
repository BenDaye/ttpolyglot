import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/common.dart';
import 'package:ttpolyglot/src/features/features.dart';

/// 项目设置页面
class ProjectSettingsView extends StatefulWidget {
  const ProjectSettingsView({super.key, required this.projectId});
  final String projectId;

  @override
  State<ProjectSettingsView> createState() => _ProjectSettingsViewState();
}

class _ProjectSettingsViewState extends State<ProjectSettingsView> {
  final TextEditingController _memberLimitController = TextEditingController();

  @override
  void dispose() {
    _memberLimitController.dispose();
    super.dispose();
  }

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
                  // 基本设置卡片
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '基本设置',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16.0),
                          _buildSettingItem(
                            context,
                            '项目名称',
                            project.name,
                            Icons.title,
                            () => ProjectDialogController.showEditNameDialog(project),
                          ),
                          _buildSettingItem(
                            context,
                            '项目描述',
                            project.description,
                            Icons.description,
                            () => ProjectDialogController.showEditDescriptionDialog(project),
                          ),
                          _buildSettingItem(
                            context,
                            '项目状态',
                            _getStatusText(controller.projectModel?.status ?? 'active'),
                            Icons.toggle_on,
                            () => ProjectDialogController.showEditStatusDialog(project),
                          ),
                          _buildSettingItem(
                            context,
                            '主语言',
                            '${project.primaryLanguage.nativeName} (${project.primaryLanguage.code})',
                            Icons.language,
                            () {
                              // 显示主语言固定性的说明
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('主语言设置'),
                                  content: const Text(
                                    '项目的主语言在创建时已设定，且不可修改。\n\n'
                                    '这是为了确保翻译数据的一致性和系统的稳定性。\n\n'
                                    '如需使用不同的主语言，请创建新项目。',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('了解'),
                                    ),
                                  ],
                                ),
                              );
                            },
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
                            style: Theme.of(context).textTheme.titleMedium,
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

                  // 成员上限设置卡片
                  _buildMemberLimitSettings(context, controller),

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
                            style: Theme.of(context).textTheme.titleMedium,
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
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.red,
                                ),
                          ),
                          const SizedBox(height: 16.0),
                          _buildDangerItem(
                            context,
                            '删除项目',
                            '永久删除项目及其所有数据',
                            Icons.delete_forever,
                            controller.deleteProject,
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
        dense: true,
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
        dense: true,
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
        dense: true,
        leading: Icon(icon, color: Colors.red),
        title: Text(
          title,
          style: const TextStyle(color: Colors.red),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMemberLimitSettings(BuildContext context, ProjectController controller) {
    // 从 controller 获取当前成员数和上限
    final currentCount = controller.members.length;
    final memberLimit = controller.projectModel?.memberLimit ?? 10;

    // 检查当前用户是否是 Owner
    final isOwner = _isCurrentUserOwner(controller);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '👥 成员上限设置',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16.0),
            if (isOwner) ...[
              // Owner 可编辑
              _buildOwnerMemberLimitEditor(
                context: context,
                controller: controller,
                currentCount: currentCount,
                memberLimit: memberLimit,
              ),
            ] else ...[
              // 其他角色只读
              _buildReadOnlyMemberLimit(
                context: context,
                currentCount: currentCount,
                memberLimit: memberLimit,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerMemberLimitEditor({
    required BuildContext context,
    required ProjectController controller,
    required int currentCount,
    required int memberLimit,
  }) {
    // 初始化输入框值
    if (_memberLimitController.text.isEmpty) {
      _memberLimitController.text = memberLimit.toString();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('成员上限'),
            const SizedBox(width: 16.0),
            SizedBox(
              width: 120.0,
              child: TextField(
                controller: _memberLimitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  suffixText: '人',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: () => _updateMemberLimit(controller, currentCount),
              child: const Text('保存'),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Text('当前成员: $currentCount 人', style: TextStyle(color: Colors.grey[600])),
        Text('可用名额: ${memberLimit - currentCount} 个', style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 12.0),
        Text(
          '💡 建议范围：5-50 人\n📊 允许范围：1-1000 人',
          style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
        ),
        const SizedBox(height: 8.0),
        Text(
          '⚠️ 提示：\n• 新上限不能小于当前成员数 ($currentCount)\n• 修改上限不会移除现有成员',
          style: const TextStyle(color: Colors.orange, fontSize: 12.0),
        ),
      ],
    );
  }

  Widget _buildReadOnlyMemberLimit({
    required BuildContext context,
    required int currentCount,
    required int memberLimit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('成员上限: $memberLimit 人'),
        const SizedBox(height: 8.0),
        Text('当前成员: $currentCount 人'),
        const SizedBox(height: 8.0),
        Text('可用名额: ${memberLimit - currentCount} 个'),
        const SizedBox(height: 12.0),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 20.0),
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  'ℹ️ 只有项目所有者可以修改成员上限',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _updateMemberLimit(ProjectController controller, int currentCount) async {
    final newLimit = int.tryParse(_memberLimitController.text);
    if (newLimit == null || newLimit < 1 || newLimit > 1000) {
      Get.snackbar('错误', '成员上限必须在 1-1000 之间');
      return;
    }

    if (newLimit < currentCount) {
      Get.snackbar('错误', '新上限不能小于当前成员数 ($currentCount)');
      return;
    }

    final projectIdInt = int.tryParse(widget.projectId);
    if (projectIdInt == null) return;

    try {
      final projectApi = Get.find<ProjectApi>();
      await projectApi.updateMemberLimit(
        projectId: projectIdInt,
        memberLimit: newLimit,
      );

      Get.snackbar('成功', '成员上限已更新为 $newLimit 人');
      await controller.refreshProject();
    } catch (error) {
      Get.snackbar('失败', '更新成员上限失败');
    }
  }

  bool _isCurrentUserOwner(ProjectController controller) {
    // TODO: 实际应该从 AuthService 获取当前用户ID并与项目所有者ID比较
    // final currentUserId = Get.find<AuthService>().currentUser?.id;
    // final project = controller.project;
    // return project?.ownerId == currentUserId;

    // 暂时返回 true 以便测试
    return true;
  }

  /// 获取状态文本
  String _getStatusText(String status) {
    switch (status) {
      case 'active':
        return '激活';
      case 'archived':
        return '已归档';
      case 'suspended':
        return '已暂停';
      default:
        return '未知';
    }
  }
}
