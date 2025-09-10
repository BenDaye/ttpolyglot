import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<bool> saveTextFile({
  required String fileName,
  required String content,
  String mimeType = 'text/plain',
}) async {
  final savePath = await FilePicker.platform.saveFile(
    dialogTitle: '选择保存位置',
    fileName: fileName,
    type: FileType.any,
  );
  if (savePath == null) return false;
  final file = File(savePath);
  await file.writeAsString(content);
  return true;
}

Future<bool> saveBytesFile({
  required String fileName,
  required List<int> bytes,
  String mimeType = 'application/octet-stream',
}) async {
  final savePath = await FilePicker.platform.saveFile(
    dialogTitle: '选择保存位置',
    fileName: fileName,
    type: FileType.any,
  );
  if (savePath == null) return false;
  final file = File(savePath);
  await file.writeAsBytes(bytes);
  return true;
}
