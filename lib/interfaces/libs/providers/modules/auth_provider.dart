import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/interfaces/ux.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";
import "package:dicoding_story_fl/use_cases.dart";

final class AuthProvider extends AsyncValueNotifier<User?> {
  AuthProvider([super.initialValue]) {
    Future.microtask(() => _fetchToken()).catchError((e) => null);
  }

  /// Logged in state.
  ///
  /// Same as [value] is not null.
  bool get isLoggedIn => !hasValue;

  Future<void> _fetchToken() async {
    if (!isLoading) isLoading = true;

    value = await ServiceLocator.find<GetAuthUseCase>().execute(null);
  }

  Future<void> login({required String email, required String password}) async {
    isLoading = true;

    try {
      await ServiceLocator.find<SignInUseCase>()
          .execute(SignInRequestDto(email: email, password: password));

      await _fetchToken();
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }

  Future<void> logout() async {
    isLoading = true;

    try {
      await ServiceLocator.find<SignOutUseCase>().execute(null);

      await _fetchToken();
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

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
      await ServiceLocator.find<SignUpUseCase>().execute(
        SignUpRequestDto(
          name: username,
          email: email,
          password: password,
        ),
      );

      await login(email: email, password: password);
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }
}
