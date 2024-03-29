import 'package:dicoding_story_fl/core/entities.dart';

class StoryDetail extends Story {
  const StoryDetail({
    required super.id,
    required super.owner,
    required super.description,
    required super.photoUrl,
    required super.createdAt,
    super.lat,
    super.lon,
  });
}
