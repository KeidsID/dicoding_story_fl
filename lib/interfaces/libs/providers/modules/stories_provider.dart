import "package:freezed_annotation/freezed_annotation.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/service_locator.dart";
import "package:dicoding_story_fl/use_cases.dart";

part "stories_provider.freezed.dart";
part "stories_provider.g.dart";

/// Provide stories as infinite list.
///
/// Call notifier [fetchStories] to fetch new stories into the [state.value].
///
/// You can also post a new story via notifier [postStory].
@Riverpod(keepAlive: true)
class Stories extends _$Stories {
  /// The count of stories to fetch.
  final int _storiesCount = 10;

  int get _halfStoriesCount => _storiesCount ~/ 2;

  @override
  FutureOr<StoriesProviderValue> build() async {
    try {
      final stories = await _getStories();

      return StoriesProviderValue(stories: stories);
    } catch (err, trace) {
      final exception = err.toAppException(trace: trace);

      throw exception;
    }
  }

  Future<List<Story>> _getStories([int page = 1]) async {
    final useCase = ServiceLocator.find<GetStoriesUseCase>();
    final requestDto = GetStoriesRequestDto(
      page: page,
      size: _halfStoriesCount,
    );

    return {
      // return stories with location only.
      ...(await useCase.execute(requestDto.copyWith(hasCoordinates: true))),

      // return both stories with and without location,
      // but did'nt include the location data on the response.
      //
      // Odd behavior right 🙄.
      ...(await useCase.execute(requestDto.copyWith(size: _storiesCount))),
    }.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Fetch new stories into [state] without notifying [AsyncLoading] state.
  /// Won't do anything if [state.value] is `null`.
  ///
  /// If [StoriesProviderValue.isLatestPage] is `true`,
  /// You need to rebuild the provider via [Ref.refresh]/[Ref.invalidate]
  /// before recalling this method.
  ///
  /// May throw an [AppException].
  Future<void> fetchStories() async {
    final stateValue = state.valueOrNull;

    if (stateValue == null) return;

    final isLatestPage = stateValue.isLatestPage;

    if (state.isLoading || isLatestPage) return;

    // state = const AsyncLoading();

    final stories = stateValue.stories;
    final page = stateValue.page;
    final nextPage = page + 1;

    try {
      final newStories = await _getStories(nextPage);

      final isEnd = newStories.length < _halfStoriesCount;

      state = AsyncData(
        state.value!.copyWith(
          stories: [...stories, ...newStories],
          page: isEnd ? page : nextPage,
          isLatestPage: isEnd,
        ),
      );
    } catch (err, trace) {
      final exception = err.toAppException(trace: trace);

      state = AsyncError(exception, exception.trace ?? trace);
      throw exception;
    }
  }

  /// Post a new story, then rebuild the [storiesProvider].
  ///
  /// May throw an [AppException].
  Future<void> postStory({
    required String description,
    required List<int> imageBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    state = const AsyncLoading();

    final postStory = ServiceLocator.find<PostStoryUseCase>().execute;

    try {
      await postStory(PostStoryRequestDto(
        description: description,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
        lat: lat,
        lon: lon,
      ));

      state = AsyncData(StoriesProviderValue(stories: await _getStories()));
    } catch (err, trace) {
      final exception = err.toAppException(trace: trace);

      state = AsyncError(exception, exception.trace ?? trace);
      throw exception;
    }
  }
}

/// [storiesProvider] state value.
@Freezed(copyWith: true)
class StoriesProviderValue with _$StoriesProviderValue {
  const factory StoriesProviderValue({
    /// Fetched stories.
    @Default(<Story>[]) List<Story> stories,

    /// Current stories page.
    @Default(1) int page,

    /// Indicate the [page] is the latest page.
    ///
    /// You may need to rebuild the [storiesProvider] if this value is `true`.
    @Default(false) bool isLatestPage,
  }) = _StoriesProviderState;
}
