import "package:dicoding_story_fl/service_locator.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

/// Provider for [ThemeMode].
///
/// [value] setter already overrides to cache the changes.
class ThemeModeProvider extends ValueNotifier<ThemeMode> {
  ThemeModeProvider() : super(_getCache());

  static SharedPreferences get _cache => ServiceLocator.find();

  static const cacheKey = "theme_mode";

  @override
  set value(ThemeMode value) {
    Future.microtask(() => _cache.setInt(cacheKey, value.index))
        .then((_) => null);

    super.value = value;
  }

  static ThemeMode _getCache() {
    final cache = _cache.getInt(cacheKey);

    if (cache == null) return ThemeMode.system;

    return ThemeMode.values[cache];
  }
}
