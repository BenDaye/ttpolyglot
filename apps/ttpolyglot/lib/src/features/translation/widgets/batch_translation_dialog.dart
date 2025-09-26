import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ttpolyglot/src/core/services/translation_service_manager.dart';
import 'package:ttpolyglot/src/features/project/controllers/project_controller.dart';
import 'package:ttpolyglot/src/features/settings/controllers/translation_config_controller.dart';
import 'package:ttpolyglot/src/features/translation/translation.dart';
import 'package:ttpolyglot_core/core.dart';

/// 批量翻译状态枚举
enum BatchTranslationStatus {
  idle, // 空闲
  running, // 运行中
  paused, // 暂停
  completed, // 完成
  cancelled, // 取消
}

/// 批量翻译弹窗
class BatchTranslationDialog extends StatefulWidget {
  const BatchTranslationDialog({
    super.key,
    required this.controller,
  });

  final TranslationController controller;

  @override
  State<BatchTranslationDialog> createState() => _BatchTranslationDialogState();

  /// 显示批量翻译弹窗
  static void show({
    required TranslationController controller,
  }) {
    Get.dialog(
      BatchTranslationDialog(
        controller: controller,
      ),
      barrierDismissible: false,
    );
  }
}

class _BatchTranslationDialogState extends State<BatchTranslationDialog> {
  // 状态管理
  TranslationProviderConfig? _selectedProvider;
  TranslationEntry? _selectedSourceEntry;
  bool _isOverride = true; // 是否覆盖
  BatchTranslationStatus _translationStatus = BatchTranslationStatus.idle;

  // 进度相关
  int _totalCount = 0;
  int _currentIndex = 0;
  int _successCount = 0;
  int _failCount = 0;
  final List<TranslationEntry> _pendingEntries = [];
  final List<TranslationEntry> _processedEntries = [];

  // 控制相关
  Timer? _translationTimer;
  bool _shouldStop = false;

