part of '../routes.dart';

/// {@template dicoding_story_fl.interfaces.ux.routes.StoriesRoute}
/// `/stories` route.
///
/// Queries:
/// - `page`: page number. Must be greater than `0`.
/// - `size`: stories count for each page. Must be greater than `0`.
/// {@endtemplate}
class StoriesRoute extends GoRouteData {
  /// {@macro dicoding_story_fl.interfaces.ux.routes.StoriesRoute}
  const StoriesRoute({this.page, this.size});

  /// Page number. Must be greater than `0`.
  ///
  /// Type are string to support web.
  final String? page;

  /// Stories count for each page. Must be greater than `0`.
  ///
  /// Type are string to support web.
  final String? size;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final parsedPage = int.tryParse(page ?? '');
    final parsedSize = int.tryParse(size ?? '');

    return StoriesScreen(
      page: parsedPage,
      size: parsedSize,
    );
  }
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
