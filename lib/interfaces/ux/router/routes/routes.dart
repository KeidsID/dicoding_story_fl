import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/interfaces/ui.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

part 'res/auth.dart';
part 'res/home.dart';
part 'routes.g.dart';

/// {@template dicoding_story_fl.interfaces.ux.routes.LoginRoute}
/// `/auth` route.
/// {@endtemplate}
@TypedGoRoute<LoginRoute>(
  path: '/auth',
  routes: [TypedGoRoute<RegisterRoute>(path: 'register')],
)
class LoginRoute extends GoRouteData {
  /// {@macro dicoding_story_fl.interfaces.ux.routes.LoginRoute}
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedShellRoute<HomeShellRoute>(routes: [
  TypedGoRoute<StoriesRoute>(
    path: '/stories',
    routes: [
      TypedGoRoute<PostStoryRoute>(path: 'post'),
      TypedGoRoute<StoryDetailRoute>(path: 'view/:id'),
    ],
  ),
  TypedGoRoute<ProfileRoute>(path: '/profile'),
])
@protected
class HomeShellRoute extends ShellRouteData {
  const HomeShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return HomeLayout(child: navigator);
  }
}
