import 'package:dicoding_story_fl/core/entities.dart';

class StoryDetail extends Story {
  const StoryDetail({
    required super.id,
    required super.owner,
    required super.description,
    required super.photoUrl,
    required super.createdAt,
    super.location,
    super.place,
  });

  @override
  StoryDetail copyWith({
    String? id,
    String? owner,
    String? description,
    String? photoUrl,
    DateTime? createdAt,
    LocationCore? location,
    PlaceCore? place,
  }) {
    return StoryDetail(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
      place: place ?? this.place,
    );
  }
}
