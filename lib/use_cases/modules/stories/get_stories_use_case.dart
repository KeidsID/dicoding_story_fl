import 'package:dicoding_story_fl/domain/entities.dart';
import 'package:dicoding_story_fl/domain/repositories.dart';
import 'package:dicoding_story_fl/use_cases/libs/types.dart';

final class GetStoriesUseCase
    implements UseCase<GetStoriesRequestDto, List<Story>> {
  const GetStoriesUseCase(this._storiesRepository);

  final StoriesRepository _storiesRepository;

  @override
  Future<List<Story>> execute(GetStoriesRequestDto requestDto) async {
    final GetStoriesRequestDto(:page, :size, :hasCoordinates) = requestDto;

    return _storiesRepository.getStories(
      page: page,
      size: size,
      hasCoordinates: hasCoordinates,
    );
  }
}

final class GetStoriesRequestDto {
  const GetStoriesRequestDto({
    required this.page,
    required this.size,
    this.hasCoordinates = false,
  });

  /// Fetch pagination order. Must be greater than `0`.
  final int page;

  /// Stories count for each [page]. Must be greater than `0`.
  final int size;

  /// Include location coordinate on the [Story].
  final bool hasCoordinates;
}