  @override
  void dispose() {
    _translationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryLanguage = ProjectController.getInstance(widget.controller.projectId).project?.primaryLanguage;

    return AlertDialog(
      title: Row(
        children: [
          Text(
            '批量翻译项目',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const Spacer(),
          if (_translationStatus != BatchTranslationStatus.running)
            IconButton(
              onPressed: () => _closeDialog(),
              icon: Icon(
                Icons.close,
                color: Colors.grey.shade600,
                size: 24.0,
              ),
              padding: const EdgeInsets.all(8.0),
              constraints: const BoxConstraints(),
              splashRadius: 28.0,
            ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 8.0,
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      content: Container(
        width: 520.0,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 配置区域
              if (_translationStatus == BatchTranslationStatus.idle) ...[
                _buildConfigurationSection(primaryLanguage),
              ] else ...[
                _buildProgressSection(),
              ],
            ],
          ),
        ),
      ),
      actions: _buildActions(),
    );
  }

  /// 构建配置区域
  Widget _buildConfigurationSection(Language? primaryLanguage) {
    // 获取所有翻译条目，按 key 分组
    final allEntries = widget.controller.translationEntries;
    final Map<String, List<TranslationEntry>> entriesByKey = {};

    for (final entry in allEntries) {
      entriesByKey.putIfAbsent(entry.key, () => []).add(entry);
    }

    // 获取可用的源语言条目（按语言去重）
    final Map<String, TranslationEntry> languageEntryMap = {};

    for (final entries in entriesByKey.values) {
      if (entries.isNotEmpty) {
        for (final entry in entries) {
          final langCode = entry.targetLanguage.code;

          // 如果该语言还没有条目，或者当前条目有内容而之前的没有内容，则更新
          if (!languageEntryMap.containsKey(langCode) ||
              (entry.targetText.isNotEmpty && languageEntryMap[langCode]!.targetText.isEmpty)) {
            // 优先选择主语言，如果是主语言且有内容则直接使用
            if (langCode == primaryLanguage?.code && entry.targetText.isNotEmpty) {
              languageEntryMap[langCode] = entry;
            } else if (entry.targetText.isNotEmpty) {
              languageEntryMap[langCode] = entry;
            } else if (!languageEntryMap.containsKey(langCode)) {
              // 如果该语言还没有任何条目，即使内容为空也先保存
              languageEntryMap[langCode] = entry;
            }
          }
        }
      }
    }

    // 获取有内容的语言条目，按语言排序
    final availableSourceEntries = languageEntryMap.values.where((entry) => entry.targetText.isNotEmpty).toList()
      ..sort((a, b) {
        // 主语言排在最前面
        if (a.targetLanguage.code == primaryLanguage?.code) return -1;
        if (b.targetLanguage.code == primaryLanguage?.code) return 1;
        // 其他语言按sortIndex排序
        return a.targetLanguage.sortIndex.compareTo(b.targetLanguage.sortIndex);
      });

    _selectedSourceEntry ??= availableSourceEntries.isNotEmpty ? availableSourceEntries.first : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 翻译统计信息
        _buildStatisticsCard(),
        const SizedBox(height: 24.0),

        // 选择翻译接口
        Obx(
          () {
            _selectedProvider ??= TranslationConfigController.instance.config.defaultProvider;
            return _buildProviderSelector(
              list: TranslationConfigController.instance.config.providers,
            );
          },
        ),
        const SizedBox(height: 24.0),

        // 选择源语言基准
        _buildSourceLanguageSelector(
          list: availableSourceEntries,
        ),
        const SizedBox(height: 24.0),

        // 翻译选项
        _buildTranslationOptions(),
      ],
    );
  }

  /// 构建统计信息卡片
  Widget _buildStatisticsCard() {
    final stats = widget.controller.statistics;
    final total = stats['total'] ?? 0;
    final completed = stats['completed'] ?? 0;
    final pending = stats['pending'] ?? 0;
    final translating = stats['translating'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: Theme.of(context).primaryColor,
                size: 20.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                '项目翻译统计',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(child: _buildStatItem('总计', total, Colors.blue)),
              Expanded(child: _buildStatItem('已完成', completed, Colors.green)),
              Expanded(child: _buildStatItem('待翻译', pending, Colors.orange)),
              Expanded(child: _buildStatItem('翻译中', translating, Colors.purple)),
            ],
          ),
        ],
      ),
    );
  }

  /// 构建统计项
  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            color: color.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  /// 构建进度区域
  Widget _buildProgressSection() {
    // 修复进度计算：使用实际完成的数量（成功+失败）
    final completedCount = _successCount + _failCount;
    final progress = _totalCount > 0 ? (completedCount / _totalCount).clamp(0.0, 1.0) : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 状态指示器
        _buildStatusIndicator(),
        const SizedBox(height: 24.0),

        // 进度条
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '翻译进度',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  '$completedCount / $_totalCount',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              minHeight: 8.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12.0,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),

        // 结果统计
        _buildResultStatistics(),
        const SizedBox(height: 16.0),

        // 当前翻译项
        if (_translationStatus == BatchTranslationStatus.running &&
            _currentIndex < _pendingEntries.length &&
            _currentIndex >= 0)
          _buildCurrentTranslationItem(),
      ],
    );
  }

  /// 构建状态指示器
  Widget _buildStatusIndicator() {
    String statusText;
    Color statusColor;
    IconData statusIcon;

    switch (_translationStatus) {
      case BatchTranslationStatus.running:
        statusText = '正在翻译...';
        statusColor = Colors.blue;
        statusIcon = Icons.translate;
        break;
      case BatchTranslationStatus.paused:
        statusText = '翻译已暂停';
        statusColor = Colors.orange;
        statusIcon = Icons.pause_circle;
        break;
      case BatchTranslationStatus.completed:
        statusText = '翻译完成';
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case BatchTranslationStatus.cancelled:
        statusText = '翻译已取消';
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusText = '准备中...';
        statusColor = Colors.grey;
        statusIcon = Icons.hourglass_empty;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20.0),
          const SizedBox(width: 8.0),
          Text(
            statusText,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建结果统计
  Widget _buildResultStatistics() {
    // 修复剩余数量计算：使用实际完成的数量计算剩余
    final completedCount = _successCount + _failCount;
    final remainingCount = (_totalCount - completedCount).clamp(0, _totalCount);

    return Row(
      children: [
        Expanded(
          child: _buildResultCard('成功', _successCount, Colors.green, Icons.check_circle),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: _buildResultCard('失败', _failCount, Colors.red, Icons.error),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: _buildResultCard('剩余', remainingCount, Colors.blue, Icons.pending),
        ),
      ],
    );
  }

  /// 构建结果卡片
  Widget _buildResultCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16.0),
          const SizedBox(height: 4.0),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建当前翻译项
  Widget _buildCurrentTranslationItem() {
    // 安全检查索引边界
    if (_currentIndex < 0 || _currentIndex >= _pendingEntries.length) {
      return const SizedBox.shrink();
    }

    final currentEntry = _pendingEntries[_currentIndex];

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  currentEntry.targetLanguage.code,
                  style: GoogleFonts.notoSansMono(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  currentEntry.key,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            currentEntry.sourceText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 构建翻译服务提供商选择器
  Widget _buildProviderSelector({
    required List<TranslationProviderConfig> list,
  }) {
    return DropdownButtonFormField<TranslationProviderConfig>(
      value: _selectedProvider,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        labelText: '请选择翻译接口',
        labelStyle: TextStyle(
          color: Theme.of(Get.context!).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.translate,
          color: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.7),
          size: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(Get.context!).primaryColor,
            width: 2.0,
          ),
        ),
      ),
      items: list.map((provider) {
        return DropdownMenuItem<TranslationProviderConfig>(
          value: provider,
          child: SizedBox(
            width: 350.0,
            child: Row(
              spacing: 4.0,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    provider.provider.name.length >= 2
                        ? provider.provider.name.substring(0, 2).toUpperCase()
                        : provider.provider.name.toUpperCase(),
                    style: GoogleFonts.notoSansMono(
                      color: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(provider.displayName),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedProvider = value;
          });
          log('选择翻译提供商: ${value.displayName}', name: 'BatchTranslationDialog');
        }
      },
    );
  }

  /// 构建源语言选择器
  Widget _buildSourceLanguageSelector({
    required List<TranslationEntry> list,
  }) {
    return DropdownButtonFormField<TranslationEntry>(
      value: _selectedSourceEntry,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20.0),
        labelText: '请选择翻译基准语言',
        labelStyle: TextStyle(
          color: Theme.of(Get.context!).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          Icons.language,
          color: Theme.of(Get.context!).primaryColor.withValues(alpha: 0.7),
          size: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: Theme.of(Get.context!).primaryColor,
            width: 2.0,
          ),
        ),
      ),
      items: list.map((entry) {
        return DropdownMenuItem<TranslationEntry>(
          value: entry,
          child: SizedBox(
            width: 350.0,
            child: Row(
              spacing: 4.0,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: Theme.of(Get.context!).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    entry.targetLanguage.code,
                    style: GoogleFonts.notoSansMono(
                      color: Theme.of(Get.context!).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    entry.targetLanguage.nativeName,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedSourceEntry = value;
          });
          log('选择源语言: ${value.targetLanguage.code} - ${value.targetLanguage.nativeName}',
              name: 'BatchTranslationDialog');
        }
      },
    );
  }

  /// 构建翻译选项
  Widget _buildTranslationOptions() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.autorenew,
            color: Theme.of(context).primaryColor,
            size: 20.0,
          ),
          const SizedBox(width: 12.0),
          const Expanded(
            child: Text(
              '是否覆盖已有翻译',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: _isOverride,
            onChanged: (value) {
              setState(() {
                _isOverride = value;
              });
            },
          ),
        ],
      ),
    );
  }

  /// 构建操作按钮
  List<Widget> _buildActions() {
    switch (_translationStatus) {
      case BatchTranslationStatus.idle:
        return [
          TextButton(
            onPressed: () => _closeDialog(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: _startBatchTranslation,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 2.0,
              shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
            child: const Text(
              '开始翻译',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ),
        ];

      case BatchTranslationStatus.running:
        return [
          ElevatedButton.icon(
            onPressed: _pauseTranslation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            icon: const Icon(Icons.pause, size: 16.0),
            label: const Text('暂停'),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton.icon(
            onPressed: _stopTranslation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            icon: const Icon(Icons.stop, size: 16.0),
            label: const Text('停止'),
          ),
        ];

      case BatchTranslationStatus.paused:
        return [
          ElevatedButton.icon(
            onPressed: _resumeTranslation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            icon: const Icon(Icons.play_arrow, size: 16.0),
            label: const Text('继续'),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton.icon(
            onPressed: _stopTranslation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            icon: const Icon(Icons.stop, size: 16.0),
            label: const Text('停止'),
          ),
          const SizedBox(width: 8.0),
          ElevatedButton.icon(
            onPressed: _saveCurrentProgress,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            icon: const Icon(Icons.save, size: 16.0),
            label: const Text('保存进度'),
          ),
        ];

      case BatchTranslationStatus.completed:
      case BatchTranslationStatus.cancelled:
        return [
          ElevatedButton(
            onPressed: () => _closeDialog(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              '完成',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ),
        ];
    }
  }

  /// 开始批量翻译
  Future<void> _startBatchTranslation() async {
    // 表单验证
    if (_selectedProvider == null) {
      _showErrorSnackBar('请选择翻译接口');
      return;
    }

    if (_selectedSourceEntry == null) {
      _showErrorSnackBar('请选择翻译基准语言');
      return;
    }

    try {
      final translationManager = Get.find<TranslationServiceManager>();

      // 检查翻译配置
      if (!await translationManager.hasValidConfigAsync()) {
        if (mounted) {
          await TranslationServiceManager.showConfigCheckDialog(context);
        }
        return;
      }

      // 准备翻译条目
      _prepareBatchTranslation();

      // 开始翻译
      setState(() {
        _translationStatus = BatchTranslationStatus.running;
      });

      _startTranslationProcess();
    } catch (error, stackTrace) {
      log('批量翻译异常', error: error, stackTrace: stackTrace, name: 'BatchTranslationDialog');
      _showErrorSnackBar('翻译处理异常: $error');
    }
  }

  /// 准备批量翻译
  void _prepareBatchTranslation() {
    final allEntries = widget.controller.translationEntries;
    final Map<String, List<TranslationEntry>> entriesByKey = {};

    // 按 key 分组
    for (final entry in allEntries) {
      entriesByKey.putIfAbsent(entry.key, () => []).add(entry);
    }

    // 获取需要翻译的条目
    _pendingEntries.clear();
    final sourceLanguageCode = _selectedSourceEntry!.targetLanguage.code;

    // 遍历所有翻译键，翻译整个项目
    for (final translationKey in entriesByKey.keys) {
      final keyEntries = entriesByKey[translationKey]!;

      // 找到源语言的条目
      final sourceEntry = keyEntries.firstWhereOrNull(
        (entry) => entry.targetLanguage.code == sourceLanguageCode && entry.targetText.isNotEmpty,
      );

      // 如果源语言没有对应的翻译，跳过这个key
      if (sourceEntry == null) continue;

      // 翻译其他语言的条目
      for (final entry in keyEntries) {
        // 跳过源语言本身
        if (entry.targetLanguage.code == sourceLanguageCode) continue;

        // 如果不覆盖且已有翻译，则跳过
        if (!_isOverride && entry.targetText.trim().isNotEmpty) continue;

        _pendingEntries.add(entry.copyWith(
          sourceText: sourceEntry.targetText,
        ));
      }
    }

    _totalCount = _pendingEntries.length;
    _currentIndex = 0;
    _successCount = 0;
    _failCount = 0;
    _processedEntries.clear();
    _shouldStop = false;
  }

  /// 开始翻译流程
  void _startTranslationProcess() {
    _translationTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (_shouldStop || _currentIndex >= _pendingEntries.length) {
        timer.cancel();
        if (_currentIndex >= _pendingEntries.length) {
          setState(() {
            _translationStatus = BatchTranslationStatus.completed;
          });
          _showCompletionDialog();
        }
        return;
      }

      if (_translationStatus == BatchTranslationStatus.running) {
        _translateNextEntry();
      }
    });
  }

  /// 翻译下一个条目
  Future<void> _translateNextEntry() async {
    if (_currentIndex >= _pendingEntries.length) return;

    final entry = _pendingEntries[_currentIndex];

    try {
      final translationManager = Get.find<TranslationServiceManager>();

      final results = await translationManager.batchTranslateEntries(
        sourceEntries: _selectedSourceEntry!,
        entries: [entry],
        provider: _selectedProvider!,
      );

      if (results.isNotEmpty && results.first.success) {
        _successCount++;
        final result = results.first;
        final updatedEntry = entry.copyWith(
          targetText: result.translatedText,
          status: TranslationStatus.completed,
          updatedAt: DateTime.now(),
        );
        _processedEntries.add(updatedEntry);

        // 立即更新到控制器
        await widget.controller.updateTranslationEntry(updatedEntry, isShowSnackbar: false);
      } else {
        _failCount++;
        final errorMessage = results.isNotEmpty ? results.first.error : '翻译失败';
        log('翻译失败: ${entry.key} - $errorMessage', name: 'BatchTranslationDialog');
      }
    } catch (error, stackTrace) {
      _failCount++;
      log('翻译条目异常', error: error, stackTrace: stackTrace, name: 'BatchTranslationDialog');
    }

    setState(() {
      _currentIndex++;
    });
  }

  /// 暂停翻译
  void _pauseTranslation() {
    setState(() {
      _translationStatus = BatchTranslationStatus.paused;
    });
    _translationTimer?.cancel();
  }

  /// 继续翻译
  void _resumeTranslation() {
    setState(() {
      _translationStatus = BatchTranslationStatus.running;
    });
    _startTranslationProcess();
  }

  /// 停止翻译
  void _stopTranslation() {
    _shouldStop = true;
    _translationTimer?.cancel();
    setState(() {
      _translationStatus = BatchTranslationStatus.cancelled;
    });
  }

  /// 保存当前进度
  Future<void> _saveCurrentProgress() async {
    try {
      // 刷新翻译条目显示
      await widget.controller.refreshTranslationEntries();

      _showInfoSnackBar('当前进度已保存');
    } catch (error, stackTrace) {
      log('保存进度失败', error: error, stackTrace: stackTrace, name: 'BatchTranslationDialog');
      _showErrorSnackBar('保存进度失败: $error');
    }
  }

  /// 显示完成对话框
  void _showCompletionDialog() {
    final message = '批量翻译完成！\n成功: $_successCount 个\n失败: $_failCount 个';

    Get.snackbar(
      '翻译完成',
      message,
      backgroundColor: _failCount > 0 ? Colors.orange : Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );

    // 刷新翻译条目显示
    widget.controller.refreshTranslationEntries();
  }

  /// 关闭对话框
  void _closeDialog() {
    if (_translationStatus == BatchTranslationStatus.running) {
      // 如果正在翻译，先停止
      _stopTranslation();
    }
    Get.back();
  }

  /// 显示错误提示
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// 显示信息提示
  void _showInfoSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
