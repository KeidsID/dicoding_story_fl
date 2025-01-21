import "package:chopper/chopper.dart";

import "../libs/clients.dart";

part "google_maps_geocoding_remote_data.chopper.dart";

@chopperApi
abstract class GoogleMapsGeocodingRemoteData extends ChopperService {
  static GoogleMapsGeocodingRemoteData create({
    required String apiKey,
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

  /// https://developers.google.com/maps/documentation/geocoding/requests-geocoding
  @Get(path: "/json")
  Future<Response<Map<String, dynamic>>> geocoding(
    @query String address, {
    @Query("language") String? languageCode,
  });

  /// https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding
  ///
  /// - [latlng], latidude and longitude values seperated by comma.
  @Get(path: "/json")
  Future<Response<Map<String, dynamic>>> reverseGeocoding(
    @query String latlng, {
    @Query("language") String? languageCode,
  });
}
