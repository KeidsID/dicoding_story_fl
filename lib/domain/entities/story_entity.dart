import "package:flutter/foundation.dart";
import "package:freezed_annotation/freezed_annotation.dart";

import "package:dicoding_story_fl/libs/decorators.dart";
import "location_data_entity.dart";

part "story_entity.freezed.dart";
part "story_entity.g.dart";

@Freezed(copyWith: true)
class Story with _$Story {
  const factory Story({
    required String id,
    @JsonKey(name: "name") required String owner,
    required String description,
    required String photoUrl,
    @dateTimeJsonConverter required DateTime createdAt,
    double? lat,
    double? lon,

    /// Detailed location data from reverse geocoding.
    @ignoreJsonSerializable LocationData? location,
  }) = _Story;

  factory Story.fromJson(Map<String, Object?> json) => _$StoryFromJson(json);
}
