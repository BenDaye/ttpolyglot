import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/forgot_password/forgot_password.dart';

/// 忘记密码视图
class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('忘记密码'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.backToSignIn,
        ),
      ),
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
                        Icons.lock_reset_outlined,
                        size: 64.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16.0),

                      // 标题
                      Text(
                        '重置密码',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),

                      // 说明文字
                      Text(
                        '请输入您的注册邮箱，我们将发送重置密码的链接到您的邮箱',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32.0),

                      // 邮箱输入框
                      TextFormField(
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          labelText: '邮箱',
                          hintText: '请输入注册邮箱',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        validator: controller.validateEmail,
                        onFieldSubmitted: (_) {
                          if (controller.canResend) {
                            controller.sendResetEmail();
                          }
                        },
                      ),
                      const SizedBox(height: 16.0),

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

                      // 成功提示
                      Obx(() => controller.successMessage.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.green,
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      controller.successMessage,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink()),
                      const SizedBox(height: 24.0),

                      // 发送按钮
                      Obx(() => ElevatedButton(
                            onPressed: controller.canResend ? controller.sendResetEmail : null,
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
                                : controller.countdown > 0
                                    ? Text(
                                        '${controller.countdown}秒后可重新发送',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : const Text(
                                        '发送重置邮件',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                          )),
                      const SizedBox(height: 16.0),

                      // 返回登录
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('想起密码了？'),
                          TextButton(
                            onPressed: controller.backToSignIn,
                            child: const Text('返回登录'),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
