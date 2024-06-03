import 'package:dicoding_story_fl/core/entities.dart';

/// Contains the interface to access
/// [Google Maps Platform APIs](https://developers.google.com/maps/documentation).
abstract interface class GMapsRepo {
  const GMapsRepo();

  /// Get current device location.
  Future<LocationCore> getLocation();

  /// Search place by query.
  ///
  /// - [languageCode], sepcifies the language to return on the place detail
  Future<List<LocationCore>> searchPlace(
    String query, {
    String? languageCode,
  });

  /// Converts the address into latitude and longitude coordinates.
  ///
  /// - [address], the street address or [plus code](https://plus.codes/) that
  ///   you want to geocode.
  /// - [languageCode], sepcifies the language to return on the place detail.
  Future<LocationCore> geocoding(String address, {String? languageCode});

  /// Converts the latitude and longitude coordinates into an address.
  ///
  /// - [includeDisplayName], whether to include the place's name on the result.
  /// - [languageCode], specifies the language to return on the place detail.
  Future<LocationCore> reverseGeocoding(
    double latitude,
    double longitude, {
    bool includeDisplayName = false,
    String? languageCode,
  });
}
