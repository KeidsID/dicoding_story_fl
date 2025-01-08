import "package:flutter/foundation.dart";
import "package:freezed_annotation/freezed_annotation.dart";

import "package:dicoding_story_fl/core/entities.dart";

part "stories_response.freezed.dart";
part "stories_response.g.dart";

@freezed
class StoriesResponse with _$StoriesResponse {
  const factory StoriesResponse({
    required bool error,
    required String message,
    required List<RawStory> listStory,
  }) = _StoriesResponse;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseFromJson(json);
}

@freezed
class RawStory with _$RawStory {
  const factory RawStory({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required String createdAt,
    double? lat,
    double? lon,
  }) = _RawStory;

  factory RawStory.fromJson(Map<String, dynamic> json) =>
      _$RawStoryFromJson(json);

  const RawStory._();

  Story toEntity() {
    return Story(
      id: id,
      owner: name,
      description: description,
      photoUrl: photoUrl,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      lat: lat,
      lon: lon,
    );
  }
}
