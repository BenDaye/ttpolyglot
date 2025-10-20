part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const home = _Paths.home;

  static const dashboard = _Paths.home + _Paths.dashboard;

  static const projects = _Paths.home + _Paths.projects;

  static String project(String projectId) => '$projects/$projectId';

  // 项目子页面路由
  static String projectDashboard(String projectId) => '${project(projectId)}/dashboard';
  static String projectTranslations(String projectId) => '${project(projectId)}/translations';
  static String projectLanguages(String projectId) => '${project(projectId)}/languages';
  static String projectMembers(String projectId) => '${project(projectId)}/members';
  static String projectSettings(String projectId) => '${project(projectId)}/settings';
  static String projectImport(String projectId) => '${project(projectId)}/import';
  static String projectExport(String projectId) => '${project(projectId)}/export';

  static const settings = _Paths.home + _Paths.settings;

  static const profile = _Paths.home + _Paths.profile;

  static const unknown = _Paths.unknown;

  static const signIn = _Paths.signIn;
  static const signUp = _Paths.signUp;
}

abstract class _Paths {
  static const home = '/home';

  static const dashboard = '/dashboard';
  static const projects = '/projects';
  static const settings = '/settings';
  static const profile = '/profile';

  static const project = '/:projectId';

  static const unknown = '/404';

  static const signIn = '/signIn';
  static const signUp = '/signUp';
}
