import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/l10n/modules.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/interfaces/modules.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/libs/extensions.dart";

/// [SignInRoute] build decorator.
const signInRouteBuild = TypedGoRoute<SignInRoute>(
  path: "${AppRoutePaths.auth}${AppRouteAuthPaths.signIn}",
);

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
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  double get _maxWidth => 400.0;
  EdgeInsetsGeometry get _padding => const EdgeInsets.all(16.0);

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      await context.read<AuthProvider>().login(
            email: emailController.text,
            password: passwordController.text,
          );
    } catch (error, trace) {
      final exception = error.toAppException(
        message: "Failed to sign in",
        trace: trace,
      );

      kLogger.w("Sign in Fail", error: exception, stackTrace: exception.trace);

      if (context.mounted) {
        final appL10n = AppL10n.of(context);

        context.scaffoldMessenger?.showSnackBar(SnackBar(
          content: Text(appL10n?.signInErrorMessage ?? "Sign in fail"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context)!;

    final headerTextStyle = context.textTheme.headlineLarge;

    return Center(
      child: SizedBox(
        width: _maxWidth,
        child: SingleChildScrollView(
          padding: _padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // header
              Text(kAppName, style: headerTextStyle),
              const SizedBox(height: 32.0),

              // inputs
              EmailTextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),
              PasswordTextField(
                controller: passwordController,
                onSubmitted: (value) => _handleSignIn(context),
              ),
              const SizedBox(height: 32.0),

              // actions
              Builder(builder: (context) {
                final authProv = context.watch<AuthProvider>();

                if (authProv.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return FilledButton(
                  onPressed: () => _handleSignIn(context),
                  child: Text(appL10n.login),
                );
              }),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${appL10n.needAnAccount}?"),
                  Builder(builder: (context) {
                    final authProv = context.watch<AuthProvider>();

                    return TextButton(
                      onPressed: authProv.isLoading
                          ? null
                          : () => const SignUpRoute().go(context),
                      child: Text(appL10n.register),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
