# Interfaces Modules

[typed-go-router]: https://pub.dev/documentation/go_router/latest/topics/Type-safe%20routes-topic.html

This is where each application route is defined. We will use
[Typed "go_router"][typed-go-router].

[routes.dart]: /lib/interfaces/modules/routes.dart

Root routes are defined in [routes.dart], while the sub-routes will be defined
in `/routes`. The reason for this is because the typed route can only be
annotated in single file.

## Rules

[/_screens]: /lib/interfaces/modules/_screens.dart

- The route screen  will be defined along with the route data in the same file,
  except for the root routes which will be defined on [/_screens] folder.

- End route file name with `_route.dart`

- End each route data class name with `Route`

- End route screen class name with `RouteScreen`

- Typed route annotation end with `Build`

- All sub-routes must be exported in the file [routes.dart]

Folder naming does not include any suffixes, but
remember to store sub routes as `**/routes` folder (e.g
`routes/root/stories/routes` is sub-routes of
`routes/root/stories/stories_route.dart` and so on).

Here's an example:

```dart
// "~" = "<rootDir>/lib/interfaces/modules"

// ~/routes.dart

import "_screens.dart" show RootShellRouteScreen;

import "routes/root/stories_route.dart";

export "routes/root/stories_route.dart";

@TypedShellRoute<RootShellRoute>(routes: [storiesRouteBuild])
final class RootShellRoute extends ShellRouteData {
  const RootShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootShellRouteScreen(child: navigator);
  }
}

// ~/modules/routes/root/stories_route.dart

/// [StoriesRoute] build decorator.
const storiesRouteBuild = TypedGoRoute<StoriesRoute>(path: "/stories");

final class StoriesRoute extends GoRouteData {
  const StoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _StoriesRouteScreen();
  }
}

class _StoriesRouteScreen extends StatelessWidget {
  // screen implementations...
}
```
