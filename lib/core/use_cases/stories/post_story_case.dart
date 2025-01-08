import "package:dicoding_story_fl/core/entities.dart";
import "package:dicoding_story_fl/core/repos.dart";

/// {@template dicoding_story_fl.domain.use_cases.stories.PostStoryCase}
/// Use case for posting new story.
/// {@endtemplate}
class PostStoryCase {
  /// {@macro dicoding_story_fl.domain.use_cases.stories.PostStoryCase}
  const PostStoryCase(this._storiesRepo);

  final StoriesRepo _storiesRepo;

  /// Post new story.
  ///
  /// [imageFilename] must include file extension.
  Future<void> execute(
    UserCreds userCreds, {
    required String description,
    required List<int> imageBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) =>
      _storiesRepo.postStory(
        userCreds,
        description: description,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
        lat: lat,
        lon: lon,
      );
}
