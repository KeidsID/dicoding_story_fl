import 'package:chopper/chopper.dart';

import 'package:dicoding_story_fl/core/entities.dart';
import 'package:dicoding_story_fl/core/repos.dart';
import 'package:dicoding_story_fl/infrastructures/api/responses.dart';
import 'package:dicoding_story_fl/infrastructures/utils/on_error_response_mixin.dart';

part 'stories_repo_impl.chopper.dart';

class StoriesRepoImpl with OnErrorResponseMixin implements StoriesRepo {
  const StoriesRepoImpl(this._client);

  final ChopperClient _client;

  StoriesApiService get _storiesApi => StoriesApiService.create(_client);

  @override
  Future<List<Story>> fetchStories(
    UserCreds userCredentials, {
    int page = 1,
    int size = 10,
    bool? hasCordinate,
  }) async {
    try {
      final rawRes = await _storiesApi.getStories(
        authorization: 'Bearer ${userCredentials.token}',
        page: page,
        size: size,
        hasCordinate: hasCordinate == null ? null : (hasCordinate ? 1 : 0),
      );
      final rawResBody = rawRes.body;

      if (rawResBody == null) throw onErrorResponse(rawRes);

      final resBody = StoriesResponse.fromJson(rawResBody);

      return resBody.listStory.map((e) => e.toEntity()).toList();
    } on SimpleException {
      rethrow;
    } catch (err, trace) {
      throw SimpleException(error: err, trace: trace);
    }
  }
}

@chopperApi
abstract class StoriesApiService extends ChopperService {
  static StoriesApiService create([ChopperClient? client]) =>
      _$StoriesApiService(client);

  /// Headers:
  ///
  /// - [authorization], `Bearer <token>` format.
  ///
  /// Query Params:
  ///
  /// - [page], page number. Valid value is greater than `0`.
  /// - [size], stories count for each page. Valid value is greater than `0`.
  /// - [hasCordinate], include location coordinate on returned stories. Valid
  ///   value are `1` for true and `0` for false, default is `0`.
  @Get(path: '/stories')
  Future<Response<Map<String, dynamic>>> getStories({
    @Header('Authorization') required String authorization,
    @query int page = 1,
    @query int size = 10,
    @Query('location') int? hasCordinate,
  });
}
