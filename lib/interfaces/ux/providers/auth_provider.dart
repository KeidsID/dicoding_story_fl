import 'package:flutter/material.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';

enum AuthProviderState {
  /// Asynchronous process running.
  loading,
  loggedIn,
  loggedOut,
}

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    required RegisterCase registerCase,
    required LoginCase loginCase,
    required LogoutCase logoutCase,
    required GetLoginSessionCase getLoginSessionCase,
  })  : _registerCase = registerCase,
        _loginCase = loginCase,
        _logoutCase = logoutCase,
        _getLoginSessionCase = getLoginSessionCase {
    _fetchToken();
  }

  final RegisterCase _registerCase;
  final LoginCase _loginCase;
  final LogoutCase _logoutCase;
  final GetLoginSessionCase _getLoginSessionCase;

  AuthProviderState _state = AuthProviderState.loggedOut;
  UserCreds? _userCreds;

  AuthProviderState get state => _state;
  UserCreds? get userCreds => _userCreds;

  /// Asynchronous process running.
  bool get isLoading => state == AuthProviderState.loading;

  set _setState(AuthProviderState value) {
    _state = value;
    notifyListeners();
  }

  Future<void> _fetchToken() async {
    _setState = AuthProviderState.loading;

    _userCreds = await _getLoginSessionCase.execute();

    _setState = (_userCreds == null)
        ? AuthProviderState.loggedOut
        : AuthProviderState.loggedIn;
  }

  Future<void> login({required String email, required String password}) async {
    final prevState = state;
    _setState = AuthProviderState.loading;

    try {
      await _loginCase.execute(email: email, password: password);

      await _fetchToken();
    } on SimpleException {
      _setState = prevState;
      rethrow;
    } catch (err, trace) {
      _setState = prevState;
      throw SimpleException(error: err, trace: trace);
    }
  }

  Future<void> logout() async {
    final prevState = state;
    _setState = AuthProviderState.loading;

    try {
      await _logoutCase.execute();

      await _fetchToken();
    } on SimpleException {
      _setState = prevState;
      rethrow;
    } catch (err, trace) {
      _setState = prevState;
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
    final prevState = state;
    _setState = AuthProviderState.loading;

    try {
      await _registerCase.execute(
        username: username,
        email: email,
        password: password,
      );

      await login(email: email, password: password);
    } on SimpleException {
      _setState = prevState;
      rethrow;
    } catch (err, trace) {
      _setState = prevState;
      throw SimpleException(error: err, trace: trace);
    }
  }
}
