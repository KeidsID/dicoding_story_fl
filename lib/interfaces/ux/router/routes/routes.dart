import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dicoding_story_fl/interfaces/ui.dart';

part 'res/auth.dart';
part 'routes.g.dart';

@TypedGoRoute<LoginRoute>(
  path: '/auth',
  routes: [TypedGoRoute<RegisterRoute>(path: 'register')],
)
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();
}

@TypedGoRoute<StoriesRoute>(path: '/stories')
class StoriesRoute extends GoRouteData {
  const StoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const StoriesScreen();
}
