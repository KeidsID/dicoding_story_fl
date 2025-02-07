import "package:chopper/chopper.dart";
import "package:flutter/foundation.dart";

part "google_maps_geocoding_remote_data.chopper.dart";

/// https://nest-gmaps-api.fly.dev/docs
@chopperApi
abstract class GoogleMapsGeocodingRemoteData extends ChopperService {
  static GoogleMapsGeocodingRemoteData create() {
    return _$GoogleMapsGeocodingRemoteData(ChopperClient(
      baseUrl: Uri.parse("https://nest-gmaps-api.fly.dev/api"),
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

  @Get(path: "/geocode")
  Future<Response<Map<String, dynamic>>> geocoding(
    @query String address, {
    @query String? languageCode,
  });

  @Get(path: "/geocode/reverse")
  Future<Response<Map<String, dynamic>>> reverseGeocoding(
    @query String lat,
    @query String lng, {
    @query String? languageCode,
  });
}
