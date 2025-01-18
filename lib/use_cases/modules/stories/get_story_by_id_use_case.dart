import "package:dicoding_story_fl/domain/services.dart";
import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

@singleton
final class GetStoryByIdUseCase implements UseCase<String, Story> {
  const GetStoryByIdUseCase(this._storiesRepository, this._mapsService);

  final StoriesRepository _storiesRepository;
  final MapsService _mapsService;

  @override
  Future<Story> execute(String id) async {
    final story = await _storiesRepository.getStoryById(id);

    final latitude = story.lat ?? 0.0;
    final longitude = story.lon ?? 0.0;

    return story.copyWith(
      location: await _mapsService.reverseGeocoding(
        latitude,
        longitude,
      ),
    );
  }
}
