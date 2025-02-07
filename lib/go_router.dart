import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_manager/calendar_page.dart';
import 'package:mini_manager/projects_page.dart';
import 'package:mini_manager/settings_stats_page.dart';
import 'package:mini_manager/shop_page.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import 'main.dart';

part 'go_router.g.dart';

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/calendar',
      pageBuilder: (context, state) => SwipeablePage(
        builder: (context) => const CalendarPage(title: "Calendar"),
      ),
    ),
    GoRoute(
      path: '/shop',
      pageBuilder: (context, state) => SwipeablePage(
        builder: (context) => const ShopPage(title: "Shop"),
      ),
    ),
    GoRoute(
      path: '/projects',
      pageBuilder: (context, state) => SwipeablePage(
        builder: (context) => const ProjectsPage(title: "Projects"),
      ),
    ),
    GoRoute(
      path: '/settings_stats',
      pageBuilder: (context, state) => SwipeablePage(
        builder: (context) => const SettingsStatsPage(title: "Settings and Stats"),
      ),
    ),
  ],
);

final goRouterBuilder = GoRouter(routes: $appRoutes);

@TypedGoRoute<CalendarPageRoute>(path: '/calendar')
@immutable
class CalendarPageRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      SwipeablePage(builder: (context) => const CalendarPage(title: "Calendar"));
}

@TypedGoRoute<ShopPageRoute>(path: '/shop')
@immutable
class ShopPageRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      SwipeablePage(builder: (context) => const ShopPage(title: "Shop"));
}

@TypedGoRoute<ProjectsPageRoute>(path: '/projects')
@immutable
class ProjectsPageRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      SwipeablePage(builder: (context) => const ProjectsPage(title: "Projects"));
}

@TypedGoRoute<SettingsStatsPageRoute>(path: '/settings_stats')
@immutable
class SettingsStatsPageRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      SwipeablePage(builder: (context) => const SettingsStatsPage(title: "Settings and Stats"));
}