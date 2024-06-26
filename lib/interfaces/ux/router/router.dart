import 'package:dicoding_story_fl/core/entities.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/interfaces/ui.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

/// Key that store the [router] state.
final routerKey = GlobalKey<NavigatorState>();

/// Depend on [AuthProvider].
///
/// [routerKey] keeps the [router] state.
GoRouter router(BuildContext context) {
  return GoRouter(
    navigatorKey: routerKey,
    routes: $appRoutes,
    initialLocation: const LoginRoute().location,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) {
      return Scaffold(
        body: SizedErrorWidget.expand(
          error: SimpleHttpException(
            statusCode: 404,
            message: 'No route found for "${state.uri.path}"',
          ),
          action: Builder(builder: (context) {
            return ElevatedButton.icon(
              onPressed: () => const StoriesRoute().go(context),
              icon: const Icon(Icons.home_outlined),
              label: const Text('Back to Home'),
            );
          }),
        ),
      );
    },
    refreshListenable: context.read<AuthProvider>(),
    redirect: (context, state) {
      final currentRoute = state.uri.path;
      final authProv = context.read<AuthProvider>();

      if (authProv.isLoading) return null;

      final isLoggedIn = authProv.value != null;
      final isAuthRoute = currentRoute.startsWith(const LoginRoute().location);

      if (isAuthRoute) {
        if (isLoggedIn) return const StoriesRoute().location;

        return null;
      }

      if (!isLoggedIn) return const LoginRoute().location;

      return null;
    },
  );
}
