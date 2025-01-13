import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";

import "routes.dart";

/// Key that store the [router] state.
final routerKey = GlobalKey<NavigatorState>();

/// Depend on [AuthProvider].
///
/// [routerKey] will presist the [router] state.
GoRouter router(BuildContext context) {
  return GoRouter(
    navigatorKey: routerKey,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) {
      return Scaffold(
        body: SizedErrorWidget.expand(
          error: AppException(
            message: 'No route found for "${state.uri.path}"',
          ),
          action: Builder(builder: (context) {
            return ElevatedButton.icon(
              onPressed: () => const StoriesRoute().go(context),
              icon: const Icon(Icons.home_outlined),
              label: const Text("Back to Home"),
            );
          }),
        ),
      );
    },
    //
    initialLocation: const SignInRoute().location,
    routes: $appRoutes,
    //
    refreshListenable: context.read<AuthProvider>(),
    redirect: (context, state) {
      final currentRoute = state.uri.path;
      final authProv = context.read<AuthProvider>();

      if (authProv.isLoading) return null;

      final isLoggedIn = authProv.value != null;
      final isAuthRoute = currentRoute.startsWith(AppRoutePaths.auth);

      if (isAuthRoute) {
        if (isLoggedIn) return const StoriesRoute().location;

        return null;
      }

      if (!isLoggedIn) return const SignInRoute().location;

      return null;
    },
  );
}
