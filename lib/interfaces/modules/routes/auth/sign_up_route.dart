import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/constants.dart";
import "package:dicoding_story_fl/interfaces/libs/l10n/modules.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/interfaces/modules.dart";

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

  double get _maxWidth => 400.0;
  EdgeInsetsGeometry get _padding => const EdgeInsets.all(16.0);

  Future<void> _handleSignUp() async {
    final showSnackBar = context.scaffoldMessenger?.showSnackBar;
    final authProv = context.read<AuthProvider>();

    try {
      await authProv.register(
        username: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    } on AppException catch (err) {
      showSnackBar?.call(SnackBar(content: Text(err.message)));
    } catch (err) {
      showSnackBar?.call(const SnackBar(
        content: Text("No internet connection"),
      ));
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
                onSubmitted: (value) => _handleSignUp(),
              ),
              const SizedBox(height: 32.0),

              // actions
              Builder(builder: (context) {
                final authProv = context.watch<AuthProvider>();

                if (authProv.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return FilledButton(
                  onPressed: () => _handleSignUp(),
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
