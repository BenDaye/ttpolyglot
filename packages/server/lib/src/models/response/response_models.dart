/// 响应模型
class LoginResponse {
  final Map<String, dynamic> user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const LoginResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in': expiresIn,
    };
  }
}

class RefreshTokenResponse {
  final String accessToken;
  final int expiresIn;

  const RefreshTokenResponse({
    required this.accessToken,
    required this.expiresIn,
  });

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'expires_in': expiresIn,
    };
  }
}

class ProjectListResponse {
  final List<Map<String, dynamic>> projects;
  final Map<String, dynamic> pagination;

  const ProjectListResponse({
    required this.projects,
    required this.pagination,
  });

  Map<String, dynamic> toJson() {
    return {
      'projects': projects,
      'pagination': pagination,
    };
  }
}

class TranslationEntryListResponse {
  final List<Map<String, dynamic>> entries;
  final Map<String, dynamic> pagination;

  const TranslationEntryListResponse({
    required this.entries,
    required this.pagination,
  });

  Map<String, dynamic> toJson() {
    return {
      'entries': entries,
      'pagination': pagination,
    };
  }
}

class UserListResponse {
  final List<Map<String, dynamic>> users;
  final Map<String, dynamic> pagination;

  const UserListResponse({
    required this.users,
    required this.pagination,
  });

  Map<String, dynamic> toJson() {
    return {
      'users': users,
      'pagination': pagination,
    };
  }
}

class ConfigListResponse {
  final List<Map<String, dynamic>> configs;
  final Map<String, dynamic> pagination;

  const ConfigListResponse({
    required this.configs,
    required this.pagination,
  });

  Map<String, dynamic> toJson() {
    return {
      'configs': configs,
      'pagination': pagination,
    };
  }
}

class TranslationProviderListResponse {
  final List<Map<String, dynamic>> providers;

  const TranslationProviderListResponse({
    required this.providers,
  });

  Map<String, dynamic> toJson() {
    return {
      'providers': providers,
    };
  }
}

class ProjectMembersResponse {
  final List<Map<String, dynamic>> members;

  const ProjectMembersResponse({
    required this.members,
  });

  Map<String, dynamic> toJson() {
    return {
      'members': members,
    };
  }
}

class TranslationHistoryResponse {
  final List<Map<String, dynamic>> history;

  const TranslationHistoryResponse({
    required this.history,
  });

  Map<String, dynamic> toJson() {
    return {
      'history': history,
    };
  }
}

class UserStatsResponse {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final int verifiedUsers;
  final int newUsersLastMonth;

  const UserStatsResponse({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.verifiedUsers,
    required this.newUsersLastMonth,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_users': totalUsers,
      'active_users': activeUsers,
      'inactive_users': inactiveUsers,
      'verified_users': verifiedUsers,
      'new_users_last_month': newUsersLastMonth,
    };
  }
}

class ProjectStatsResponse {
  final int totalProjects;
  final int activeProjects;
  final int archivedProjects;
  final int publicProjects;
  final int privateProjects;
  final int newProjectsLastMonth;
  final double avgKeysPerProject;
  final double avgCompletionPercentage;

  const ProjectStatsResponse({
    required this.totalProjects,
    required this.activeProjects,
    required this.archivedProjects,
    required this.publicProjects,
    required this.privateProjects,
    required this.newProjectsLastMonth,
    required this.avgKeysPerProject,
    required this.avgCompletionPercentage,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_projects': totalProjects,
      'active_projects': activeProjects,
      'archived_projects': archivedProjects,
      'public_projects': publicProjects,
      'private_projects': privateProjects,
      'new_projects_last_month': newProjectsLastMonth,
      'avg_keys_per_project': avgKeysPerProject,
      'avg_completion_percentage': avgCompletionPercentage,
    };
  }
}

class TranslationStatsResponse {
  final int totalEntries;
  final int completedEntries;
  final int reviewingEntries;
  final int approvedEntries;
  final int pendingEntries;
  final int totalCharacters;
  final int totalWords;
  final double avgQualityScore;
  final int entriesWithIssues;

  const TranslationStatsResponse({
    required this.totalEntries,
    required this.completedEntries,
    required this.reviewingEntries,
    required this.approvedEntries,
    required this.pendingEntries,
    required this.totalCharacters,
    required this.totalWords,
    required this.avgQualityScore,
    required this.entriesWithIssues,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_entries': totalEntries,
      'completed_entries': completedEntries,
      'reviewing_entries': reviewingEntries,
      'approved_entries': approvedEntries,
      'pending_entries': pendingEntries,
      'total_characters': totalCharacters,
      'total_words': totalWords,
      'avg_quality_score': avgQualityScore,
      'entries_with_issues': entriesWithIssues,
    };
  }
}

class BatchOperationResponse {
  final int total;
  final int success;
  final int failed;
  final List<Map<String, dynamic>> results;

  const BatchOperationResponse({
    required this.total,
    required this.success,
    required this.failed,
    required this.results,
  });

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'success': success,
      'failed': failed,
      'results': results,
    };
  }
}

class HealthCheckResponse {
  final String status;
  final String timestamp;
  final Map<String, dynamic> services;

  const HealthCheckResponse({
    required this.status,
    required this.timestamp,
    required this.services,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp,
      'services': services,
    };
  }
}

class VersionResponse {
  final String version;
  final String buildDate;
  final String environment;
  final Map<String, dynamic> metadata;

  const VersionResponse({
    required this.version,
    required this.buildDate,
    required this.environment,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'build_date': buildDate,
      'environment': environment,
      'metadata': metadata,
    };
  }
}

class StatusResponse {
  final String status;
  final String uptime;
  final Map<String, dynamic> stats;
  final Map<String, dynamic> services;

  const StatusResponse({
    required this.status,
    required this.uptime,
    required this.stats,
    required this.services,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'uptime': uptime,
      'stats': stats,
      'services': services,
    };
  }
}
