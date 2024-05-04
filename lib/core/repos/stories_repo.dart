import '../entities.dart';

abstract interface class StoriesRepo {
  Future<List<Story>> fetchStories(
    UserCreds userCreds, {
    int page = 1,
    int size = 10,
    bool includeLocation = false,
  });

  Future<StoryDetail> storyDetailById(
    String id, {
    required UserCreds userCreds,
  });

  Future<void> postStory(
    UserCreds userCreds, {
    required String description,
    required List<int> imageBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  });
}
