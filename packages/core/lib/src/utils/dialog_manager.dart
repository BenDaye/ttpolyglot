import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

final class DialogManager {
  DialogManager._();

  static CancelFunc showSuccess(String message, {String? title}) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
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
        onConfirm: cancelFunc,
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static CancelFunc showError(String message, {String? title}) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
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
        title: title ?? '错误',
        message: message,
        icon: Icons.error,
        iconColor: Colors.red,
        onConfirm: cancelFunc,
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static CancelFunc showInfo(String message, {String? title}) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
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
        onConfirm: cancelFunc,
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static CancelFunc showWarning(String message, {String? title}) {
    return BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
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
        onConfirm: cancelFunc,
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }

  static Future<bool> showConfirm(
    String message, {
    String? title,
    String? confirmText,
    String? cancelText,
  }) async {
    bool? result;
    BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              result = false;
              cancel();
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
        onConfirm: () {
          result = true;
          cancelFunc();
        },
        onCancel: () {
          result = false;
          cancelFunc();
        },
      ),
      animationDuration: const Duration(milliseconds: 300),
    );

    // 等待对话框关闭
    await Future.delayed(const Duration(milliseconds: 100));
    while (result == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return result!;
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
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 280.0,
        minWidth: 280.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
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
                    style: const TextStyle(
                      fontSize: 16.0,
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
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1.0),
          InkWell(
            onTap: onConfirm,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: const Text(
                '确定',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
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
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 280.0,
        minWidth: 280.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 20.0),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
              ),
            ),
          ),
          const Divider(height: 1.0),
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
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 1.0,
                height: 44.0,
                color: Colors.grey[300],
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
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.blue,
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
    );
  }
}
