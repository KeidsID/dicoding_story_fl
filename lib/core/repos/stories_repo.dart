import '../entities.dart';

abstract interface class StoriesRepo {
  Future<List<Story>> fetchStories({
    int page = 1,
    int size = 10,
    bool? hasCordinate,
  });
}
