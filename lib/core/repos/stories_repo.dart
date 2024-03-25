import '../entities.dart';

abstract interface class StoriesRepo {
  Future<List<Story>> fetchStories({int? page, int? size, bool? hasCordinate});
}
