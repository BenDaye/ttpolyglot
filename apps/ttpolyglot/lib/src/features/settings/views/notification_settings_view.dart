import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/settings/controllers/notification_settings_controller.dart';
import 'package:ttpolyglot_model/model.dart';

/// 通知设置页面
class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key, this.projectId});

  final int? projectId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationSettingsController>(
      init: NotificationSettingsController(projectId: projectId),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(projectId != null ? '项目通知设置' : '通知设置'),
        ),
        body: Obx(() {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.settings.isEmpty) {
            return _buildEmptyState(context, controller);
          }

          return _buildSettingsList(context, controller);
        }),
      ),
    );
  }

  /// 构建设置列表
  Widget _buildSettingsList(
    BuildContext context,
    NotificationSettingsController controller,
  ) {
    // 按通知类型分组
    final groupedSettings = <NotificationTypeEnum, List<NotificationSettingsModel>>{};
    for (final setting in controller.settings) {
      if (!groupedSettings.containsKey(setting.notificationType)) {
        groupedSettings[setting.notificationType] = [];
      }
      groupedSettings[setting.notificationType]!.add(setting);
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 页面说明
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '通知设置',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  '选择您希望接收的通知类型和渠道。',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),

        // 通知类型列表
        ...groupedSettings.entries.map((entry) {
          return _buildNotificationTypeEnumCard(
            context,
            controller,
            entry.key,
            entry.value,
          );
        }),
      ],
    );
  }

  /// 构建通知类型卡片
  Widget _buildNotificationTypeEnumCard(
    BuildContext context,
    NotificationSettingsController controller,
    NotificationTypeEnum type,
    List<NotificationSettingsModel> settings,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 通知类型标题
            Row(
              children: [
                Text(
                  controller.getNotificationTypeEnumIcon(type),
                  style: const TextStyle(fontSize: 24.0),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.getNotificationTypeEnumDisplayText(type),
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _getNotificationTypeEnumDescription(type),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24.0),
            // 通知渠道选项
            ...settings.map((setting) {
              return _buildChannelSwitch(context, controller, setting);
            }),
          ],
        ),
      ),
    );
  }

  /// 构建渠道开关
  Widget _buildChannelSwitch(
    BuildContext context,
    NotificationSettingsController controller,
    NotificationSettingsModel setting,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            _getChannelIcon(setting.channel),
            size: 20.0,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              controller.getChannelDisplayText(setting.channel),
              style: const TextStyle(fontSize: 14.0),
            ),
          ),
          Obx(() => Switch(
                value: controller.isNotificationEnabled(
                  notificationType: setting.notificationType,
                  channel: setting.channel,
                ),
                onChanged: (value) {
                  controller.updateSetting(
                    notificationType: setting.notificationType,
                    channel: setting.channel,
                    isEnabled: value,
                  );
                },
              )),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(
    BuildContext context,
    NotificationSettingsController controller,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64.0,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16.0),
          Text(
            '暂无通知设置',
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '点击下方按钮初始化默认设置',
            style: TextStyle(
              fontSize: 14.0,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton.icon(
            onPressed: controller.initializeDefaultSettings,
            icon: const Icon(Icons.add),
            label: const Text('初始化默认设置'),
          ),
        ],
      ),
    );
  }

  /// 获取通知类型描述
  String _getNotificationTypeEnumDescription(NotificationTypeEnum type) {
    return type.description;
  }

  /// 获取渠道图标
  IconData _getChannelIcon(NotificationChannelEnum channel) {
    return switch (channel) {
      NotificationChannelEnum.email => Icons.email_outlined,
      NotificationChannelEnum.inApp => Icons.notifications_outlined,
    };
  }
}
