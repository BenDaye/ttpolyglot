import 'dart:developer';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../config/server_config.dart';

/// 邮件服务
class EmailService {
  final ServerConfig _config;
  SmtpServer? _smtpServer;

  EmailService(this._config);

  /// 初始化邮件服务
  Future<void> initialize() async {
    try {
      if (_config.smtpHost != null &&
          _config.smtpPort != null &&
          _config.smtpUser != null &&
          _config.smtpPassword != null) {
        if (_config.smtpPort == 587) {
          // STARTTLS
          _smtpServer = SmtpServer(
            _config.smtpHost!,
            port: _config.smtpPort!,
            username: _config.smtpUser!,
            password: _config.smtpPassword!,
            ignoreBadCertificate: false,
            ssl: false,
            allowInsecure: false,
          );
        } else if (_config.smtpPort == 465) {
          // SSL
          _smtpServer = SmtpServer(
            _config.smtpHost!,
            port: _config.smtpPort!,
            username: _config.smtpUser!,
            password: _config.smtpPassword!,
            ignoreBadCertificate: false,
            ssl: true,
            allowInsecure: false,
          );
        } else {
          // 其他端口
          _smtpServer = SmtpServer(
            _config.smtpHost!,
            port: _config.smtpPort!,
            username: _config.smtpUser!,
            password: _config.smtpPassword!,
          );
        }

        log('邮件服务初始化成功', name: 'EmailService');
      } else {
        log('邮件服务配置不完整，跳过初始化', name: 'EmailService');
      }
    } catch (error, stackTrace) {
      log('邮件服务初始化失败', error: error, stackTrace: stackTrace, name: 'EmailService');
      rethrow;
    }
  }

  /// 检查邮件服务是否已配置
  bool get isConfigured => _smtpServer != null;

  /// 发送邮件
  Future<void> sendEmail({
    required String to,
    required String subject,
    required String htmlContent,
    String? textContent,
    List<Address>? cc,
    List<Address>? bcc,
    List<Attachment>? attachments,
  }) async {
    if (!isConfigured) {
      log('邮件服务未配置，跳过发送邮件', name: 'EmailService');
      return;
    }

    try {
      final message = Message()
        ..from = Address(_config.smtpFromAddress ?? 'noreply@ttpolyglot.com', 'TTPolyglot')
        ..recipients.add(Address(to))
        ..subject = subject
        ..html = htmlContent;

      if (textContent != null) {
        message.text = textContent;
      }

      if (cc != null) {
        message.ccRecipients.addAll(cc);
      }

      if (bcc != null) {
        message.bccRecipients.addAll(bcc);
      }

      if (attachments != null) {
        message.attachments.addAll(attachments);
      }

      await send(message, _smtpServer!);
      log('邮件发送成功: $to, 主题: $subject', name: 'EmailService');
    } catch (error, stackTrace) {
      log('邮件发送失败: $to', error: error, stackTrace: stackTrace, name: 'EmailService');
      rethrow;
    }
  }

  /// 发送邮箱验证邮件
  Future<void> sendVerificationEmail({
    required String email,
    required String verificationToken,
    required String verificationUrl,
  }) async {
    const subject = '验证您的邮箱 - TTPolyglot';
    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>验证您的邮箱</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h2 style="color: #2c3e50;">欢迎使用 TTPolyglot</h2>
        <p>感谢您注册 TTPolyglot 多语言翻译管理系统。</p>
        <p>请点击下面的链接验证您的邮箱地址：</p>
        <div style="text-align: center; margin: 30px 0;">
            <a href="$verificationUrl" style="
                background-color: #3498db;
                color: white;
                padding: 12px 24px;
                text-decoration: none;
                border-radius: 4px;
                display: inline-block;
            ">验证邮箱</a>
        </div>
        <p>如果上面的按钮无法点击，请复制以下链接到浏览器中打开：</p>
        <p style="word-break: break-all; background-color: #f8f9fa; padding: 10px; border-radius: 4px;">
            $verificationUrl
        </p>
        <p><strong>注意：</strong>此链接将在24小时后过期。</p>
        <p>如果您没有注册 TTPolyglot 账户，请忽略此邮件。</p>
        <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
        <p style="color: #666; font-size: 12px;">
            此邮件由系统自动发送，请勿回复。<br>
            如果您有任何问题，请联系我们的支持团队。
        </p>
    </div>
</body>
</html>
''';

    final textContent = '''
欢迎使用 TTPolyglot

感谢您注册 TTPolyglot 多语言翻译管理系统。

请访问以下链接验证您的邮箱地址：
$verificationUrl

注意：此链接将在24小时后过期。

如果您没有注册 TTPolyglot 账户，请忽略此邮件。

此邮件由系统自动发送，请勿回复。
''';

    await sendEmail(
      to: email,
      subject: subject,
      htmlContent: htmlContent,
      textContent: textContent,
    );
  }

  /// 发送密码重置邮件
  Future<void> sendPasswordResetEmail({
    required String email,
    required String resetUrl,
  }) async {
    const subject = '重置密码 - TTPolyglot';
    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>重置密码</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h2 style="color: #2c3e50;">重置您的密码</h2>
        <p>您收到此邮件是因为您请求重置 TTPolyglot 账户的密码。</p>
        <p>请点击下面的链接重置您的密码：</p>
        <div style="text-align: center; margin: 30px 0;">
            <a href="$resetUrl" style="
                background-color: #e74c3c;
                color: white;
                padding: 12px 24px;
                text-decoration: none;
                border-radius: 4px;
                display: inline-block;
            ">重置密码</a>
        </div>
        <p>如果上面的按钮无法点击，请复制以下链接到浏览器中打开：</p>
        <p style="word-break: break-all; background-color: #f8f9fa; padding: 10px; border-radius: 4px;">
            $resetUrl
        </p>
        <p><strong>注意：</strong>此链接将在1小时后过期。</p>
        <p>如果您没有请求重置密码，请忽略此邮件。</p>
        <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
        <p style="color: #666; font-size: 12px;">
            此邮件由系统自动发送，请勿回复。<br>
            如果您有任何问题，请联系我们的支持团队。
        </p>
    </div>
</body>
</html>
''';

    final textContent = '''
重置您的密码

您收到此邮件是因为您请求重置 TTPolyglot 账户的密码。

请访问以下链接重置您的密码：
$resetUrl

注意：此链接将在1小时后过期。

如果您没有请求重置密码，请忽略此邮件。

此邮件由系统自动发送，请勿回复。
''';

    await sendEmail(
      to: email,
      subject: subject,
      htmlContent: htmlContent,
      textContent: textContent,
    );
  }

