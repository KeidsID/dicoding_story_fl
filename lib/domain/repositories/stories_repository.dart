import "../entities.dart" show Story;

abstract interface class StoriesRepository {
  /// Required for API requests.
  String? authToken;

  Future<List<Story>> getStories({
    int page = 1,
    int size = 10,
    bool hasCoordinates = false,
  });

  Future<Story> getStoryById(String id);
  Future<void> postStory({
    required String description,
    required List<int> imageBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  });
}
