import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/api/api.dart';
import 'package:ttpolyglot_core/core.dart';
import 'package:ttpolyglot_model/model.dart';

/// 通知设置控制器
class NotificationSettingsController extends GetxController {
  final NotificationSettingsApi _api = NotificationSettingsApi();

  // 项目ID（可选，为空表示全局设置）
  final int? projectId;

  // 通知设置列表
  final _settings = <NotificationSettingsModel>[].obs;
  List<NotificationSettingsModel> get settings => _settings;

  // 加载状态
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // 保存状态
  final _isSaving = false.obs;
  bool get isSaving => _isSaving.value;

  NotificationSettingsController({this.projectId});

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  /// 加载通知设置
  Future<void> loadSettings() async {
    _isLoading.value = true;

    try {
      if (projectId != null) {
        _settings.value = await _api.getProjectNotificationSettings(
          projectId: projectId!,
        );
      } else {
        _settings.value = await _api.getUserNotificationSettings() ?? [];
      }
    } catch (error, stackTrace) {
      Logger.error('[loadSettings] 加载通知设置失败', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// 更新单个通知设置
  Future<void> updateSetting({
    required NotificationTypeEnum notificationType,
    required NotificationChannelEnum channel,
    required bool isEnabled,
  }) async {
    try {
      if (projectId != null) {
        await _api.updateProjectNotificationSetting(
          projectId: projectId!,
          notificationType: notificationType,
          channel: channel,
          isEnabled: isEnabled,
        );
      } else {
        await _api.updateNotificationSetting(
          notificationType: notificationType,
          channel: channel,
          isEnabled: isEnabled,
        );
      }

      // 更新本地状态
      final index = _settings.indexWhere((s) => s.notificationType == notificationType && s.channel == channel);
      if (index != -1) {
        _settings[index] = _settings[index].copyWith(isEnabled: isEnabled);
        _settings.refresh();
      }
    } catch (error, stackTrace) {
      Logger.error('[updateSetting] 更新通知设置失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '更新通知设置失败');
      rethrow;
    }
  }

  /// 批量更新通知设置
  Future<void> batchUpdateSettings(List<NotificationSettingUpdate> updates) async {
    _isSaving.value = true;

    try {
      await _api.batchUpdateNotificationSettings(
        projectId: projectId,
        updates: updates,
      );

      // 重新加载设置
      await loadSettings();

      Get.snackbar('成功', '通知设置已保存');
    } catch (error, stackTrace) {
      Logger.error('[batchUpdateSettings] 批量更新通知设置失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '保存通知设置失败');
    } finally {
      _isSaving.value = false;
    }
  }

  /// 初始化默认设置
  Future<void> initializeDefaultSettings() async {
    try {
      await _api.initializeDefaultSettings(projectId: projectId);
      await loadSettings();
    } catch (error, stackTrace) {
      Logger.error('[initializeDefaultSettings] 初始化默认设置失败', error: error, stackTrace: stackTrace);
      Get.snackbar('错误', '初始化默认设置失败');
    }
  }

  /// 检查通知是否启用
  bool isNotificationEnabled({
    required NotificationTypeEnum notificationType,
    required NotificationChannelEnum channel,
  }) {
    final setting = _settings.firstWhereOrNull((s) => s.notificationType == notificationType && s.channel == channel);
    return setting?.isEnabled ?? true;
  }

  /// 获取通知类型显示文本
  String getNotificationTypeEnumDisplayText(NotificationTypeEnum type) {
    return type.displayName;
  }

  /// 获取通知渠道显示文本
  String getChannelDisplayText(NotificationChannelEnum channel) {
    return channel.displayName;
  }

  /// 获取通知类型图标
  String getNotificationTypeEnumIcon(NotificationTypeEnum type) {
    return type.icon;
  }
}
