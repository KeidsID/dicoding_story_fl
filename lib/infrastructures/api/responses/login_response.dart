import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dicoding_story_fl/core/entities.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required bool error,
    required String message,
    required RawUserCreds loginResult,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
class RawUserCreds with _$RawUserCreds {
  const factory RawUserCreds({
    required String userId,
    required String name,
    required String token,
  }) = _RawUserCreds;

  factory RawUserCreds.fromJson(Map<String, dynamic> json) =>
      _$RawUserCredsFromJson(json);

  const RawUserCreds._();

  UserCreds toEntity() {
    return UserCreds(id: userId, name: name, token: token);
  }
}
