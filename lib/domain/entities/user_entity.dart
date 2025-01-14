import "package:freezed_annotation/freezed_annotation.dart";
import "package:flutter/foundation.dart";

part "user_entity.freezed.dart";
part "user_entity.g.dart";

@Freezed(toJson: true)
class User with _$User {
  const factory User({
    @JsonKey(name: "userId") required String id,
    required String name,

    /// Token for fetching stories from API.
    @JsonKey(name: "token") required String authToken,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
