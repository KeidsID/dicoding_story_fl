import "package:chopper/chopper.dart";
import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/infrastructures/libs/data/local/modules.dart";
import "package:dicoding_story_fl/infrastructures/libs/data/remote/modules.dart";
import "package:dicoding_story_fl/libs/extensions.dart";

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._localData, this._remoteData);

  final AuthLocalData _localData;
  final AuthRemoteData _remoteData;

  @override
  Future<User?> getAuth() async {
    return _localData.getUser();
  }

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final rawResponse = await _remoteData.signIn(body: {
        "email": email,
        "password": password,
      });
      final rawResponseBody = rawResponse.body!;

      final user = User.fromJson(rawResponseBody["loginResult"]);

      _localData.saveUser(user);

      return user;
    } on ChopperHttpException catch (exception, trace) {
      throw handleApiErrorResponse(exception, trace);
    } catch (error, trace) {
      throw error.toAppException(
        message: "Failed to sign in",
        trace: trace,
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _localData.removeUser();
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _remoteData.signUp(body: {
        "name": name,
        "email": email,
        "password": password,
      });
    } on ChopperHttpException catch (exception, trace) {
      throw handleApiErrorResponse(exception, trace);
    } catch (error, trace) {
      throw error.toAppException(
        message: "Failed to sign up",
        trace: trace,
      );
    }
  }
}
