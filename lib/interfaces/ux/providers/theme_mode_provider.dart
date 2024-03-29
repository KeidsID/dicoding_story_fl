import 'package:dicoding_story_fl/container.dart' as container;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for [ThemeMode].
///
/// [value] setter already overrides to cache the changes.
class ThemeModeProvider extends ValueNotifier<ThemeMode> {
  ThemeModeProvider() : super(_getCache());

  static SharedPreferences get _cache => container.get();

  static const cacheKey = 'theme_mode';

  @override
  set value(ThemeMode newValue) {
    Future.microtask(() => _cache.setInt(cacheKey, newValue.index));

    super.value = newValue;
  }

  static ThemeMode _getCache() {
    final cache = _cache.getInt(cacheKey);

    if (cache == null) return ThemeMode.system;

    return ThemeMode.values[cache];
  }
}
