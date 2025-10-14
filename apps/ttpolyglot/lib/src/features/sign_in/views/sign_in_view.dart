import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/sign_in/sign_in.dart';

/// 登录视图
class SignInView extends GetView<SignInController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400.0),
            child: Obx(() => Form(
                  key: controller.formKey,
                  autovalidateMode: controller.autoValidateMode,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo 图标
                      Icon(
                        Icons.translate,
                        size: 64.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16.0),

                      // 应用标题
                      Text(
                        'TTPolyglot',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),

                      // 副标题
                      Text(
                        '翻译管理平台',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48.0),

                      // 用户名/邮箱输入框
                      TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          labelText: '用户名或邮箱',
                          hintText: '请输入用户名或邮箱',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: controller.validateEmail,
                        onFieldSubmitted: (_) {
                          // 按回车后聚焦到密码框
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // 密码输入框
                      Obx(() => TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.showPassword,
                            decoration: InputDecoration(
                              labelText: '密码',
                              hintText: '请输入密码',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                                tooltip: controller.showPassword ? '隐藏密码' : '显示密码',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                            textInputAction: TextInputAction.done,
                            validator: controller.validatePassword,
                            onFieldSubmitted: (_) => controller.login(),
                          )),
                      const SizedBox(height: 8.0),

                      // 错误提示
                      Obx(() => controller.errorMessage.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      controller.errorMessage,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.error,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink()),
                      const SizedBox(height: 24.0),

                      // 登录按钮
                      Obx(() => ElevatedButton(
                            onPressed: controller.isLoading ? null : controller.login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              elevation: 2.0,
                            ),
                            child: controller.isLoading
                                ? const SizedBox(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    '登录',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          )),
                      const SizedBox(height: 16.0),

                      // 其他选项（暂时隐藏）
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     TextButton(
                      //       onPressed: () {
                      //         // TODO: 忘记密码
                      //       },
                      //       child: const Text('忘记密码？'),
                      //     ),
                      //     TextButton(
                      //       onPressed: () {
                      //         // TODO: 注册账号
                      //       },
                      //       child: const Text('注册账号'),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
