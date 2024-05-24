import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

/// {@template dicoding_story_fl.domain.use_cases.stories.GetStoryDetailCase}
/// Use case for get story detail case.
/// {@endtemplate}
class GetStoryDetailCase {
  /// {@macro dicoding_story_fl.domain.use_cases.stories.GetStoryDetailCase}
  const GetStoryDetailCase({
    required StoriesRepo storiesRepo,
    required GMapsRepo gMapsRepo,
  })  : _storiesRepo = storiesRepo,
        _gMapsRepo = gMapsRepo;

  final StoriesRepo _storiesRepo;
  final GMapsRepo _gMapsRepo;

  /// Get story detail by story id.
  Future<StoryDetail> execute(
    String id, {
    required UserCreds userCredentials,
  }) async {
    final raw = await _storiesRepo.storyDetailById(
      id,
      userCreds: userCredentials,
    );

    final loc = raw.location;

    if (loc == null) return raw;

    try {
      return raw.copyWith(location: await _gMapsRepo.reverseGeocoding(loc));
    } catch (err, trace) {
      kLogger.w(
        'GetStoryDetailCase reverse geocoding',
        error: err,
        stackTrace: trace,
      );

      return raw;
    }
  }
}
