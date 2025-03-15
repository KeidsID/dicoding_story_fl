import "package:chopper/chopper.dart";

import "package:dicoding_story_fl/infrastructures/libs/data/remote/libs/clients.dart";

part "google_maps_geocoding_remote_data.chopper.dart";

/// https://nest-gmaps-api.fly.dev/docs
@chopperApi
abstract class GoogleMapsGeocodingRemoteData extends ChopperService {
  static GoogleMapsGeocodingRemoteData create(
    String apiKey, {
    String? bundleId,
    String? androidSHA,
  }) {
    return _$GoogleMapsGeocodingRemoteData(GoogleMapsApiClient(
      type: GoogleMapsApiClientType.geocoding,
      apiKey: apiKey,
      bundleId: bundleId,
      androidSHA: androidSHA,
    ));
  }

  @GET(path: "/json")
  Future<Response<Map<String, dynamic>>> geocoding(
    @query String address, {
    @Query("language") String? languageCode,
  });

  @GET(path: "/json")
  Future<Response<Map<String, dynamic>>> reverseGeocoding(
    @query String latlng, {
    @Query("language") String? languageCode,
  });
}
