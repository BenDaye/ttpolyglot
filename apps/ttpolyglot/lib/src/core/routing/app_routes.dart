part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const home = _Paths.home;

  static const dashboard = _Paths.home + _Paths.dashboard;

  static const projects = _Paths.home + _Paths.projects;

  static String project(String projectId) => '$projects/$projectId';
  static String projectDashboard(String projectId) => '$projects/$projectId/dashboard';
  static String projectTranslations(String projectId) => '$projects/$projectId/translations';
  static String projectLanguages(String projectId) => '$projects/$projectId/languages';

  static const settings = _Paths.home + _Paths.settings;

  static const unknown = _Paths.unknown;

  static const signIn = _Paths.signIn;
  static const signUp = _Paths.signUp;
}

abstract class _Paths {
  static const home = '/home';

  static const dashboard = '/dashboard';
  static const projects = '/projects';
  static const settings = '/settings';

  static const project = '/:projectId';

  static const projectDashboard = '/dashboard';
  static const projectTranslations = '/translations';
  static const projectLanguages = '/languages';

  static const unknown = '/404';

  static const signIn = '/signIn';
  static const signUp = '/signUp';
}
