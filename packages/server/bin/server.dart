import 'dart:developer';
import 'dart:io';

import 'package:ttpolyglot_server/server.dart';

void main(List<String> args) async {
  try {
    // 启动服务器
    final server = TTPolyglotServer();
    await server.start();

    log('TTPolyglot 服务端启动成功', name: 'ServerMain');

    // 处理优雅关闭信号
    ProcessSignal.sigint.watch().listen((signal) async {
      log('接收到关闭信号，正在优雅关闭服务器...', name: 'ServerMain');
      await server.stop();
      exit(0);
    });

    ProcessSignal.sigterm.watch().listen((signal) async {
      log('接收到终止信号，正在优雅关闭服务器...', name: 'ServerMain');
      await server.stop();
      exit(0);
    });
  } catch (error, stackTrace) {
    log('服务器启动失败', error: error, stackTrace: stackTrace, name: 'ServerMain');
    exit(1);
  }
}
