import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

final class DialogUtils {
  DialogUtils._();

  static CancelFunc showSuccess(
    String message, {
    String? title,
    Future<bool> Function()? onConfirm,
    Future<bool> Function()? onCancel,
  }) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              if (onCancel != null) {
                final result = await onCancel.call();
                if (result) {
                  cancel();
                }
              } else {
                cancel();
              }
            },
            child: AnimatedBuilder(
              builder: (_, Widget? child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              animation: controller,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
            ),
          ),
          CustomSingleChildLayout(
            delegate: _CustomLayoutDelegate(),
            child: child,
          ),
        ],
      ),
      toastBuilder: (cancelFunc) => _DialogCard(
        title: title ?? '成功',
        message: message,
        icon: Icons.check_circle,
        iconColor: Colors.green,
        onConfirm: () async {
          if (onConfirm != null) {
            final result = await onConfirm.call();
            if (result) {
              cancelFunc();
            }
          } else {
            cancelFunc();
          }
        },
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static CancelFunc showError(
    String message, {
    String? title,
    Future<bool> Function()? onConfirm,
  }) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: AnimatedBuilder(
              builder: (_, Widget? child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              animation: controller,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
            ),
          ),
          CustomSingleChildLayout(
            delegate: _CustomLayoutDelegate(),
            child: child,
          ),
        ],
      ),
      toastBuilder: (cancelFunc) => _DialogCard(
        title: title ?? '错误',
        message: message,
        icon: Icons.error,
        iconColor: Colors.red,
        onConfirm: () async {
          if (onConfirm != null) {
            final result = await onConfirm.call();
            if (result) {
              cancelFunc();
            }
          } else {
            cancelFunc();
          }
        },
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static CancelFunc showInfo(
    String message, {
    String? title,
    Future<bool> Function()? onConfirm,
    Future<bool> Function()? onCancel,
  }) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              if (onCancel != null) {
                final result = await onCancel.call();
                if (result) {
                  cancel();
                }
              } else {
                cancel();
              }
            },
            child: AnimatedBuilder(
              builder: (_, Widget? child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              animation: controller,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
            ),
          ),
          CustomSingleChildLayout(
            delegate: _CustomLayoutDelegate(),
            child: child,
          ),
        ],
      ),
      toastBuilder: (cancelFunc) => _DialogCard(
        title: title ?? '提示',
        message: message,
        icon: Icons.info,
        iconColor: Colors.blue,
        onConfirm: () async {
          if (onConfirm != null) {
            final result = await onConfirm.call();
            if (result) {
              cancelFunc();
            }
          } else {
            cancelFunc();
          }
        },
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static CancelFunc showWarning(
    String message, {
    String? title,
    Future<bool> Function()? onConfirm,
    Future<bool> Function()? onCancel,
  }) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              if (onCancel != null) {
                final result = await onCancel.call();
                if (result) {
                  cancel();
                }
              } else {
                cancel();
              }
            },
            child: AnimatedBuilder(
              builder: (_, Widget? child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              animation: controller,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
            ),
          ),
          CustomSingleChildLayout(
            delegate: _CustomLayoutDelegate(),
            child: child,
          ),
        ],
      ),
      toastBuilder: (cancelFunc) => _DialogCard(
        title: title ?? '警告',
        message: message,
        icon: Icons.warning,
        iconColor: Colors.orange,
        onConfirm: () async {
          if (onConfirm != null) {
            final result = await onConfirm.call();
            if (result) {
              cancelFunc();
            }
          } else {
            cancelFunc();
          }
        },
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static CancelFunc showConfirm(
    String message, {
    String? title,
    String? confirmText,
    String? cancelText,
    Future<bool> Function()? onConfirm,
    Future<bool> Function()? onCancel,
  }) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              if (onCancel != null) {
                final result = await onCancel.call();
                if (result) {
                  cancel();
                }
              } else {
                cancel();
              }
            },
            child: AnimatedBuilder(
              builder: (_, Widget? child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              animation: controller,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
            ),
          ),
          CustomSingleChildLayout(
            delegate: _CustomLayoutDelegate(),
            child: child,
          ),
        ],
      ),
      toastBuilder: (cancelFunc) => _ConfirmDialogCard(
        title: title ?? '确认',
        message: message,
        confirmText: confirmText ?? '确定',
        cancelText: cancelText ?? '取消',
        onConfirm: () async {
          if (onConfirm != null) {
            final result = await onConfirm.call();
            if (result) {
              cancelFunc();
            }
          } else {
            cancelFunc();
          }
        },
        onCancel: () async {
          if (onCancel != null) {
            final result = await onCancel.call();
            if (result) {
              cancelFunc();
            }
          } else {
            cancelFunc();
          }
        },
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}

class _CustomLayoutDelegate extends SingleChildLayoutDelegate {
  _CustomLayoutDelegate();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(
      (size.width - childSize.width) / 2.0,
      (size.height - childSize.height) / 2.0,
    );
  }

  @override
  bool shouldRelayout(_CustomLayoutDelegate oldDelegate) => false;
}

class _DialogCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onConfirm;

  const _DialogCard({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 280.0,
        minWidth: 280.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Material(
        color: theme.dialogBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
              child: Text(
                message,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Divider(height: 1.0, color: theme.dividerColor),
            InkWell(
              onTap: onConfirm,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  '确定',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmDialogCard extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ConfirmDialogCard({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 280.0,
        minWidth: 280.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Material(
        color: theme.dialogBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
              child: Text(
                message,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            Divider(height: 1.0, color: theme.dividerColor),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: onCancel,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        cancelText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1.0,
                  height: 44.0,
                  color: theme.dividerColor,
                ),
                Expanded(
                  child: InkWell(
                    onTap: onConfirm,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        confirmText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
