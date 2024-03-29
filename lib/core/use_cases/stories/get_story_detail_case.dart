import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';

/// {@template dicoding_story_fl.domain.use_cases.stories.GetStoryDetailCase}
/// Use case for get story detail case.
/// {@endtemplate}
class GetStoryDetailCase {
  /// {@macro dicoding_story_fl.domain.use_cases.stories.GetStoryDetailCase}
  const GetStoryDetailCase(this._storiesRepo);

  final StoriesRepo _storiesRepo;

  /// Get story detail by story id.
  Future<StoryDetail> execute(
    String id, {
    required UserCreds userCredentials,
  }) =>
      _storiesRepo.storyDetailById(id, userCredentials: userCredentials);
}
