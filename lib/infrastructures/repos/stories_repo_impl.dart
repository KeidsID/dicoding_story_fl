import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;

import 'package:dicoding_story_fl/common/constants.dart';
import 'package:dicoding_story_fl/common/utils.dart';
import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';
import 'package:dicoding_story_fl/infrastructures/api/responses.dart';
import 'package:dicoding_story_fl/infrastructures/utils/on_error_response_mixin.dart';

part 'stories_repo_impl.chopper.dart';

class StoriesRepoImpl with OnErrorResponseMixin implements StoriesRepo {
  StoriesRepoImpl(ChopperClient client)
      : _storiesApi = StoriesApiService.create(client);

  final StoriesApiService _storiesApi;

  @override
  Future<List<Story>> fetchStories(
    UserCreds userCreds, {
    int page = 1,
    int size = 10,
    bool includeLocation = false,
  }) async {
    try {
      final rawRes = await _storiesApi.getStories(
        authorization: 'Bearer ${userCreds.token}',
        page: page,
        size: size,
        includeLocation: includeLocation ? 1 : 0,
      );
      final rawResBody = rawRes.body;

      if (rawResBody == null) throw onErrorResponse(rawRes);

      final resBody = StoriesResponse.fromJson(rawResBody);

      return resBody.listStory.map((e) => e.toEntity()).toList();
    } catch (err, trace) {
      throw err.toSimpleException(trace: trace);
    }
  }

  @override
  Future<StoryDetail> storyDetailById(
    String id, {
    required UserCreds userCreds,
  }) async {
    try {
      final rawRes = await _storiesApi.getStoryDetail(
        id,
        authorization: 'Bearer ${userCreds.token}',
      );
      final rawResBody = rawRes.body;

      if (rawResBody == null) throw onErrorResponse(rawRes);

      final resBody = StoryDetailResponse.fromJson(rawResBody);

      return resBody.story.toEntity();
    } catch (err, trace) {
      throw err.toSimpleException(trace: trace);
    }
  }

  @override
  Future<void> postStory(
    UserCreds userCreds, {
    required String description,
    required List<int> imageBytes,
    required String imageFilename,
    double? lat,
    double? lon,
  }) async {
    try {
      kLogger.d(imageFilename);

      final rawRes = await _storiesApi.postStory(
        authorization: 'Bearer ${userCreds.token}',
        description: description,
        imageFile: MultipartFile.fromBytes(
          'photo',
          imageBytes,
          filename: imageFilename,
        ),
        lat: lat,
        lon: lon,
      );
      final rawResBody = rawRes.body;

      if (rawResBody == null) throw onErrorResponse(rawRes);
    } catch (err, trace) {
      throw err.toSimpleException(trace: trace);
    }
  }
}

@chopperApi
abstract class StoriesApiService extends ChopperService {
  static StoriesApiService create([ChopperClient? client]) =>
      _$StoriesApiService(client);

  /// Fetch list of stories.
  ///
  /// Headers:
  ///
  /// - [authorization], `Bearer <token>` format.
  ///
  /// Query Params:
  ///
  /// - [page], page number. Valid value is greater than `0`.
  /// - [size], stories count for each page. Valid value is greater than `0`.
  /// - [includeLocation], include location coordinate 
  ///   (`latitude`, and `longitude` value) on returned stories. Valid value are
  ///   `1` for true and `0` for false, default is `0`.
  @Get(path: '/stories')
  Future<Response<Map<String, dynamic>>> getStories({
    @Header('Authorization') required String authorization,
    //
    @query int page = 1,
    @query int size = 10,
    @Query('location') int? includeLocation,
  });

  /// Fetch story detail by [storyId].
  ///
  /// Headers:
  ///
  /// - [authorization], `Bearer <token>` format.
  @Get(path: '/stories/{id}')
  Future<Response<Map<String, dynamic>>> getStoryDetail(
    @Path('id') String storyId, {
    @Header('Authorization') required String authorization,
  });

  /// Post a new story.
  ///
  /// Headers:
  ///
  /// - [authorization], `Bearer <token>` format.
  ///
  /// Request Body (multipart):
  ///
  /// - [description] - `text`, story description.
  /// - [imageFile] - `file`, story image (max size 1MB). Use
  ///   [MultipartFile] from `package:http`. Make sure the
  ///   [MultipartFile.field] is `"photo"`.
  /// - [lat] - `float`, latitude (optional).
  /// - [lon] - `float`, longitude (optional).
  ///
  /// https://story-api.dicoding.dev/v1/#/?id=add-new-story
  @Post(path: '/stories')
  @multipart
  Future<Response<Map<String, dynamic>>> postStory({
    @Header('Authorization') required String authorization,
    //
    @part required String description,
    @PartFile('photo') required MultipartFile imageFile,
    @part double? lat,
    @part double? lon,
  });
}
