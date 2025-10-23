import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:ttpolyglot/src/features/projects/controllers/create_project_controller.dart';
import 'package:ttpolyglot_core/core.dart';

/// 创建项目向导对话框
class CreateProjectDialog extends StatelessWidget {
  const CreateProjectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateProjectController>(
      init: CreateProjectController(),
      builder: (controller) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: 700.0,
          constraints: const BoxConstraints(maxHeight: 600.0),
          child: Obx(
            () => Column(
              children: [
                // 标题栏
                _buildHeader(context, controller),

                // 步骤指示器
                _buildStepIndicator(context, controller),

                // 内容区域
                Expanded(
                  child: _buildStepContent(context, controller),
                ),

                // 底部按钮
                _buildFooter(context, controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建标题栏
  Widget _buildHeader(BuildContext context, CreateProjectController controller) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Symbols.add_circle, size: 24.0),
          const SizedBox(width: 12.0),
          Text(
            '创建新项目',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Symbols.close),
            onPressed: controller.cancel,
          ),
        ],
      ),
    );
  }

  /// 构建步骤指示器
  Widget _buildStepIndicator(BuildContext context, CreateProjectController controller) {
    final steps = ['项目信息', '语言配置', '邀请成员', '通知设置'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isActive = index == controller.currentStep;
          final isCompleted = index < controller.currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: isActive || isCompleted
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Symbols.check, size: 18.0, color: Colors.white)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        steps[index],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                              color: isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                if (index < steps.length - 1)
                  Expanded(
                    child: Container(
                      height: 2.0,
                      color: isCompleted
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// 构建步骤内容
  Widget _buildStepContent(BuildContext context, CreateProjectController controller) {
    switch (controller.currentStep) {
      case 0:
        return _buildProjectInfoStep(context, controller);
      case 1:
        return _buildLanguageConfigStep(context, controller);
      case 2:
        return _buildInviteMembersStep(context, controller);
      case 3:
        return _buildNotificationSettingsStep(context, controller);
      default:
        return const SizedBox.shrink();
    }
  }

  /// 构建项目信息步骤
  Widget _buildProjectInfoStep(BuildContext context, CreateProjectController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 项目名称
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: '项目名称',
                hintText: '输入项目名称',
                border: OutlineInputBorder(),
              ),
              validator: controller.validateName,
            ),
            const SizedBox(height: 16.0),

            // 项目标识
            TextFormField(
              controller: controller.slugController,
              decoration: const InputDecoration(
                labelText: '项目标识（用于 URL）',
                hintText: 'my-project',
                border: OutlineInputBorder(),
                helperText: '只能包含小写字母、数字和连字符',
              ),
              validator: controller.validateSlug,
            ),
            const SizedBox(height: 16.0),

            // 项目描述
            TextFormField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(
                labelText: '项目描述（可选）',
                hintText: '简要描述项目用途',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),

            // 可见性选择
            Text(
              '可见性',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8.0),
            Obx(
              () => Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('私有'),
                    subtitle: const Text('只有项目成员可以访问'),
                    value: 'private',
                    groupValue: controller.visibility,
                    onChanged: (value) => controller.setVisibility(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('团队可见'),
                    subtitle: const Text('团队成员可以查看'),
                    value: 'team',
                    groupValue: controller.visibility,
                    onChanged: (value) => controller.setVisibility(value!),
                  ),
                  RadioListTile<String>(
                    title: const Text('公开'),
                    subtitle: const Text('所有人都可以查看'),
                    value: 'public',
                    groupValue: controller.visibility,
                    onChanged: (value) => controller.setVisibility(value!),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建语言配置步骤
  Widget _buildLanguageConfigStep(BuildContext context, CreateProjectController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 主语言选择
          Text(
            '主语言',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8.0),
          Obx(
            () => DropdownButtonFormField<Language>(
              value: controller.primaryLanguage,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '选择主语言',
              ),
              items: controller.availableLanguages
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang.name),
                      ))
                  .toList(),
              onChanged: controller.setPrimaryLanguage,
            ),
          ),
          const SizedBox(height: 24.0),

          // 目标语言选择
          Text(
            '目标语言',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8.0),
          Obx(
            () => Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ...controller.targetLanguages.map((lang) => Chip(
                      label: Text(lang.name),
                      onDeleted: () => controller.removeTargetLanguage(lang),
                    )),
                ActionChip(
                  label: const Text('添加语言'),
                  avatar: const Icon(Symbols.add, size: 18.0),
                  onPressed: () => _showLanguagePicker(context, controller),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建邀请成员步骤
  Widget _buildInviteMembersStep(BuildContext context, CreateProjectController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '邀请成员',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8.0),
          Text(
            '你可以稍后在项目设置中邀请成员，现在可以跳过此步骤。',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24.0),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: 打开成员邀请对话框
            },
            icon: const Icon(Symbols.person_add),
            label: const Text('邀请成员'),
          ),
        ],
      ),
    );
  }

  /// 构建通知设置步骤
  Widget _buildNotificationSettingsStep(BuildContext context, CreateProjectController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '通知设置',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8.0),
          Text(
            '选择你希望接收的通知类型。',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24.0),
          Obx(
            () => SwitchListTile(
              title: const Text('邮件通知'),
              subtitle: const Text('通过邮件接收重要通知'),
              value: controller.emailNotificationsEnabled,
              onChanged: controller.toggleEmailNotifications,
            ),
          ),
          Obx(
            () => SwitchListTile(
              title: const Text('站内通知'),
              subtitle: const Text('在应用内接收通知'),
              value: controller.inAppNotificationsEnabled,
              onChanged: controller.toggleInAppNotifications,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建底部按钮
  Widget _buildFooter(BuildContext context, CreateProjectController controller) {
    final isLastStep = controller.currentStep == 3;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 上一步按钮
          if (controller.currentStep > 0)
            TextButton(
              onPressed: controller.previousStep,
              child: const Text('上一步'),
            )
          else
            const SizedBox.shrink(),

          const Spacer(),

          // 取消按钮
          TextButton(
            onPressed: controller.cancel,
            child: const Text('取消'),
          ),
          const SizedBox(width: 8.0),

          // 下一步/完成按钮
          Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading
                  ? null
                  : isLastStep
                      ? controller.createProject
                      : controller.nextStep,
              child: controller.isLoading
                  ? const SizedBox(
                      width: 16.0,
                      height: 16.0,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    )
                  : Text(isLastStep ? '创建项目' : '下一步'),
            ),
          ),
        ],
      ),
    );
  }

  /// 显示语言选择器
  void _showLanguagePicker(BuildContext context, CreateProjectController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择语言'),
        content: SizedBox(
          width: 300.0,
          child: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.availableLanguages.length,
              itemBuilder: (context, index) {
                final lang = controller.availableLanguages[index];
                final isSelected = controller.targetLanguages.contains(lang);
                final isPrimary = lang == controller.primaryLanguage;

                if (isPrimary) {
                  return ListTile(
                    title: Text(lang.name),
                    trailing: const Chip(
                      label: Text('主语言'),
                      labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    enabled: false,
                  );
                }

                return CheckboxListTile(
                  title: Text(lang.name),
                  value: isSelected,
                  onChanged: (value) {
                    if (value == true) {
                      controller.addTargetLanguage(lang);
                    } else {
                      controller.removeTargetLanguage(lang);
                    }
                  },
                );
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }
}
