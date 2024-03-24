import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';
import 'package:dicoding_story_fl/infrastructures/api/responses.dart';

part 'auth_repo_impl.chopper.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._client);

  final ChopperClient _client;

  _AuthService get _auth => _AuthService.create(_client);

  Exception _onErrorResponse(Response<String> res) {
    try {
      final error = res.error;

      if (error != null) {
        final errorBody = CommonResponse.fromJson(jsonDecode(error as String));
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
      final rawRes = await _auth.postLogin(body: {
        "email": email,
        "password": password,
      });
      final rawResBody = rawRes.body;

      if (rawResBody == null) throw _onErrorResponse(rawRes);

      final resBody = LoginResponse.fromJson(jsonDecode(rawResBody));

      return UserCreds(
        name: resBody.loginResult.name,
        token: resBody.loginResult.token,
      );
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
    } catch (err, trace) {
      throw SimpleException(error: err, trace: trace);
    }
  }
}

@chopperApi
abstract class _AuthService extends ChopperService {
  static _AuthService create([ChopperClient? client]) => _$_AuthService(client);

  /// Body:
  /// ```json
  /// {
  ///   "name": "String",
  ///   "email": "String",
  ///   "password": "String"
  /// }
  /// ```
  @Post(path: '/register')
  Future<Response<String>> postRegister({
    @body required Map<String, dynamic> body,
  });

  /// Body:
  /// ```json
  /// {
  ///   "email": "String",
  ///   "password": "String"
  /// }
  /// ```
  @Post(path: '/login')
  Future<Response<String>> postLogin({
    @body required Map<String, dynamic> body,
  });
}
