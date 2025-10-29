import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ttpolyglot_utils/utils.dart';

class UploadDrop extends StatefulWidget {
  final Widget child;
  final Function(bool)? onDragging;
  final Function(List<PlatformFile>)? onDrop;

  const UploadDrop({
    super.key,
    required this.child,
    this.onDragging,
    this.onDrop,
  });

  @override
  State<UploadDrop> createState() => _UploadDropState();
}

class _UploadDropState extends State<UploadDrop> {
  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (details) {
        LoggerUtils.error('文件拖拽进入区域');
        //
        widget.onDragging?.call(true);
      },
      onDragExited: (details) {
        LoggerUtils.error('文件拖拽离开区域');
        //
        widget.onDragging?.call(false);
      },
      onDragDone: (details) async {
        LoggerUtils.error('文件被释放，共${details.files.length}个文件');
        //
        widget.onDragging?.call(false);

        final List<XFile> files = details.files;

        final platformFiles = await Future.wait(files.map((item) async {
          final bytes = await item.readAsBytes();
          return PlatformFile(
            name: item.name,
            size: bytes.length,
            path: item.path,
            bytes: bytes,
          );
        }));

        widget.onDrop?.call(platformFiles);
      },
      child: widget.child,
    );
  }
}
