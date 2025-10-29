import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttpolyglot/src/features/reset_password/reset_password.dart';

/// 重置密码视图
class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('重置密码'),
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
                        Icons.key_outlined,
                        size: 64.0,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16.0),

                      // 标题
                      Text(
                        '设置新密码',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),

                      // 说明文字
                      Text(
                        '请设置您的新密码',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32.0),

                      // 新密码输入框
                      Obx(() => TextFormField(
                            controller: controller.passwordController,
                            obscureText: !controller.showPassword,
                            decoration: InputDecoration(
                              labelText: '新密码',
                              hintText: '至少8位，包含字母和数字',
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
                            textInputAction: TextInputAction.next,
                            validator: controller.validatePassword,
                          )),
                      const SizedBox(height: 8.0),

                      // 密码强度指示器
                      Obx(() => _buildPasswordStrengthIndicator(context)),
                      const SizedBox(height: 16.0),

                      // 确认密码输入框
                      Obx(() => TextFormField(
                            controller: controller.confirmPasswordController,
                            obscureText: !controller.showConfirmPassword,
                            decoration: InputDecoration(
                              labelText: '确认新密码',
                              hintText: '请再次输入新密码',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.showConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: controller.toggleConfirmPasswordVisibility,
                                tooltip: controller.showConfirmPassword ? '隐藏密码' : '显示密码',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surface,
                            ),
                            textInputAction: TextInputAction.done,
                            validator: controller.validateConfirmPassword,
                            onFieldSubmitted: (_) => controller.resetPassword(),
                          )),
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
                      const SizedBox(height: 24.0),

                      // 重置密码按钮
                      Obx(() => ElevatedButton(
                            onPressed: controller.isLoading ? null : controller.resetPassword,
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
                                    '确认重置',
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
                          TextButton(
                            onPressed: controller.goToSignIn,
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

  /// 构建密码强度指示器
  Widget _buildPasswordStrengthIndicator(BuildContext context) {
    if (controller.passwordStrength == 0) {
      return const SizedBox.shrink();
    }

    final strengthLabels = ['很弱', '弱', '中', '强', '很强'];
    final strengthColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow.shade700,
      Colors.lightGreen,
      Colors.green,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) {
            return Expanded(
              child: Container(
                height: 4.0,
                margin: EdgeInsets.only(
                  right: index < 3 ? 4.0 : 0.0,
                ),
                decoration: BoxDecoration(
                  color: index < controller.passwordStrength
                      ? strengthColors[controller.passwordStrength - 1]
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4.0),
        Text(
          '密码强度：${strengthLabels[controller.passwordStrength - 1]}',
          style: TextStyle(
            fontSize: 12.0,
            color: strengthColors[controller.passwordStrength - 1],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
