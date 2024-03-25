import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.onSubmitted,
  });

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: !isVisible,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        label: const Text('Password'),
        suffixIcon: IconButton(
          onPressed: () => setState(() => isVisible = !isVisible),
          icon: Icon(
            (isVisible) ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
