import 'package:flutter/material.dart';

import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';

class AuthProvider extends ValueNotifier<UserCreds?> {
  AuthProvider([UserCreds? initialValue]) : super(initialValue) {
    Future.microtask(() => _fetchToken());
  }

  bool _isLoading = false;

  /// Asynchronous process running.
  bool get isLoading => _isLoading;

  /// Update [isLoading] and notify listeners.
  @protected
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  set value(UserCreds? value) {
    _isLoading = false;

    super.value = value;
  }

  Future<void> _fetchToken() async {
    if (!isLoading) isLoading = true;

    value = await container.get<GetLoginSessionCase>().execute();
  }

  Future<void> login({required String email, required String password}) async {
    isLoading = true;

    try {
      await container
          .get<LoginCase>()
          .execute(email: email, password: password);

      await _fetchToken();
    } catch (err, trace) {
      if (err is SimpleException) rethrow;

      throw SimpleException(error: err, trace: trace);
    }
  }

  Future<void> logout() async {
    isLoading = true;

    try {
      await container.get<LogoutCase>().execute();

      await _fetchToken();
    } catch (err, trace) {
      if (err is SimpleException) rethrow;

      throw SimpleException(error: err, trace: trace);
    }
  }

  /// Register as new user to Dicoding Story API, then auto call [login] after
  /// the register process is complete.
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    isLoading = true;

    try {
      await container.get<RegisterCase>().execute(
            username: username,
            email: email,
            password: password,
          );

      await login(email: email, password: password);
    } catch (err, trace) {
      if (err is SimpleException) rethrow;

      throw SimpleException(error: err, trace: trace);
    }
  }
}
