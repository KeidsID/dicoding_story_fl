import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

/// {@template dicoding_story_fl.domain.use_cases.stories.GetStoriesCase}
/// Use case for fetch stories.
/// {@endtemplate}
class GetStoriesCase {
  /// {@macro dicoding_story_fl.domain.use_cases.stories.GetStoriesCase}
  const GetStoriesCase(this._storiesRepo);

  final StoriesRepo _storiesRepo;

  /// Fetch stories from server.
  ///
  /// - [page], page number. Default is `1`.
  /// - [size], stories count for each page. Default is `10`.
  /// - [hasCordinate], include location coordinate on the [Story]. Default is
  ///   `false`.
  Future<List<Story>> execute({int? page, int? size, bool? hasCordinate}) =>
      _storiesRepo.fetchStories(
        page: page,
        size: size,
        hasCordinate: hasCordinate,
      );
}
