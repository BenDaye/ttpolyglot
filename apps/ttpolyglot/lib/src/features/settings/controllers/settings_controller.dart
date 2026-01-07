import 'package:get/get.dart';
import 'package:ttpolyglot/src/common/api/api.dart';
import 'package:ttpolyglot_model/model.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 设置页面控制器
class SettingsController extends GetxController {
  final UserSettingsApi _userSettingsApi = Get.find<UserSettingsApi>();
  final LanguageApi _languageApi = Get.find<LanguageApi>();

  // 响应式变量
  final _isDarkMode = false.obs;
  final _language = 'zh-CN'.obs;
  final _autoSave = true.obs;
  final _notifications = true.obs;
  final _isLoading = false.obs;
  final _languages = <LanguageModel>[].obs;

  // Getters
  bool get isDarkMode => _isDarkMode.value;
  String get language => _language.value;
  bool get autoSave => _autoSave.value;
  bool get notifications => _notifications.value;
  bool get isLoading => _isLoading.value;
  List<LanguageModel> get languages => _languages;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  /// 切换深色模式
  void toggleDarkMode() {
    _isDarkMode.value = !_isDarkMode.value;
  }

  /// 设置语言
  Future<void> setLanguage(String languageCode) async {
    _language.value = languageCode;
    await _saveLanguageToServer(languageCode);
  }

  /// 切换自动保存
  Future<void> toggleAutoSave() async {
    _autoSave.value = !_autoSave.value;
    await _saveGeneralSettingsToServer();
  }

  /// 切换通知
  Future<void> toggleNotifications() async {
    _notifications.value = !_notifications.value;
    await _saveGeneralSettingsToServer();
  }

  /// 从服务器加载设置
  Future<void> loadSettingsFromServer() async {
    try {
      _isLoading.value = true;
      final settings = await _userSettingsApi.getUserSettings();

      // 更新响应式变量
      // 使用服务器返回的语言代码格式（连字符格式：en-US）
      final serverLanguageCode = settings.languageSettings.languageCode?.code ?? 'zh-CN';
      _language.value = serverLanguageCode;
      _autoSave.value = settings.generalSettings.autoSave;
      _notifications.value = settings.generalSettings.notifications;

      LoggerUtils.info('从服务器加载设置成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('从服务器加载设置失败', error: error, stackTrace: stackTrace);
    } finally {
      _isLoading.value = false;
    }
  }

  /// 保存语言设置到服务器
  Future<void> _saveLanguageToServer(String languageCode) async {
    try {
      // 使用连字符格式发送给服务器（en-US）
      await _userSettingsApi.updateLanguageSettings(languageCode);
      LoggerUtils.info('保存语言设置到服务器成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('保存语言设置到服务器失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 保存通用设置到服务器
  Future<void> _saveGeneralSettingsToServer() async {
    try {
      await _userSettingsApi.updateGeneralSettings(
        autoSave: _autoSave.value,
        notifications: _notifications.value,
      );
      LoggerUtils.info('保存通用设置到服务器成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('保存通用设置到服务器失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 加载语言列表
  Future<void> _loadLanguages() async {
    try {
      final languageList = await _languageApi.getLanguages();
      _languages.value = languageList;
      LoggerUtils.info('加载语言列表成功: ${languageList.length} 个语言');
    } catch (error, stackTrace) {
      LoggerUtils.error('加载语言列表失败', error: error, stackTrace: stackTrace);
      // 如果加载失败，使用默认语言列表
      _languages.value = LanguageEnum.toArray();
    }
  }

  /// 加载设置
  Future<void> loadSettings() async {
    // 加载语言列表
    await _loadLanguages();
    // 从服务器加载最新数据
    await loadSettingsFromServer();
  }
}
