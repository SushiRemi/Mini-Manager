// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $calendarPageRoute,
      $shopPageRoute,
      $projectsPageRoute,
      $settingsStatsPageRoute,
    ];

RouteBase get $calendarPageRoute => GoRouteData.$route(
      path: '/calendar',
      factory: $CalendarPageRouteExtension._fromState,
    );

extension $CalendarPageRouteExtension on CalendarPageRoute {
  static CalendarPageRoute _fromState(GoRouterState state) =>
      CalendarPageRoute();

  String get location => GoRouteData.$location(
        '/calendar',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $shopPageRoute => GoRouteData.$route(
      path: '/shop',
      factory: $ShopPageRouteExtension._fromState,
    );

extension $ShopPageRouteExtension on ShopPageRoute {
  static ShopPageRoute _fromState(GoRouterState state) => ShopPageRoute();

  String get location => GoRouteData.$location(
        '/shop',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $projectsPageRoute => GoRouteData.$route(
      path: '/projects',
      factory: $ProjectsPageRouteExtension._fromState,
    );

extension $ProjectsPageRouteExtension on ProjectsPageRoute {
  static ProjectsPageRoute _fromState(GoRouterState state) =>
      ProjectsPageRoute();

  String get location => GoRouteData.$location(
        '/projects',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $settingsStatsPageRoute => GoRouteData.$route(
      path: '/settings_stats',
      factory: $SettingsStatsPageRouteExtension._fromState,
    );

extension $SettingsStatsPageRouteExtension on SettingsStatsPageRoute {
  static SettingsStatsPageRoute _fromState(GoRouterState state) =>
      SettingsStatsPageRoute();

  String get location => GoRouteData.$location(
        '/settings_stats',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
