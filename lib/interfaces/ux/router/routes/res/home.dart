part of '../routes.dart';

/// {@template dicoding_story_fl.interfaces.ux.routes.StoriesRoute}
/// `/stories` route.
/// {@endtemplate}
class StoriesRoute extends GoRouteData {
  /// {@macro dicoding_story_fl.interfaces.ux.routes.StoriesRoute}
  const StoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StoriesScreen();
}

/// {@template dicoding_story_fl.interfaces.ux.routes.ProfileRoute}
/// `/profile` route.
/// {@endtemplate}
class ProfileRoute extends GoRouteData {
  /// {@macro dicoding_story_fl.interfaces.ux.routes.ProfileRoute}
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfileScreen();
}
