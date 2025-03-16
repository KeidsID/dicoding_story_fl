import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/libs/providers.dart";
import "package:dicoding_story_fl/interfaces/libs/widgets.dart";
import "package:dicoding_story_fl/interfaces/modules.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/libs/extensions.dart";

enum AuthRouteScreenVariant {
  signIn,
  signUp;

  static AuthRouteScreenVariant? fromUrlParams(String value) {
    return switch (value) {
      "sign-in" => AuthRouteScreenVariant.signIn,
      "sign-up" => AuthRouteScreenVariant.signUp,
      _ => null,
    };
  }

  String? toUrlParams() {
    return switch (this) {
      AuthRouteScreenVariant.signIn => "sign-in",
      AuthRouteScreenVariant.signUp => "sign-up",
    };
  }
}

class AuthRouteScreen extends ConsumerStatefulWidget {
  const AuthRouteScreen({
    super.key,
    this.variant = AuthRouteScreenVariant.signIn,
    this.email,
    this.name,
  });

  final AuthRouteScreenVariant variant;

  /// Initial value for email field.
  final String? email;

  /// Initial value for name field.
  final String? name;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthRouteScreenState();
}

class _AuthRouteScreenState extends ConsumerState<AuthRouteScreen> {
  Auth get authProviderNotifier => ref.read(authProvider.notifier);

  late AuthRouteScreenVariant variant;
  bool get isSignInVariant => variant == AuthRouteScreenVariant.signIn;

  double get _maxWidth => 400.0;
  EdgeInsetsGeometry get _padding => const EdgeInsets.all(16.0);

  void _handleRouteParams(BuildContext context) {
    final email = _emailController.text;
    final name = _nameController.text;

    AuthRoute(
      v: variant.toUrlParams(),
      email: email.isEmpty ? null : email,
      name: name.isEmpty ? null : name,
    ).go(context);
  }

  void _handleEmailAndNameFieldChanges(String _) {
    _handleRouteParams(context);
  }

  void _handleVariantNavigation(BuildContext context) {
    setState(() {
      variant = isSignInVariant
          ? AuthRouteScreenVariant.signUp
          : AuthRouteScreenVariant.signIn;
    });

    _handleRouteParams(context);
  }

  Future<void> _handleVariantAction(BuildContext context) async {
    final email = _emailController.text;
    final name = _nameController.text;
    final password = _passwordController.text;

    try {
      if (isSignInVariant) {
        return authProviderNotifier.signIn(email: email, password: password);
      }

      await authProviderNotifier.signUp(
        email: email,
        name: name,
        password: password,
      );
    } catch (err, trace) {
      final exception = err.toAppException(trace: trace);

      kLogger.w(exception);

      if (context.mounted) {
        final appL10n = AppL10n.of(context)!;

        context.scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(appL10n.signInErrorMessage),
        ));
      }
    }
  }

  // BUILD

  late final TextEditingController _emailController;
  late final TextEditingController _nameController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();

    variant = widget.variant;

    _emailController = TextEditingController(text: widget.email);
    _nameController = TextEditingController(text: widget.name);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appL10n = AppL10n.of(context)!;
    final textTheme = context.textTheme;

    final AsyncValue<User?>(:isLoading) = ref.watch(authProvider);

    final headerTitle = isSignInVariant ? kAppName : appL10n.registerForm;
    final mainActionLabel = isSignInVariant ? appL10n.login : appL10n.register;
    final navigationActionCaption =
        isSignInVariant ? appL10n.needAnAccount : appL10n.alreadyHaveAnAccount;
    final navigationActionLabel =
        isSignInVariant ? appL10n.register : appL10n.login;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: _maxWidth,
            child: SingleChildScrollView(
              padding: _padding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // header
                  Text(headerTitle, style: textTheme.headlineLarge),
                  const SizedBox(height: 32.0),

                  // inputs
                  AnimatedSize(
                    duration: Durations.medium1,
                    curve: Curves.easeInOutSine,
                    child: switch (isSignInVariant) {
                      true => const SizedBox.shrink(),
                      _ => TextField(
                          controller: _nameController,
                          enabled: !isLoading,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            label: Text("Username"),
                            hintText: "John Doe",
                          ),
                          onChanged: _handleEmailAndNameFieldChanges.debounce(),
                        ),
                    },
                  ),
                  const SizedBox(height: 16.0),
                  EmailTextField(
                    controller: _emailController,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.next,
                    onChanged: _handleEmailAndNameFieldChanges.debounce(),
                  ),
                  const SizedBox(height: 16.0),
                  PasswordTextField(
                    controller: _passwordController,
                    enabled: !isLoading,
                    onSubmitted: (value) => _handleVariantAction(context),
                  ),
                  const SizedBox(height: 32.0),

                  // actions
                  if (isLoading) const CircularProgressIndicator(),
                  if (!isLoading) ...[
                    FilledButton(
                      onPressed: () => _handleVariantAction(context),
                      child: Text(mainActionLabel),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$navigationActionCaption?"),
                        TextButton(
                          onPressed: () => _handleVariantNavigation(context),
                          child: Text(navigationActionLabel),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
