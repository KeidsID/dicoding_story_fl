import 'package:dicoding_story_fl/domain/repositories.dart';
import 'package:dicoding_story_fl/use_cases/libs/types.dart';

final class PostStoryUseCase implements UseCase<PostStoryRequestDto, void> {
  const PostStoryUseCase(this._storiesRepository);

  final StoriesRepository _storiesRepository;

  @override
  Future<void> execute(PostStoryRequestDto requestDto) {
    final PostStoryRequestDto(
      :description,
      :imageBytes,
      :imageFilename,
      :lat,
      :lon
    ) = requestDto;

    return _storiesRepository.postStory(
      description: description,
      imageBytes: imageBytes,
      imageFilename: imageFilename,
      lat: lat,
      lon: lon,
    );
  }
}

final class PostStoryRequestDto {
  const PostStoryRequestDto({
    required this.description,
    required this.imageBytes,
    required this.imageFilename,
    this.lat,
    this.lon,
  });

  final String description;
  final List<int> imageBytes;

  /// Must include file extension.
  final String imageFilename;
  final double? lat;
  final double? lon;
}
