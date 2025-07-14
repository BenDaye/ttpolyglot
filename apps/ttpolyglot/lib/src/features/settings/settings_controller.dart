import 'package:get/get.dart';

/// 设置页面控制器
class SettingsController extends GetxController {
  // 响应式变量
  final _isDarkMode = false.obs;
  final _language = 'zh_CN'.obs;
  final _autoSave = true.obs;
  final _notifications = true.obs;

  // Getters
  bool get isDarkMode => _isDarkMode.value;
  String get language => _language.value;
  bool get autoSave => _autoSave.value;
  bool get notifications => _notifications.value;

  // 语言选项
  final List<Map<String, String>> languages = [
    {'code': 'zh_CN', 'name': '中文'},
    {'code': 'en_US', 'name': 'English'},
  ];

  /// 切换深色模式
  void toggleDarkMode() {
    _isDarkMode.value = !_isDarkMode.value;
    // 这里可以添加保存到本地存储的逻辑
    _saveSettings();
  }

  /// 设置语言
  void setLanguage(String languageCode) {
    _language.value = languageCode;
    _saveSettings();
  }

  /// 切换自动保存
  void toggleAutoSave() {
    _autoSave.value = !_autoSave.value;
    _saveSettings();
  }

  /// 切换通知
  void toggleNotifications() {
    _notifications.value = !_notifications.value;
    _saveSettings();
  }

  /// 保存设置到本地存储
  void _saveSettings() {
    // 这里可以添加保存到 SharedPreferences 或其他存储的逻辑
    // 例如：
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('isDarkMode', _isDarkMode.value);
    // await prefs.setString('language', _language.value);
    // await prefs.setBool('autoSave', _autoSave.value);
    // await prefs.setBool('notifications', _notifications.value);
  }

  /// 加载设置
  void loadSettings() {
    // 这里可以添加从本地存储加载设置的逻辑
    // 例如：
    // final prefs = await SharedPreferences.getInstance();
    // _isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    // _language.value = prefs.getString('language') ?? 'zh_CN';
    // _autoSave.value = prefs.getBool('autoSave') ?? true;
    // _notifications.value = prefs.getBool('notifications') ?? true;
  }

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }
}
