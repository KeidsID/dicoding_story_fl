import 'package:dicoding_story_fl/core/repos.dart';

/// {@template dicoding_story_fl.domain.use_cases.auth.LogoutCase}
/// Use case for delete recent login session.
/// {@endtemplate}
class LogoutCase {
  /// {@macro dicoding_story_fl.domain.use_cases.auth.LogoutCase}
  const LogoutCase(this._authRepo);

  final AuthRepo _authRepo;

  /// Delete recent login session.
  Future<void> execute() => _authRepo.logout();
}
