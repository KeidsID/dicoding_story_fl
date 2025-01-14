import "package:chopper/chopper.dart";
import "package:http/http.dart" show MultipartFile;
import "package:injectable/injectable.dart";

part "stories_remote_data.chopper.dart";

@lazySingleton
@ChopperApi(baseUrl: "/stories")
abstract class StoriesRemoteData extends ChopperService {
  @factoryMethod
  static StoriesRemoteData create([ChopperClient? client]) =>
      _$StoriesRemoteData(client);

  /// https://story-api.dicoding.dev/v1/#/?id=add-new-story
  @post
  @multipart
  Future<Response<Map<String, dynamic>>> postStory({
    @Header("Authorization") required String bearerToken,
    //
    @part required String description,
    @PartFile("photo") required MultipartFile image,
    @part double? lat,
    @part double? lon,
  });

  /// https://story-api.dicoding.dev/v1/#/?id=get-all-stories
  @get
  Future<Response<Map<String, dynamic>>> getStories({
    @Header("Authorization") required String bearerToken,
    //
    @query int page = 1,
    @query int size = 10,
    @Query("location") int? hasCoordinates,
  });

  /// https://story-api.dicoding.dev/v1/#/?id=detail-story
  @Get(path: "/{id}")
  Future<Response<Map<String, dynamic>>> getStoryById({
    @Header("Authorization") required String bearerToken,
    @path required String id,
  });
}
