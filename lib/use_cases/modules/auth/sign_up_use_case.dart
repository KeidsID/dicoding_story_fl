import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

@singleton
final class SignUpUseCase implements UseCase<SignUpRequestDto, void> {
  const SignUpUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> execute(SignUpRequestDto requestDto) {
    final SignUpRequestDto(:email, :password, :name) = requestDto;

    return _authRepository.signUp(
      email: email,
      password: password,
      name: name,
    );
  }
}

final class SignUpRequestDto {
  const SignUpRequestDto({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;
}
