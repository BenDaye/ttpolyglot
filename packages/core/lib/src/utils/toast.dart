import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

// 重新导出 CancelFunc，方便其他地方使用
export 'package:bot_toast/bot_toast.dart' show CancelFunc;

final class Toast {
  Toast._();

  static BotToastNavigatorObserver botToastObserver() => BotToastNavigatorObserver();
  static TransitionBuilder get botToastInit => BotToastInit();

  static CancelFunc showSuccess(
    String message, {
    Icon? icon,
    Alignment? align,
    Duration? duration,
  }) {
    return showToast(
      message,
      align: align,
      duration: duration,
      icon: icon ?? const Icon(Icons.done),
      iconColor: Colors.white,
      iconBackgroundColor: Colors.green,
    );
  }

  static CancelFunc showInfo(
    String message, {
    Icon? icon,
    Alignment? align,
    Duration? duration,
  }) {
    return showToast(
      message,
      align: align,
      duration: duration,
      icon: icon ?? const Icon(Icons.info_outline),
      iconColor: Colors.white,
      iconBackgroundColor: Colors.blueAccent,
    );
  }

  static CancelFunc showWarning(
    String message, {
    Icon? icon,
    Alignment? align,
    Duration? duration,
  }) {
    return showToast(
      message,
      align: align,
      duration: duration,
      icon: icon ?? const Icon(Icons.warning_amber_rounded),
      iconColor: Colors.white,
      iconBackgroundColor: Colors.orange,
    );
  }

  static CancelFunc showError(
    String message, {
    Icon? icon,
    Alignment? align,
    Duration? duration,
  }) {
    return showToast(
      message,
      align: align,
      duration: duration,
      icon: icon ?? const Icon(Icons.close),
      iconColor: Colors.white,
      iconBackgroundColor: Colors.red,
    );
  }

  static CancelFunc showToast(
    String message, {
    Icon? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    Color? textColor,
    Alignment? align,
    Duration? duration,
    VoidCallback? onClose,
  }) {
    return BotToast.showCustomText(
      onlyOne: true,
      crossPage: false,
      align: align ?? Alignment(0.0, 0.75),
      duration: duration ?? const Duration(seconds: 3),
      onClose: onClose,
      toastBuilder: (cancel) {
        final List<Widget> items = <Widget>[];

        if (icon != null) {
          items.add(
            Container(
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? Colors.black12,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: IconTheme(
                  data: IconThemeData(
                    size: 14.0,
                    color: iconColor,
                  ),
                  child: icon),
            ),
          );
        }

        items.add(Flexible(
          child: Text(
            message,
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyle(
              leading: 0,
              forceStrutHeight: true,
            ),
            style: TextStyle(
              fontSize: 14.0,
              color: textColor,
            ),
          ),
        ));

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 3.0),
                blurRadius: 5.0,
              ),
            ],
          ),
          child: Row(
            spacing: 5.0,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items,
          ),
        );
      },
    );
  }

  static CancelFunc showLoading({
    String? placeholder,
    Widget? loadingWidget,
    Color? loadingColor,
    Color? textColor,
    Duration? duration,
    VoidCallback? onClose,
  }) {
    return BotToast.showCustomLoading(
      crossPage: false,
      clickClose: false,
      ignoreContentClick: false,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: Colors.white54,
      onClose: onClose,
      toastBuilder: (cancel) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            spacing: 6.0,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              loadingWidget ??
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      color: loadingColor ?? Colors.blueAccent,
                    ),
                  ),
              Text(
                placeholder ?? '加载中...',
                style: TextStyle(
                  fontSize: 14.0,
                  color: textColor ?? Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static CancelFunc showNotification({
    String? title,
    String? subTitle,
    Widget? leading,
    Widget? trailing,
    Duration? duration,
    VoidCallback? onTap,
    VoidCallback? onClose,
  }) {
    assert(title != null || subTitle != null, 'title and subTitle can not be both null');
    return BotToast.showNotification(
      crossPage: true,
      borderRadius: 6.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      duration: duration ?? const Duration(seconds: 3),
      leading: leading == null ? null : (_) => leading,
      trailing: trailing == null ? null : (_) => trailing,
      title: (_) => Text(
        (title ?? subTitle)!,
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
      subtitle: subTitle == null
          ? null
          : (_) => Text(
                subTitle,
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
      onTap: onTap,
      onClose: onClose,
    );
  }
}
