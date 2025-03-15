import "package:flutter/material.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:dicoding_story_fl/service_locator.dart";

part "app_configs_provider.freezed.dart";
part "app_configs_provider.g.dart";

/// Provide configs for [MaterialApp].
@Riverpod(keepAlive: true)
class AppConfigs extends _$AppConfigs {
  @override
  AppConfigsProviderState build() {
    final locale = ref.watch(_appLocaleProvider);
    final themeMode = ref.watch(_appThemeModeProvider);

    return AppConfigsProviderState(locale: locale, themeMode: themeMode);
  }

  void setLocale(Locale? locale) {
    ref.read(_appLocaleProvider.notifier).setLocale(locale);
  }

  void setThemeMode(ThemeMode themeMode) {
    ref.read(_appThemeModeProvider.notifier).setThemeMode(themeMode);
  }
}

/// [appConfigsProvider] state.
@Freezed(copyWith: true)
class AppConfigsProviderState with _$AppConfigsProviderState {
  const factory AppConfigsProviderState({
    Locale? locale,
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _AppConfigsProviderState;
}

SharedPreferences get _cacheService => ServiceLocator.find();

@Riverpod(keepAlive: true)
class _AppLocale extends _$AppLocale {
  @override
  Locale? build() {
    return _cachedLocale;
  }

  String get _cacheKey => "app.locale";

  Locale? get _cachedLocale {
    final cache = _cacheService.getString(_cacheKey);

    if (cache == null) return null;

    final List<String> localeParts = cache.split("_");

    if (localeParts.length == 1) return Locale(localeParts.first);

    return Locale(localeParts.first, localeParts.lastOrNull);
  }

  void setLocale(Locale? locale) {
    state = locale;

    if (locale == null) {
      _cacheService.remove(_cacheKey);
    } else {
      _cacheService.setString(
        _cacheKey,
        locale.countryCode != null
            ? "${locale.languageCode}_${locale.countryCode}"
            : locale.languageCode,
      );
    }
  }
}

@Riverpod(keepAlive: true)
class _AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() {
    return _cachedThemeMode;
  }

  String get _cacheKey => "app.theme_mode";

  ThemeMode get _cachedThemeMode {
    final cache = _cacheService.getInt(_cacheKey);

    if (cache == null) return ThemeMode.system;

    return ThemeMode.values[cache];
  }

  void setThemeMode(ThemeMode themeMode) {
    state = themeMode;

    _cacheService.setInt(_cacheKey, themeMode.index);
  }
}
