import 'package:fl_utilities/fl_utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/interfaces/ui.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

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
      kLogger.d('Login Fail', error: err, stackTrace: err.trace);

      showSnackBar?.call(SnackBar(content: Text(err.message)));
    } catch (err, trace) {
      kLogger.f('Login Fail', error: err, stackTrace: trace);

      showSnackBar?.call(SnackBar(content: Text('$err')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(appName, style: context.textTheme.headlineLarge),
                  const SizedBox(height: 16.0),

                  // Inputs
                  EmailTextField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                  ),
                  PasswordTextField(
                    controller: passwordController,
                    onSubmitted: (value) => _doLogin(),
                  ),
                  const SizedBox(height: 32.0),

                  // Actions
                  Consumer<AuthProvider>(builder: (context, authProv, child) {
                    if (authProv.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return FilledButton(
                      onPressed: () => _doLogin(),
                      child: const Text('Log in'),
                    );
                  }),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Need an account?'),
                      Consumer<AuthProvider>(
                          builder: (context, authProv, child) {
                        return TextButton(
                          onPressed: authProv.isLoading
                              ? null
                              : () => const RegisterRoute().go(context),
                          child: const Text('Register'),
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
