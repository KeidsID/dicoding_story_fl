import 'package:equatable/equatable.dart';

import 'package:dicoding_story_fl/core/entities.dart';

/// {@template dicoding_story_fl.core.entities.Story}
/// Story summary posted by user.
/// {@endtemplate}
class Story extends Equatable {
  /// {@macro dicoding_story_fl.core.entities.Story}
  const Story({
    required this.id,
    required this.owner,
    required this.description,
    required this.photoUrl,
    required this.createdAt,
    this.location,
  });

  /// Unique identifier.
  final String id;

  /// The username of the person who posted the story.
  final String owner;

  /// The description of the story
  final String description;

  /// The URL of the photo attached by the story owner.
  final String photoUrl;

  /// Date and time this story was posted.
  final DateTime createdAt;

  /// Geographic coordinate of the story location (if available).
  final LocationCore? location;

  @override
  List<Object?> get props {
    return [id, owner, description, photoUrl, createdAt, location];
  }

  Story copyWith({
    String? id,
    String? owner,
    String? description,
    String? photoUrl,
    DateTime? createdAt,
    LocationCore? location,
  }) {
    return Story(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      description: description ?? this.description,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      location: location ?? this.location,
    );
  }
}
