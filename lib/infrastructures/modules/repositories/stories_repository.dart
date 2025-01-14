import "package:chopper/chopper.dart";
import "package:http/http.dart" show MultipartFile;
import "package:injectable/injectable.dart";

import "package:dicoding_story_fl/domain/entities.dart";
import "package:dicoding_story_fl/domain/repositories.dart";
import "package:dicoding_story_fl/infrastructures/libs/data/remote/modules.dart";
import "package:dicoding_story_fl/libs/extensions.dart";

@LazySingleton(as: StoriesRepository)
final class StoriesRepositoryImpl implements StoriesRepository {
  StoriesRepositoryImpl(this._remoteData);

  final StoriesRemoteData _remoteData;

  @override
  String? authToken;

  @override
  Future<List<Story>> getStories({
    int page = 1,
    int size = 10,
    bool hasCoordinates = false,
  }) async {
    try {
      final token = authToken;

      if (token == null) throw const AppException(message: "Unauthorized");

      final rawResponse = await _remoteData.getStories(
        bearerToken: "Bearer $token",
        page: page,
        size: size,
        hasCoordinates: hasCoordinates ? 1 : 0,
      );
      final rawResponseBody = rawResponse.body!;

      final rawStories = rawResponseBody["listStory"] as List;

      return rawStories
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ChopperHttpException catch (exception, trace) {
      throw handleApiErrorResponse(exception, trace);
    } catch (error, trace) {
      throw error.toAppException(
        message: "Failed to fetch stories",
        trace: trace,
      );
    }
  }

  @override
  Future<Story> getStoryById(String id) async {
    try {
      final token = authToken;

      if (token == null) throw const AppException(message: "Unauthorized");

      final rawResponse = await _remoteData.getStoryById(
        bearerToken: "Bearer $token",
        id: id,
      );
      final rawResponseBody = rawResponse.body!;

      return Story.fromJson(rawResponseBody["story"] as Map<String, dynamic>);
    } on ChopperHttpException catch (exception, trace) {
      throw handleApiErrorResponse(exception, trace);
    } catch (error, trace) {
      throw error.toAppException(
        message: "Failed to fetch story",
        trace: trace,
      );
    }
  }

  @override
  Future<void> postStory({
    required String description,
    required List<int> imageBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    try {
      final token = authToken;

      if (token == null) throw const AppException(message: "Unauthorized");

      final imageFile = MultipartFile.fromBytes(
        "photo",
        imageBytes,
        filename: imageFilename,
      );

      await _remoteData.postStory(
        bearerToken: "Bearer $token",
        description: description,
        image: imageFile,
        lat: lat,
        lon: lon,
      );
    } on ChopperHttpException catch (exception, trace) {
      throw handleApiErrorResponse(exception, trace);
    } catch (error, trace) {
      throw error.toAppException(
        message: "Failed to post story",
        trace: trace,
      );
    }
  }
}
