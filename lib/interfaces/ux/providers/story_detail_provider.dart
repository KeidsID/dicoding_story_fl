import "package:dicoding_story_fl/common/utils.dart";
import "package:dicoding_story_fl/container.dart" as container;
import "package:dicoding_story_fl/core/entities.dart";
import "package:dicoding_story_fl/core/use_cases.dart";
import "package:dicoding_story_fl/interfaces/ux.dart";

final class StoryDetailProvider extends AsyncValueNotifier<StoryDetail> {
  StoryDetailProvider({required this.storyId, required this.userCreds})
      : super(null) {
    Future.microtask(() => refresh()).then((_) => null);
  }

  final String storyId;
  final UserCreds userCreds;

  /// Refresh [value].
  Future<void> refresh() async {
    isLoading = true;

    try {
      value = await container.get<GetStoryDetailCase>().execute(
            storyId,
            userCredentials: userCreds,
          );
    } catch (err, trace) {
      final parsedError = err.toSimpleException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }
}
