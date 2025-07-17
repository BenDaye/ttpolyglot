import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

class UploadDrop extends StatefulWidget {
  final Widget child;
  final Function(List<PlatformFile> files)? onDrop;
  final Function(bool)? onDragging;

  const UploadDrop({
    super.key,
    required this.child,
    this.onDrop,
    this.onDragging,
  });

  @override
  State<UploadDrop> createState() => _UploadDropState();
}

class _UploadDropState extends State<UploadDrop> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // 判断是否是web端
      return Stack(
        children: [
          DropzoneView(
            onHover: () => widget.onDragging?.call(true),
            onLeave: () => widget.onDragging?.call(false),
            onDropFiles: (details) {
              widget.onDragging?.call(false);
              //
              if (details == null || details.isEmpty) {
                return;
              }
              final files = details
                  .map((item) => PlatformFile(
                        name: item.name,
                        size: item.size,
                        path: item.webkitRelativePath,
                        // bytes: item.,
                        // readStream: item.,
                      ))
                  .toList();
              widget.onDrop?.call(files);
            },
          ),
          widget.child,
        ],
      );
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // 桌面端
      return DropTarget(
        onDragEntered: (details) => widget.onDragging?.call(true),
        onDragExited: (details) => widget.onDragging?.call(false),
        onDragDone: (details) async {
          widget.onDragging?.call(false);
          //
          if (details.files.isEmpty) {
            return;
          }
          final files = await Future.wait(details.files.map((item) async => PlatformFile(
                name: item.name,
                size: await item.length(),
                path: item.path,
                bytes: await item.readAsBytes(),
                readStream: item.openRead(),
              )));
          widget.onDrop?.call(files);
        },
        child: widget.child,
      );
    }
    return widget.child;
  }
}
