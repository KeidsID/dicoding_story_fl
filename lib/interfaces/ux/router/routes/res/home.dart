part of "../routes.dart";

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

/// {@template dicoding_story_fl.interfaces.ux.routes.PostStoryRoute}
/// `/stories/post` route.
/// {@endtemplate}
class PostStoryRoute extends GoRouteData {
  /// {@macro dicoding_story_fl.interfaces.ux.routes.PostStoryRoute}
  const PostStoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChangeNotifierProvider.value(
        value: PickedImageProvider(),
        child: const PostStoryScreen(),
      );
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
