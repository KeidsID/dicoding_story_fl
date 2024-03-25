import 'package:equatable/equatable.dart';

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
    required this.lat,
    required this.lon,
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

  /// [lat] (Latitude) unit used for geographic coordinate.
  final double? lat;

  /// [lon] (Longitude) unit used for geographic coordinate.
  final double? lon;

  @override
  List<Object?> get props => [id];
}
