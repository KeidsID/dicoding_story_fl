import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

/// {@template dicoding_story_fl.domain.use_cases.stories.GetStoriesCase}
/// Use case for fetch stories.
/// {@endtemplate}
class GetStoriesCase {
  /// {@macro dicoding_story_fl.domain.use_cases.stories.GetStoriesCase}
  const GetStoriesCase({
    required StoriesRepo storiesRepo,
    required GMapsRepo gMapsRepo,
  })  : _storiesRepo = storiesRepo,
        _gMapsRepo = gMapsRepo;

  final StoriesRepo _storiesRepo;
  final GMapsRepo _gMapsRepo;

  /// Fetch stories from server.
  ///
  /// - [userCredentials], user credentials needed to fetch stories.
  /// - [page], page number. Must be greater than `0`.
  /// - [size], stories count for each page. Must be greater than `0`.
  /// - [includeLocation], include location coordinate on the [Story]. Default is
  ///   `false`.
  Future<List<Story>> execute(
    UserCreds userCredentials, {
    int page = 1,
    int size = 10,
    bool includeLocation = false,
  }) async {
    final raws = await _storiesRepo.fetchStories(
      userCredentials,
      page: page,
      size: size,
      includeLocation: includeLocation,
    );

    return await Future.wait(raws.map((e) async {
      final loc = e.location;

      if (loc == null) return e;

      try {
        return e.copyWith(location: await _gMapsRepo.reverseGeocoding(loc));
      } catch (err, trace) {
        kLogger.w(
          'GetStoriesCase reverse geocoding',
          error: err,
          stackTrace: trace,
        );

        return e;
      }
    }));
  }
}
