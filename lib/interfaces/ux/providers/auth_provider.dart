import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';
import 'package:flutter/foundation.dart';

final class AuthProvider extends AsyncValueNotifier<UserCreds?> {
  AuthProvider([super.initialValue]) {
    // Async process is skipped if it is not wrapped in [Future.microtask] for 
    // the web platform.
    // 
    // Vice versa for Android, [Future.microtask] will make the async process 
    // skipped.
    // 
    // *flutter v3.19.2
    // *dart v3.3.0
    if (kIsWeb) {
      Future.microtask(_fetchToken);
      return;
    }

    _fetchToken();
  }

  /// Logged in state.
  ///
  /// Same as [value] is not null.
  bool get isLoggedIn => !hasValue;

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
      final parsedError = err.toSimpleException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }

  Future<void> logout() async {
    isLoading = true;

    try {
      await container.get<LogoutCase>().execute();

      await _fetchToken();
    } catch (err, trace) {
      final parsedError = err.toSimpleException(trace: trace);

      setError(parsedError);
      throw parsedError;
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
      final parsedError = err.toSimpleException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }
}
