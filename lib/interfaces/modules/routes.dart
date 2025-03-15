import "dart:async";

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "_screens.dart";
import "routes/root.dart";

export "routes/root.dart";

part "routes.g.dart";

@TypedGoRoute<AuthRoute>(path: "/auth")
final class AuthRoute extends GoRouteData {
  const AuthRoute({
    this.v,
    this.email,
    this.name,
  });

  AuthRoute.fromRouterState(GoRouterState state)
      : v = state.uri.queryParameters["v"],
        email = state.uri.queryParameters["email"],
        name = state.uri.queryParameters["name"];

  /// Variant of screen.
  ///
  /// Check [AuthRouteScreenVariant.toUrlParams].
  final String? v;
  final String? email;
  final String? name;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final variant = AuthRouteScreenVariant.fromUrlParams(v ?? "") ??
        AuthRouteScreenVariant.signIn;

    return AuthRouteScreen(variant: variant, email: email, name: name);
  }
}

@TypedShellRoute<RootShellRoute>(routes: [
  storiesRouteBuild,
  profileRouteBuild,
])
final class RootShellRoute extends ShellRouteData {
  const RootShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return RootShellRouteScreen(child: navigator);
  }
}
