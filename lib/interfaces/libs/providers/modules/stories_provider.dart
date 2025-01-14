import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";
import "package:dicoding_story_fl/use_cases.dart";

import "../libs/types.dart";

final class StoriesProvider extends AsyncValueNotifier<List<Story>> {
  StoriesProvider({this.storiesCount = 10}) : super([]);

  /// Count of stories to fetch.
  final int storiesCount;

  int _page = 1;
  bool _isLatestPage = false;

  /// Next page to fetch.
  int get page => _page;

  /// Check if it's latest fetched page.
  ///
  /// [fetchStories] won't fetch if it's `true`.
  bool get isLatestPage => _isLatestPage;

  /// Fetch stories and set it to [value].
  ///
  /// May throw a [AppException].
  Future<void> fetchStories() async {
    if (isLatestPage || isLoading) return;

    isLoading = true;

    try {
      final stories = await ServiceLocator.find<GetStoriesUseCase>()
          .execute(GetStoriesRequestDto(page: page, size: storiesCount));

      if (stories.length < storiesCount) {
        _isLatestPage = true;
      } else {
        _page++;
      }

      value = [...value!, ...stories];
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }

  /// Reset provider to initial state. Then do [fetchStories] again.
  Future<void> refresh() async {
    _page = 1;
    _isLatestPage = false;
    value = [];

    await fetchStories();
  }

  /// Post a new story, then call [refresh].
  ///
  /// May throw a [AppException].
  Future<void> postStory({
    required String description,
    required List<int> imageBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    isLoading = true;

    try {
      await ServiceLocator.find<PostStoryUseCase>().execute(PostStoryRequestDto(
        description: description,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
        lat: lat,
        lon: lon,
      ));

      await refresh();
    } catch (err, trace) {
      final parsedError = err.toAppException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }
}
