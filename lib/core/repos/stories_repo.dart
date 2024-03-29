import '../entities.dart';

abstract interface class StoriesRepo {
  Future<List<Story>> fetchStories(
    UserCreds userCredentials, {
    int page = 1,
    int size = 10,
    bool? hasCordinate,
  });

  Future<StoryDetail> storyDetailById(
    String id, {
    required UserCreds userCredentials,
  });
}
