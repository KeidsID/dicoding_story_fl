import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

/// {@template dicoding_story_fl.domain.use_cases.auth.GetLoginSessionCase}
/// Use case for get recent login session.
/// {@endtemplate}
class GetLoginSessionCase {
  /// {@macro dicoding_story_fl.domain.use_cases.auth.GetLoginSessionCase}
  const GetLoginSessionCase(this._authRepo);

  final AuthRepo _authRepo;

  /// Get recent login credentials.
  Future<UserCreds?> execute() => _authRepo.getLoginSession();
}
