import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";
import "package:dicoding_story_fl/use_cases.dart";

import "../libs/types.dart";

final class StoryDetailProvider extends AsyncValueNotifier<Story> {
  StoryDetailProvider(this.storyId) : super(null) {
    Future.microtask(() => refresh()).then((_) => null);
  }

  final String storyId;

  /// Refresh [value].
  Future<void> refresh() async {
    isLoading = true;

    try {
      value = await ServiceLocator.find<GetStoryByIdUseCase>().execute(
        storyId,
      );
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }
}
