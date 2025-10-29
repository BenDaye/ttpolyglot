import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _saveSettingsLocal();
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

      // 同时保存到本地缓存
      await _saveSettingsLocal();

      LoggerUtils.info('从服务器加载设置成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('从服务器加载设置失败', error: error, stackTrace: stackTrace);
      // 加载失败时从本地加载
      await _loadSettingsLocal();
    } finally {
      _isLoading.value = false;
    }
  }

  /// 保存语言设置到服务器
  Future<void> _saveLanguageToServer(String languageCode) async {
    try {
      // 使用连字符格式发送给服务器（en-US）
      await _userSettingsApi.updateLanguageSettings(languageCode);
      await _saveSettingsLocal();
      LoggerUtils.info('保存语言设置到服务器成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('保存语言设置到服务器失败', error: error, stackTrace: stackTrace);
      // 保存失败时仅保存到本地
      await _saveSettingsLocal();
    }
  }

  /// 保存通用设置到服务器
  Future<void> _saveGeneralSettingsToServer() async {
    try {
      await _userSettingsApi.updateGeneralSettings(
        autoSave: _autoSave.value,
        notifications: _notifications.value,
      );
      await _saveSettingsLocal();
      LoggerUtils.info('保存通用设置到服务器成功');
    } catch (error, stackTrace) {
      LoggerUtils.error('保存通用设置到服务器失败', error: error, stackTrace: stackTrace);
      // 保存失败时仅保存到本地
      await _saveSettingsLocal();
    }
  }

  /// 保存设置到本地存储（作为缓存）
  Future<void> _saveSettingsLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode.value);
      await prefs.setString('language', _language.value);
      await prefs.setBool('autoSave', _autoSave.value);
      await prefs.setBool('notifications', _notifications.value);
    } catch (error, stackTrace) {
      LoggerUtils.error('保存设置到本地失败', error: error, stackTrace: stackTrace);
    }
  }

  /// 从本地存储加载设置
  Future<void> _loadSettingsLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
      _language.value = prefs.getString('language') ?? 'zh-CN';
      _autoSave.value = prefs.getBool('autoSave') ?? true;
      _notifications.value = prefs.getBool('notifications') ?? true;
    } catch (error, stackTrace) {
      LoggerUtils.error('从本地加载设置失败', error: error, stackTrace: stackTrace);
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

  /// 加载设置（优先从服务器，失败则从本地）
  Future<void> loadSettings() async {
    // 先从本地快速加载
    await _loadSettingsLocal();
    // 加载语言列表
    await _loadLanguages();
    // 然后从服务器加载最新数据
    await loadSettingsFromServer();
  }
}
