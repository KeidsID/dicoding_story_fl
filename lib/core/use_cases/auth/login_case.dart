import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

/// {@template dicoding_story_fl.domain.use_cases.auth.LoginCase}
/// Use case for logging in.
/// {@endtemplate}
class LoginCase {
  /// {@macro dicoding_story_fl.domain.use_cases.auth.LoginCase}
  const LoginCase(this._authRepo);

  final AuthRepo _authRepo;

  /// Logging in user.
  Future<UserCreds> execute(
          {required String email, required String password}) =>
      _authRepo.login(email: email, password: password);
}
