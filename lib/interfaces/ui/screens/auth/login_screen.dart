import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "package:dicoding_story_fl/common/constants.dart";
import "package:dicoding_story_fl/core/entities.dart";
import "package:dicoding_story_fl/interfaces/app_l10n.dart";
import "package:dicoding_story_fl/interfaces/ui.dart";
import "package:dicoding_story_fl/interfaces/ux.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  Future<void> _doLogin() async {
    final showSnackBar = context.scaffoldMessenger?.showSnackBar;
    final authProv = context.read<AuthProvider>();

    try {
      await authProv.login(
        email: emailController.text,
        password: passwordController.text,
      );
    } on SimpleException catch (err) {
      kLogger.d("Login Fail", error: err, stackTrace: err.trace);

      showSnackBar?.call(SnackBar(content: Text(err.message)));
    } catch (err, trace) {
      kLogger.f("Login Fail", error: err, stackTrace: trace);

      showSnackBar?.call(SnackBar(content: Text("$err")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            // Page max width
            width: 400.0,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header
                  Text(kAppName, style: context.textTheme.headlineLarge),
                  const SizedBox(height: 32.0),

                  // Inputs
                  EmailTextField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16.0),
                  PasswordTextField(
                    controller: passwordController,
                    onSubmitted: (value) => _doLogin(),
                  ),
                  const SizedBox(height: 32.0),

                  // Actions
                  Builder(builder: (context) {
                    final authProv = context.watch<AuthProvider>();

                    if (authProv.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return FilledButton(
                      onPressed: () => _doLogin(),
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
                              : () => const RegisterRoute().go(context),
                          child: Text(appL10n.register),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
