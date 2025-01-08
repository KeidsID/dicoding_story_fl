import "package:dicoding_story_fl/core/entities.dart";
import "package:dicoding_story_fl/core/repos.dart";

/// {@template dicoding_story_fl.domain.use_cases.stories.GetStoriesCase}
/// Use case for fetch stories.
/// {@endtemplate}
class GetStoriesCase {
  /// {@macro dicoding_story_fl.domain.use_cases.stories.GetStoriesCase}
  const GetStoriesCase(this._storiesRepo);

  final StoriesRepo _storiesRepo;

  /// Fetch stories from server.
  ///
  /// - [userCredentials], user credentials needed to fetch stories.
  /// - [page], page number. Must be greater than `0`.
  /// - [size], stories count for each page. Must be greater than `0`.
  /// - [hasCordinate], include location coordinate on the [Story]. Default is
  ///   `false`.
  Future<List<Story>> execute(
    UserCreds userCredentials, {
    int page = 1,
    int size = 10,
    bool? hasCordinate,
  }) =>
      _storiesRepo.fetchStories(
        userCredentials,
        page: page,
        size: size,
        hasCordinate: hasCordinate,
      );
}
