import 'package:fl_utilities/fl_utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/interfaces/ui.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  Future<void> _doRegister() async {
    final showSnackBar = context.scaffoldMessenger?.showSnackBar;
    final authProv = context.read<AuthProvider>();

    try {
      await authProv.register(
        username: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
    } on SimpleException catch (err) {
      showSnackBar?.call(SnackBar(content: Text(err.message)));
    } catch (err) {
      showSnackBar?.call(const SnackBar(
        content: Text('No internet connection'),
      ));
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
                  Text('Register Form', style: context.textTheme.headlineLarge),
                  const SizedBox(height: 16.0),

                  // Inputs
                  TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      label: Text('Name'),
                      hintText: 'John Doe from Dicoding',
                    ),
                  ),
                  EmailTextField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                  ),
                  PasswordTextField(
                    controller: passwordController,
                    onSubmitted: (value) => _doRegister(),
                  ),
                  const SizedBox(height: 32.0),

                  // Actions
                  Consumer<AuthProvider>(builder: (context, authProv, child) {
                    if (authProv.isLoading) {
                      return const CircularProgressIndicator();
                    }

                    return FilledButton(
                      onPressed: () => _doRegister(),
                      child: const Text('Register'),
                    );
                  }),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      Consumer<AuthProvider>(
                        builder: (context, authProv, child) {
                          return TextButton(
                            onPressed: authProv.isLoading
                                ? null
                                : () => const LoginRoute().go(context),
                            child: const Text('Log in'),
                          );
                        },
                      ),
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
