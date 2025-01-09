import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

@singleton
final class GetAuthUseCase implements UseCase<void, User?> {
  const GetAuthUseCase(this._authRepository, this._storiesRepository);

  final AuthRepository _authRepository;
  final StoriesRepository _storiesRepository;

  @override
  Future<User?> execute(void requestDto) async {
    final user = await _authRepository.getAuth();

    if (user != null) {
      _storiesRepository.authToken = user.authToken;
    }

    return user;
  }
}
