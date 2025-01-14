import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

@singleton
final class SignOutUseCase implements UseCase<void, void> {
  const SignOutUseCase(this._authRepository, this._storiesRepository);

  final AuthRepository _authRepository;
  final StoriesRepository _storiesRepository;

  @override
  Future<void> execute(void requestDto) async {
    await _authRepository.signOut();

    _storiesRepository.authToken = null;
  }
}
