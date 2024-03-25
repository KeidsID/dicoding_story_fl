import 'package:go_router/go_router.dart';

import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/interfaces/ux.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: $appRoutes,
  initialLocation: const LoginRoute().location,
  debugLogDiagnostics: true,
  refreshListenable: container.get<AuthProvider>(),
  redirect: (context, state) {
    final currentRoute = state.uri.path;
    final authProv = context.read<AuthProvider>();

    if (authProv.isLoading) return null;

    final isLoggedIn = authProv.state == AuthProviderState.loggedIn;
    final isAuthRoute = currentRoute.startsWith(const LoginRoute().location);

    if (isAuthRoute) {
      if (isLoggedIn) return const StoriesRoute().location;

      return null;
    }

    if (!isLoggedIn) return const LoginRoute().location;

    return null;
  },
);
