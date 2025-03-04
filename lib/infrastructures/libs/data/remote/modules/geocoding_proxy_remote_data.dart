import "package:chopper/chopper.dart";
import "package:dicoding_story_fl/domain/services.dart";
import "package:flutter/foundation.dart";

part "geocoding_proxy_remote_data.chopper.dart";

/// https://nest-gmaps-api.fly.dev/docs
@chopperApi
abstract class GeocodingProxyRemoteData extends ChopperService {
  static GeocodingProxyRemoteData create(ConfigService configService) {
    final ConfigService(:env) = configService;

    return _$GeocodingProxyRemoteData(ChopperClient(
      baseUrl: Uri.parse("${env.gmapsProxyServer}/api"),
      converter: const JsonConverter(),
      errorConverter: const JsonConverter(),
      interceptors: [
        if (kDebugMode)
          HttpLoggingInterceptor(
            level: Level.basic,
            logger: chopperLogger,
          ),
      ],
    ));
  }

  @GET(path: "/geocode")
  Future<Response<Map<String, dynamic>>> geocoding(
    @query String address, {
    @query String? languageCode,
  });

  @GET(path: "/geocode/reverse")
  Future<Response<Map<String, dynamic>>> reverseGeocoding(
    @query String lat,
    @query String lng, {
    @query String? languageCode,
  });
}
