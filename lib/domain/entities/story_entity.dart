import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import "package:dicoding_story_fl/libs/decorators.dart";

part 'story_entity.freezed.dart';
part 'story_entity.g.dart';

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    @JsonKey(name: "name") required String owner,
    required String description,
    required String photoUrl,
    @dateTimeJsonConverter required DateTime createdAt,
    double? lat,
    double? lon,
  }) = _Story;

  factory Story.fromJson(Map<String, Object?> json) => _$StoryFromJson(json);
}
