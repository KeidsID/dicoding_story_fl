import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/container.dart' as container;
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/use_cases.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

final class StoriesProvider extends AsyncValueNotifier<List<Story>> {
  StoriesProvider([super.initialValue]);

  /// Fetch stories and set it to [value].
  Future<void> fetchStories(
    UserCreds userCreds, {
    int page = 1,
    int size = 10,
    bool? hasCordinate,
  }) async {
    isLoading = true;

    try {
      final stories = await container.get<GetStoriesCase>().execute(
            userCreds,
            page: page,
            size: size,
            hasCordinate: hasCordinate,
          );

      value = stories;
    } catch (err, trace) {
      final parsedError = err.toSimpleException(trace);

      setError(parsedError);
      throw parsedError;
    }
  }
}
