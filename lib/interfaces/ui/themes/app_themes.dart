import 'package:flutter/material.dart';

abstract class AppThemes {
  static ThemeData get light => _getTheme(Brightness.light);
  static ThemeData get dark => _getTheme(Brightness.dark);

  /// Dicoding color.
  static const _appColor = Color(0xFF2D3E50);
  static const _useMaterial3 = true;
  static TextTheme? get _textTheme => null;

  static ThemeData _getTheme(Brightness brightness) {
    return ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _appColor,
        brightness: brightness,
      ),
      useMaterial3: _useMaterial3,
      textTheme: _textTheme,
    );
  }
}
