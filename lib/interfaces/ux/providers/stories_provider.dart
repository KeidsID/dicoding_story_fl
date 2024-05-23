import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

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
  /// May throw a [SimpleException].
  Future<void> fetchStories(UserCreds userCreds) async {
    if (isLatestPage || isLoading) return;

    isLoading = true;

    try {
      final stories = await container.get<GetStoriesCase>().execute(
            userCreds,
            page: page,
            size: storiesCount,
            includeLocation: true,
          );

      if (stories.length < storiesCount) {
        _isLatestPage = true;
      } else {
        _page++;
      }

      value = [...value!, ...stories];
    } catch (err, trace) {
      final parsedError = err.toSimpleException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }

  /// Reset provider to initial state. Then do [fetchStories] again.
  Future<void> refresh(UserCreds userCreds) async {
    _page = 1;
    _isLatestPage = false;
    value = [];

    await fetchStories(userCreds);
  }

  /// Post a new story, then call [refresh].
  ///
  /// May throw a [SimpleException].
  Future<void> postStory(
    UserCreds userCreds, {
    required String description,
    required List<int> imageBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    isLoading = true;

    try {
      await container.get<PostStoryCase>().execute(
            userCreds,
            description: description,
            imageBytes: imageBytes,
            imageFilename: imageFilename,
            lat: lat,
            lon: lon,
          );

      await refresh(userCreds);
    } catch (err, trace) {
      final parsedError = err.toSimpleException(trace: trace);

      setError(parsedError);
      throw parsedError;
    }
  }
}
