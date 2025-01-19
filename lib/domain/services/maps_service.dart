import "package:dicoding_story_fl/domain/entities.dart";

abstract interface class MapsService {
  /// Get current device location.
  Future<LocationData> getLocation();

  /// Get location data from [address].
  ///
  /// - [languageCode], specify the language to return on the place detail.
  Future<LocationData> geocoding(String address, {String? languageCode});

  /// Get location data from [latitude] and [longitude] values.
  ///
  /// - [languageCode], specify the language to return on the place detail.
  /// - [includeDisplayName], will do additional request to get place name.
  Future<LocationData> reverseGeocoding(
    double latitude,
    double longitude, {
    String? languageCode,
    bool includeDisplayName = true,
  });

  /// Search place by [query].
  ///
  /// - [languageCode], specify the language to return on the place detail.
  Future<List<LocationData>> searchPlace(String query, {String? languageCode});
}
