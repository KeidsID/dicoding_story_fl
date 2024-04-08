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

  /// Page number.
  ///
  /// Actual type are [int].
  final String? page;

  /// Stories count for each page.
  ///
  /// Actual type are [int].
  final String? size;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final parsedPage = int.tryParse(page ?? '');
    final parsedSize = int.tryParse(size ?? '');

    return StoriesScreen(page: parsedPage, size: parsedSize);
  }
}

/// {@template dicoding_story_fl.interfaces.ux.routes.PostStoryRoute}
/// `/stories/post` route.
/// {@endtemplate}
class PostStoryRoute extends GoRouteData {
  /// {@macro dicoding_story_fl.interfaces.ux.routes.PostStoryRoute}
  const PostStoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PostStoryScreen();
}

/// {@template dicoding_story_fl.interfaces.ux.routes.StoryDetailRoute}
/// `/stories/view/:id` route.
/// {@endtemplate}
class StoryDetailRoute extends GoRouteData {
  /// {@macro dicoding_story_fl.interfaces.ux.routes.StoryDetailRoute}
  const StoryDetailRoute(this.id);

  final String id;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      StoryDetailScreen(id);
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
