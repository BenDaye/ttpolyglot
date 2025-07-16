import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ttpolyglot_core/core.dart';

/// 拖拽上传组件
class DragDropUpload extends StatefulWidget {
  const DragDropUpload({
    super.key,
    required this.onFileSelected,
    required this.languages,
    this.allowedExtensions = const [],
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.multiple = false,
    this.height = 200.0,
    this.title = '拖拽文件到此处或点击选择',
    this.subtitle = '支持多种文件格式',
    this.icon = Icons.cloud_upload,
    this.borderRadius = 12.0,
    this.showFileInfo = true,
  });

  /// 文件选择回调
  final Function(List<PlatformFile>, Map<String, Language>) onFileSelected;

  /// 可选的语言列表
  final List<Language> languages;

  /// 允许的文件扩展名（不包含点号）
  final List<String> allowedExtensions;

  /// 最大文件大小（字节）
  final int maxFileSize;

  /// 是否支持多文件选择
  final bool multiple;

  /// 组件高度
  final double height;

  /// 标题文本
  final String title;

  /// 副标题文本
  final String subtitle;

  /// 图标
  final IconData icon;

  /// 圆角半径
  final double borderRadius;

  /// 是否显示文件信息
  final bool showFileInfo;

  @override
  State<DragDropUpload> createState() => _DragDropUploadState();
}

class _DragDropUploadState extends State<DragDropUpload> {
  bool _isDragOver = false;
  final List<PlatformFile> _selectedFiles = [];

