import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

abstract class AppThemes {
  /// Dicoding color.
  static const primaryColorSeed = Color(0xFF2D3E50);

  static FlexSchemeColor get _flexSchemeColor =>
      FlexSchemeColor.from(primary: primaryColorSeed);

  // https://rydmike.com/flexcolorscheme/themesplayground-latest/

  static const int _usedColors = 1;
  static FlexSurfaceMode? get _surfaceMode =>
      FlexSurfaceMode.highSurfaceLowScaffold;

  /// `0-40`
  static const int _blendLevel = 10;

  /// Use true black on background for dark theme, and plain white for light
  /// theme.
  ///
  /// Also surface are 5% less blend.
  static const bool _trueTheme = false;

  static const FlexSubThemesData _subThemesData = FlexSubThemesData(
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    splashType: FlexSplashType.inkRipple,
    inputDecoratorIsFilled: false,
    popupMenuSchemeColor: SchemeColor.surface,
    useInputDecoratorThemeInDialogs: true,
  );

  static FlexKeyColors? get _keyColors => const FlexKeyColors();
  static VisualDensity? get _visualDensity => VisualDensity.comfortable;
  static const bool useMaterial3 = true;

  static const String fontFamily = 'Rubik';

  static ThemeData get light {
    return FlexThemeData.light(
      colors: _flexSchemeColor,
      usedColors: _usedColors,
      surfaceMode: _surfaceMode,
      blendLevel: _blendLevel,
      lightIsWhite: _trueTheme,
      subThemesData: _subThemesData,
      keyColors: _keyColors,
      visualDensity: _visualDensity,
      useMaterial3: useMaterial3,
      fontFamily: fontFamily,
    );
  }

  static ThemeData get dark {
    return FlexThemeData.dark(
      colors: _flexSchemeColor,
      usedColors: _usedColors,
      surfaceMode: _surfaceMode,
      blendLevel: _blendLevel,
      darkIsTrueBlack: _trueTheme,
      subThemesData: _subThemesData,
      keyColors: _keyColors,
      visualDensity: _visualDensity,
      useMaterial3: useMaterial3,
      fontFamily: fontFamily,
    );
  }
}
