import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:dicoding_story_fl/core/entities.dart';

part 'story_detail_response.freezed.dart';
part 'story_detail_response.g.dart';

@freezed
class StoryDetailResponse with _$StoryDetailResponse {
  const factory StoryDetailResponse({
    required bool error,
    required String message,
    required RawStoryDetail story,
  }) = _StoryDetailResponse;

  factory StoryDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryDetailResponseFromJson(json);
}

@freezed
class RawStoryDetail with _$RawStoryDetail {
  const factory RawStoryDetail({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required String createdAt,
    double? lat,
    double? lon,
  }) = _RawStoryDetail;

  factory RawStoryDetail.fromJson(Map<String, dynamic> json) =>
      _$RawStoryDetailFromJson(json);

  const RawStoryDetail._();

  StoryDetail toEntity() {
    return StoryDetail(
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
