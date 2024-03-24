import 'package:dicoding_story_fl/core/repos.dart';

/// {@template dicoding_story_fl.domain.use_cases.auth.RegisterCase}
/// Use case for registering new user.
/// {@endtemplate}
class RegisterCase {
  /// {@macro dicoding_story_fl.domain.use_cases.auth.RegisterCase}
  const RegisterCase(this._authRepo);

  final AuthRepo _authRepo;

  /// Registers new user.
  Future<void> execute({
    required String username,
    required String email,
    required String password,
  }) =>
      _authRepo.register(username: username, email: email, password: password);
}
