import "dart:convert";

import "package:injectable/injectable.dart";
import "package:shared_preferences/shared_preferences.dart";

import "package:dicoding_story_fl/domain/entities/user_entity.dart";

import "../libs/constants.dart";

@lazySingleton
final class AuthLocalData {
  AuthLocalData({
    required SharedPreferences sharedPreferences,
  }) : _cache = sharedPreferences;

  final SharedPreferences _cache;

  User? getUser() {
    final String? rawUser = _cache.getString(CacheKeys.user);

    if (rawUser == null) return null;

    return User.fromJson(jsonDecode(rawUser));
  }

  Future<bool> saveUser(User user) {
    return _cache.setString(
      CacheKeys.user,
      jsonEncode(user.toJson()),
    );
  }

  Future<bool> removeUser() {
    return _cache.remove(CacheKeys.user);
  }
}
