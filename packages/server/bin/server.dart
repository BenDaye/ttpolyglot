import 'dart:io';

import 'package:ttpolyglot_server/server.dart';

void main(List<String> args) async {
  try {
    final logger = LoggerFactory.getLogger('ServerMain');
    // 启动服务器
    final server = TTPolyglotServer();
    await server.start();

    logger.info('TTPolyglot 服务端启动成功');

    // 处理优雅关闭信号
    ProcessSignal.sigint.watch().listen((signal) async {
      logger.info('接收到关闭信号，正在优雅关闭服务器...');
      await server.stop();
      exit(0);
    });

    ProcessSignal.sigterm.watch().listen((signal) async {
      logger.info('接收到终止信号，正在优雅关闭服务器...');
      await server.stop();
      exit(0);
    });
  } catch (error, stackTrace) {
    logger.error('服务器启动失败', error: error, stackTrace: stackTrace);
    exit(1);
  }
}
