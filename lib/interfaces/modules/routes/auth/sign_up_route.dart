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

/// [SignUpRoute] build decorator.
const signUpRouteBuild = TypedGoRoute<SignUpRoute>(
  path: "${AppRoutePaths.auth}${AppRouteAuthPaths.signUp}",
);

final class SignUpRoute extends GoRouteData {
  const SignUpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const _SignUpRouteScreen();
  }
}

class _SignUpRouteScreen extends StatefulWidget {
  const _SignUpRouteScreen();

  @override
  State<_SignUpRouteScreen> createState() => _SignUpRouteScreenState();
}

class _SignUpRouteScreenState extends State<_SignUpRouteScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  double get _maxWidth => 400.0;
  EdgeInsetsGeometry get _padding => const EdgeInsets.all(16.0);

  Future<void> _handleSignUp(BuildContext context) async {
    final authProv = context.read<AuthProvider>();

    try {
      await authProv.register(
        username: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    } catch (error, trace) {
      final exception = error.toAppException(
        message: "Failed to sign up",
        trace: trace,
      );

      kLogger.w("Sign up fail", error: exception, stackTrace: exception.trace);

      if (context.mounted) {
        final appL10n = AppL10n.of(context);

        context.scaffoldMessenger?.showSnackBar(SnackBar(
          content: Text(appL10n?.signUpErrorMessage ?? "Sign up fail"),
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
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
              Text(appL10n.registerForm, style: headerTextStyle),
              const SizedBox(height: 32.0),

              // inputs
              TextField(
                controller: nameController,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  label: Text("Username"),
                  hintText: "John Doe",
                ),
              ),
              const SizedBox(height: 16.0),
              EmailTextField(
                controller: emailController,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16.0),
              PasswordTextField(
                controller: passwordController,
                onSubmitted: (value) => _handleSignUp(context),
              ),
              const SizedBox(height: 32.0),

              // actions
              Builder(builder: (context) {
                final authProv = context.watch<AuthProvider>();

                if (authProv.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return FilledButton(
                  onPressed: () => _handleSignUp(context),
                  child: Text(appL10n.register),
                );
              }),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${appL10n.alreadyHaveAnAccount}?"),
                  Builder(builder: (context) {
                    final authProv = context.watch<AuthProvider>();

                    return TextButton(
                      onPressed: authProv.isLoading
                          ? null
                          : () => const SignInRoute().go(context),
                      child: Text(appL10n.login),
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
