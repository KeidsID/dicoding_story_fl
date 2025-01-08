part of "../routes.dart";

/// {@template dicoding_story_fl.interfaces.ux.routes.RegisterRoute}
/// `/auth/register` route.
/// {@endtemplate}
class RegisterRoute extends GoRouteData {
  /// {@macro dicoding_story_fl.interfaces.ux.routes.RegisterRoute}
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();
}
