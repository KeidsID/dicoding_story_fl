import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

final class SignOutUseCase implements UseCase<void, void> {
  const SignOutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(void requestDto) async {
    return _authRepository.signOut();
  }
}
