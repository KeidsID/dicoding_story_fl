import '../entities.dart';

abstract interface class StoriesRepo {
  Future<List<Story>> fetchStories(
    UserCreds userCreds, {
    int page = 1,
    int size = 10,
    bool? hasCordinate,
  });

  Future<StoryDetail> storyDetailById(
    String id, {
    required UserCreds userCreds,
  });

  Future<void> postStory(
    UserCreds userCreds, {
    required String description,
    required List<int> imageBytes,
    double? lat,
    double? lon,
  });
}
