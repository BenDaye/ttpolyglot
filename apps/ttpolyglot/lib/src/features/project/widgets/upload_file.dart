import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ttpolyglot/src/features/project/widgets/upload_drop.dart';

class UploadFile extends StatefulWidget {
  final double height;
  final bool multiple;
  final String title;
  final String subtitle;
  final List<String> allowedExtensions;
  final int maxFileSize;
  final Function(List<PlatformFile>)? onFileSelected;

  const UploadFile({
    super.key,
    this.height = 200.0,
    this.multiple = false,
    this.title = '拖拽文件到此处或点击选择',
    this.subtitle = '支持 JSON、CSV、Excel、ARB、PO 格式',
    this.allowedExtensions = const [],
    this.maxFileSize = 10 * 1024 * 1024, // 10MB
    this.onFileSelected,
  });

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  bool _isDragging = false;

  /// 过滤文件方法
  void _filterFiles(List<PlatformFile> files) {
    // 定义符合条件的文件列表
    final validFiles = <PlatformFile>[];
    // 循环遍历选中的文件
    for (final file in files) {
      // 检查文件大小
      if (file.size > widget.maxFileSize) {
        _showErrorSnackBar('文件 ${file.name} 大小超出限制');
        continue;
      }
      // 检查文件扩展名
      final extension = file.name.split('.').last;
      if (!widget.allowedExtensions.contains(extension)) {
        _showErrorSnackBar('文件 ${file.name} 不支持的文件类型');
        continue;
      }
      validFiles.add(file);
    }
    if (validFiles.isEmpty) {
      return;
    }
    // 执行回调
    widget.onFileSelected?.call(validFiles);
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
      //
      if (result == null) {
        return;
      }
      //
      _filterFiles(result.files);
    } catch (error, stackTrace) {
      log('_pickFiles', error: error, stackTrace: stackTrace);
      _showErrorSnackBar('选择文件失败: $error');
    }
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

  @override
  Widget build(BuildContext context) {
    return UploadDrop(
      onDrop: _filterFiles,
      onDragging: (isDragging) => setState(() => _isDragging = isDragging),
      child: GestureDetector(
        onTap: _pickFiles,
        child: Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isDragging
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              width: 2.0,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12.0),
            color: _isDragging
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                : Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_upload,
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
                style: _isDragging
                    ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        )
                    : Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
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
      ),
    );
  }
}
