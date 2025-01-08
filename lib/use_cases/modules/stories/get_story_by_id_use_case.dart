import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/use_cases/libs/types.dart";

final class GetStoryByIdUseCase implements UseCase<String, Story> {
  const GetStoryByIdUseCase(this._storiesRepository);

  final StoriesRepository _storiesRepository;

  @override
  Future<Story> execute(String id) async {
    return _storiesRepository.getStoryById(id);
  }
}
