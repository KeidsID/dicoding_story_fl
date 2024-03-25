import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';
import 'package:dicoding_story_fl/infrastructures/api/responses.dart';

part 'auth_repo_impl.chopper.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl({
    required ChopperClient client,
    required SharedPreferences sharedPreferences,
  })  : _client = client,
        _cache = sharedPreferences;

  final ChopperClient _client;
  final SharedPreferences _cache;

  _AuthService get _auth => _AuthService.create(_client);

  Exception _onErrorResponse(Response<Map<String, dynamic>> res) {
    try {
      final error = res.error;

      if (error != null) {
        final errorBody =
            CommonResponse.fromJson(error as Map<String, dynamic>);
        return SimpleHttpException(
          statusCode: res.statusCode,
          message: errorBody.message,
          error: errorBody,
          trace: StackTrace.current,
        );
      }

      return SimpleException(error: res, trace: StackTrace.current);
    } catch (err, trace) {
      return SimpleException(error: err, trace: trace);
    }
  }

  @override
  Future<UserCreds> login({
    required String email,
    required String password,
  }) async {
    try {
      // check login session
      final cachedUserCreds = await getLoginSession();

      if (cachedUserCreds != null) return cachedUserCreds;

      final rawRes = await _auth.postLogin(body: {
        "email": email,
        "password": password,
      });
      final rawResBody = rawRes.body;

      if (rawResBody == null) throw _onErrorResponse(rawRes);

      final resBody = LoginResponse.fromJson(rawResBody);

      final userCreds = UserCreds(
        name: resBody.loginResult.name,
        token: resBody.loginResult.token,
      );

      // cache login session
      _cache.setString(_loginCacheKey, jsonEncode(userCreds.toCache()));

      return userCreds;
    } on SimpleException {
      rethrow;
    } catch (err, trace) {
      throw SimpleException(error: err, trace: trace);
    }
  }

  @override
  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final rawRes = await _auth.postRegister(body: {
        "name": username,
        "email": email,
        "password": password,
      });

      if (!rawRes.isSuccessful) throw _onErrorResponse(rawRes);
    } on SimpleException {
      rethrow;
    } catch (err, trace) {
      throw SimpleException(error: err, trace: trace);
    }
  }

  // --------------------------------------------------------------------------
  // CACHE
  // --------------------------------------------------------------------------

  static const _loginCacheKey = 'login_session';

  @override
  Future<UserCreds?> getLoginSession() async {
    await _cache.reload();

    final rawCreds = _cache.getString(_loginCacheKey);

    return rawCreds == null ? null : UserCreds.fromCache(jsonDecode(rawCreds));
  }

  @override
  Future<void> logout() => _cache.remove(_loginCacheKey);
}

@chopperApi
abstract class _AuthService extends ChopperService {
  static _AuthService create([ChopperClient? client]) => _$_AuthService(client);

  /// Valid [body] value: 
  /// 
  /// ```json
  /// {
  ///   "name": "String",
  ///   "email": "String",
  ///   "password": "String"
  /// }
  /// ```
  @Post(path: '/register')
  Future<Response<Map<String, dynamic>>> postRegister({
    @body required Map<String, dynamic> body,
  });

  /// Valid [body] value:
  /// 
  /// ```json
  /// {
  ///   "email": "String",
  ///   "password": "String"
  /// }
  /// ```
  @Post(path: '/login')
  Future<Response<Map<String, dynamic>>> postLogin({
    @body required Map<String, dynamic> body,
  });
}
