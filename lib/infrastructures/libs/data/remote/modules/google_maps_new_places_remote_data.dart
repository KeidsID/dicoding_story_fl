import "package:chopper/chopper.dart";

import "../libs/clients.dart";

part "google_maps_new_places_remote_data.chopper.dart";

@chopperApi
abstract class GoogleMapsNewPlacesRemoteData extends ChopperService {
  static GoogleMapsNewPlacesRemoteData create({
    required String apiKey,
    String? bundleId,
    String? androidSHA,
  }) {
    return _$GoogleMapsNewPlacesRemoteData(GoogleMapsApiClient(
      type: GoogleMapsApiClientType.newPlaces,
      apiKey: apiKey,
      bundleId: bundleId,
      androidSHA: androidSHA,
    ));
  }

  /// https://developers.google.com/maps/documentation/places/web-service/place-details
  @Get(path: "/places/{placeId}")
  Future<Response<Map<String, dynamic>>> placeDetails(
    @path String placeId, {
    @Header("X-Goog-FieldMask") required String fieldMask,
    @query String? languageCode,
  });

  /// https://developers.google.com/maps/documentation/places/web-service/text-search
  @Post(path: "/places:searchText")
  Future<Response<Map<String, dynamic>>> textSearch({
    @Header("X-Goog-FieldMask") required String fieldMask,
    @body required Map<String, dynamic> body,
  });
}
