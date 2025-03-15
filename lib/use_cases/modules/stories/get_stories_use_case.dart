import "package:freezed_annotation/freezed_annotation.dart";
import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/domain/services.dart";
import "package:dicoding_story_fl/libs/constants.dart";
import "package:dicoding_story_fl/libs/extensions.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

part "get_stories_use_case.freezed.dart";

@singleton
final class GetStoriesUseCase
    implements UseCase<GetStoriesRequestDto, List<Story>> {
  const GetStoriesUseCase(this._storiesRepository, this._mapsService);

  final StoriesRepository _storiesRepository;
  final MapsService _mapsService;

  @override
  Future<List<Story>> execute(GetStoriesRequestDto requestDto) async {
    final GetStoriesRequestDto(:page, :size, :hasCoordinates) = requestDto;

    final stories = await _storiesRepository.getStories(
      page: page,
      size: size,
      hasCoordinates: hasCoordinates,
    );

    if (hasCoordinates) {
      return Future.wait(stories.map((e) async {
        try {
          final location = await _mapsService.reverseGeocoding(
            e.lat ?? 0.0,
            e.lon ?? 0.0,
          );

          return e.copyWith(location: location);
        } catch (error, trace) {
          final exception = error.toAppException(trace: trace);

          kLogger.w(
            "Fail to load story address",
            error: exception,
            stackTrace: exception.trace,
          );

          return e.copyWith(location: null);
        }
      }));
    }

    return stories;
  }
}

@Freezed(copyWith: true)
class GetStoriesRequestDto with _$GetStoriesRequestDto {
  const factory GetStoriesRequestDto({
    /// Fetch pagination order. Must be greater than `0`.
    required int page,

    /// Stories count for each [page]. Must be greater than `0`.
    required int size,

    /// Include location coordinate on the [Story].
    @Default(false) bool hasCoordinates,
  }) = _GetStoriesRequestDto;
}
