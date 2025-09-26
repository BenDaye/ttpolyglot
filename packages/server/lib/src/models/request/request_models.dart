/// 请求模型
class LoginRequest {
  final String emailOrUsername;
  final String password;
  final String? deviceId;
  final String? deviceName;
  final String? deviceType;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic>? locationInfo;

  const LoginRequest({
    required this.emailOrUsername,
    required this.password,
    this.deviceId,
    this.deviceName,
    this.deviceType,
    this.ipAddress,
    this.userAgent,
    this.locationInfo,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      emailOrUsername: json['email_or_username'] as String,
      password: json['password'] as String,
      deviceId: json['device_id'] as String?,
      deviceName: json['device_name'] as String?,
      deviceType: json['device_type'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      locationInfo: json['location_info'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email_or_username': emailOrUsername,
      'password': password,
      if (deviceId != null) 'device_id': deviceId,
      if (deviceName != null) 'device_name': deviceName,
      if (deviceType != null) 'device_type': deviceType,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (userAgent != null) 'user_agent': userAgent,
      if (locationInfo != null) 'location_info': locationInfo,
    };
  }
}

class RegisterRequest {
  final String username;
  final String email;
  final String password;
  final String? displayName;
  final String? phone;
  final String? timezone;
  final String? locale;

  const RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    this.displayName,
    this.phone,
    this.timezone,
    this.locale,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      displayName: json['display_name'] as String?,
      phone: json['phone'] as String?,
      timezone: json['timezone'] as String?,
      locale: json['locale'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      if (displayName != null) 'display_name': displayName,
      if (phone != null) 'phone': phone,
      if (timezone != null) 'timezone': timezone,
      if (locale != null) 'locale': locale,
    };
  }
}

class RefreshTokenRequest {
  final String refreshToken;
  final String? ipAddress;
  final String? userAgent;

  const RefreshTokenRequest({
    required this.refreshToken,
    this.ipAddress,
    this.userAgent,
  });

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) {
    return RefreshTokenRequest(
      refreshToken: json['refresh_token'] as String,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
      if (ipAddress != null) 'ip_address': ipAddress,
      if (userAgent != null) 'user_agent': userAgent,
    };
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequest(
      currentPassword: json['current_password'] as String,
      newPassword: json['new_password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
    };
  }
}

class CreateProjectRequest {
  final String name;
  final String primaryLanguageCode;
  final String? description;
  final String? slug;
  final String? visibility;
  final Map<String, dynamic>? settings;

  const CreateProjectRequest({
    required this.name,
    required this.primaryLanguageCode,
    this.description,
    this.slug,
    this.visibility,
    this.settings,
  });

  factory CreateProjectRequest.fromJson(Map<String, dynamic> json) {
    return CreateProjectRequest(
      name: json['name'] as String,
      primaryLanguageCode: json['primary_language_code'] as String,
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      visibility: json['visibility'] as String?,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'primary_language_code': primaryLanguageCode,
      if (description != null) 'description': description,
      if (slug != null) 'slug': slug,
      if (visibility != null) 'visibility': visibility,
      if (settings != null) 'settings': settings,
    };
  }
}

class UpdateProjectRequest {
  final String? name;
  final String? description;
  final String? slug;
  final String? status;
  final String? visibility;
  final Map<String, dynamic>? settings;

  const UpdateProjectRequest({
    this.name,
    this.description,
    this.slug,
    this.status,
    this.visibility,
    this.settings,
  });

  factory UpdateProjectRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProjectRequest(
      name: json['name'] as String?,
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      status: json['status'] as String?,
      visibility: json['visibility'] as String?,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (slug != null) 'slug': slug,
      if (status != null) 'status': status,
      if (visibility != null) 'visibility': visibility,
      if (settings != null) 'settings': settings,
    };
  }
}

class CreateTranslationEntryRequest {
  final String entryKey;
  final String languageCode;
  final String? sourceText;
  final String? targetText;
  final String? translatorId;
  final String? contextInfo;

  const CreateTranslationEntryRequest({
    required this.entryKey,
    required this.languageCode,
    this.sourceText,
    this.targetText,
    this.translatorId,
    this.contextInfo,
  });

  factory CreateTranslationEntryRequest.fromJson(Map<String, dynamic> json) {
    return CreateTranslationEntryRequest(
      entryKey: json['entry_key'] as String,
      languageCode: json['language_code'] as String,
      sourceText: json['source_text'] as String?,
      targetText: json['target_text'] as String?,
      translatorId: json['translator_id'] as String?,
      contextInfo: json['context_info'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entry_key': entryKey,
      'language_code': languageCode,
      if (sourceText != null) 'source_text': sourceText,
      if (targetText != null) 'target_text': targetText,
      if (translatorId != null) 'translator_id': translatorId,
      if (contextInfo != null) 'context_info': contextInfo,
    };
  }
}

class UpdateTranslationEntryRequest {
  final String? targetText;
  final String? status;
  final String? translatorId;
  final String? reviewerId;
  final String? contextInfo;
  final double? qualityScore;
  final Map<String, dynamic>? issues;

  const UpdateTranslationEntryRequest({
    this.targetText,
    this.status,
    this.translatorId,
    this.reviewerId,
    this.contextInfo,
    this.qualityScore,
    this.issues,
  });

  factory UpdateTranslationEntryRequest.fromJson(Map<String, dynamic> json) {
    return UpdateTranslationEntryRequest(
      targetText: json['target_text'] as String?,
      status: json['status'] as String?,
      translatorId: json['translator_id'] as String?,
      reviewerId: json['reviewer_id'] as String?,
      contextInfo: json['context_info'] as String?,
      qualityScore: json['quality_score'] as double?,
      issues: json['issues'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (targetText != null) 'target_text': targetText,
      if (status != null) 'status': status,
      if (translatorId != null) 'translator_id': translatorId,
      if (reviewerId != null) 'reviewer_id': reviewerId,
      if (contextInfo != null) 'context_info': contextInfo,
      if (qualityScore != null) 'quality_score': qualityScore,
      if (issues != null) 'issues': issues,
    };
  }
}

class CreateTranslationProviderRequest {
  final String providerType;
  final String displayName;
  final String? appId;
  final String? appKey;
  final String? apiUrl;
  final Map<String, dynamic>? settings;

  const CreateTranslationProviderRequest({
    required this.providerType,
    required this.displayName,
    this.appId,
    this.appKey,
    this.apiUrl,
    this.settings,
  });

  factory CreateTranslationProviderRequest.fromJson(Map<String, dynamic> json) {
    return CreateTranslationProviderRequest(
      providerType: json['provider_type'] as String,
      displayName: json['display_name'] as String,
      appId: json['app_id'] as String?,
      appKey: json['app_key'] as String?,
      apiUrl: json['api_url'] as String?,
      settings: json['settings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider_type': providerType,
      'display_name': displayName,
      if (appId != null) 'app_id': appId,
      if (appKey != null) 'app_key': appKey,
      if (apiUrl != null) 'api_url': apiUrl,
      if (settings != null) 'settings': settings,
    };
  }
}

class UpdateConfigRequest {
  final String configKey;
  final dynamic configValue;

  const UpdateConfigRequest({
    required this.configKey,
    required this.configValue,
  });

  factory UpdateConfigRequest.fromJson(Map<String, dynamic> json) {
    return UpdateConfigRequest(
      configKey: json['config_key'] as String,
      configValue: json['config_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'config_key': configKey,
      'config_value': configValue,
    };
  }
}
