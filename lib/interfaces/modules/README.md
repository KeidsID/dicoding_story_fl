# interfaces modules

[typed-go-router]: https://pub.dev/documentation/go_router/latest/topics/Type-safe%20routes-topic.html

This is where each application route is defined. We will use
[Typed "go_router"][typed-go-router].

[root-routes]: /lib/interfaces/modules/routes.dart

Root routes (root shell/go route data) are defined in
[`routes.dart`][root-routes], while the sub-routes will be defined in
`/routes`. The reason for this is because the typed route can only be annotated
in single file.

The route screen/widget, it will be defined along with the route data in the same file.

For naming convention, end each route data class name with `Route`, end screen
class name with `RouteScreen`, typed route annotation end with `Build`, and
file name with `_route.dart`. Folder naming does not include any suffixes, but
remember to store sub routes as `**/routes` folder (e.g
`routes/root/stories/routes` is sub-routes of
`routes/root/stories/stories_route.dart` and so on).

For visualization, look at the following example:

```dart
// lib/interfaces/modules/routes.dart

import "routes/auth/sign_in_route.dart";

@TypedShellRoute<AuthShellRoute>(routes: [signInRouteBuild])
final class AuthShellRoute extends ShellRouteData {
  const AuthShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return _AuthShellRouteScreen(child: navigator);
  }
}

class _AuthShellRouteScreen extends StatelessWidget {
  const _AuthShellRouteScreen({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    // shell screen implementations
  }
}

// lib/interfaces/modules/routes/auth/sign_in_route.dart

/// [SignInRoute] build decorator.
const signInRouteBuild = TypedGoRoute<SignInRoute>(path: "/auth/sign-in");

final class SignInRoute extends GoRouteData {
  const SignInRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _SignInRouteScreen();
  }
}

class _SignInRouteScreen extends StatefulWidget {
  const _SignInRouteScreen();

  @override
  State<_SignInRouteScreen> createState() => _SignInRouteScreenState();
}

class _SignInRouteScreenState extends State<_SignInRouteScreen> {
  // route screen implementations
}
```
