import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dicoding_story_fl/container.dart' as container;

class LocaleProvider extends ValueNotifier<Locale?> {
  LocaleProvider() : super(_getCache());

  static SharedPreferences get _cache => container.get();

  static const cacheKey = 'locale';

  @override
  set value(Locale? value) {
    Future.microtask(() async {
      if (value == null) {
        await _cache.remove(cacheKey);
        return;
      }

      await _cache.setString(
        cacheKey,
        value.countryCode != null
            ? '${value.languageCode}_${value.countryCode}'
            : value.languageCode,
      );
    }).then((_) => null);

    super.value = value;
  }

  static Locale? _getCache() {
    final cache = _cache.getString(cacheKey);

    if (cache == null) return null;

    final List<String> parsedCache = cache.split('_');

    if (parsedCache.length == 1) return Locale(parsedCache.first);

    return Locale(parsedCache.first, parsedCache.lastOrNull);
  }
}