  // 文件语言映射：文件名 -> 选择的语言
  final Map<String, Language> _fileLanguageMap = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 上传区域
        Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isDragOver ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline,
              width: _isDragOver ? 3.0 : 2.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: _isDragOver
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ),
          child: _buildUploadArea(),
        ),

        // 文件列表（如果有文件且需要显示）
        if (_selectedFiles.isNotEmpty && widget.showFileInfo) ...[
          const SizedBox(height: 16.0),
          _buildFileList(),
        ],
      ],
    );
  }

  Widget _buildUploadArea() {
    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        setState(() {
          _isDragOver = true;
        });
        return true;
      },
      onAcceptWithDetails: (details) {
        setState(() {
          _isDragOver = false;
        });
        _handleDroppedFiles(details.data);
      },
      onLeave: (data) {
        setState(() {
          _isDragOver = false;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: _pickFiles,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: 48.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: _pickFiles,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('选择文件'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileList() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 表格标题
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              spacing: 10.0,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    '语言',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '文件名',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      '翻译数量',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '已解决/冲突',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                ),
                const SizedBox(width: 48.0), // 为删除按钮留出空间
              ],
            ),
          ),

          // 文件列表
          if (_selectedFiles.isNotEmpty) ...[
            ...(_selectedFiles.asMap().entries.map((entry) {
              final index = entry.key;
              final file = entry.value;
              return _buildFileTableRow(file, index);
            })),
          ],

          // 底部操作按钮
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // 取消导入 - 清空文件列表
                    setState(() {
                      _selectedFiles.clear();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: const Text('取消导入'),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    // 判断是否所有文件都有效
                    for (final file in _selectedFiles) {
                      if (!_validateFile(file)) {
                        _showErrorSnackBar('文件 ${file.name} 超出限制');
                        return;
                      }
                    }
                    // 确认导入
                    widget.onFileSelected(_selectedFiles, _fileLanguageMap);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('导入'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTableRow(PlatformFile file, int index) {
    final isValid = _validateFile(file);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        spacing: 10.0,
        children: [
          // 语言
          Expanded(
            flex: 2,
            child: _buildLanguageSelector(file),
          ),
          // 文件名
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (!isValid) ...[
                  const SizedBox(height: 4.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber,
                          size: 12.0,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '超出限制',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // 翻译数量
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
              ),
            ),
          ),
          // 已解决/冲突
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '0 / 0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          // 删除按钮
          SizedBox(
            width: 48.0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedFiles.removeAt(index);
                });
              },
              icon: const Icon(Icons.delete_outline, size: 18.0),
              iconSize: 18.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(
                minWidth: 48.0,
                minHeight: 48.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(PlatformFile file) {
    final selectedLanguage = _fileLanguageMap[file.name];
    final availableLanguages = widget.languages;

    // 如果没有选择语言，尝试自动匹配
    if (selectedLanguage == null && availableLanguages.isNotEmpty) {
      final matchedLanguage = _matchLanguageFromFileName(file.name);
      if (matchedLanguage != null) {
        _fileLanguageMap[file.name] = matchedLanguage;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButton<Language>(
        value: _fileLanguageMap[file.name],
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down, size: 16.0),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
        hint: const Text('选择语言'),
        items: availableLanguages
            .map(
              (language) => DropdownMenuItem<Language>(
                value: language,
                child: Text(
                  '${language.nativeName} (${language.code})',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
            .toList(),
        onChanged: (language) {
          if (language != null) {
            setState(() {
              _fileLanguageMap[file.name] = language;
            });
          }
        },
      ),
    );
  }

  /// 选择文件
  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions.isEmpty ? null : widget.allowedExtensions,
        allowMultiple: widget.multiple,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          // 检查并处理重复文件
          for (final newFile in result.files) {
            final existingIndex = _selectedFiles.indexWhere(
              (existingFile) => existingFile.name == newFile.name,
            );

            if (existingIndex != -1) {
              // 文件已存在，覆盖
              _selectedFiles[existingIndex] = newFile;
              log('文件已存在，已覆盖: ${newFile.name}');
            } else {
              // 文件不存在，添加
              _selectedFiles.add(newFile);
              // 自动匹配语言
              final matchedLanguage = _matchLanguageFromFileName(newFile.name);
              if (matchedLanguage != null) {
                _fileLanguageMap[newFile.name] = matchedLanguage;
              }
              log('添加新文件: ${newFile.name}');
            }
          }
        });

        // 如果不是多文件模式，立即回调
        if (!widget.multiple) {
          widget.onFileSelected(_selectedFiles, _fileLanguageMap);
        }
      }
    } catch (error, stackTrace) {
      log('_pickFiles', error: error, stackTrace: stackTrace);
      _showErrorSnackBar('选择文件失败: $error');
    }
  }

  /// 处理拖拽的文件
  void _handleDroppedFiles(dynamic data) {
    try {
      if (data is List) {
        final files = <PlatformFile>[];
        for (final item in data) {
          if (item is PlatformFile) {
            files.add(item);
          }
        }
        if (files.isNotEmpty) {
          setState(() {
            // 检查并处理重复文件
            for (final newFile in files) {
              final existingIndex = _selectedFiles.indexWhere(
                (existingFile) => existingFile.name == newFile.name,
              );

              if (existingIndex != -1) {
                // 文件已存在，覆盖
                _selectedFiles[existingIndex] = newFile;
                log('文件已存在，已覆盖: ${newFile.name}');
              } else {
                // 文件不存在，添加
                _selectedFiles.add(newFile);
                // 自动匹配语言
                final matchedLanguage = _matchLanguageFromFileName(newFile.name);
                if (matchedLanguage != null) {
                  _fileLanguageMap[newFile.name] = matchedLanguage;
                }
                log('添加新文件: ${newFile.name}');
              }
            }
          });

          // 如果不是多文件模式，立即回调
          if (!widget.multiple) {
            widget.onFileSelected(_selectedFiles, _fileLanguageMap);
          }
        }
      }
    } catch (error, stackTrace) {
      log('_handleDroppedFiles', error: error, stackTrace: stackTrace);
      _showErrorSnackBar('处理拖拽文件失败: $error');
    }
  }

  /// 验证文件
  bool _validateFile(PlatformFile file) {
    // 检查文件大小
    if (file.size > widget.maxFileSize) {
      return false;
    }

    // 检查文件扩展名
    if (widget.allowedExtensions.isNotEmpty) {
      final extension = _getFileExtension(file.name);
      if (!widget.allowedExtensions.contains(extension.toLowerCase())) {
        return false;
      }
    }

    return true;
  }

  /// 获取文件扩展名
  String _getFileExtension(String fileName) {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last : '';
  }

  /// 根据文件名匹配语言
  Language? _matchLanguageFromFileName(String fileName) {
    if (widget.languages.isEmpty) return null;

    final fileNameLower = fileName.toLowerCase();

    // 尝试匹配语言代码
    for (final language in widget.languages) {
      final code = language.code.toLowerCase();
      final languageCode = code.split('-').first;
      if (code == fileName || fileNameLower.contains(languageCode)) {
        log('根据文件名匹配到语言: ${language.nativeName} (${language.code})');
        return language;
      }
    }

    // 如果没有匹配到，返回第一个语言
    log('未匹配到语言，使用默认语言: ${widget.languages.first.nativeName} (${widget.languages.first.code})');
    return widget.languages.first;
  }

  /// 显示错误提示
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onError,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
