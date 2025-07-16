import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

/// 拖拽上传组件
class DragDropUpload extends StatefulWidget {
  const DragDropUpload({
    super.key,
    required this.onFileSelected,
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
  final Function(List<PlatformFile>) onFileSelected;

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
  List<PlatformFile> _selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isDragOver
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.outline,
          width: _isDragOver ? 3.0 : 2.0,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: _isDragOver
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_selectedFiles.isNotEmpty && widget.showFileInfo) {
      return _buildFileList();
    }

    return _buildUploadArea();
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
                // if (widget.allowedExtensions.isNotEmpty) ...[
                //   const SizedBox(height: 8.0),
                //   Text(
                //     '支持格式: ${widget.allowedExtensions.map((ext) => '.$ext').join(', ')}',
                //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                //           color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                //         ),
                //   ),
                // ],
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
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _selectedFiles.length,
            itemBuilder: (context, index) {
              final file = _selectedFiles[index];
              return _buildFileItem(file, index);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '已选择 ${_selectedFiles.length} 个文件',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFiles.clear();
                  });
                },
                child: const Text('清空'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  widget.onFileSelected(_selectedFiles);
                },
                child: const Text('确认上传'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFileItem(PlatformFile file, int index) {
    final isValid = _validateFile(file);
    final fileSize = _formatFileSize(file.size);
    final extension = _getFileExtension(file.name);

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isValid
            ? Theme.of(context).colorScheme.surfaceContainer
            : Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isValid
              ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)
              : Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.insert_drive_file : Icons.error,
            color: isValid
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.error,
            size: 24.0,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$fileSize • $extension',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                if (!isValid) ...[
                  const SizedBox(height: 4.0),
                  Text(
                    _getValidationError(file),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedFiles.removeAt(index);
              });
            },
            icon: const Icon(Icons.close),
            iconSize: 20.0,
          ),
        ],
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
          _selectedFiles = result.files;
        });

        if (!widget.multiple) {
          widget.onFileSelected(_selectedFiles);
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
            _selectedFiles = files;
          });
          if (!widget.multiple) {
            widget.onFileSelected(_selectedFiles);
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

  /// 获取验证错误信息
  String _getValidationError(PlatformFile file) {
    if (file.size > widget.maxFileSize) {
      return '文件过大，最大支持 ${_formatFileSize(widget.maxFileSize)}';
    }

    if (widget.allowedExtensions.isNotEmpty) {
      final extension = _getFileExtension(file.name);
      if (!widget.allowedExtensions.contains(extension.toLowerCase())) {
        return '不支持的文件格式，支持: ${widget.allowedExtensions.map((ext) => '.$ext').join(', ')}';
      }
    }

    return '文件验证失败';
  }

  /// 获取文件扩展名
  String _getFileExtension(String fileName) {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last : '';
  }

  /// 格式化文件大小
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '${bytes}B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  /// 显示错误提示
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}