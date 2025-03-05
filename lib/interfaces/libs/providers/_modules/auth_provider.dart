import "package:riverpod_annotation/riverpod_annotation.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";
import "package:dicoding_story_fl/use_cases.dart";

part "auth_provider.g.dart";

@Riverpod(keepAlive: true)
sealed class Auth extends _$Auth {
  @override
  Future<User?> build() {
    return ServiceLocator.find<GetAuthUseCase>().execute(null);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    final signInUseCase = ServiceLocator.find<SignInUseCase>();

    try {
      state = AsyncData(await signInUseCase.execute(SignInRequestDto(
        email: email,
        password: password,
      )));
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

      state = AsyncError(parsedError, parsedError.trace ?? trace);
    }
  }

  /// Will do [signIn] after the registration process is complete.
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    final signUpUseCase = ServiceLocator.find<SignUpUseCase>();

    try {
      await signUpUseCase.execute(SignUpRequestDto(
        name: name,
        email: email,
        password: password,
      ));

      await signIn(email: email, password: password);
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

      state = AsyncError(parsedError, parsedError.trace ?? trace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    final signOutUseCase = ServiceLocator.find<SignOutUseCase>();

    try {
      await signOutUseCase.execute(null);

      state = const AsyncData(null);
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

      state = AsyncError(parsedError, parsedError.trace ?? trace);
    }
  }
}
