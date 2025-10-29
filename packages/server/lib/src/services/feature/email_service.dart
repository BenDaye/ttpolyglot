import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:ttpolyglot_server/server.dart';
import 'package:ttpolyglot_utils/utils.dart';

/// 邮件服务
class EmailService extends BaseService {
  EmailService() : super('EmailService');

  /// 发送邮箱验证邮件
  Future<bool> sendEmailVerification({
    required String to,
    required String username,
    required String token,
  }) async {
    LoggerUtils.info('发送邮箱验证邮件: $to');
    try {
      if (!_isEmailConfigured()) {
        LoggerUtils.warning('邮件服务未配置，跳过发送');
        return false;
      }

      final subject = '验证您的邮箱地址';
      final verificationUrl = '${ServerConfig.siteUrl}/verify-email?token=$token';

      final htmlContent = _generateEmailVerificationHtml(
        username: username,
        verificationUrl: verificationUrl,
      );

      return await _sendEmail(
        to: to,
        subject: subject,
        htmlContent: htmlContent,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('sendEmailVerification', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 发送密码重置邮件
  Future<bool> sendPasswordReset({
    required String to,
    required String username,
    required String token,
  }) async {
    // final logger = LoggerFactory.getLogger('EmailService');
    LoggerUtils.info('发送密码重置邮件: $to');
    try {
      if (!_isEmailConfigured()) {
        LoggerUtils.warning('邮件服务未配置，跳过发送');
        return false;
      }

      final subject = '重置您的密码';
      final resetUrl = '${ServerConfig.siteUrl}/reset-password?token=$token';

      final htmlContent = _generatePasswordResetHtml(
        username: username,
        resetUrl: resetUrl,
      );

      return await _sendEmail(
        to: to,
        subject: subject,
        htmlContent: htmlContent,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('sendPasswordReset', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 发送忘记密码邮件
  Future<bool> sendForgotPassword({
    required String to,
    required String username,
    required String token,
  }) async {
    // final logger = LoggerFactory.getLogger('EmailService');
    LoggerUtils.info('发送忘记密码邮件: $to');
    try {
      if (!_isEmailConfigured()) {
        LoggerUtils.warning('邮件服务未配置，跳过发送');
        return false;
      }

      final subject = '重置您的密码';
      final resetUrl = '${ServerConfig.siteUrl}/reset-password?token=$token';

      final htmlContent = _generateForgotPasswordHtml(
        username: username,
        resetUrl: resetUrl,
      );

      return await _sendEmail(
        to: to,
        subject: subject,
        htmlContent: htmlContent,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('sendForgotPassword', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 检查邮件服务是否已配置
  bool _isEmailConfigured() {
    return ServerConfig.smtpHost.isNotEmpty &&
        ServerConfig.smtpUser.isNotEmpty &&
        ServerConfig.smtpPassword.isNotEmpty &&
        ServerConfig.smtpFromAddress.isNotEmpty;
  }

  /// 发送邮件
  Future<bool> _sendEmail({
    required String to,
    required String subject,
    required String htmlContent,
  }) async {
    // final logger = LoggerFactory.getLogger('EmailService');
    LoggerUtils.info('发送邮件到: $to');
    LoggerUtils.info('主题: $subject');
    try {
      final message = Message()
        ..from = Address(ServerConfig.smtpFromAddress, 'TTPolyglot')
        ..recipients.add(to)
        ..subject = subject
        ..html = htmlContent;

      final smtpServer = SmtpServer(
        ServerConfig.smtpHost,
        port: ServerConfig.smtpPort,
        username: ServerConfig.smtpUser,
        password: ServerConfig.smtpPassword,
      );

      final result = await send(message, smtpServer);
      if (result.toString().isEmpty) {
        LoggerUtils.info('邮件发送成功');
        return true;
      }
      LoggerUtils.error('邮件发送失败: ${result.toString()}');
      return false;
    } catch (error, stackTrace) {
      LoggerUtils.error('_sendEmail', error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// 生成邮箱验证邮件HTML内容
  String _generateEmailVerificationHtml({
    required String username,
    required String verificationUrl,
  }) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>验证您的邮箱地址</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background-color: #f8f9fa; padding: 20px; text-align: center; }
        .content { padding: 20px; }
        .button { 
            display: inline-block; 
            background-color: #007bff; 
            color: white; 
            padding: 12px 24px; 
            text-decoration: none; 
            border-radius: 4.0px; 
            margin: 20px 0;
        }
        .footer { background-color: #f8f9fa; padding: 20px; text-align: center; font-size: 14px; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>TTPolyglot</h1>
        </div>
        <div class="content">
            <h2>欢迎，$username！</h2>
            <p>感谢您注册 TTPolyglot 账户。请点击下面的按钮验证您的邮箱地址：</p>
            <p style="text-align: center;">
                <a href="$verificationUrl" class="button">验证邮箱地址</a>
            </p>
            <p>如果按钮无法点击，请复制以下链接到浏览器中打开：</p>
            <p style="word-break: break-all; background-color: #f8f9fa; padding: 10px; border-radius: 4.0px;">
                $verificationUrl
            </p>
            <p>此链接将在24小时后过期。</p>
        </div>
        <div class="footer">
            <p>如果您没有注册此账户，请忽略此邮件。</p>
            <p>&copy; 2024 TTPolyglot. 保留所有权利。</p>
        </div>
    </div>
</body>
</html>
    ''';
  }

  /// 生成密码重置邮件HTML内容
  String _generatePasswordResetHtml({
    required String username,
    required String resetUrl,
  }) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>重置您的密码</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background-color: #f8f9fa; padding: 20px; text-align: center; }
        .content { padding: 20px; }
        .button { 
            display: inline-block; 
            background-color: #dc3545; 
            color: white; 
            padding: 12px 24px; 
            text-decoration: none; 
            border-radius: 4.0px; 
            margin: 20px 0;
        }
        .footer { background-color: #f8f9fa; padding: 20px; text-align: center; font-size: 14px; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>TTPolyglot</h1>
        </div>
        <div class="content">
            <h2>重置您的密码</h2>
            <p>您好，$username！</p>
            <p>我们收到了重置您账户密码的请求。请点击下面的按钮重置您的密码：</p>
            <p style="text-align: center;">
                <a href="$resetUrl" class="button">重置密码</a>
            </p>
            <p>如果按钮无法点击，请复制以下链接到浏览器中打开：</p>
            <p style="word-break: break-all; background-color: #f8f9fa; padding: 10px; border-radius: 4.0px;">
                $resetUrl
            </p>
            <p>此链接将在1小时后过期。</p>
            <p><strong>如果您没有请求重置密码，请忽略此邮件。</strong></p>
        </div>
        <div class="footer">
            <p>&copy; 2024 TTPolyglot. 保留所有权利。</p>
        </div>
    </div>
</body>
</html>
    ''';
  }

  /// 生成忘记密码邮件HTML内容
  String _generateForgotPasswordHtml({
    required String username,
    required String resetUrl,
  }) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>忘记密码</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background-color: #f8f9fa; padding: 20px; text-align: center; }
        .content { padding: 20px; }
        .button { 
            display: inline-block; 
            background-color: #28a745; 
            color: white; 
            padding: 12px 24px; 
            text-decoration: none; 
            border-radius: 4.0px; 
            margin: 20px 0;
        }
        .footer { background-color: #f8f9fa; padding: 20px; text-align: center; font-size: 14px; color: #666; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>TTPolyglot</h1>
        </div>
        <div class="content">
            <h2>忘记密码</h2>
            <p>您好，$username！</p>
            <p>我们收到了您忘记密码的请求。请点击下面的按钮设置新密码：</p>
            <p style="text-align: center;">
                <a href="$resetUrl" class="button">设置新密码</a>
            </p>
            <p>如果按钮无法点击，请复制以下链接到浏览器中打开：</p>
            <p style="word-break: break-all; background-color: #f8f9fa; padding: 10px; border-radius: 4.0px;">
                $resetUrl
            </p>
            <p>此链接将在1小时后过期。</p>
            <p><strong>如果您没有请求重置密码，请忽略此邮件。</strong></p>
        </div>
        <div class="footer">
            <p>&copy; 2024 TTPolyglot. 保留所有权利。</p>
        </div>
    </div>
</body>
</html>
    ''';
  }
}
