import 'package:dicoding_story_fl/infrastructures/api/responses.dart';

class LoginResponse extends CommonResponse {
  const LoginResponse({
    required super.error,
    required super.message,
    required this.loginResult,
  });

  final LoginResult loginResult;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json['error'],
      message: json['message'],
      loginResult: LoginResult.fromJson(json['loginResult']),
    );
  }
}

class LoginResult {
  const LoginResult({
    required this.userId,
    required this.name,
    required this.token,
  });

  final String userId;
  final String name;
  final String token;

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json['userId'],
      name: json['name'],
      token: json['token'],
    );
  }
}
