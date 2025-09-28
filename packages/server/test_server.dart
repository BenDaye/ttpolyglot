import 'dart:io';

import 'package:ttpolyglot_server/server.dart';

void main() async {
  print('开始测试服务器启动...');

  try {
    // 测试创建服务器实例
    print('创建服务器实例...');
    final serverInstance = TTPolyglotServer();
    print('服务器实例创建成功');

    // 测试启动服务器
    print('启动服务器...');
    await serverInstance.start();
    print('服务器启动成功');
  } catch (error, stackTrace) {
    print('错误: $error');
    print('堆栈: $stackTrace');
    exit(1);
  }
}