  /// 发送欢迎邮件
  Future<void> sendWelcomeEmail({
    required String email,
    required String username,
  }) async {
    final subject = '欢迎加入 TTPolyglot - $username';
    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>欢迎加入 TTPolyglot</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h2 style="color: #2c3e50;">欢迎加入 TTPolyglot！</h2>
        <p>亲爱的 $username，</p>
        <p>欢迎您加入 TTPolyglot 多语言翻译管理系统！</p>
        <p>您现在可以：</p>
        <ul>
            <li>创建和管理翻译项目</li>
            <li>与团队成员协作翻译</li>
            <li>使用AI翻译助手提高效率</li>
            <li>导出翻译文件到各种格式</li>
        </ul>
        <p>开始您的多语言翻译之旅吧！</p>
        <div style="text-align: center; margin: 30px 0;">
            <a href="${_config.siteUrl ?? 'https://ttpolyglot.com'}" style="
                background-color: #27ae60;
                color: white;
                padding: 12px 24px;
                text-decoration: none;
                border-radius: 4px;
                display: inline-block;
            ">开始使用</a>
        </div>
        <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
        <p style="color: #666; font-size: 12px;">
            此邮件由系统自动发送，请勿回复。<br>
            如果您有任何问题，请访问我们的帮助中心或联系支持团队。
        </p>
    </div>
</body>
</html>
''';

    final textContent = '''
欢迎加入 TTPolyglot！

亲爱的 $username，

欢迎您加入 TTPolyglot 多语言翻译管理系统！

您现在可以：
- 创建和管理翻译项目
- 与团队成员协作翻译
- 使用AI翻译助手提高效率
- 导出翻译文件到各种格式

开始您的多语言翻译之旅吧！

访问：${_config.siteUrl ?? 'https://ttpolyglot.com'}

此邮件由系统自动发送，请勿回复。
''';

    await sendEmail(
      to: email,
      subject: subject,
      htmlContent: htmlContent,
      textContent: textContent,
    );
  }

  /// 发送项目邀请邮件
  Future<void> sendProjectInvitationEmail({
    required String email,
    required String projectName,
    required String inviterName,
    required String invitationUrl,
  }) async {
    final subject = '项目邀请 - $projectName';
    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>项目邀请</title>
</head>
<body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
    <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
        <h2 style="color: #2c3e50;">项目邀请</h2>
        <p>$inviterName 邀请您加入翻译项目 "$projectName"。</p>
        <p>点击下面的链接查看邀请：</p>
        <div style="text-align: center; margin: 30px 0;">
            <a href="$invitationUrl" style="
                background-color: #9b59b6;
                color: white;
                padding: 12px 24px;
                text-decoration: none;
                border-radius: 4px;
                display: inline-block;
            ">查看邀请</a>
        </div>
        <p>如果您还没有 TTPolyglot 账户，系统会引导您完成注册。</p>
        <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
        <p style="color: #666; font-size: 12px;">
            此邮件由系统自动发送，请勿回复。<br>
            如果您认为这是一封误发的邮件，请忽略。
        </p>
    </div>
</body>
</html>
''';

    final textContent = '''
项目邀请

$inviterName 邀请您加入翻译项目 "$projectName"。

请访问以下链接查看邀请：
$invitationUrl

如果您还没有 TTPolyglot 账户，系统会引导您完成注册。

此邮件由系统自动发送，请勿回复。
''';

    await sendEmail(
      to: email,
      subject: subject,
      htmlContent: htmlContent,
      textContent: textContent,
    );
  }
}
