import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

final class SignInUseCase implements UseCase<SignInRequestDto, User> {
  const SignInUseCase(this._authRepository, this._storiesRepository);

  final AuthRepository _authRepository;
  final StoriesRepository _storiesRepository;

  @override
  Future<User> execute(SignInRequestDto requestDto) async {
    final SignInRequestDto(:email, :password) = requestDto;

    final user = await _authRepository.signIn(email: email, password: password);

    _storiesRepository.authToken = user.authToken;

    return user;
  }
}

final class SignInRequestDto {
  const SignInRequestDto({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
